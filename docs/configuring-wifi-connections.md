---
title: "Configuring WiFi Connections"
table_of_contents: False
---

# Configuring WiFi Connections

First, determine the name of the WiFi interface:

```
$ network-manager.nmcli d
DEVICE             TYPE      STATE         CONNECTION
...
wlan0              wifi      disconnected     --
```

Make sure the WiFi radio is on (which is its default state):

```
$ network-manager.nmcli r wifi on
```

Then, list the available WiFi networks:

```
$ network-manager.nmcli d wifi list
*  SSID           MODE   CHAN  RATE       SIGNAL  BARS  SECURITY         
   ...
   my_wifi      Infra  5     54 Mbit/s  89      ▂▄▆█  WPA2      
```

To connect, for instance, to the access point ‘my_wifi’, you would use the
following commands:

```
$ network-manager.nmcli c add con-name <name> ifname wlan0 type wifi ssid my_wifi
$ network-manager.nmcli c modify <name> wifi-sec.key-mgmt wpa-psk wifi-sec.psk <password>
```

<name> is an arbitrary name given to the connection, and <password> is the
password for the connection (this last command can be used to change the
password too). New connections have DHCP enabled for both IPv4 and IPv6 by
default.

Once a connection has been created, NetworkManager will consider it for
connection whenever the device’s WiFi is disconnected and NetworkManager
detects the access point is available via recent scan results.

The autoconnect behaviour of a connection can be changed by modifying the
connection’s autoconnect property:

```
$ network-manager.nmcli c modify <name> connection.autoconnect [yes|no]
```

Some other interesting commands follow.

To show the details of a connection:

```
$ network-manager.nmcli c show <name>
```

To trigger a manual WiFi scan:

```
$ network-manager.nmcli d wifi rescan
```

To delete a connection:

```
$ network-manager.nmcli c delete <name>
```
