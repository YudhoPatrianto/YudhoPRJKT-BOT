#!/bin/bash

# Load Config
source $HOME/YudhoPRJKT-BOT/.secret/bot.config

# Load Environment BOT
export TOKEN=${TOKEN}
export ENDPOINT=${ENDPOINT}
export last_id=${LAST_ID}

# Clearing Log
function ClearLog() {
    search_latest_log=$(curl -s -X GET "${ENDPOINT}/getUpdates" | jq '.result | max_by(.update_id) | .update_id')
    if [[ ${search_latest_log} != *"null"* ]]; then
    curl -s -X GET "${ENDPOINT}/getUpdates" \
    -d "offset=$(($search_latest_log + 1))" \
    > /dev/null
    fi
}

# Main Bot
function RunBOT() {
    function GetUpdates() {
        curl -s "${ENDPOINT}/getUpdates?offset=$((last_id+1))" | jq -r '.result[-1]'
    }

    function sendMessage() { # Usage For Sending Message: sendMessage ${chat_id} "Input Your Text" "HTML/Markdown" ${reply_chat}
        local chat_id=$1
        local text=$2
        local StylingText=$3
        local reply_to_message_id=$4

        curl -s -X POST "${ENDPOINT}/sendMessage" \
        -d "chat_id=$chat_id" \
        -d "text=$text" \
        -d "reply_to_message_id=$reply_to_message_id" \
        -d parse_mode=$StylingText \
        > /dev/null
    }

    function sendVideo() { # Usage For Sending Video: sendVideo ${chat_id} "Input Your Text/Caption" "HTML/Markdown" ${reply_chat}
        local chat_id=$1
        local caption=$2
        local StyledCaption=$3
        local reply_to_message_id=$4
        local GetVideoPath=$(echo $(echo $(pwd)/*.mp4))

        curl -s -X POST "${ENDPOINT}/sendVideo" \
        -F chat_id="${chat_id}" \
        -F video=@"${GetVideoPath}" \
        -F disable_notification=False \
        -F protect_content=False \
        -F supports_streaming=True \
        -F show_caption_above_media=True \
        -F caption="${caption}" \
        -F parse_mode="${StyledCaption}" \
        -F has_spoiler=False \
        -F reply_to_message_id="$reply_to_message_id" \
        > /dev/null 
    }

    function pinChatMessage() { # Pin  Message
        GetChatForPins=$(curl -s -X POST "${ENDPOINT}/getUpdates" | jq -r '.result[-1].message')
        if [[ ${GetChatForPins} == *"reply_to_message"* ]]; then
    
        # Pin A Message
        local chat_id_pin=$(curl -s -X POST "${ENDPOINT}/getUpdates" | jq -r '.result[-1].message.chat.id')
        local message_id_pin=$(curl -s -X POST "${ENDPOINT}/getUpdates" | jq -r '.result[-1].message.reply_to_message.message_id')
    
        curl -s -X POST "${ENDPOINT}/pinChatMessage" \
        -d chat_id=${chat_id_pin} \
        -d message_id=${message_id_pin} \
        -d disable_notification=False \
        > /dev/null

        # Send Notification Pin
        sendMessage ${chat_id} "📍<b>Pesan Telah Saya Pin</b>" "HTML" ${reply_chat}

        else
        SearchUsernameRequestPin=$(curl -s -X POST "${ENDPOINT}/getUpdates" | jq -r '.result[-1].message.from.username')
        sendMessage ${chat_id} "<b>Maaf</b> @${SearchUsernameRequestPin} <b>Saya Tidak Dapat Melakukan Pin Pesan, Coba Lah Membalas/Reply Target Pesan Yang Ingin Anda Pin...</b>" "HTML" ${reply_chat}
        fi
    }


    function unpinChatMessage() { # Unpin Message
        GetChatForUnpins=$(curl -s -X POST "${ENDPOINT}/getUpdates" | jq -r '.result[-1].message')
        if [[ ${GetChatForUnpins} == *"reply_to_message"* ]]; then
    
        # Unpin A Message
        local chat_id_unpin=$(curl -s -X POST "${ENDPOINT}/getUpdates" | jq -r '.result[-1].message.chat.id')
        local message_id_unpin=$(curl -s -X POST "${ENDPOINT}/getUpdates" | jq -r '.result[-1].message.reply_to_message.message_id')
    
        curl -s -X POST "${ENDPOINT}/unpinChatMessage" \
        -d chat_id=${chat_id_unpin} \
        -d message_id=${message_id_unpin} \
        > /dev/null

        # Send Notification Unpin
        sendMessage ${chat_id} "📌<b>Pesan Telah Saya Unpin</b>" "HTML" ${reply_chat}
    
        else
        SearchUsernameRequestUnpin=$(curl -s -X POST "${ENDPOINT}/getUpdates" | jq -r '.result[-1].message.from.username')
        sendMessage ${chat_id} "<b>Maaf</b> @${SearchUsernameRequestUnpin} <b>Saya Tidak Dapat Melakukan Unpin Pesan, Coba Lah Membalas/Reply Target Pesan Yang Ingin Anda Unpin...</b>" "HTML" ${reply_chat}
        fi
    }

    # Let's Get Start Bot
    while true; do
    export goUpdate=$(GetUpdates)
    if [[ ! -z "${goUpdate}" ]]; then
    # Take All Information Needed
    last_id=$(echo "${goUpdate}" | jq '.update_id')
    # Command Handler
    export CommandHandler=$(echo "${goUpdate}" | jq -r '.message.text')
    
    # User Info
    first_name=$(echo "${goUpdate}" | jq -r '.message.from.first_name')
    last_name=$(echo "${goUpdate}" | jq -r '.message.from.last_name')
    export user_id=$(echo "${goUpdate}" | jq -r '.message.from.id')
    export username=$(echo "${goUpdate}" | jq -r '.message.from.username')
    export chat_id=$(echo "${goUpdate}" | jq -r '.message.chat.id')
    
    # Reply Chat
    export reply_chat=$(echo "${goUpdate}" | jq '.message.message_id')
    fi

    # Command Handler
    if [[ ${CommandHandler} == *"/start"* ]]; then
    sendMessage ${chat_id} "<b>Hallo👋</b>%0A<b>First Name:</b> <code>${first_name}</code>%0A<b>First Name:</b> <code>${last_name}</code>%0A<b>Username:</b> @${username}%0A<b>User ID:</b> <code>${user_id}</code>%0A%0A<b>Kamu Dapat Melihat Semua Command Di</b> /help" "HTML" ${reply_chat}

    elif [[ ${CommandHandler} == *"/help"* ]]; then
    sendMessage ${chat_id} "<b>Still On Development</b>%0ADevelopment By: @YudhoPatrianto" "HTML" ${reply_chat}

    elif [[ ${CommandHandler} == *"/pin"* ]]; then
    pinChatMessage

    elif [[ ${CommandHandler} == *"/unpin"* ]]; then
    unpinChatMessage

    fi


    sleep 0.1
done
}

# Running Bot
ClearLog # Clear Log
sleep 2s
RunBOT