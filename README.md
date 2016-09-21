# Buildpack for Raspberry Pi

Buildpack for Particle firmware running on the Raspberry Pi.

[![Build Status](https://travis-ci.org/spark/buildpack-raspberrypi.svg)](https://travis-ci.org/spark/buildpack-raspberrypi) [![](https://imagelayers.io/badge/particle/buildpack-raspberrypi:latest.svg)](https://imagelayers.io/?images=particle/buildpack-raspberrypi:latest 'Get your own badge on imagelayers.io')

| |
|---|
| **Raspberry Pi (you are here)** |
| [Base](https://github.com/spark/buildpack-base) |

This image inherits [base buildpack](https://github.com/spark/buildpack-base).

## Overview

This buildpack contains a cross-compiler and other build tools
configured for the Raspberry Pi. The toolchain is built using the
crosstool-ng toolchain builder.

## Building image

**Before building this image, build or pull [buildpack-base](https://github.com/spark/buildpack-base).**

**This image takes about 30 minutes to build.** Go grab a coffee :coffee:

```bash
$ export BUILDPACK_IMAGE=raspberry-pi
$ git clone "git@github.com:spark/buildpack-${BUILDPACK_IMAGE}.git"
$ cd buildpack-$BUILDPACK_IMAGE
$ ./scripts/build-and-push
```

# TODO: The rest of the REAME needs to be updated for RPi

## Running

```bash
$ mkdir -p ~/tmp/input && mkdir -p ~/tmp/output && mkdir -p ~/tmp/cache
$ docker run --rm \
  -v ~/tmp/input:/input \
  -v ~/tmp/output:/output \
  -v ~/tmp/cache:/cache \
  -e FIRMWARE_REPO=https://github.com/spark/firmware.git#v0.5.3-rc.2 \
  -e PLATFORM_ID=3 \
  particle/buildpack-gcc
```

`FIRMWARE_REPO` will be fetched to cache directory provided with `-v` flag. It will also contain compilation intermediate files.

### Input files
Source files have to be placed in `~/tmp/input`

### Output files
After build `~/tmp/output` will be propagated with:

* `run.log` - `stdout` combined with `stderr`
* `stderr.log` - contents of `stderr`, usefull to parse `gcc` errors

**Files only available if compilation succeeds:**
* `firmware.bin` - compiled firmware

## Updating the toolchain

To update the toolchain, run ct-ng to generate a new .config file, 
update the repo with this .config file and rebuild the buildpack.

```
docker run --rm -ti particle/buildpack-raspberrypi /bin/bash
cd /tmp

cat < .config
# Copy-paste the current .config and press Ctrl-D

ct-ng menuconfig

cat .config
# Copy-paste the new config into the git repo and rebuild the container
```
