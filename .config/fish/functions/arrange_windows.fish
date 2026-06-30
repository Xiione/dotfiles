function arrange_windows --description 'Arrange application windows across yabai spaces'
    set -l app_names
    set -l window_ids

    yabai -m query --windows | jq -r '.[] | [.id, (.app | gsub("[^a-zA-Z0-9_]"; ""))] | @tsv' \
        | while read -l window_id app_name
        set -a window_ids "$window_id"
        set -a app_names "$app_name"
        yabai -m window "$window_id" --space 5
    end

    set -l space_1 Neogurt
    set -l space_2 Arc
    set -l space_3 KeePassXC Calendar Reminders Messages Obsidian
    set -l space_4 Nicotine Feishin Discord
    set -l layouts space_1 space_2 space_3 space_4

    for space_number in (seq (count $layouts))
        set -l previous_id

        for app_name in $$layouts[$space_number]
            set -l app_index (contains --index -- "$app_name" $app_names)
            test -n "$app_index"; or continue

            set -l window_id $window_ids[$app_index]
            yabai -m window "$window_id" --space "$space_number"

            if test -n "$previous_id"
                yabai -m window "$previous_id" --stack "$window_id"
            end

            set previous_id "$window_id"
        end
    end

    command -q sketchybar; and sketchybar --trigger windows_on_spaces
end
