#!/bin/sh
snap_install() {
	name=$1
	if [ -n "$SNAP_CHANNEL" ] ; then
		# Don't reinstall if we have it installed already
		if ! snap list | grep $name ; then
			snap install --$SNAP_CHANNEL $name
		fi
	else
		# Need first install from store to get all necessary assertions into
		# place. Second local install will then bring in our locally built
		# snap.
		snap install $name
		snap install --dangerous $PROJECT_PATH/$name*_amd64.snap
	fi
}

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

# waits for a service to be active. Besides that, waits enough
# time after detecting it to be active to prevent restarting
# same service too quickly several times.
# $1 service name
# $2 start limit interval in seconds (default set to 10. Exec `systemctl show THE_SERVICE -p StartLimitInterval` to verify)
# $3 start limit burst. Times allowed to start the service in start_limit_interval time (default set to 5. Exec `systemctl show THE_SERVICE -p StartLimitBurst` to verify)
wait_for_systemd_service() {
	while ! systemctl status $1 ; do
		sleep 1
	done
  # As debian services default limit is to allow 5 restarts in a 10sec period
  # (StartLimitInterval=10000000 and StartLimitBurst=5), having enough wait time we
  # prevent "service: Start request repeated too quickly" error.
  #
  # You can check those values for certain service by typing:
  #   $systemctl show THE_SERVICE -p StartLimitInterval,StartLimitBurst
  #
  if [ $# -ge 2 ]; then
    start_limit_interval = $2
  else
    start_limit_interval=$(systemctl show $1 -p StartLimitInterval | sed 's/StartLimitInterval=//')
    # original limit interval is provided in microseconds.
    start_limit_interval=$((start_limit_interval / 1000000))
  fi

  if [ $# -eq 3 ]; then
    start_limit_burst = $3
  else
    start_limit_burst=$(systemctl show $1 -p StartLimitBurst | sed 's/StartLimitBurst=//')
  fi

  # adding 1 to be sure we exceed the limit
  sleep_time=$((1 + $start_limit_interval / $start_limit_burst))
	sleep $sleep_time
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

# Creates an open AP using wifi-ap with SSID Ubuntu
create_open_ap() {
    snap install wifi-ap
    # wifi-ap needs a bit of time to settle down
    while ! wifi-ap.status | MATCH "ap.active: true" ; do
        sleep .5
    done
    /snap/bin/wifi-ap.config set wifi.interface=wlan0
    /snap/bin/wifi-ap.config set wifi.ssid=Ubuntu
    /snap/bin/wifi-ap.config set wifi.security=open

    # NM some times still detects the wifi as WPA2 instead of open, so we need
    # to re-start to force it to refresh. See LP: #1704085. Before that, we have
    # to wait to make sure the AP sends the beacon frames so wpa_supplicant
    # detects the AP changes and reports the right environment to the new NM
    # instance.
    sleep 30
    systemctl restart snap.network-manager.networkmanager.service
    while ! busctl status org.freedesktop.NetworkManager &> /dev/null ; do
        sleep 0.5
    done

    # Restarting NM breaks wifi-ap (it logs "Failed to set beacon parameters").
    # Restarting wifi-ap fixes the issue. See LP: #1704096.
    wifi-ap.status restart-ap
    while ! wifi-ap.status | MATCH "ap.active: true" ; do
        sleep .5
    done

    /snap/bin/network-manager.nmcli d wifi rescan
    while ! /snap/bin/network-manager.nmcli d wifi | MATCH Ubuntu ; do
        /snap/bin/network-manager.nmcli d wifi rescan
        sleep 5
    done
}
