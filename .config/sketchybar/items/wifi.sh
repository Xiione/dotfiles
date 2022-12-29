#!/usr/bin/env sh

POPUP_CLICK_SCRIPT="sketchybar --set \$NAME popup.drawing=toggle"

sketchybar --add alias "Control Center,WiFi" right                      \
           --rename "Control Center,WiFi" wifi_alias                    \
           --set wifi_alias icon.drawing=off                            \
                              label.drawing=off                         \
                              alias.color=$WHITE                        \
                              width=45                                  \
                              align=right                               \
                              click_script="$POPUP_CLICK_SCRIPT"        \
                                 script="$PLUGIN_DIR/wifi.sh"           \
                                 update_freq=5                          \
                                 popup.drawing=off                      \
           --subscribe wifi_alias mouse.entered                         \
                                 mouse.exited                           \
                                 mouse.exited.global                    \

# sketchybar --add item            wifi.logo right                        \
#            --set wifi.logo       icon=$WIFI_SLASH                       \
#                                  icon.font="$FONT:SemiBold:16.0"        \
#                                  icon.color=$GREEN                      \
#                                  background.padding_right=10            \
#                                  background.padding_left=-3             \
#                                  label.drawing=off                      \
#                                  script="$PLUGIN_DIR/wifi.sh"           \
#                                  click_script="$POPUP_CLICK_SCRIPT"     \
#                                  update_freq=10                         \
#                                  popup.drawing=off                      \
#            --subscribe wifi.logo mouse.entered                          \
#                                  mouse.exited                           \
#                                  mouse.exited.global                    \
                                                                        
sketchybar --add item            wifi.ssid popup.wifi_alias             \
           --set wifi.ssid       label=SSID                             \
                                 icon=$NETWORK                          \
                                 icon.background.drawing=off            \
                                                                        \
           --add item            wifi.txrate popup.wifi_alias           \
           --set wifi.txrate     label="0 Mbps"                         \
                                 icon=$TX                               \
                                 icon.background.drawing=off            \
