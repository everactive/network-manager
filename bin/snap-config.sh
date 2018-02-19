#!/bin/sh -ex
# Functions to apply snap settings

_switch_wifi_powersave() {
    path=$SNAP_DATA/conf.d/wifi-powersave.conf
    # See https://developer.gnome.org/libnm/stable/NMSettingWireless.html#NMSettingWirelessPowersave
    # for the meaning of the different values for the wifi.powersave option.
    case $1 in
        enabled)
            cat <<EOF > "$path"
[connection]
wifi.powersave = 3
EOF
            ;;
        disabled)
            cat <<EOF > "$path"
[connection]
wifi.powersave = 2
EOF
            ;;
        *)
            echo "WARNING: invalid value '$1' supplied for wifi.powersave configuration option"
            exit 1
            ;;
    esac
}

_switch_wifi_wake_on_wlan() {
    value=0
    # See `man nm-settings` for details about those values. They
    # correspond to the enum NMSettingWirelessWakeOnWLan defined
    # in libnm-core. NetworkManager only allows us to set integer
    # values here.
    case "$1" in
        disabled)
            value=0
            ;;
        any)
            value=2
            ;;
        disconnect)
            value=4
            ;;
        magic)
            value=8
            ;;
        gtk-rekey-failure)
            value=16
            ;;
        eap-identity-request)
            value=32
            ;;
        4way-handshake)
            value=64
            ;;
        rfkill-release)
            value=128
            ;;
        tcp)
            value=256
            ;;
        *)
            echo "ERROR: Invalid value provided for wifi.wake-on-wlan"
            exit 1
            ;;
    esac
    password=$2
    path=$SNAP_DATA/conf.d/wifi-wowlan.conf

    echo "[connection]" > "$path"
    # If we don't get a value provided there is no one set in the snap
    # configuration and we can simply leave it out here and let
    # NetworkManager take its default one.
    if [ -n "$value" ]; then
        echo "wifi.wake-on-wlan=$value" >> "$path"
    fi
    if [ -n "$password" ]; then
        echo "wifi.wake-on-wlan-password=$password" >> "$path"
    fi
}

_switch_ethernet() {
    case "$1" in
        true)
            cat <<EOF > /etc/netplan/00-default-nm-renderer.yaml
network:
  renderer: NetworkManager
EOF
            ;;
        false)
            rm -f /etc/netplan/00-default-nm-renderer.yaml
            ;;
        *)
            echo "ERROR: Invalid value provided for ethernet"
            exit 1
    esac
}

_switch_debug_enable() {
    DEBUG_FILE=$SNAP_DATA/.debug_enabled
    # $1 true/false for enabling/disabling debug log level in nm
    # We create/remove the file for future executions and also change
    # the logging level of the running daemon.
    if [ "$1" = "true" ]; then
        if [ ! -f "$DEBUG_FILE" ]; then
            touch "$DEBUG_FILE"
            "$SNAP"/bin/nmcli-internal g log level DEBUG
        fi
    else
        if [ -f "$DEBUG_FILE" ]; then
            rm -f "$DEBUG_FILE"
            "$SNAP"/bin/nmcli-internal g log level INFO
        fi
    fi
}

. "$SNAP"/bin/snap-prop.sh

apply_snap_config() {
    _switch_wifi_powersave "$(get_wifi_powersave)"
    _switch_wifi_wake_on_wlan "$(get_wifi_wake_on_wlan)" "$(get_wifi_wake_on_password)"
    _switch_ethernet "$(get_ethernet_enable)"
    _switch_debug_enable "$(get_debug_enable)"
}
