---
title: "Routing Tables"
table_of_contents: True
---

# Routing Tables

This section describes the way to setup routing table as well as it explains the
logic used to prioritize interfaces.

The routing table is stored in the kernel which merely acts upon it. The route
itself is set by the user-space tools. There is no preference as any tool
created for this reason will do. It can be either a DHCP client, ip command or
route command.

Routing table acts as a junction and is there to show where the different
network subnets will be routed to. An example of a routing table is shown below.

```
$ route
Kernel IP routing table
Destination     Gateway         Genmask         Flags Metric Ref    Use Iface
default         netgear.aircard 0.0.0.0         UG    600    0        0 wlp3s0
10.0.1.0        *               255.255.255.0   U     0      0        0 lxcbr0
10.42.0.0       *               255.255.255.0   U     100    0        0 enp0s25
link-local      *               255.255.0.0     U     1000   0        0 docker0
172.17.0.0      *               255.255.0.0     U     0      0        0 docker0
192.168.1.0     *               255.255.255.0   U     600    0        0 wlp3s0
192.168.122.0   *               255.255.255.0   U     0      0        0 virbr0
```

The packets going to &lt;Destination&gt; are pushed through the &lt;Gateway&gt;.
The '*' for the &lt;Gateway&gt; means that the destination network is directly
connected.

In the example above by default all packets are routed through "netgear.aircard"
which is the locally resolved hostname (192.168.1.1) for a router. On the other
hand the packets directed to addresses falling under 10.0.1.0 and following will
not.

The &lt;Metric&gt; column translates to the number of hops required to reach the
destination and is used to determine which route shall be preferred when there
are more than one route available for a specific destination. Since it
reassembles the concept of distance the lower it's value is the better.

The &lt;Metric&gt; value can be set manually but for the defaults the following
rules applies:

* The Ethernet is preferred over WiFi
* WiFi is preferred over WWAN

# Editing the Routing Tables

The routing table can be added or modified using the either *ip* or *route*
tools. Both are available on the Ubunct Core.

## Adding and Removing

To add the route type:

```
$ sudo route add <destination> gw <gateway>
```

where the &lt;destination&gt; is either a static IP address or a subnet or
"default". The &lt;gateway&gt; is the IP address or resolvable hostname of the
gateway. Optionally it is possble to specific the metric too:

```
$ sudo route add <destination> gw <gateway> metric <metric>
```

where the &lt;metric&gt; is the number that fits into uint32.

To remove the route type:

```
$ sudo route del <destination>
```

which will rmove the whole single entry from the routing table.

## Modification

The *route add* command will add a new entry to the routing table regardless if
the new one doubles with what is in the table already. In order to modify an
existing entry one has to type:

```
$ sudo ip route replace <destination> via <gateway> metric <metric>
```
