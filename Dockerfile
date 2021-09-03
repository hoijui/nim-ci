# SPDX-FileCopyrightText: 2021 Robin Vobruba <hoijui.quaero@gmail.com>
#
# SPDX-License-Identifier: Unlicense

FROM debian:latest

# ARG WORK_DIR="$HOME"
# WORKDIR "$WORK_DIR"

RUN apt-get update

RUN apt-get install --no-install-recommends -y -qq \
	cpio \
	wget \
	curl \
	unzip \
	ca-certificates \
	git \
	ccache \
	build-essential \
	mingw-w64 \
	pkg-config-mingw-w64-x86-64

# Download and execute ChooseNim
# (installs latest version of nim, nimble and some other basic nim tools)
RUN curl "https://nim-lang.org/choosenim/init.sh" \
	--output "choosenim_init.sh" \
	-sSf
RUN sh choosenim_init.sh -y
ENV NIM_BINS="$HOME/.nimble/bin"
ENV PATH="$NIM_BINS:${PATH}"

# This can be set from outside,
# for exampel on the command line with:
# docker build --build-arg NIM_VERSION=some_value # ... the rest of the build command is omitted
# NOTE This is replaced by the inject-dockerfile script.
# ARG NIM_VERSION "1.4.8"
ARG NIM_VERSION="1.4.x"

# Downloads and extracts the win64 version of nim.
# We need this for some DLL dependencies at runtime
# (strangely, not at compile-/link-time).
ARG NIM_WIN_VERSION=$NIM_VERSION
ARG NIM_WIN_DIR="nim-${NIM_WIN_VERSION}-win64"
ARG NIM_WIN_ARCH="nim-${NIM_WIN_VERSION}_x64.zip"
RUN echo "NIM_VERSION=$NIM_VERSION"
RUN echo "NIM_WIN_VERSION=$NIM_WIN_VERSION"
RUN echo "NIM_WIN_DIR=$NIM_WIN_DIR"
RUN echo "NIM_WIN_ARCH=$NIM_WIN_ARCH"
RUN curl "https://nim-lang.org/download/$NIM_WIN_ARCH" \
		--output "$NIM_WIN_ARCH" \
		-sSf
RUN unzip "$NIM_WIN_ARCH"
RUN mv "nim-${NIM_WIN_VERSION}" "$NIM_WIN_DIR"

# Make these available to the user of the docker image
ENV NIM_WIN_VERSION=$NIM_WIN_VERSION
ENV NIM_WIN_DIR=$NIM_WIN_DIR

LABEL maintainer="Robin Vobruba <hoijui.quaero@gmail.com>"
LABEL version="0.1.0"
LABEL description="A CI base image when building nim(lang) packages for Linux (native compilation) and Windows (cross compilation)."
