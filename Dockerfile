# SPDX-FileCopyrightText: 2021-2024 Robin Vobruba <hoijui.quaero@gmail.com>
#
# SPDX-License-Identifier: Unlicense

FROM bitnami/minideb:bookworm

ARG HOME="/root"
RUN pwd

RUN install_packages \
	build-essential \
	ca-certificates \
	curl \
	git \
	libpcre3-dev \
	libssl-dev \
	mingw-w64 \
	musl \
	musl-dev \
	musl-tools \
	pandoc \
	unzip \
	zip

ARG WORK_DIR="$HOME"
WORKDIR "$WORK_DIR"

# Download and execute ChooseNim.
# It installs latest version of nim, nimble
# and some other basic Nim tools.
RUN curl "https://nim-lang.org/choosenim/init.sh" \
	--output "choosenim_init.sh" \
	-sSf
RUN sh choosenim_init.sh -y
ENV NIM_BINS="$HOME/.nimble/bin"
ENV PATH="$NIM_BINS:${PATH}"

# This can be set from outside,
# for example on the command line with:
# docker build . --build-arg NIM_VERSION=some_value # ... the rest of the build command is omitted
# NOTE This is replaced by the 'inject-dockerfile' script.
ARG NIM_VERSION="REPLACE_ME"
ARG GIT_VERSION="REPLACE_ME"

# Downloads and extracts the win64 version of nim.
# We need this for some DLL dependencies at runtime
# (strangely, not at compile-/link-time).
ARG NIM_WIN_VERSION=$NIM_VERSION
ARG NIM_WIN_DIR="nim-${NIM_WIN_VERSION}-win64"
ARG NIM_WIN_ARCH="nim-${NIM_WIN_VERSION}_x64.zip"
RUN curl "https://nim-lang.org/download/$NIM_WIN_ARCH" \
		--output "$NIM_WIN_ARCH" \
		-sSf
RUN unzip "$NIM_WIN_ARCH"
RUN mv "nim-${NIM_WIN_VERSION}" "$NIM_WIN_DIR"

# Make these available to the user of the docker image
ENV NIM_WIN_VERSION=$NIM_WIN_VERSION
ENV NIM_WIN_DIR="$WORK_DIR/$NIM_WIN_DIR"
RUN echo "Installed win64 Nim version: NIM_WIN_VERSION=$NIM_WIN_VERSION"
RUN echo "Installed win64 Nim dir:     NIM_WIN_DIR='$NIM_WIN_DIR'"

LABEL maintainer="Robin Vobruba <hoijui.quaero@gmail.com>"
LABEL version="$GIT_VERSION"
LABEL description="A CI base image when building nim(lang) packages for Linux (native compilation) and Windows (cross compilation)."
