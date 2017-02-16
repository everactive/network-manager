---
title: "Report a Bug"
table_of_contents: False
---

# Rebort a Bug



General bugs against the modem-manager, network-manager or wifi-ap snaps can be
reported [here](https://bugs.launchpad.net/snappy-hwe-snaps/+filebug).

When submitting a bug report for a networking related bug, please attach:

 * */var/log/syslog*

And the output of the following two commands:

```
$ network-manager.nmcli d
$ network-manager.nmcli c
```

If there is a modem and the modem-manager snap is installed, also add the output
of

```
$ modem-manager.mmcli -m <N>
```

With being <N> the modem number as reported by

```
$ modem-manager.mmcli -L
```
