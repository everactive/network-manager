---
title: Ethernet Support
table_of_contents: true
---

# Ethernet Support

The NetworkManager snap provides a configuration option to adjust
if it should manage ethernet network connections.

By default the NetworkManager snap does not manage ethernet network
devices as it would conflict with the default network management in
Ubuntu Core.

## Changing Ethernet Support

To enable management of ethernet network devices the snap provides the
*ethernet.enable* configuration option.

This configuration option accepts the following values

 * **false (default):** Ethernet support is disabled. All network
 devices matching the expression 'en*' or 'eth*' will be ignored.
 * **true:** All ethernet devices available on the system will be
 managed by NetworkManager. networkd will not manage any of these
 anymore.

Changing the *ethernet* configuration option needs a reboot of the
device it's running on:

```
 $ snap set network-manager ethernet.enable=true
 $ sudo reboot
```

Once ethernet support is enabled NetworkManager will take over
management of all available ethernet network devices on the device.
**This may cause temporary connection loss for the device.**

NetworkManager will reuse existing configurations files from */etc/netplan*
when ethernet support is enabled.
