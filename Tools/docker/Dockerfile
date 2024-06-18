#
# PX4 base development environment
#

FROM ubuntu:24.04
LABEL maintainer="Daniel Agar <daniel@agar.ca>"

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
RUN apt-get update && apt-get -y --quiet --no-install-recommends install \
		astyle \
		autoconf \
		automake \
		binutils-arm-none-eabi \
		bison \
		build-essential \
		bzip2 \
		ca-certificates \
		ccache \
		cmake \
		cppcheck \
		curl \
		dirmngr \
		doxygen \
		file \
		flex \
		g++ \
		g++-aarch64-linux-gnu \
		g++-arm-linux-gnueabihf \
		gcc \
		gcc-aarch64-linux-gnu \
		gcc-arm-linux-gnueabihf \
		gcc-arm-none-eabi \
		gdb \
		gdb-multiarch \
		genromfs \
		git \
		gnupg \
		gosu \
		gperf \
		kconfig-frontends \
		lcov \
		libstdc++-arm-none-eabi-newlib \
		libncurses-dev \
		libfreetype6-dev \
		libgtest-dev \
		libpng-dev \
		libssl-dev \
		libtool \
		lsb-release \
		make \
		ninja-build \
		openjdk-8-jdk \
		openjdk-8-jre \
		openssh-client \
		pkg-config \
		python3-dev \
		python3-setuptools \
		python3-wheel \
		python3-pip \
		python3-venv \
		rsync \
		shellcheck \
		tzdata \
		unzip \
		uncrustify \
		valgrind \
		vim-common \
		wget \
		xsltproc \
		zip \
	&& apt-get -y autoremove \
	&& apt-get clean autoclean \
	&& rm -rf /var/lib/apt/lists/{apt,dpkg,cache,log} /tmp/* /var/tmp/*

# gtest
RUN cd /usr/src/gtest \
	&& mkdir build && cd build \
	&& cmake .. && make -j$(nproc) \
	&& find . -name \*.a -exec cp {} /usr/lib \; \
	&& cd .. && rm -rf build

RUN echo "I'm building for $TARGETARCH"

# symlink to arm-none-eabi-gcc
# RUN ln -s /opt/gcc/bin/arm-none-eabi-gcc /usr/bin/arm-none-eabi-gcc \
# 	&& ln -s /opt/gcc/bin/arm-none-eabi-g++ /usr/bin/arm-none-eabi-g++ 

# # manual ccache setup
# RUN ln -s /usr/bin/ccache /usr/lib/ccache/cc \
# 	&& ln -s /usr/bin/ccache /usr/lib/ccache/c++

# # RUN ln -s /usr/bin/ccache /usr/lib/ccache/arm-none-eabi-g++ \
# # 	&& ln -s /usr/bin/ccache /usr/lib/ccache/arm-none-eabi-gcc

VOLUME /ccache
ENV CCACHE_DIR=/ccache 

VOLUME /venv
COPY requirements.txt /requirements.txt
RUN python3 -m venv /venv 
ENV PATH="/venv/bin:$PATH"
RUN /venv/bin/pip3 install -r requirements.txt

# create user with id 1001 (jenkins docker workflow default)
RUN useradd --shell /bin/bash -u 1001 -c "" -m user && usermod -a -G dialout user

# setup virtual X server
RUN mkdir /tmp/.X11-unix && \
	chmod 1777 /tmp/.X11-unix && \
	chown -R root:root /tmp/.X11-unix
ENV DISPLAY :99

ENV CCACHE_UMASK=000
ENV PATH="/usr/lib/ccache:$PATH"
ENV TERM=xterm
ENV TZ=UTC

# SITL UDP PORTS
EXPOSE 14556/udp
EXPOSE 14557/udp
# create and start as LOCAL_USER_ID
COPY entrypoint.sh /usr/local/bin/entrypoint.sh
WORKDIR /PX4
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
