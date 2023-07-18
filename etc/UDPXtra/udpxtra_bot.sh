#!/bin/bash

# UDP Xtra Manager Telegram Bot
# Date: Jul 17, 2023.

TELEGRAM_BOT_TOKEN="6008613985:AAE7BK45KKm7rS_u8agzAUrhD9Du3P74TPI"
TELEGRAM_CHAT_ID="1559919183"

MAIN_SCRIPT_PATH="/usr/bin/udpx"

get_vps_info() {
    output=$(bash "$MAIN_SCRIPT_PATH" show_vps)
    echo "$output"
}

start() {
    keyboard='{
        "inline_keyboard": [
            [
                {
                    "text": "User Management",
                    "callback_data": "User Management"
                }
            ],
            [
                {
                    "text": "VPS Info",
                    "callback_data": "VPS Info"
                }
            ]
        ]
    }'

    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=😊 Welcome to UDP Xtra Manager Bot!" \
        -d "reply_markup=$keyboard" > /dev/null
}

user_management_menu() {
    keyboard='{
        "inline_keyboard": [
            [
                {
                    "text": "List Users",
                    "callback_data": "List Users"
                }
            ],
            [
                {
                    "text": "Add User",
                    "callback_data": "Add User"
                },
                {
                    "text": "Delete User",
                    "callback_data": "Delete User"
                }
            ],
            [
                {
                    "text": "Back",
                    "callback_data": "Back"
                }
            ]
        ]
    }'

    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=User Management Menu" \
        -d "reply_markup=$keyboard" > /dev/null
}

button_handler() {
    callback_data=$1

    case $callback_data in
        "User Management")
            user_management_menu
            ;;
        "List Users")
            output=$(bash "$MAIN_SCRIPT_PATH" print_users)
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=$output" > /dev/null
            ;;
        "Add User")
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=Please enter the username, password, and expiry date in the format: username password expiry_date" > /dev/null
            ;;
        "Delete User")
            output=$(bash "$MAIN_SCRIPT_PATH" print_users)
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=$output" > /dev/null
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=Please enter the username to delete" > /dev/null
            ;;
        "VPS Info")
            vps_info=$(get_vps_info)
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=$vps_info" > /dev/null
            ;;
    esac
}

message_handler() {
    text=$1

    case $text in
        "/start")
            start
            ;;
        "User Management")
            user_management_menu
            ;;
        "List Users")
            output=$(bash "$MAIN_SCRIPT_PATH" print_users)
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=$output" > /dev/null
            ;;
        "Add User")
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=Please enter the username, password, and expiry date in the format: username password expiry_date" > /dev/null
            ;;
        "Delete User")
            output=$(bash "$MAIN_SCRIPT_PATH" print_users)
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=$output" > /dev/null
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=Please enter the username to delete" > /dev/null
            ;;
        "Back")
            start
            ;;
    esac
}

# Start the bot in the background
while true; do
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
done

echo "Bot is running..."
#!/bin/bash

# UDP Xtra Manager Telegram Bot
# Date: Jul 17, 2023.

TELEGRAM_BOT_TOKEN="6008613985:AAE7BK45KKm7rS_u8agzAUrhD9Du3P74TPI"
TELEGRAM_CHAT_ID="1559919183"

MAIN_SCRIPT_PATH="/usr/bin/udpx"

get_vps_info() {
    output=$(bash "$MAIN_SCRIPT_PATH" show_vps)
    echo "$output"
}

start() {
    keyboard='{
        "inline_keyboard": [
            [
                {
                    "text": "User Management",
                    "callback_data": "User Management"
                }
            ],
            [
                {
                    "text": "VPS Info",
                    "callback_data": "VPS Info"
                }
            ]
        ]
    }'

    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=😊 Welcome to UDP Xtra Manager Bot!" \
        -d "reply_markup=$keyboard" > /dev/null
}

user_management_menu() {
    keyboard='{
        "inline_keyboard": [
            [
                {
                    "text": "List Users",
                    "callback_data": "List Users"
                }
            ],
            [
                {
                    "text": "Add User",
                    "callback_data": "Add User"
                },
                {
                    "text": "Delete User",
                    "callback_data": "Delete User"
                }
            ],
            [
                {
                    "text": "Back",
                    "callback_data": "Back"
                }
            ]
        ]
    }'

    curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        -d "chat_id=$TELEGRAM_CHAT_ID" \
        -d "text=User Management Menu" \
        -d "reply_markup=$keyboard" > /dev/null
}

button_handler() {
    callback_data=$1

    case $callback_data in
        "User Management")
            user_management_menu
            ;;
        "List Users")
            output=$(bash "$MAIN_SCRIPT_PATH" print_users)
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=$output" > /dev/null
            ;;
        "Add User")
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=Please enter the username, password, and expiry date in the format: username password expiry_date" > /dev/null
            ;;
        "Delete User")
            output=$(bash "$MAIN_SCRIPT_PATH" print_users)
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=$output" > /dev/null
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=Please enter the username to delete" > /dev/null
            ;;
        "VPS Info")
            vps_info=$(get_vps_info)
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=$vps_info" > /dev/null
            ;;
    esac
}

message_handler() {
    text=$1

    case $text in
        "/start")
            start
            ;;
        "User Management")
            user_management_menu
            ;;
        "List Users")
            output=$(bash "$MAIN_SCRIPT_PATH" print_users)
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=$output" > /dev/null
            ;;
        "Add User")
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=Please enter the username, password, and expiry date in the format: username password expiry_date" > /dev/null
            ;;
        "Delete User")
            output=$(bash "$MAIN_SCRIPT_PATH" print_users)
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=$output" > /dev/null
            curl -s -X POST "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
                -d "chat_id=$TELEGRAM_CHAT_ID" \
                -d "text=Please enter the username to delete" > /dev/null
            ;;
        "Back")
            start
            ;;
    esac
}

# Start the bot in the background
while true; do
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
done

echo "Bot is running..."
