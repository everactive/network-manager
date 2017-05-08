---
title: "Configure WiFi Connections"
table_of_contents: True
---

# Configure WiFi Connections

This section explains how to establish a WiFi connection. It covers creating and
modyfying connections as well as directly connecting.

## Establish a Wireless Connection

This section will show how to establish a wifi connection to the wireles
network. Note that connecting directly will create implicitly a connection (that
can be seen with "nmcli c"). The naming of such will follow "SSID N" pattern,
where N is a number.

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

&lt;password&gt; is the password for the connection which needs to have 8-63
characters or 64 hexadecimal characters to specify a full 256-bit key.

## Connect to a Hidden Network

A hidden network is a normal wireless network that simply does not broadcast
it's SSID unless solicited. This means that its name cannot be searched and
must be known from some other source.

Issue the following command to create a connection associated with a hidden
network &lt;ssid&gt;:

```
$ nmcli c add type wifi con-name <name> ifname wlan0 ssid <ssid>
$ nmcli c modify <name> wifi-sec.key-mgmt wpa-psk wifi-sec.psk <password>
```

Now you can establish a connection by typing:

```
$ nmcli c up <name>
```

&lt;name&gt; is an arbitrary name given to the connection and &lt;password&gt;
is the password to the network. It needs to have between 8-63 characters or 64
hexadecimal characters in order to specify a full 256-bit key.

## Further Information

You will find further information and more detailed examples on following pages:

* <https://developer.gnome.org/NetworkManager/unstable/nmcli.html>
* <https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/7/html/Networking_Guide/sec-Using_the_NetworkManager_Command_Line_Tool_nmcli.html>
