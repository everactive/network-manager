---
title: "FAQ"
table_of_contents: False
---

# FAQ

This section covers some of the most commonly encountered problems and attempts
to provide solutions for them.

## Ethernet devices are not used

### Possible cause: Ethernet support is disabled for NetworkManager

By default the network-manager snap disables ethernet support to avoid conflicts
with networkd/netplan which are used by default on Ubuntu Core. See
*[Enable Ethernet Support](enable-ethernet-support.md)* for details on how to
enable it.
