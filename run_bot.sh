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
ENV_SEARCH_IP=$(bash $PWD/env/info/search_ip.sh)

# Lines And Header
ENV_HEADER=$(bash $PWD/env/header/header.sh) 
ENV_LINES=$(bash $PWD/env/lines/lines.sh) 

# Send Search IP
curl -s -X POST $URL_MSG > /dev/null 2>&1 \
    -d chat_id=$CHAT_ID \
    -d "text=\`$(echo 🔎Searching Your Public IP)\`%0A" \
    -d parse_mode=Markdown

sleep 5s

# Send Found IP
curl -s -X POST $URL_MSG > /dev/null 2>&1 \
    -d chat_id=$CHAT_ID \
    -d "text=\`$(echo ✅Found Your Public IP)\`%0A" \
    -d parse_mode=Markdown


sleep 3s

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
# Send Files
send_file() {
FILE_DIR=$(echo file/)$(ls file/*.exe | grep -v '*.exe' | cut -d'/' -f2)
URL_FILES=https://api.telegram.org/bot$TOKEN/sendDocument
curl -X POST > /dev/null 2>&1 -F "chat_id=$CHAT_ID" -F "document=@$FILE_DIR" $URL_FILES
}


# Send Notify Upload
curl -s -X POST $URL_MSG > /dev/null 2>&1 \
    -d chat_id=$CHAT_ID \
    -d "text=\`📤⌛️Uploading Files\`" \
    -d "parse_mode=Markdown"

sleep 5s

calculated() {
SECONDS=0
send_file
echo "$((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
}

# Send Notify When Failed Upload
send_failed_notify_upload() {
curl -s -X POST $URL_MSG > /dev/null 2>&1 \
    -d chat_id=$CHAT_ID \
    -d "text=\`❌Failed to Upload File, File Does Not Exist\`" \
    -d "parse_mode=Markdown"
}


sleep 1s
# Send Notify When Completed
upload_success() {
curl -s -X POST $URL_MSG > /dev/null 2>&1 \
    -d chat_id=$CHAT_ID \
    -d "text=\`✅Done Uploading Files At: $(calculated)\`" \
    -d "parse_mode=Markdown"
}

check_file=$(ls -l $PWD/file/*.exe 2>&1 | grep "No such file or directory" | cut -d' ' -f5-)
if [ "$check_file" ]; then
send_failed_notify_upload
else
upload_success
fi
