#!/usr/bin/env sh

sketchybar --add item           wifi.logo right                         \
           --set wifi.logo      icon=$WIFI_SLASH                        \
                                icon.font="$FONT:SemiBold:16.0"         \
                                icon.color=$GREEN                       \
                                background.padding_right=10             \
                                label.drawing=off                       \
                                script="$PLUGIN_DIR/wifi.sh"            \
                                update_freq=5                           \
                                                                        \
           --add item           wifi.ssid right                         \
           --set wifi.ssid      label.font="$FONT:Semibold:7"           \
                                label=SSID                              \
                                icon.drawing=off                        \
                                width=0                                 \
                                y_offset=6                              \
                                                                        \
           --add item           wifi.txrate right                       \
           --set wifi.txrate    label.font="$FONT:Bold:12"              \
                                label="TxRate"                          \
                                y_offset=-4                             \
                                width=50                                \
                                icon.drawing=off                        \
