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

wait_for_systemd_service() {
	while ! systemctl status $1 ; do
		sleep 1
	done
	sleep 1
}

wait_for_network_manager() {
	wait_for_systemd_service snap.network-manager.networkmanager
}

stop_after_first_reboot() {
	if [ $SPREAD_REBOOT -eq 1 ] ; then
		exit 0
	fi
}

mac_to_ipv6() {
  mac=$1
  ipv6_address=fe80::$(printf %02x $((0x${mac%%:*} ^ 2)))
  mac=${mac#*:}
  ipv6_address=$ipv6_address${mac%:*:*:*}ff:fe
  mac=${mac#*:*:}
  ipv6_address=$ipv6_address${mac%:*}${mac##*:}
  echo $ipv6_address
}