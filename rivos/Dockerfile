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

### Stage 2: Create a .deb Ubuntu package
FROM gitlab.ba.rivosinc.com:5050/rv/it/rivos-sdk/packager:latest as opensbi_packager

COPY --from=riscv_builder /rivos/opensbi /rivos/sysroot/riscv/boot/opensbi

ARG UPVER
ARG PKGVER
ARG CI_JOB_TOKEN
ARG CI_PROJECT_NAME
ARG CI_PROJECT_URL
ARG SECTION

RUN ./build_upload_package --deb \
  --arch all \
  ${SECTION:+--component ${SECTION}} \
  --description "RISC-V Open Source Supervisor Binary Interface." \
  --directory "/rivos/sysroot/riscv/boot/opensbi" \
  --license "BSD-2-Clause" \
  --name "${CI_PROJECT_NAME}" \
  --pkg_version "${PKGVER}" \
  --token "${CI_JOB_TOKEN}" \
  --url "${CI_PROJECT_URL}" \
  --upstream_version "${UPVER}"

### Stage 3: create a fresh container image with the built artifacts
FROM ubuntu:20.04 as opensbi
COPY --from=riscv_builder /rivos/opensbi /rivos/opensbi
