#!/bin/sh -ex

SUDO=
if [ $(id -u) -ne 0 ]; then
	SUDO=sudo
fi

# Install all necessary build dependencies in our bare build environment
$SUDO apt update
$SUDO apt install -y --force-yes \
        autoconf autoconf-archive pkg-config \
        libtool gcc g++ libc6-dev \
        intltool gtk-doc-tools libdbus-glib-1-dev libdbus-1-dev libiw-dev \
        libglib2.0-dev libnl-3-dev libnl-route-3-dev libnl-genl-3-dev \
        libnss3-dev libgnutls28-dev libgcrypt11-dev uuid-dev systemd \
        libsystemd-dev libudev-dev libgudev-1.0-dev libgirepository1.0-dev \
        gobject-introspection libglib2.0-doc libmm-glib-dev libndp-dev \
        libreadline-dev libnewt-dev dbus-test-runner isc-dhcp-client \
        python-dbus python-gi iptables ppp-dev

./autogen.sh
./configure
make -j$(nproc)
make check
