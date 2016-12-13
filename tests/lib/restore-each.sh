#!/bin/bash

. $TESTSLIB/snap-names.sh
. $TESTSLIB/utilities.sh

# Remove all snaps not being the core, gadget, kernel or snap we're testing
for snap in /snap/*; do
	snap="${snap:6}"
	case "$snap" in
		"bin" | "$gadget_name" | "$kernel_name" | "$core_name" | "$SNAP_NAME" )
			;;
		*)
			snap remove "$snap"
			;;
	esac
done

# Drop any generated or modified netplan configuration files. The original
# ones will be restored below.
rm -f /etc/netplan/*

# Ensure we have the same state for snapd as we had before
systemctl stop snapd.service snapd.socket
rm -rf /var/lib/snapd/*
tar xzf $SPREAD_PATH/snapd-state.tar.gz -C /
rm -rf /root/.snap
systemctl start snapd.service snapd.socket

systemctl stop snap.network-manager.networkmanager
rm -rf /var/snap/network-manager/*
tar xzf $SPREAD_PATH/nm-state.tar.gz -C /
systemctl start snap.network-manager.networkmanager

# Make sure the original netplan configuration is applied and active
netplan generate
netplan apply
