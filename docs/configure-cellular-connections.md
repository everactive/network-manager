---
title: "Configure Cellular Connections"
table_of_contents: False
---

# Configure Cellular Connections

Check whether a modem was properly detected via:

```
$ modem-manager.mmcli -L
Found 1 modems:
	/org/freedesktop/ModemManager1/Modem/0 [description]
```

In this case we have just one modem, with id 0 (the number at the end of the DBus path).

Show detailed information about the modem:

```
$ modem-manager.mmcli -m 0
/org/freedesktop/ModemManager1/Modem/0 (device id '871faa978a12ccb25b9fa30d15667571ab38ed88')
  -------------------------
  Hardware |   manufacturer: 'ZTE INCORPORATED'
           |          model: 'MF626'
           |       revision: 'MF626V1.0.0B06'
           |      supported: 'gsm-umts'
           |        current: 'gsm-umts'
           |   equipment id: '357037039840195'
  -------------------------
  System   |         device: '/sys/devices/pci0000:00/0000:00:01.2/usb1/1-1'
           |        drivers: 'option1'
           |         plugin: 'ZTE'
           |   primary port: 'ttyUSB3'
           |          ports: 'ttyUSB0 (qcdm), ttyUSB1 (at), ttyUSB3 (at)'
  -------------------------
  Numbers  |           own : 'unknown'
  -------------------------
  Status   |           lock: 'sim-pin'
           | unlock retries: 'sim-pin (3), sim-puk (10)'
           |          state: 'locked'
           |    power state: 'on'
           |    access tech: 'unknown'
           | signal quality: '0' (cached)
  -------------------------
  Modes    |      supported: 'allowed: any; preferred: none'
           |        current: 'allowed: any; preferred: none'
  -------------------------
  Bands    |      supported: 'unknown'
           |        current: 'unknown'
  -------------------------
  IP       |      supported: 'none'
  -------------------------
  SIM      |           path: '/org/freedesktop/ModemManager1/SIM/0'

  -------------------------
  Bearers  |          paths: 'none'
```

In this case we can see that the SIM has PIN enabled and state is ‘locked’. To enter the PIN, we need to know the SIM number id, which in this case is 0 (it is the number at the end of /org/freedesktop/ModemManager1/SIM/0). Knowing that we can send the PIN to the SIM with:

```
$ modem-manager.mmcli -i 0 --pin=<PIN>
successfully sent PIN code to the SIM
```

Some more commands for handling the PIN are:

```
$ modem-manager.mmcli -i 0 --pin=<PIN> --enable-pin
$ modem-manager.mmcli -i 0 --pin=<PIN> --disable-pin
$ modem-manager.mmcli -i 0 --pin=<PIN> --change-pin=<NEW_PIN>
$ modem-manager.mmcli -i 0 --puk=<PUK>
```

Which enables PIN lock, disables PIN lock, changes the PIN code, and introduces the
[PUK](https://en.wikipedia.org/wiki/Personal_unblocking_code) in case we have blocked
the SIM, respectively.

After that we can set up a cellular connection doing

```
$ network-manager.nmcli c add type gsm ifname <interface> con-name <name> apn <operator_apn>
$ network-manager.nmcli r wwan on
```

where <interface> is the string listed as “primary port” when doing “mmcli -m <N>”, <name> is an arbitrary name used to identify the connection, and <operator_apn> is the APN name for your cellular data plan.  Note that <interface> is usually a serial port with pattern /dev/tty*, not a networking interface. The reason for ModemManager to use that instead of the networking interface is that this last one can appear/disappear dynamically while the ports do not if the hardware configuration remains unchanged. For instance, the networking interface can be ppp0, ppp1, etc., and it might be different each time it is possible to have other ppp connections with, say, VPNs.

After executing these commands, NetworkManager will automatically try to bring up the cellular connection whenever ModemManager reports that the modem has registered (the state of the modem can be checked with the previously introduced command “modem-manager.mmcli -m <N>”). When done successfully, NetworkManager will create routes for the new network interface, with less priority than Ethernet or WiFi interfaces. To disable the connection, we can do:

```
$ network-manager.nmcli r wwan off
```

or change the autoconnect property if we need more fine-grained control:

```
$ network-manager.nmcli c modify <name> connection.autoconnect [yes|no]
```

Finally, note that we can provide the PIN (so it is entered automatically) or more needed APN provisioning information when creating/modifying the WWAN connection. For instance:

```
$ network-manager.nmcli c add type gsm ifname <interface> con-name <name> apn <operator_apn> username <user> password <password> pin <PIN>
```
