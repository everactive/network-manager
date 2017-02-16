---
title: "NetworkManager"
table_of_contents: False
---

# About NetworkManager

NetworkManager is a system network service that manages your network
devices and connections, attempts to keep network connectivity active
when available. It manages ethernet, WiFi, mobile broadband (WWAN) and
PPPoE devices while also providing VPN integration with a variety of
different VPN serivces.

By default network management on [Ubuntu Core](https://www.ubuntu.com/core) is
handled by systemd's
[networkd](https://www.freedesktop.org/software/systemd/man/systemd-networkd.service.html)
and [netplan](https://launchpad.net/netplan). While NetworkManager has some
support to handle netplan configuration files ethernet support is disabled by
default and has to be turned on explicitly to avoid conflicts with existing
network configuration.

## What NetworkManager offers

The upstream NetworkManager projects offers a wide range of features which
are theoretically are all available in the snap'ed version as well. However
as the snap should be always delivered in high quality we don't have yet all
upstream features enabled.

Currently we provide support for the following high level features:

 * WiFi connectivity
 * WWAN connectivity (together with ModemManager)
 * Ethernet connectivity

## Upstream documentation

Existing documentation from the upstream project can be found
[here](https://wiki.gnome.org/Projects/NetworkManager).
