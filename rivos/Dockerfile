# Copyright (c) 2021 by Rivos Inc.
# Licensed under the BSD 2-Clause License, see LICENSE for details.
# SPDX-License-Identifier: BSD-2-Clause
FROM gitlab.ba.rivosinc.com:5050/ext/sw/riscv-gnu-toolchain:latest as riscv_builder

COPY . /src/
WORKDIR /tmp/build

# Build the 'generic' openSBI firmwares for QEMU
RUN make -C /src CROSS_COMPILE=riscv64-unknown-linux-gnu- PLATFORM=generic \
         O=/tmp/build  I=/rivos/opensbi INSTALL_FIRMWARE_PATH=. -j         \
         install_firmwares

FROM ubuntu:20.04 as opensbi
COPY --from=riscv_builder /rivos/opensbi /rivos/opensbi
