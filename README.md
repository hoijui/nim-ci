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

### Example for GitLab-CI

This `.gitlab-ci.yml` file compiles the software
for Linux and Windows (both 64bit).

```yaml
default:
  image: hoijui/nim-ci:latest

pages:
  script:
  - |
    echo
    echo "Compiling the software for Linux ..."
    nimble -y build
    echo
    echo "Cross-compiling the software for Windows 64 ..."
    nimble -y build \
      --os:windows \
      --cpu:amd64 \
      --gcc.exe:/usr/bin/x86_64-w64-mingw32-gcc \
      --gcc.linkerexe:/usr/bin/x86_64-w64-mingw32-gcc \
      -d:release \
      --app:console \
      --opt:size \
      --passL:-static \
      --opt:speed \
      --embedsrc \
      --threads:on \
      --checks:on
  only:
    - master
  artifacts:
    paths:
    - public
```

### Example project (GitLab)

See the [.gitlab-ci.yml](https://gitlab.com/OSEGermany/osh-tool/-/blob/master/.gitlab-ci.yml)
of the [`osh-tool`](https://gitlab.com/OSEGermany/osh-tool)
for a sample project that uses `nim-ci`.
