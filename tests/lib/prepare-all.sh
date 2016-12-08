#!/bin/bash

# We don't have to build a snap when we should use one from a
# channel
if [ -n "$SNAP_CHANNEL" ] ; then
	exit 0
fi

# If there is a network-manager snap prebuilt for us, lets take
# that one to speed things up.
if [ -e /home/network-manager/network-manager_*_amd64.snap ] ; then
	exit 0
fi

# Setup classic snap and build the network-manager snap in there
snap install --devmode --beta classic
cat <<-EOF > /home/test/build-snap.sh
#!/bin/sh
set -ex
apt update
apt install -y --force-yes snapcraft
cd /home/network-manager
snapcraft clean
snapcraft
# If we have any hooks we need to copy them in place as long as
# snapcraft does not support them
if [ -d hooks ]; then
	cp -r hooks prime/meta
	snapcraft snap prime
fi
EOF
chmod +x /home/test/build-snap.sh
sudo classic /home/test/build-snap.sh
snap remove classic

# Make sure we have a snap build
test -e /home/network-manager/network-manager_*_amd64.snap
