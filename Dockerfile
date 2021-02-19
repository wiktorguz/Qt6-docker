FROM ubuntu:18.04 as base

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update && apt-get install -y \
 python3-pip \
 build-essential \
 libfreetype6-dev \
 libx11-dev \
 libxcomposite-dev \
 mesa-common-dev \
 libcurl4-openssl-dev \
 libwebkit2gtk-4.0-dev \
 qtchooser \
 libfontconfig1 \
 curl \
 unzip \
 libgl1-mesa-dev \
 wget \
 && apt-get -qq clean \
 && rm -rf /var/lib/apt/lists/*

RUN pip3 install cmake ninja conan


#ENV QT_PATH /opt/Qt
#ENV QT_DESKTOP $QT_PATH/5.9.9/gcc_64
#ENV PATH $QT_DESKTOP/bin:$PATH


FROM base as builder
RUN wget https://download.qt.io/official_releases/qt/6.0/6.0.1/single/qt-everywhere-src-6.0.1.tar.xz
RUN tar -xf qt-everywhere-src-6.0.1.tar.xz
WORKDIR qt-everywhere-src-6.0.1
RUN mkdir build
WORKDIR build
RUN cmake .. -GNinja
RUN cmake --build . --parallel
RUN cmake --install .


# FROM base

# RUN apt-get update && apt-get install -y \
#  libncurses5-dev \
#  python3 \
#  ccache \
#  libfuse-dev \
#  libjasper-dev \
#  libegl1-mesa-dev \
#  && apt-get -qq clean \
#  && rm -rf /var/lib/apt/lists/*

# COPY --from=unpacker /opt/Qt /opt/Qt
# RUN qtchooser -install qt5.9 /opt/Qt/5.9.9/gcc_64/bin/qmake

# RUN wget https://github.com/probonopd/linuxdeployqt/releases/download/7/linuxdeployqt-7-x86_64.AppImage && chmod a+x linuxdeployqt-7-x86_64.AppImage