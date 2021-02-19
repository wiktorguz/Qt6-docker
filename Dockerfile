FROM ubuntu:18.04 as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
 python3-pip \
 build-essential \
 libfreetype6-dev \
 libx11-dev \
 libxcomposite-dev \
 libgl1-mesa-dev \
 mesa-common-dev \
 libcurl4-openssl-dev \
 libwebkit2gtk-4.0-dev \
 qtchooser \
 libfontconfig1 \
 curl \
 unzip \
 wget \
 && apt-get -qq clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install cmake ninja conan

FROM base as builder
RUN wget https://download.qt.io/official_releases/qt/6.0/6.0.1/single/qt-everywhere-src-6.0.1.tar.xz
RUN tar -xf qt-everywhere-src-6.0.1.tar.xz
WORKDIR qt-everywhere-src-6.0.1
RUN mkdir build
WORKDIR build
RUN cmake .. -GNinja
RUN cmake --build . --parallel
RUN cmake --install .


FROM base

WORKDIR /home/qt

# additional packages for linuxDeployQt
RUN apt-get update && apt-get install -y \
 libncurses5-dev \
 libfuse-dev \
 libjasper-dev \
 libegl1-mesa-dev \
 && apt-get -qq clean \
 && rm -rf /var/lib/apt/lists/*

COPY --from=unpacker /usr/local /usr/local

RUN wget https://github.com/probonopd/linuxdeployqt/releases/download/7/linuxdeployqt-7-x86_64.AppImage && chmod a+x linuxdeployqt-7-x86_64.AppImage
