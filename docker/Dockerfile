ARG UBUNTU_VERSION=20.04
FROM ubuntu:${UBUNTU_VERSION}

RUN sed -ie 's/# deb-src/deb-src/' /etc/apt/sources.list

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
  apt-get install -y git make build-essential ccache gcc g++ python-is-python3 ninja-build flex bison libssl-dev libelf-dev && \
  apt-get build-dep -y qemu-system && \
  apt-get build-dep -y ovmf

RUN apt-get update && apt-get install -y devscripts cpio zstd rsync kmod dracut vim python3-venv

RUN apt-get update && apt-get install -y grub-common grub2-common dosfstools mtools uuid-dev iasl wget

RUN wget http://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.bz2 && \
  tar xfj nasm-2.15.05.tar.bz2 && \
  cd nasm-2.15.05 && \
  ./autogen.sh && \
  ./configure --prefix=/usr/local/ && \
  make -j$(nproc) && \
  make install && \
  cd .. && \
  rm -rf nasm-2.15.05 nasm-2.15.05.tar.bz2

RUN mkdir -p /usr/lib/grub/x86_64-efi/
COPY ./x86_64-efi/* /usr/lib/grub/x86_64-efi/


ENV PATH="/usr/lib/ccache:$PATH"
ENV CCACHE_COMPRESS=true
