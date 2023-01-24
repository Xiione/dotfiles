#!/usr/bin/env sh

sketchybar --add alias "Control Center,Battery" right                 \
           --rename "Control Center,Battery" battery_alias            \
           --set battery_alias icon.drawing=off                       \
                               label.drawing=off                      \
                               alias.color=$WHITE                     \
                               background.padding_right=-8            \
                               background.padding_left=3              \
                               width=30                               \
                               align=center                           \
                               update_freq=3                          \
                               popup.drawing=off                      \
