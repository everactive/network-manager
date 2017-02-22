---
title: Wake on WLAN
table_of_contents: True
---

# Wake on WLAN

Wake on WLAN (called WoWLAN in the following) is a feature which allows a device
to be woken up from standby power states to faciliate device management. It is based
on the well well-established standard for Wake on LAN. The functionality is not entirely
equivalent to Wake on LAN and there are some limitations.

The NetworkManager snap allows its users to configure one or more triggers to allow
the device it operates on to be woken up remotely.

An important precondition for WoWLAN to work is that your device's kernel WiFi driver has
support for it.

You can read more about the kernel side implementation on the following sites:

 * <https://wireless.wiki.kernel.org/en/users/documentation/wowlan>

### Enable Wake on WLAN Globally

To allow users to enable or disable WoWLAN, the snap provides two configuration
options:

 * **wifi.wake-on-wlan**
 * **wifi.wake-on-wlan-password**

Both options can be set via the configuration API snaps provide. See
<https://docs.ubuntu.com/core/en/guides/build-device/config-hooks> for more
details.

Both configuration options will affect all wireless network devices. If you
want to change it just for a single wireless connection please have a look at
the chapter [Per Connection Configuration](#per-connection-configuration) below.


#### wifi.wake-on-wlan

This configuration option accepts the following values:

 * **disabled (default):** Wake on WLAN is disabled for all wireless network devices.
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

Example:

```
 $ snap set network-manager wifi.wake-on-wlan=magic
```

#### wifi.wake-on-wlan-password

This configuration option accepts a textual value. If specified, the value will
be used in addition to the wireless device MAC address to function as a password
that disallows unpriviledged actors to wake up the device.

Example:

```
 $ snap set network-manager wifi.wake-on-wlan-password=MyPassword
```
</br>
### Per Connection Configuration

To configure WoWLAN per connection you have to use the *nmcli* utility which comes
with the NetworkManager snap. It allows you to configure the same two options
as the snap accepts. However, the *wifi.wake-on-wlan* option takes a numeric value
instead of a textual one.

The *wifi.wake-on-wlan* option accepts the following values (see above for a detailed
description of each value)

 * **0:** disabled
 * **1:** Use global default configuration
 * **2:** any
 * **4:** disconnect
 * **8:** magic
 * **16:** gtk-rekey-failure
 * **32:** 4way-handshake
 * **128:** rfkill-release
 * **256:** tcp

The *wifi.wake-on-wlan-password* option accepts the same values as the snap
configuration option.

Example:

```
 $ nmcli c modify my-connection wifi.wake-on-wlan 2
 $ nmcli c modify my-connection wifi.wake-on-wlan-password Test1234
```
</br>
### Verify WoWLAN Configuration

NetworkManager will use the kernel to configure WoWLAN on the hardware level.
The *iw* utility provides a simple way to verify the right option is configured.

If you don't have the *iw* utility on your system you can install it with the
*wireless-tools* snap.

```
 $ snap install --devmode wireless-tools
 $ sudo wireless-tools.iw phy phy0 wowlan show
 WoWLAN is enabled:
 * wake up on magic packet
```

See the help output of the *iw* command for more documentation and available
options.
