#!/bin/bash

. $TESTSLIB/snap-names.sh

# Remove all snaps not being the core, gadget, kernel or network-manager snap
for snap in /snap/*; do
	snap="${snap:6}"
	case "$snap" in
		"bin" | "$gadget_name" | "$kernel_name" | "$core_name" | "network-manager" )
			;;
		*)
			snap remove "$snap"
			;;
	esac
done

# Ensure we have the same state for snapd as we had before
systemctl stop snapd.service snapd.socket
rm -rf /var/lib/snapd/*
$(cd / && tar xzf $SPREAD_PATH/snapd-state.tar.gz)
rm -rf /root/.snap
systemctl start snapd.service snapd.socket
