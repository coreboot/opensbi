/*
 * SPDX-License-Identifier: BSD-2-Clause
 *
 * Copyright (c) 2020 Rivosinc
 *
 * Authors:
 *   Atish Patra <atishp@rivosinc.com>
 */

#define RCODE_BASE_ADDR 0x06000000
#define LRAM_BASE_ADDR  0x7f800000

	
	. = RCODE_BASE_ADDR;
	.rcode.text : {
	        KEEP(*(.rcode.text))
	}

	. = LRAM_BASE_ADDR;
        .lram.text : {
		KEEP(*(.lram.text))
	}
