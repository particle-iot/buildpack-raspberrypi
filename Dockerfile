FROM particle/buildpack-base:0.3.6

COPY .config /tmp/x-tools-build/.config

ENV BUILD_PACKAGES="bzip2 xz-utils gcc g++ gperf bison flex texinfo wget help2man gawk libtool-bin automake ncurses-dev"

# Build the ARM toolchain using the crosstool-ng toolchain builder
RUN apt-get update -q \
      && apt-get install -qy make $BUILD_PACKAGES \
      && curl -o /tmp/crosstool-ng.tar.bz2 http://crosstool-ng.org/download/crosstool-ng/crosstool-ng-1.22.0.tar.bz2 \
      && cd /tmp && tar xfj /tmp/crosstool-ng.tar.bz2 \
      && cd /tmp/crosstool-ng && ./configure && make install \
      && cd /tmp/x-tools-build && ct-ng build \
      && cd /tmp/crosstool-ng && make uninstall \
      && apt-get remove -qy $BUILD_PACKAGES && apt-get clean && apt-get purge \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /usr/local/gcc-arm-embedded/share

