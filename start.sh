#!/usr/bin/env bash

# Secret
TOKEN=$(cat .secret/token)
CHAT_ID=$(cat .secret/chatid)
URL="https://api.telegram.org/bot$TOKEN"


# Enviroment Kernel
KERNEL_NAME=RvLProMaster
TARGET_DEVICE=[selene]
TARGET_VENDOR=[R]
TARGET_CLANG=$(clang --version | head -n 1)
TARGET_DATE=$(date "+%Y-%m-%d")
TARGET_TOOLCHAIN=/workspace/gitpod/$TARGET_DEVICE
BUILD_DIR=/workspace/gitpod/$TARGET_DEVICE
BOT_DIR=/workspace/gitpod/YudhoPRJKT-BOT
OUT_KERNEL=/workspace/gitpod/$TARGET_DEVICE/out/arch/arm64/boot
ANYKERNEL_DIR=/workspace/gitpod/$TARGET_DEVICE/AnyKernel


# Enviroment Bot
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
ENV_HEADER=$(bash $PWD/env/header/header.sh) 
ENV_LINES=$(bash $PWD/env/lines/lines.sh)


# Send Spesification 
curl -s -X POST $URL/SendMessage > /dev/null 2>&1 \
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

# Compilation Kernel
function compile() {
    export PATH="$TARGET_TOOLCHAIN:$PATH"
    export CROSS_COMPILE_COMPAT=arm-linux-gnueabi-
    make -j$(nproc --all) O=out ARCH=arm64 $TARGET_DEVICE_defconfig
    make -j$(nproc --all) ARCH=arm64 O=out \
                          CC=clang \
                          CROSS_COMPILE=aarch64-linux-gnu- \
                          CROSS_COMPILE_ARM32=arm-linux-gnueabi-
}

function zippins() {
    cd $BUILD_DIR
    git clone -q https://github.com/YudhoPatrianto/AnyKernel -b selene-old AnyKernel
    cp $OUT_KERNEL/Image.gz-dtb $ANYKERNEL_DIR
    cp $OUT_KERNEL/dtbo.img $ANYKERNEL_DIR
    cd $ANYKERNEL_DIR
    zip -r9 $TARGET_VENDOR$TARGET_DEVICE-$KERNEL_NAME-$TARGET_DATE *
    


function calculate_compile() {
SECONDS=0
compile
echo "$((SECONDS/3600))h $(((SECONDS/60)%60))m $((SECONDS%60))s"
}

# Send Build Notify
curl -s -X POST $URL/SendMessage > /dev/null 2>&1 \
    -d chat_id=$CHAT_ID \
    -d "text=🔨<code>Build Started For Device:</code><b>$TARGET_DEVICE</b>" \
    -d parse_mode=HTML

# Notify Zipping
curl -s -X POST $URL/SendMessage > /dev/null 2>&1 \
    -d chat_id=$CHAT_ID \
    -d "text=📦<b>Zipping Process></b>$()" \
    -d parse_mode=HTML


KERNEL_DIR=$(echo file/)$(ls file/*.zip | grep -v '*.zip' | cut -d'/' -f2)
curl -s -X POST $URL/SendDocument > /dev/null 2>&1 \
    -F chat_id=$CHAT_ID \
    -F "disable_web_page_preview=true" \
    -F "document=@$KERNEL_DIR" \    
    -F parse_mode=HTML


