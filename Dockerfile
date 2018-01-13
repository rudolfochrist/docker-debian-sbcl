# -*- docker-image-name: "rudolfochrist/debian-sbcl"; -*-

FROM debian:stable-slim
LABEL maintainer="Sebastian Christ"
LABEL email="rudolfo.christ@gmail.com"
WORKDIR /root

# Build arguments
ARG SBCL_VERSION=1.4.2
ARG SBCL_SHA256_SUM=c0f3767616e6c5383e82682cb45488a861a6ae6c5acbb79e5022bc1e60a1b45b
ARG SBCL_INSTALL_DIR=sbcl-$SBCL_VERSION-x86-64-linux
ARG SBCL_TAR=$SBCL_INSTALL_DIR-binary.tar
ARG SBCL_BZIP=$SBCL_TAR.bz2

ARG QL_SHA256SUM=4a7a5c2aebe0716417047854267397e24a44d0cce096127411e9ce9ccfeb2c17

# Deps
RUN apt-get update &&\
    apt-get install -y \
        build-essential \
        wget \
        &&\
    rm -rf /var/lib/apt/lists/*

# Install SBCL
RUN wget http://prdownloads.sourceforge.net/sbcl/$SBCL_BZIP &&\
    bzip2 -d $SBCL_BZIP &&\
    echo "$SBCL_SHA256_SUM $SBCL_TAR" | sha256sum -c - &&\
    tar xf $SBCL_TAR &&\
    cd $SBCL_INSTALL_DIR &&\
    sh install.sh &&\
    rm -rf $SBCL_TAR $SBCL_INSTALL_DIR

# Install Quicklisp
RUN mkdir -p /usr/local/quicklisp &&\
    wget https://beta.quicklisp.org/quicklisp.lisp &&\
    echo "$QL_SHA256SUM quicklisp.lisp" | sha256sum -c - &&\
    sbcl --load quicklisp.lisp \
         --eval '(quicklisp-quickstart:install :path "/usr/local/lib/quicklisp")'

# Copy files
COPY image /
COPY version .

# Volumes
VOLUME /usr/local/lib/quicklisp
ENTRYPOINT ["/usr/local/bin/sbcl"]

