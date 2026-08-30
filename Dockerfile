FROM debian:stable-slim

ENV DEBIAN_FRONTEND=noninteractive

ARG ARM_VERSION=15.3.rel1
ARG ARM_ARCHIVE=arm-gnu-toolchain-${ARM_VERSION}-x86_64-arm-none-eabi.tar.xz
ARG ARM_URL=https://developer.arm.com/-/media/Files/downloads/gnu/${ARM_VERSION}/binrel/${ARM_ARCHIVE}

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        build-essential \
        curl \
        git \
        cmake \
        ninja-build \
        gdb-multiarch \
        clang-format \
        clangd \
        clang-tidy \
        cppcheck \
        python3 \
        python3-pip \
        python-is-python3 \
        stlink-tools \
    && rm -rf /var/lib/apt/lists/*

RUN curl -fL "${ARM_URL}" -o /tmp/arm-toolchain.tar.xz \
    && mkdir -p /opt/arm-toolchain \
    && tar -xf /tmp/arm-toolchain.tar.xz -C /opt/arm-toolchain --strip-components=1 \
    && rm /tmp/arm-toolchain.tar.xz
 
ENV PATH="/opt/arm-toolchain/bin:${PATH}"

RUN pip3 install --no-cache-dir \
        lizard \
        gcovr \
        rust-just \
    && rm -rf /root/.cache/pipx

WORKDIR /workspace

CMD ["/bin/bash"]