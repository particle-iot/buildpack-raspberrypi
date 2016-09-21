FROM particle/buildpack-base:0.3.6

ENV XTOOLS_HOME=/x-tools
ENV XTOOLS_BUILD=/tmp/x-tools-build

COPY .config $XTOOLS_BUILD/.config

# Packages used only when building this container
ENV BUILD_PACKAGES="bzip2 xz-utils gcc g++ gperf bison flex texinfo wget help2man gawk libtool-bin automake ncurses-dev"

ENV BOOST_VERSION=1_59_0
ENV BOOST_VERSION_DOT=1.59.0
ENV BOOST_HOME=/boost
ENV BOOST_ROOT=$BOOST_HOME/boost_$BOOST_VERSION

COPY bin /bin

ENV PATH=$PATH:$XTOOLS_HOME/arm-unknown-linux-gnueabi/bin/

# Build the ARM toolchain using the crosstool-ng toolchain builder
RUN apt-get update -q \
      && apt-get install -qy make $BUILD_PACKAGES \
      && /bin/install-xtools \
      && /bin/build-boost \
      && apt-get remove -qy $BUILD_PACKAGES && apt-get autoremove -qy && apt-get clean && apt-get purge \
      && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

