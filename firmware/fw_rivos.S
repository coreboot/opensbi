/*
 * SPDX-License-Identifier: BSD-2-Clause
 *
 * Copyright (c) 2020 Rivos Inc.
 *
 * Authors:
 *   Atish Patra <atishp@rivosinc.com>
 */

#include <sbi/riscv_asm.h>
#include <sbi/riscv_encoding.h>
#include <sbi/riscv_elf.h>

.section ".rcode.text", "ax"
	/* Entry point at the R-code (realistic) reset vector */
	.global _rcode_start
_rcode_start:
	lla	t0, __lram_start_addr
	REG_L	t1, 0(t0)
	csrw	CSR_REPC, t1
	.long	0x3020000b /* rret */

.section ".lram.text", "ax"

	.global _lram_start
_lram_start:
	/* PMARR SETUP */
	lla	t0, __pmarr_1_start_addr
	REG_L	t1, 0(t0)
	ori	t1, t1, 3 /* Program WB ((PMARR_BASE_0[7:0]=3)) */
	csrw 	CSR_PMARR_1_BASE, t1

	/* PMARR_0 is at LRAM address(0x7f800000). Hence, program the
	 * PMARR_1 should be programmed for remaining regions.
	 * TODO: This is hack and supports 2GB of one WB region so
	 * M-mode firmware can run with WB memory.
	 * Ideally, we should program only whatever M-mode requires.
	 * Remaining regions should be configured after parsing
	 * the device tree. Don't need anything IO region as default
	 * is UC.
	 */

	/* PMARR_1_MASK is ~(size - 1) | 1 (1: valid) */
	lla	t0, __pmarr_1_size
	REG_L	t1, 0(t0)
	addi	t1, t1, -1
	not	t1, t1
	ori	t1, t1, 1
	csrw	CSR_PMARR_1_MASK, t1

	fence
	fence.i
	/* We must have a sfence.vma here to flush the TLB. Otherwise, above loads
	 * happened as UC region and TLB reports next access as uncacheable.
	 * Regular loads will still be fine but atomics will fail in that case.
	 * The alternate solution would be load only from the first 8MB region of
	 * LRAM which is set as WB after reset.
	 */
	sfence.vma

	/* First program the MDRR */
	# MxRR mask is ~(size - 1) | 1 (1: valid)
	lla	t0, _data_start
	lla	t1, _fw_end
	sub	t2, t1, t0
	addi	t2, t2, -1
	not	t2, t2
	ori	t2, t2, 1

	csrw	CSR_MDRR_MASK, t2
	csrw	CSR_MDRR_BASE, t0

	/* Program the MCRR now */
	lla	t0, _fw_start
	lla	t1, _fw_rw_start
	sub	t2, t1, t0
	addi	t2, t2, -1
	not	t2, t2
	ori	t2, t2, 1
	csrw	CSR_MCRR_1_MASK, t2
	csrw	CSR_MCRR_1_BASE, t0

	lla	t3, __fw_payload_fdt_start
	REG_L	a1, 0(t3)
	jr t0

	.data
	.align 3
__fw_payload_fdt_start:
	RISCV_PTR	FW_PAYLOAD_FDT_ADDR
__lram_start_addr:
	RISCV_PTR	0x7f800000
__pmarr_1_start_addr:
	RISCV_PTR	0x80000000
__pmarr_1_size:
	RISCV_PTR	0x80000000
