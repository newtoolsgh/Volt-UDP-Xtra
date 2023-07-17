#!/bin/bash

# UDP Xtra Manager Telegram Bot
# Date: Jul 17, 2023.

# Check if the TOKEN and CHAT_ID environment variables are already set
if [[ -z $TELEGRAM_BOT_TOKEN || -z $TELEGRAM_CHAT_ID ]]; then
    echo "Get ChatID here: https://t.me/useridinfobot"
    echo ""
    read -p "Enter Telegram bot token: " TOKEN
    read -p "Enter your ChatID: " CHAT_ID

    # Store the TOKEN and CHAT_ID in environment variables
    export TELEGRAM_BOT_TOKEN=$TOKEN
    export TELEGRAM_CHAT_ID=$CHAT_ID
fi

MAIN_SCRIPT_PATH="/usr/bin/udpx"

get_vps_info() {
    output=$(bash "$MAIN_SCRIPT_PATH" show_vps)
    echo "$output"
}

start() {
    keyboard='[["User Management"],["VPS Info"]]'
    sticker_path="/etc/UDPXtra/srkr.tgs"

    sticker_message=$(base64 -w 0 "$sticker_path")
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendSticker" -d "chat_id=$TELEGRAM_CHAT_ID" -d "sticker=$sticker_message" > /dev/null

    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=Welcome to UDP Xtra Manager Bot!" -d "reply_markup={\"keyboard\":$keyboard,\"resize_keyboard\":true}" > /dev/null
}

user_management_menu() {
    keyboard='[["List Users"],["Add User"],["Delete User"],["Back"]]'
    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=User Management Menu" -d "reply_markup={\"keyboard\":$keyboard,\"resize_keyboard\":true}" > /dev/null
}

button_handler() {
    callback_data=$1

    if [[ $callback_data == "User Management" ]]; then
        user_management_menu
    elif [[ $callback_data == "List Users" ]]; then
        output=$(bash "$MAIN_SCRIPT_PATH" print_users)
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=$output" > /dev/null
    elif [[ $callback_data == "Add User" ]]; then
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=Please enter the username, password, and expiry date in the format: username password expiry_date" > /dev/null
    elif [[ $callback_data == "Delete User" ]]; then
        output=$(bash "$MAIN_SCRIPT_PATH" print_users)
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=$output" > /dev/null
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=Please enter the username to delete" > /dev/null
    elif [[ $callback_data == "VPS Info" ]]; then
        vps_info=$(get_vps_info)
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=$vps_info" > /dev/null
    fi
}

message_handler() {
    text=$1

    if [[ $text == "/start" ]]; then
        start
    elif [[ $text == "User Management" ]]; then
        user_management_menu
    elif [[ $text == "List Users" ]]; then
        output=$(bash "$MAIN_SCRIPT_PATH" print_users)
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=$output" > /dev/null
    elif [[ $text == "Add User" ]]; then
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=Please enter the username, password, and expiry date in the format: username password expiry_date" > /dev/null
    elif [[ $text == "Delete User" ]]; then
        output=$(bash "$MAIN_SCRIPT_PATH" print_users)
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=$output" > /dev/null
        curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" -d "chat_id=$TELEGRAM_CHAT_ID" -d "text=Please enter the username to delete" > /dev/null
    elif [[ $text == "Back" ]]; then
        start
    fi
}

# Start the bot in the background using nohup
nohup bash -c 'while true; do
    start
    while read -r update; do
        callback_data=$(echo "$update" | jq -r ".callback_query.data")
        message_text=$(echo "$update" | jq -r ".message.text")
        if [[ -n $callback_data ]]; then
            button_handler "$callback_data"
        elif [[ -n $message_text ]]; then
            message_handler "$message_text"
        fi
    done
    sleep 1
done' > /dev/null 2>&1 &

echo "Bot is running..."
echo "Press enter to go menu!"
