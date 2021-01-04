FROM nvidia/cuda:10.0-cudnn7-devel
LABEL maintainer="chilopod <inkstone.mukade@gmail.com>"
ARG TENSORFLOW_VERSION=1.14.0
ARG BAZEL_VERSION=0.24.1

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH=$PATH:/usr/local/cuda/bin
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64

# ------------------ TENSORFLOW INSTALL --------------------
## dependency
RUN apt-get update && \
    apt-get install -y \
        build-essential cmake git wget zip unzip zlib1g-dev pkg-config \
	python3-dev python3-pip python3-numpy \
    ## Cleanup
    && rm -rf /var/lib/apt/lists/*
RUN pip3 install -U pip six numpy wheel setuptools mock future keras_applications keras_preprocessing

#sudo apt install python3-dev python3-pip
#mkdir env
#virtualenv -p python3 env
#source env/bin/activate
#pip install -U pip six numpy wheel mock
#pip install -U keras_applications==1.0.6 --no-deps
#pip install -U keras_preprocessing==1.0.5 --no-deps
#RUN pip3 install -U pip virtualenv
RUN mkdir -p /installs; exit 0
WORKDIR /installs

RUN wget https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VERSION}/bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh && \
    chmod +x bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh && \
    ./bazel-${BAZEL_VERSION}-installer-linux-x86_64.sh
RUN wget https://github.com/tensorflow/tensorflow/archive/v${TENSORFLOW_VERSION}.zip && \
    unzip v${TENSORFLOW_VERSION}.zip
WORKDIR /installs/tensorflow-${TENSORFLOW_VERSION}

ENV TF_NEED_CUDA=1
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ./configure 
RUN bazel build --config=opt --config=cuda --local_ram_resources=2048 //tensorflow/tools/pip_package:build_pip_package
RUN ./bazel-bin/tensorflow/tools/pip_package/build_pip_package /installs
RUN pip3 install /installs/tensorflow-${TENSORFLOW_VERSION}-cp36-cp36m-linux_x86_64.whl

## remove tmpdata
RUN rm /usr/bin/python3.6
RUN rm -rf /installs
