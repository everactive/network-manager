---
title: "Report a Bug"
table_of_contents: False
---

# Rebort a Bug

Bugs can be reported [here](https://bugs.launchpad.net/snappy-hwe-snaps/+filebug).

When submitting a bug report, please attach:

 * */var/log/syslog*

And the output of the following two commands:

```
$ nmcli d
$ nmcli c
```

If there is a modem and the modem-manager snap is installed, also add the output
of

```
$ sudo modem-manager.mmcli -m <N>
```

With being <N> the modem number as reported by

```
$ sudo modem-manager.mmcli -L
```
