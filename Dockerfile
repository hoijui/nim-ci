# SPDX-FileCopyrightText: 2021 Robin Vobruba <hoijui.quaero@gmail.com>
#
# SPDX-License-Identifier: Unlicense

FROM debian:latest

ENV WORKDIR="$HOME"
WORKDIR "$WORKDIR"

RUN apt-get update

RUN apt-get install --no-install-recommends -y -qq \
	cpio \
	wget \
	curl \
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

# This can be set from outside,
# for exampel on the command line with:
# docker build --build-arg NIM_VERSION=some_value # ... the rest of the build command is omitted
ARG NIM_VERSION "1.4.8"

# Downloads and extracts the win64 version of nim.
# We need this for some DLL dependencies at runtime
# (strangely, not at compile-/link-time).
ENV NIM_WIN_VERSION="$NIM_VERSION"
ENV NIM_WIN_DIR="$WORKDIR/nim-${NIM_WIN_VERSION}-win64"
ENV NIM_WIN_ARCH="nim-${NIM_WIN_VERSION}_x64.zip"
RUN curl "https://nim-lang.org/download/$NIM_WIN_ARCH" \
		--output "$NIM_WIN_ARCH" \
		-sSf
RUN unzip "$NIM_WIN_ARCH"
RUN mv "nim-${NIM_WIN_VERSION}" "$NIM_WIN_DIR"

LABEL maintainer="Robin Vobruba <hoijui.quaero@gmail.com>"
LABEL version="0.1.0"
LABEL description="A CI base image when building nim(lang) packages for Linux (native compilation) and Windows (cross compilation)."
