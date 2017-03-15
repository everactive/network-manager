---
title: "Enable Ethernet Support"
table_of_contents: False
---

# Enable Ethernet Support

By default the network-manager snap has support for Ethernet disabled as Ubuntu
Core uses networkd/netplan by default to manage Ethernet connections. As both
will naturally conflict, the network-manager snap is currently configured to
ignore Ethernet devices and the user has to take care to enable it after installation.

For future versions, we plan to improve this to allow the network-manager snap
to perform all necessary steps to enable Ethernet support automatically.

## Configure System for Ethernet Support

Before doing any of the steps described below, backup the content of /etc/netplan
to be able to restore it at a later point.

Also, ensure you do a full backup of the system as your system
may end up without any network connection which can lead to problems accessing
headless devices when no serial console is available.

Enable Ethernet support by following these steps:


As a first step, install the network-manager snap as described [here](installation.md)
if it is not already installed.

If you don't want any netplan configuration files being used by NetworkManager,
delete all files from /etc/netplan. Any remaining files will be considered by
NetworkManager and used to configure Ethernet and wireless network devices. The
configuration of those connections can't be changed through the NetworkManager
command line utilities or the DBus API.

To tell netplan to render NetworkManager connection configuration files by
default, create the file /etc/netplan/00-default-nm-renderer.yaml with the
following content:

```
network:
  renderer: NetworkManager
```

Everything is now set up and ready for NetworkManager to take over. After a
reboot of the system NetworkManager will manage all Ethernet connections.
Reboot the system with

```
$ sudo reboot
```

When the system is rebooted NetworkManager should automatically set up attached
Ethernet ports or use existing netplan configuration files to setup connections.

Once logged into the system you may check the current connection status by

```
$ nmcli c show
```