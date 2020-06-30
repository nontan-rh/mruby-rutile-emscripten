FROM ubuntu:20.04

SHELL ["/bin/bash", "-c"]

# Setup APT

RUN apt-get update \
    && apt-get upgrade -y

# Basic commands

RUN apt-get install -y --no-install-recommends \
    ca-certificates \
    gnupg \
    software-properties-common \
    ssh-client \
    unzip \
    wget \
    xz-utils \
    && true

# Install tools for building mruby

RUN apt-get install -y --no-install-recommends \
    gcc \
    make \
    libc6-dev \
    bison \
    ruby \
    rake \
    doxygen \
    graphviz \
    && true

# Install latest git

RUN add-apt-repository ppa:git-core/ppa \
    && apt-get update \
    && apt-get install -y --no-install-recommends git

# Install Emscripten

RUN git clone --depth 1 https://github.com/emscripten-core/emsdk.git /emsdk \
    && cd /emsdk \
    && rm -fr .git \
    && ./emsdk install latest \
    && ./emsdk activate latest

ENV PATH=/emsdk:/emsdk/upstream/emscripten:/emsdk/node/12.18.1_64bit/bin:$PATH \
    EMSDK=/emsdk \
    EM_CONFIG=/emsdk/.emscripten \
    EM_CACHE=/emsdk/upstream/emscripten/cache \
    EMSDK_NODE=/emsdk/node/12.18.1_64bit/bin/node
