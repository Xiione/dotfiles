#!/usr/bin/env sh

CURRENT_WIFI="$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I)"
SSID="$(echo "$CURRENT_WIFI" | grep -o "SSID: .*" | sed 's/^SSID: //')"
CURR_TX="$(echo "$CURRENT_WIFI" | grep -o "lastTxRate: .*" | sed 's/^lastTxRate: //')"

if [ "$SSID" = "" ]; then
    sketchybar --set wifi.logo icon=􀙈  \
                               icon.color=0xffD8DEE9
    sketchybar --set wifi.ssid label="None"
    sketchybar --set wifi.txrate label="0 􀆏"
else
    if ((CURR_TX <= 10)); then
        sketchybar --set wifi.logo icon=􀙥  \
                                   icon.color=0xffEBCB8B
    else
        sketchybar --set wifi.logo icon=􀙇  \
                                   icon.color=0xffA3BE8C
    fi
    sketchybar --set wifi.ssid label="$SSID"
    sketchybar --set wifi.txrate label="${CURR_TX} 􀆏"
fi
