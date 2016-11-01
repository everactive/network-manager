#!/bin/bash

if [ $SPREAD_REBOOT -ge 1 ] ; then
	# Give system a moment to settle
	sleep 2

	# For debugging dump all snaps and connected slots/plugs
	snap list
	snap interfaces

	exit 0
fi

echo "Wait for firstboot change to be ready"
while ! snap changes | grep -q "Done"; do
	snap changes || true
	snap change 1 || true
	sleep 1
done

echo "Ensure fundamental snaps are still present"
. $TESTSLIB/snap-names.sh
for name in $gadget_name $kernel_name $core_name; do
	if ! snap list | grep -q $name ; then
		echo "Not all fundamental snaps are available, all-snap image not valid"
		echo "Currently installed snaps:"
		snap list
		exit 1
	fi
done

echo "Kernel has a store revision"
snap list | grep ^${kernel_name} | grep -E " [0-9]+\s+canonical"

# If we don't install network-manager here we get a system
# without any network connectivity after reboot.
if [ -n "$SNAP_CHANNEL" ] ; then
	snap install --$SNAP_CHANNEL network-manager
else
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
	snap install --dangerous network-manager_*_amd64.snap
	# As we have a snap which we build locally its unasserted and therefor
	# we don't have any snap-declarations in place and need to manually
	# connect all plugs.
	snap connect network-manager:nmcli network-manager:service
	snap connect network-manager:network-setup-observe
	snap connect network-manager:ppp
	EOF
	chmod +x /home/test/build-snap.sh
	sudo classic /home/test/build-snap.sh
fi

# Snapshot of the current snapd state for a later restore
if [ ! -f $SPREAD_PATH/snapd-state.tar.gz ] ; then
	systemctl stop snapd.service snapd.socket
	tar czf $SPREAD_PATH/snapd-state.tar.gz /var/lib/snapd /etc/netplan
	systemctl start snapd.socket
fi

# We need to reboot the system in order to get NetworkManager
# configured as the main network management service.
REBOOT
