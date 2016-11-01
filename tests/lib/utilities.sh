#!/bin/sh
switch_netplan_to_network_manager() {
	if [ -e /etc/netplan/00-default-nm-renderer.yaml ] ; then
		return 0
	fi

	cat <<-EOF > /etc/netplan/00-default-nm-renderer.yaml
network:
  renderer: NetworkManager
	EOF
}

switch_netplan_to_networkd() {
	if [ ! -e /etc/netplan/00-default-nm-renderer.yaml ] ; then
		return 0
	fi

	rm /etc/netplan/00-default-nm-renderer.yaml
}
