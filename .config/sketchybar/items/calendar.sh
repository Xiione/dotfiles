#!/usr/bin/env sh

sketchybar --add item     calendar right                    \
           --set calendar icon=cal                          \
                          icon.font="$FONT:Black:12.0"      \
                          label.font="$FONT:SemiBold:13.0"  \
                          icon.padding_left=10              \
                          label.width=65                    \
                          label.align=right                 \
                          label.padding_right=11            \
                          background.padding_left=0         \
                          background.drawing=on             \
                          background.color=$CLICK           \
                          y_offset=1                        \
                          update_freq=30                    \
                          script="$PLUGIN_DIR/calendar.sh"  \
                          click_script="$PLUGIN_DIR/zen.sh" \
           --subscribe    calendar system_woke
