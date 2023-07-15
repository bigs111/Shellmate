#!/bin/bash

SERVERS_FILE=".shellmate"

function show_header() {
    echo -e "\e[1;31m"
    echo "   _____ _          _ _                 _       "
    echo "  / ____| |        | | |               | |      "
    echo " | (___ | |__   ___| | |_ __ ___   __ _| |_ ___ "
    echo "  \___ \| '_ \ / _ \ | | '_ \` _ \ / _\` | __/ _ \\"
    echo "  ____) | | | |  __/ | | | | | | | (_| | ||  __/"
    echo " |_____/|_| |_|\___|_|_|_| |_| |_|\__,_|\__\___|"
    echo -e "\e[0m"
}

function show_menu() {
    clear
    show_header
    echo -e "\e[1m\e[34m1. List Servers"
    echo "2. Add Server"
    echo "3. Delete Server"
    echo "4. Connect to Server"
    echo "6. Edit Server Details"
    echo "7. Search Server"
    echo "8. Exit"
    echo -e "--------------------------------\e[0m"
    read -p "Select your choice: " choice
    handle_choice "$choice"
}

function handle_choice() {
    case $1 in
        1)
            list_servers
            ;;
        2)
            add_server
            ;;
        3)
            delete_server
            ;;
        4)
            connect_to_server
            ;;
        6)
            edit_server_details
            ;;
        7)
            search_server
            ;;
        8)
            exit 0
            ;;
        *)
            echo -e "\e[1m\e[31mInvalid choice. Please try again.\e[0m"
            sleep 2
            show_menu
            ;;
    esac
}

function list_servers() {
    clear
    echo -e "\e[1m\e[34m===================="
    echo -e "   List of Servers"
    echo -e "====================\e[0m"
    
    if [[ -s $SERVERS_FILE ]]; then
        # Read the server details from the file
        mapfile -t servers < "$SERVERS_FILE"
        
        # Iterate over each server and ping it
        for server_info in "${servers[@]}"; do
            server_name=$(cut -d '|' -f1 <<< "$server_info")
            username=$(cut -d '|' -f2 <<< "$server_info")
            server_ip=$(cut -d '|' -f3 <<< "$server_info")
            
            if ping -c 1 "$server_ip" &> /dev/null; then
                echo -e "$server_name: $username@$server_ip \e[1m\e[32m[UP]\e[0m"
            else
                echo -e "$server_name: $username@$server_ip \e[1m\e[31m[DOWN]\e[0m"
            fi
        done
    else
        echo "No servers added yet."
    fi
    
    echo -e "\e[1m\e[34m====================\e[0m"
    read -p "Press Enter to continue..."
    show_menu
}


function add_server() {
    clear
    echo -e "\e[1m\e[34m===================="
    echo -e "    Add a Server"
    echo -e "====================\e[0m"
    read -p "Enter the server name: " server_name
    read -p "Enter the server IP: " server_ip
    read -p "Enter the username: " username
    echo "$server_name|$username|$server_ip" >> "$SERVERS_FILE"
    echo -e "\e[1m\e[32mServer added successfully!\e[0m"
    sleep 2
    show_menu
}

function delete_server() {
    clear
    echo -e "\e[1m\e[34m===================="
    echo -e "   Delete a Server"
    echo -e "====================\e[0m"
    if [[ -s $SERVERS_FILE ]]; then
        cat -n "$SERVERS_FILE"
        echo -e "\e[1m\e[34m====================\e[0m"
        read -p "Enter the line number of the server to delete: " line_num
        sed -i "${line_num}d" "$SERVERS_FILE"
        echo -e "\e[1m\e[32mServer deleted successfully!\e[0m"
    else
        echo "No servers added yet."
    fi
    sleep 2
    show_menu
}

function connect_to_server() {
    clear
    echo -e "\e[1m\e[34m===================="
    echo -e "  Connect to a Server"
    echo -e "====================\e[0m"
    if [[ -s $SERVERS_FILE ]]; then
        cat -n "$SERVERS_FILE"
        echo -e "\e[1m\e[34m====================\e[0m"
        read -p "Enter the line number of the server to connect: " line_num
        server_info=$(sed -n "${line_num}p" "$SERVERS_FILE")
        server_name=$(cut -d '|' -f1 <<< "$server_info")
        username=$(cut -d '|' -f2 <<< "$server_info")
        server_ip=$(cut -d '|' -f3 <<< "$server_info")
        echo "Connecting to $server_name..."
        ssh "$username@$server_ip"
    else
        echo "No servers added yet."
    fi
    echo -e "\e[1m\e[34m====================\e[0m"
    read -p "Press Enter to continue..."
    show_menu
}

function edit_server_details() {
    clear
    echo -e "\e[1m\e[34m===================="
    echo -e "  Edit Server Details"
    echo -e "====================\e[0m"
    if [[ -s $SERVERS_FILE ]]; then
        cat -n "$SERVERS_FILE"
        echo -e "\e[1m\e[34m====================\e[0m"
        read -p "Enter the line number of the server to edit: " line_num
        server_info=$(sed -n "${line_num}p" "$SERVERS_FILE")
        server_name=$(cut -d '|' -f1 <<< "$server_info")
        username=$(cut -d '|' -f2 <<< "$server_info")
        server_ip=$(cut -d '|' -f3 <<< "$server_info")
        read -p "Enter the new server name: " new_name
        read -p "Enter the new server IP: " new_ip
        read -p "Enter the new username: " new_username
        sed -i "${line_num}s@$server_info@$new_name|$new_username|$new_ip@" "$SERVERS_FILE"
        echo -e "\e[1m\e[32mServer details updated successfully!\e[0m"
    else
        echo "No servers added yet."
    fi
    sleep 2
    show_menu
}

function search_server() {
    clear
    echo -e "\e[1m\e[34m===================="
    echo -e "    Search Server"
    echo -e "====================\e[0m"
    read -p "Enter the server name or IP to search: " search_query
    if [[ -s $SERVERS_FILE ]]; then
        grep -i "$search_query" "$SERVERS_FILE"
    else
        echo "No servers added yet."
    fi
    echo -e "\e[1m\e[34m====================\e[0m"
    read -p "Press Enter to continue..."
    show_menu
}

# Main program
show_menu

