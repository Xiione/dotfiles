#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Requesting sudo privileges at the start
echo -e "${BLUE}Requesting sudo privileges...${NC}"
sudo -v
if [ $? -ne 0 ]; then
    echo -e "${RED}Error: Failed to obtain sudo privileges.${NC}"
    exit 1
fi

# Keep sudo privileges alive while the script runs
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Prompt the user for selecting an option
while true; do
    while true; do
        echo -e "${BLUE}Select an option:${RED}"
        echo -e "WARNING: Enabling Game mode for your process MAY or MAY NOT improve its overall performance.\nThus, keep this in mind while using this tool. In case you encounter "errors" after launching\nyour game or seems slower, restart your Mac.\n\nIf a process is already running in Game mode, please set first its priority number to 20. ${YELLOW}"
        echo -e "[1] Revert Game mode default behavior"
        echo -e "[2] Force Game mode on and run it for a specific software"
        echo -e "[3] Exit"
        read -p "$(echo -e ${BLUE}Enter the number of the option you want to select:${NC})" user_option

        if [[ $user_option -eq 1 || $user_option -eq 2 || $user_option -eq 3 ]]; then
            break
        else
            echo -e "${RED}Invalid option. Please enter 1, 2, or 3.${NC}"
        fi
    done
    
    if [[ $user_option -eq 1 ]]; then
        # Revert Game mode default behavior
        sudo /Applications/Xcode.app/Contents/Developer/usr/bin/gamepolicyctl game-mode set auto
        echo -e "${GREEN}Successfully restored Game mode default behavior.${NC}"
        exit 0
    elif [[ $user_option -eq 2 ]]; then
        # Force Game mode on
        sudo /Applications/Xcode.app/Contents/Developer/usr/bin/gamepolicyctl game-mode set on
        
        # List all active window processes and allow the user to pick one to change its priority
        echo -e "${BLUE}Listing active window processes...${NC}"
        active_processes=$(osascript -e 'tell application "System Events" to get the name of every application process whose visible is true')

        # Split the active_processes output by comma and handle multi-word process names correctly
        IFS=","
        read -r -a process_array <<< "$active_processes"

        echo -e "${BLUE}Active window processes:${NC}"
        for i in "${!process_array[@]}"; do
            process_name=$(echo -e "${process_array[$i]}" | xargs)
            echo -e "${YELLOW} [$i] $process_name${NC}"
        done

        # Select a process ID
        while true; do
            read -p "$(echo -e ${BLUE}Enter the number of the process you want to change the priority for:${NC})" process_number

            if [[ $process_number -ge 0 && $process_number -lt ${#process_array[@]} ]]; then
                selected_process=$(echo -e "${process_array[$process_number]}" | xargs)
                selected_pid=$(pgrep "$selected_process")

                if [ -z "$selected_pid" ]; then
                    echo -e "${RED}Error: Unable to retrieve process ID for $selected_process.${NC}"
                else
                    break
                fi
            else
                echo -e "${RED}Invalid selection. Please enter a number between 0 and $((${#process_array[@]} - 1)).${NC}"
            fi
        done

        # Set the priority number of the selected process
        while true; do
            read -p "$(echo -e ${BLUE}Enter the new priority for $selected_process. -20 for max, 0 for average, 20 for lowest:${NC})" new_priority

            if [[ $new_priority =~ ^-?[0-9]+$ && $new_priority -ge -20 && $new_priority -le 20 ]]; then
                echo -e "${GREEN}Setting priority of $selected_process (PID: $selected_pid) to $new_priority...${NC}"
                sudo renice $new_priority -p $selected_pid
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}$selected_process priority set to $new_priority successfully.${NC}"
                    exit 0
                else
                    echo -e "${RED}Error: Failed to set priority for $selected_process.${NC}"
                fi
            else
                echo -e "${RED}Invalid priority value: $new_priority. Please enter a value between -20 and 20.${NC}"
            fi
        done
    elif [[ $user_option -eq 3 ]]; then
        exit 0
    fi
done

sleep 1

echo -e "${GREEN}Game mode script completed.${NC}"
