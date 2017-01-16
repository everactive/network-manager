---
title: Wake on WLAN
table_of_contents: true
---

# Wake on WLAN

Wake on WLAN (called WoWLAN in the following) is a technique which allows a device
to be woken up from standby power states to faciliate device management. It is based
on the well established standard for Wake on LAN. The functionality is not entirely
equivalent to Wake on LAN and there are some limitations.

The NetworkManager snap allows its users to configure one or more triggers to allow
the device it operates on to be woken up remotely.

An important precondition for WoWLAN to work is that your kernel WiFi driver has
support for it.

You can read more about the kernel side implementation on the following sites:

 * <https://wireless.wiki.kernel.org/en/users/documentation/wowlan>

## Enable Wake on WLAN globally

To allow users to enable or disable WoWLAN the snap provides two configuration
options:

 * **wifi.wake-on-wlan**
 * **wifi.wake-on-wlan-password**

Both options can be set via the *snapctl* command or by calling the
*/v2/snaps/[snap name]/conf* REST API endpoint (see
<https://github.com/snapcore/snapd/wiki/REST-API> for details) of
the snapd service.

Both configuration options will affect all wireless network devices. If you
want to change it just for a single wireless connection please read the


### wifi.wake-on-wlan

This configuration options accepts the following options

 * **disabled (default):** Wake on WLAN is disabled for all wireless network devices
 * **any:** Wake on WLAN is enabled and any possible trigger will cause the system to wake up.
 * **disconnect:** If a connection to a station gets disconnected the device will be woken up.
 * **magic:** Wake on WLAN is enabled and only a received magic packet will cause the 
 system to wake up. The magic packet has the same structure as the one
 used for Wake on LAN. For more details see <https://en.wikipedia.org/wiki/Wake-on-LAN#Magic_packet>
 The content of the magic packet can be extended with the
 wifi.wake-on-wlan-password option to require the client to send a
 specific byte sequence functioning as a password so that not anyone
 unpriviledged can wake up the system.
 * **gtk-rekey-failure:** A failure of a GTK rekey operation will cause the device to wake up.
 * **4way-handshake:** Reiteration of the 4way handshake will cause the device to wake up.
 * **rfkill-release:** Release of a rfkill will cause the device to wake up.
 * **tcp:** Any incoming TCP packet will cause the device to wake up.


```
 $ snap set network-manager wifi.wake-on-wlan=magic
```

### wifi.wake-on-wlan-password

This configuration option accepts a textual value. If specified, the value will
be used in addition to the wireless device MAC address to function as a password
to disallow unpriviledged actors to wake up the device.

Example:

```
 $ snap set network-manager wifi.wake-on-wlan-password=MyPassword
```

## Per connection configuration

To configure WoWLAN per connection you have to use the *nmcli* utility which comes
with the NetworkManager snap. It allows you to configure the same two options
as the snap accepts. However the *wifi.wake-on-wlan* option takes a numeric value
instead of a textual one.

The *wifi.wake-on-wlan* option accepts the following values (see above for a detailed
description of each value)

 * **0:** disabled
 * **1:** Use global default configuration.
 * **2:** any
 * **4:** disconnect
 * **8:** magic
 * **16:** gtk-rekey-failure
 * **32:** 4way-handshake
 * **128:** rfkill-release
 * **256:** tcp

The *wifi.wake-on-wlan-password* option accepts the same values as the snap
configuration option does.

Example:

```
 $ nmcli c modify my-connection wifi.wake-on-wlan 2
 $ nmcli c modify my-connection wifi.wake-on-wlan-password Test1234
```