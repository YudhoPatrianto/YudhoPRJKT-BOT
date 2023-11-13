#!/usr/bin/env bash

# Secret
TOKEN=$(cat .secret/token)
CHAT_ID=$(cat .secret/chatid)

# URL For Send Message
URL_MSG=https://api.telegram.org/bot$TOKEN/SendMessage

# Enviroment
ENV_KERNEL=$(bash $PWD/env/info/kernel_info.sh)
ENV_OS=$(bash $PWD/env/info/os_info.sh)
ENV_USERS=$(bash $PWD/env/info/users_info.sh)
ENV_CPU=$(bash $PWD/env/info/cpu_model.sh) 
ENV_TOTAL=$(bash $PWD/env/info/total_core_info.sh) 
ENV_UPTIME=$(bash $PWD/env/info/fixed_uptime.sh) 
ENV_MEMORY=$(bash $PWD/env/info/memory_info.sh) 
ENV_DISK=$(bash $PWD/env/info/disk_info.sh) 
ENV_CPU_USAGE=$(bash $PWD/env/info/cpu_usage.sh) 
ENV_ISP=$(bash $PWD/env/info/isp_info.sh) 

# Lines And Header
ENV_HEADER=$(bash $PWD/env/header/header.sh) 
ENV_LINES=$(bash $PWD/env/lines/lines.sh) 


# Send Spesification 
curl -s -X POST $URL_MSG > /dev/null 2>&1 \
    -d chat_id=$CHAT_ID \
    -d "text=\`$ENV_HEADER\`%0A \
\`$ENV_CPU\` %0A \
\`$ENV_CPU_USAGE\`%0A \
\`$ENV_KERNEL%0A\` \
\`$ENV_OS\`%0A \
\`$ENV_USERS\`%0A \
\`$ENV_MEMORY\` %0A \
\`$ENV_DISK\` %0A \
\`$ENV_TOTAL\`%0A \
\`$ENV_UPTIME\`%0A\
\`$ENV_ISP\` \
\`$ENV_LINES\`%0A%0A"\
    -d "parse_mode=Markdown"



# =================================================================================================================
# Put Your FILE Location In Here
FILE_CHECK=$(pwd)/file/platform-tools_r34.0.5-windows.zip

# Send Files
function send_file() {
FILE_DIR=$(echo file/)$(ls file/*.sh | grep -v '*.sh' | cut -d'/' -f2)
URL_FILES=https://api.telegram.org/bot$TOKEN/sendDocument
curl -X POST > /dev/null 2>&1 -F "chat_id=$CHAT_ID" -F "document=@$FILE_DIR" $URL_FILES
}


# Send Notify Upload
curl -s -X POST $URL_MSG > /dev/null 2>&1 \
    -d chat_id=$CHAT_ID \
    -d "text=\`📤⌛️Uploading Files\`" \
    -d "parse_mode=Markdown"

sleep 5s

function calculated() {
SECONDS=0
send_file
echo "$((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
}

sleep 1s
# Send Notify When Completed
curl -s -X POST $URL_MSG > /dev/null 2>&1 \
    -d chat_id=$CHAT_ID \
    -d "text=\`✅Done Uploading Files At: $(calculated)\`" \
    -d "parse_mode=Markdown"







