This document gives a short overview of how you can use NetworkManager
from the command line with the utilities we provide with the snap.

We ship the std. command line utility nmcli with the snap you can use
to configure NetworkManager. It allows most operations needed. In the
following parts of this document we will outline how you can use it.

You can list the currently available network connections with

 $ nmcli con show
 NAME  UUID                                  TYPE             DEVICE
 test  6d5d698d-0a81-4c78-966d-7c06ea200fd6  802-11-wireless  wlan0
 eth0  7e2c2f48-3ac0-4275-add1-98fbf2652237  802-3-ethernet   --  

The current status of the different network devices the host provides
can be listed with

 $ nmcli dev status
 DEVICE  TYPE      STATE         CONNECTION
 wlan0   wifi      connected     test
 eth0    ethernet  disconnected  --
 lo      loopback  unmanaged     --

To add a ethernet connection you can use the following command

 $ nmcli con add con-name test1 ifname eth0 type ethernet \
    ip4 192.168.178.21 gw4 192.168.178.1

Modifying the connection after it was added is possible with

 $ nmcli con mod test1 ipv4.dns 8.8.8.8

Finally we need to bring up the connection with

 $ nmcli con up test1

Showing detailed information about the active configuration

 $ nmcli con show test1

which lists various details.

Setting up a WiFi connection works similar.

 $ nmcli con add con-name test2 ifname wlan0 type wifi \
    ssid <YOUR SSID> \
    wifi-sec.key-mgmt wpa-psk \
    wifi-sec.psk <YOUR PASSPHRASE>

Finally we need to activate the connection

 $ nmcli con up test2

More information about what features the nmcli command provies can be
found at http://manpages.ubuntu.com/manpages/vivid/man1/nmcli.1.html
