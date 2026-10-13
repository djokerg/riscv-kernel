# Build and run environment for the os1 kernel:
# RISC-V cross toolchain + QEMU, nothing else.
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        make \
        gcc-riscv64-linux-gnu \
        g++-riscv64-linux-gnu \
        binutils-riscv64-linux-gnu \
        qemu-system-misc \
        gdb-multiarch \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /os1
