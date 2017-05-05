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

The routing table can be added or modified using the standard *ip* command which
is available on Ubuntu Core.

You can find more information on it on the following page:

* <https://linux.die.net/man/8/ip?>

Separately it is possible to modify routing information per single connection
using the nmcli tool. The parameters such as: gateway, routes and metrics can be
modified.

The following options are responsible:

```
ipv4.gateway:
ipv4.routes:
ipv4.route-metric:

ipv6.gateway:
ipv6.routes:
ipv6.route-metric:
```

These options can be modified in a following way:

```
$ nmcli connection modify <name> +ipv4.routes <destination> ipv4.gateway <gateway>
$ nmcli connection modify <name> ipv4.route-metric <metric>
```

Where &lt;name&gt; is the connection name. You can obtain it by listing
available connections on the system:

```
$ nmcli c show
```

&lt;destination&gt; is the destination network provided as a static IP address,
subnet or "default". &lt;gateway&gt; is the new gateway information.
&lt;metric&gt; is the new metric information.

Note that this kind of changes can be made separately for each connection thus
it is possible to provide a fine grained control over how the packets directed
to different networks are routed.

It is also important to understand that bringing up and down connections with
different values set for these options is in fact changing the routing table.
