# -*- docker-image-name: "rudolfochrist/debian-sbcl"; -*-

FROM debian:stable
LABEL maintainer="Sebastian Christ"
LABEL email="rudolfo.christ@gmail.com"
WORKDIR /root

# Args
ARG SBCL_VERSION=1.4.1

# Deps
RUN apt-get update && apt-get install -y \
    wget \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install SBCL
RUN wget http://prdownloads.sourceforge.net/sbcl/sbcl-$SBCL_VERSION-x86-64-linux-binary.tar.bz2 \
    && tar xf sbcl-$SBCL_VERSION-x86-64-linux-binary.tar.bz2 \
    && cd sbcl-$SBCL_VERSION-x86-64-linux \
    && sh install.sh \
    && rm -rf /root/sbcl-$SBCL_VERSION-x86-64-linux-binary.tar.bz2 /root/sbcl-$SBCL_VERSION-x86-64-linux

# copy init file
COPY image /

ENTRYPOINT ["/usr/local/bin/sbcl"]

