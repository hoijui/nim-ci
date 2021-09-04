<!--
SPDX-FileCopyrightText: 2021 Robin Vobruba <hoijui.quaero@gmail.com>

SPDX-License-Identifier: CC0-1.0
-->

[![License: GPL v3](
    https://img.shields.io/badge/License-Unlicense-blue.svg)](
    https://unlicense.org)
[![REUSE status](
    https://api.reuse.software/badge/github.com/hoijui/nim-ci)](
    https://api.reuse.software/info/github.com/hoijui/nim-ci)

# Nim(lang) CI base

A CI base docker image for when building [Nim(lang)](https://nim-lang.org) packages
for Linux (native compilation)
and Windows (cross compilation).

## Features

* Based on [`debian:latest`](https://hub.docker.com/_/debian)
* Uses [ChooseNim](https://github.com/dom96/choosenim) to install Nim and Nimble
* Contains the [Windows 64bit version of Nim](
  https://nim-lang.org/install_windows.html) -
  This allows packaging required base-DLLs with the win64 binary.
  (TODO Check if they are required for running under wine only,
  or also on native windows?)

## Usage

In your CI configuration,
choose `hoijui/nim-ci` as the base (docker-)image.
Then you are able to use nim and nimble for native-compiling (Linux 64bit),
and additionally MinGW for cross-compiling (Windows 64bit).

Example for GitLab-CI:

TODO
