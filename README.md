# YudhoPRJKT-BOT
The Telegram Bot To Send Files And Notify 


#### Usage 

## You Must Install Some Dependencies
---------------
```bash
sudo apt-get update && sudo apt-get upgrade -y && sudo apt-get install jq nano vim curl git whois dos2unix -y
```

## Clonned First The Repo And Go To Directory
---------------
```bash
git clone https://github.com/YudhoPatrianto/YudhoPRJKT-BOT && cd YudhoPRJKT-BOT
```

## Input Your Auth Bot Token And Chat ID First
---------------
```bash
nano .secret/token
```

## And 
---------------
```bash
nano .secret/chatid
```

## Insert Your IP Public For Displaying ISP Name
---------------
```bash
nano $PWD/env/info/isp_info.sh
```

##### Or Edit In Here
---------------
[Edit In Here](https://github.com/YudhoPatrianto/YudhoPRJKT-BOT/blob/6b6fb0b914cf88fdb30094f9fd59e9219e8d61c2/env/info/isp_info.sh#L4C4-L4C4 "Edit In Here")

### Give The Bot To Full Access Control File
---------------
```bash
chmod 777 run_bot.sh
```

# Run The Bot
---------------
```bash
bash run_bot.sh
```
