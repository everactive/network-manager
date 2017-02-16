---
title: "Enable Ethernet Support"
table_of_contents: False
---

# Enable Ethernet Support

By default the network-manager snap has support for ethernet disable as Ubuntu
Core uses networkd/netplan by default to manage ethernet connections. As both
will naturally conflict the snap currently keeps ethernet disabled and the user
has to take care to get it enabled after installation.

For future versions we plan to improve this to allow the network-manager snap
to perform all necessary snaps to enable ethernet support automatically.

## Configure the system for ethernet support

To enable ethernet support the following steps need to be manually executed.

Before doing any of the steps described below backup the content of /etc/netplan
to be able to restore it at a later point.

Also ensure you do a full backup of the system if you prefer to as your system
may end up without any network connection which can lead to problems accessing
headless devices when no serial console is available.

As first step install the network-manager as described [here](installation.md)
if it is not already installed.

If you don't want any netplan configuration files being used by NetworkManager
delete all files from /etc/netplan. Remaining files will be considered by
NetworkManager and used to configure ethernet and wireless network devices. The
configuration of those connections can't be changed through the NetworkManager
command line utilities or the DBus API.

To tell netplan to render NetworkManager connection configuration files by
default, create the file /etc/netplan/00-default-nm-renderer.yaml with the
following content

```
network:
  renderer: NetworkManager
```

Everything is now setup and ready for NetworkManager to take over. After a
reboot of the system NetworkManager will manage all ethernet connections.
Reboot the system with

```
$ sudo reboot
```

When the system is rebooted NetworkManager should automatically setup attached
ethernet ports or use existing netplan configuration files to setup connections.

Once logged into the system you can check the current connection status by

```
$ network-manager.nmcli c show
```
