# -*- docker-image-name: "rudolfochrist/debian-sbcl"; -*-

FROM debian:stable-slim
LABEL maintainer="Sebastian Christ"
LABEL email="rudolfo.christ@gmail.com"
WORKDIR /root

# Build arguments
ARG SBCL_VERSION=1.4.3
ARG SBCL_SHA256_SUM=38e8379f6371da2d59ef05c08fc7d558650ac44e4f5cc3956b62640b0d027291
ARG SBCL_TAR=sbcl-$SBCL_VERSION-x86-linux-binary.tar
ARG SBCL_BZIP=$SBCL_TAR.bz2

# Deps
RUN apt-get update &&\
    apt-get install -y \
        wget \
        build-essential &&\
    rm -rf /var/lib/apt/lists/*

# Install SBCL
RUN wget http://prdownloads.sourceforge.net/sbcl/$SBCL_BZIP &&\
    bzip2 -d $SBCL_BZIP &&\
    echo "$SBCL_SHA256_SUM $SBCL_TAR" | sha256sum -c - &&\
    tar xf $SBCL_TAR &&\
    cd sbcl-$SBCL_VERSION-x86-linux &&\
    sh install.sh &&\
    rm -rf /root/sbcl-$SBCL_VERSION-x86-64-linux-binary.tar.bz2 /root/sbcl-$SBCL_VERSION-x86-64-linux

# copy files
COPY image /

ENTRYPOINT ["/usr/local/bin/sbcl"]
