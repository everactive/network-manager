---
title: "Edit Connections"
table_of_contents: True
---

# Edit Connections

This part will show you how to use a network-manager build-in editor to modify
the connections.

Type:

```
$ nmcli connection edit
```

It will bring up an interactive connection editor. In the first step you will be
prompted to enter connection type. The list of valid connection types will be
displayed on the screen. Once you select one you will be taken to the nmcli
console where you have the possibility to modify it's parameters.

Alternatively, if you know the valid connection types, you could jump straight
to the nmcli console by providing the type as a parameter:

```
$ nmcli connection edit type <type>
```

where <type> must be a valid connection type such as for example 'wifi'.

An attempt to edit the wifi connection type would look like:

```
kzapalowicz@core16-2:~$ nmcli c edit

(process:2311): nmcli-CRITICAL **: check_valid_name: assertion 'val' failed
Valid connection types: generic, 802-3-ethernet (ethernet), pppoe,
802-11-wireless (wifi), wimax, gsm, cdma, infiniband, adsl, bluetooth, vpn,
802-11-olpc-mesh (olpc-mesh), vlan, bond, team, bridge, bond-slave, team-slave,
bridge-slave, no-slave, tun, ip-tunnel, macvlan, vxlan
Enter connection type: wifi

===| nmcli interactive connection editor |===

Adding a new '802-11-wireless' connection

Type 'help' or '?' for available commands.
Type 'describe [<setting>.<prop>]' for detailed property description.

You may edit the following settings: connection, 802-11-wireless (wifi),
802-11-wireless-security (wifi-sec), 802-1x, ipv4, ipv6
nmcli>
```

From now on it is possible to edit the wifi connection settings. The list of
settings is provided as in the example above. The nmcli console offers a set of
commands that can be used to navigate between settings. To get the list of
available commands type 'help' or '?'

```
nmcli> ?
------------------------------------------------------------------------------
---[ Main menu ]---
goto     [<setting> | <prop>]        :: go to a setting or property
remove   <setting>[.<prop>] | <prop> :: remove setting or reset property value
set      [<setting>.<prop> <value>]  :: set property value
describe [<setting>.<prop>]          :: describe property
print    [all | <setting>[.<prop>]]  :: print the connection
verify   [all | fix]                 :: verify the connection
save     [persistent|temporary]      :: save the connection
activate [<ifname>] [/<ap>|<nsp>]    :: activate the connection
back                                 :: go one level up (back)
help/?   [<command>]                 :: print this help
nmcli    <conf-option> <value>       :: nmcli configuration
quit                                 :: exit nmcli
------------------------------------------------------------------------------
nmcli> 
```
