This summarizes the current open points (unsorted, unpriorized and
probably incomplete):

- Confinement: Currently everything runs unconfined which needs to be
  changed to secure everything.

- ModemManager support: We need to modify modem manager the same
  way as we modified NetworkManager to not rely on any directories
  outside of SNAP_APP_PATH or SNAP_APP_DATA_PATH

- NetworkManager:
    * Fix usage of timestamp files outside of SNAP_APP_DATA_PATH
    * How are network connections kept across a snap update?
    * Multi architecture support: Currently we have some hard coded
      paths for amd64.
    * Do we have any problems with keeping host configuration in
      /etc/network/interfaces or with the networking systemd service?
    * DNS configuration with resolvconf needs to be verified
    * Maybe remove dnsmasq service again if we get it working when
      launched by NetworkManager directly.
    * Find out what can be dropped from our wrapper script
      bin/networkmanager with getting a bin/networkmanager.wrapper
      one from snappy automatically which does adjust LD_LIBRARY_PATH
      too.

- Integrate wpa-supplicant into the snap so we run completely
  independent of the system image.
