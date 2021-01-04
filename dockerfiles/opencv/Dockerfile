FROM nvidia/cuda:10.0-devel
LABEL maintainer="chilopod <inkstone.mukade@gmail.com>"

ARG OPENCV_VERSION=4.1.0
ARG GPU_ARCH=7.5

# ------------------ OPENCV INSTALL --------------------
## dependency
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y \
        build-essential cmake git wget unzip yasm pkg-config \
        libjpeg-dev libtiff-dev libpng-dev \
        libgtk-3-dev \
        libgtkglext1 libgtkglext1-dev \
        libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev \
        libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libavresample-dev \
        libopenblas-base libopenblas-dev liblapacke-dev \
        libdc1394-22-dev \
        libhdf5-dev libgflags-dev libgoogle-glog-dev \
        libvtk6-qt-dev \
	python-pip libpython-dev python-numpy \
        libpython3-dev python3-numpy \
    ## Cleanup
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /installs; exit 0
WORKDIR /installs

## opencv
RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip -O ${OPENCV_VERSION}.zip \
    && unzip ${OPENCV_VERSION}.zip
RUN wget https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip -O opencv_contrib-${OPENCV_VERSION}.zip\
    && unzip opencv_contrib-${OPENCV_VERSION}.zip

RUN mkdir opencv-${OPENCV_VERSION}/build
WORKDIR opencv-${OPENCV_VERSION}/build

RUN cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-${OPENCV_VERSION}/modules \
        -D WITH_JASPER=OFF \
        -D WITH_OpenBLAS=OFF \
        -D WITH_CUDA=ON \
        -D WITH_CUBLAS=ON \
        -D WITH_NVCUVID=OFF \
        -D CUDA_ARCH_BIN=5.0 \
        -D CUDA_ARCH_PTX="" \
        -D CUDA_FAST_MATH=1 .. \
    && export NUMPROC=$(nproc --all) \
    && make -j$NUMPROC install

## remove tmpdata
RUN rm -r /installs
