---
title: "Configure WiFi Connections"
table_of_contents: True
---

# Configure WiFi Connections

This section explains how to establish a WiFi connection. It covers creating and
modyfying connections as well as connecting directly.

## Connect directly without creating a connection

First, determine the name of the WiFi interface:

```
$ nmcli d
DEVICE             TYPE      STATE         CONNECTION
...
wlan0              wifi      disconnected     --
```

Make sure the WiFi radio is on (which is its default state):

```
$ nmcli r wifi on
```

Then, list the available WiFi networks:

```
$ nmcli d wifi list
*  SSID           MODE   CHAN  RATE       SIGNAL  BARS  SECURITY
   ...
   my_wifi      Infra  5     54 Mbit/s  89      ▂▄▆█  WPA2
```

As an example, to connect to the access point 'my_wifi', you would use the
following command:

```
$ nmcli d wifi connect my_wifi password <password>
```

<password> is the password for the connection which needs to have 8-63
characters or 64 hexadecimal characters to specify a full 256-bit key.

## Create connection and connect

First, determine the name of the WiFi interface:

```
$ nmcli d
DEVICE             TYPE      STATE         CONNECTION
...
wlan0              wifi      disconnected     --
```

Make sure the WiFi radio is on (which is its default state):

```
$ nmcli r wifi on
```

Then, list the available WiFi networks:

```
$ nmcli d wifi list
*  SSID           MODE   CHAN  RATE       SIGNAL  BARS  SECURITY         
   ...
   my_wifi      Infra  5     54 Mbit/s  89      ▂▄▆█  WPA2      
```

As an example, to connect to the access point ‘my_wifi’, you would use the
following commands:

```
$ nmcli c add con-name <name> ifname wlan0 type wifi ssid my_wifi
$ nmcli c modify <name> wifi-sec.key-mgmt wpa-psk wifi-sec.psk <password>
```

<name> is an arbitrary name given to the connection, and <password> is the
password for the connection (this last command can be used to change the
password too). The password needs to have 8-63 characters or 64 hexadecimal characters to specify a full 256-bit key. New connections have DHCP enabled
for both IPv4 and IPv6 by default.

Once a connection has been created, NetworkManager will consider it for
a given connection whenever the device’s WiFi is disconnected and NetworkManager
detects the access point is available via recent scan results.

The autoconnect behaviour of a connection is enabled by default and can be changed
by modifying the connection’s autoconnect property:

```
$ nmcli c modify <name> connection.autoconnect [yes|no]
```

Some other interesting commands follow.

To show the details of a connection:

```
$ nmcli c show <name>
```

To trigger a manual WiFi scan:

```
$ nmcli d wifi rescan
```

To delete a connection:

```
$ nmcli c delete <name>
```

## Connect to a hidden network

This section describes how to connect to a hidden network using nmcli tool.

A hidden network is a normal wireless network that simply does not broadcast
it's SSID unless solicitaed. This means that it's name cannot be searched and
must be known from some other source.

As in the example above issue the following commandd to create connection
associated with a hidden network <ssid>:

```
$ nmcli c add type wifi con-name <name> ifname wlan0 ssid <ssid>
$ nmcli c modify <name> wifi-sec.key-mgmt wpa-psk wifi-sec.psk <password>
```

Now you can establish a connection by typing:

```
$ nmcli c up <name>
```

Similarly to the previous examples <name> is an arbitrary name given to the
connection and <password> is te password to the network. It needs to have
between 8-63 characters or 64 hexadecimal chcracters in order to specify a full
256-bit key.
