#!/bin/sh -ex
# Getters for snap properties

get_wifi_powersave() {
    value=$(snapctl get wifi.powersave)
    if [ -z "$value" ]; then
        value="disabled"
    fi
    echo "$value"
}

get_wifi_wake_on_wlan() {
    value=$(snapctl get wifi.wake-on-wlan)
    if [ -z "$value" ]; then
        value="disabled"
    fi
    echo "$value"
}

get_wifi_wake_on_password() {
    snapctl get wifi.wake-on-wlan-password
}

get_ethernet_enable() {
    value=$(snapctl get ethernet.enable)
    if [ -z "$value" ]; then
        # TODO Check if this is the way to set it to true in plano
        # (pre-injected file). But the gadget snap could be used instead!
        if [ -e /etc/netplan/00-default-nm-renderer.yaml ]; then
            value=true
        else
            value=false
        fi
    fi
    echo "$value"
}

get_debug_enable() {
    value=$(snapctl get debug.enable)
    if [ -z "$value" ]; then
        value="false"
    fi
    echo "$value"
}
