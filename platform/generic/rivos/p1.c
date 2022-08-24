/*
 * SPDX-License-Identifier: BSD-2-Clause
 *
 * Copyright (c) 2022 Rivos Inc. 
 */

#include <platform_override.h>
#include <sbi/riscv_io.h>
#include <sbi/sbi_bitops.h>
#include <sbi/sbi_error.h>

#include <sbi_utils/fdt/fdt_helper.h>
#include <sbi_utils/timer/rivos_timer.h>

static int rivos_p1_final_init(bool cold_boot, const struct fdt_match *match)
{
	int rc = 0;

	rc = rivos_mtimer_init(cold_boot);
	
	return rc;
}

static const struct fdt_match rivos_p1_match[] = {
	{ .compatible = "rivos,p1" },
	{ },
};

const struct platform_override rivos_p1 = {
	.match_table	= rivos_p1_match,
	.final_init	= rivos_p1_final_init,
};