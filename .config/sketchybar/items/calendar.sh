#!/usr/bin/env sh

sketchybar --add item     calendar right                    \
           --set calendar icon=cal                          \
                          icon.font="$FONT:Black:12.0"      \
                          label.font="$FONT:SemiBold:13.0"  \
                          icon.padding_left=10              \
                          icon.padding_right=0              \
                          label.width=dynamic               \
                          label.align=right                 \
                          label.padding_left=5              \
                          background.padding_left=0         \
                          background.drawing=on             \
                          background.color=$CLICK           \
                          y_offset=0                        \
                          update_freq=30                    \
                          script="$PLUGIN_DIR/calendar.sh"  \
                          click_script="$PLUGIN_DIR/zen.sh" \
           --subscribe    calendar system_woke
