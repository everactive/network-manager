---
title: "Install NetworkManager"
table_of_contents: True
---

# Install NetworkManager

The NetworkManager snap is currently available from the Ubuntu Store. It can
be installed on any system that support snaps but is only recommended on
[Ubuntu Core](https://www.ubuntu.com/core) at the moment.

You can install the snap with the following command:

```
 $ snap install network-manager
 network-manager 1.2.2-10 from 'canonical' installed
```

The snap is available from other channels (candidate, beta, edge) too but those
are not meant for the general use. Their meaning is internal to the development
team of the network-manager snap.

All necessary plugs and slots will be automatically connected within the
installation process. You can verify this with

```
$ snap interfaces network-manager
Slot                     Plug
:network-setup-observe   network-manager
:ppp                     network-manager
network-manager:service  network-manager:nmcli
-                        network-manager:modem-manager
```

**NOTE:** The _network-manager:modem-manager_ plug only gets connected when the
_modem-manager_ snap is installed too. Otherwise it stays disconnected.

Once the installation has successfully finished the
NetworkManager service is running in the background. You can check its current
status with

```
 $ systemctl status snap.network-manager.networkmanager
 ● snap.network-manager.networkmanager.service - Service for snap application network-manager.networkmanager
   Loaded: loaded (/etc/systemd/system/snap.network-manager.networkmanager.service; enabled; vendor preset: enabled)
   Active: active (running) since Thu 2017-02-16 09:59:39 UTC; 16s ago
   Main PID: 1389 (networkmanager)
   [...]
```

Now you have NetworkManager successfully installed.

## Next steps

 * TBD
