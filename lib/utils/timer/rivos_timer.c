/*
 * SPDX-License-Identifier: BSD-2-Clause
 *
 * Copyright (c) 2022 Rivos Inc.
 *
 * Authors:
 *   Atish Patra <atishp@rivosinc.com>
 */


#include <sbi/riscv_asm.h>
#include <sbi/riscv_encoding.h>
#include <sbi/sbi_error.h>
#include <sbi/sbi_hartmask.h>
#include <sbi/sbi_timer.h>
#include <sbi/sbi_console.h>

#include <sbi_utils/fdt/fdt_helper.h>

#define RIVOS_TIMER_MTIMECMP_CSR 0x7c0

static u64 rivos_mtimer_value(void)
{
	return csr_read(CSR_TIME);
}

static void rivos_mtimer_event_stop(void)
{
	csr_write(RIVOS_TIMER_MTIMECMP_CSR, -1UL);
}

static void rivos_mtimer_event_start(u64 next_event)
{
	csr_write(RIVOS_TIMER_MTIMECMP_CSR, next_event);
}

static struct sbi_timer_device rtimer = {
	.name = "rivos-mtimer",
	.timer_value = rivos_mtimer_value,
	.timer_event_start = rivos_mtimer_event_start,
	.timer_event_stop = rivos_mtimer_event_stop
};

int rivos_mtimer_init(bool cold_boot)
{
	int rc;
	void *fdt = fdt_get_address();
	u64 mtime_freq;

	if (cold_boot) {
		rc = fdt_parse_timebase_frequency(fdt, &mtime_freq);
		if (rc) {
			sbi_printf("Couldn't find timebase frequency in the DT\n");
			return rc;
		}
		rtimer.timer_freq = mtime_freq;
		sbi_timer_set_device(&rtimer);
	}

	rivos_mtimer_event_stop();

	return 0;
}
