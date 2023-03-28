#!/bin/bash

#the options below is honeypot only and not a real services.
#the user have 4 options to choose, ssh, ftp, smb or all together.
echo pleash choose the desire service:
echo
echo 1. SSH
echo 2. FTP
echo 3. SMB
echo 4. start all services

#function for ssh service honeypot in monitor mode. the function use expect script for automation.
function ssh()
{
x-terminal-emulator -e expect ssh.exp & sudo tail -f /home/kali/Desktop/pentbox/ssh_log.txt >> /home/kali/Desktop/pentbox/honeypot_log.txt
}

#function for ftp service honeypot in monitor mode. the function use expect script for automation.

function ftp()
{
x-terminal-emulator -e expect ftp.exp & sudo tail -f /home/kali/Desktop/pentbox/ftp_log.txt >> /home/kali/Desktop/pentbox/honeypot_log.txt
}

#function for smb service honeypot in montior mode. the function use expect script for automation.

function smb()
{
x-terminal-emulator -e expect smb.exp & sudo tail -f /home/kali/Desktop/pentbox/smb_log.txt >> /home/kali/Desktop/pentbox/honeypot_log.txt
}

#if the user enter 4, all the functions above will run together in monitor mode.
read user_input
if  [ $user_input -eq 1 ]
    then ssh & echo ssh honeypot log:
    elif [ $user_input -eq 2 ]
    then ftp & echo ftp honeypot log:
    elif [ $user_input -eq 3 ]
    then smb & echo smb honeypot log:
    elif [ $user_input -eq 4 ]
    then  ssh & ftp & smb & echo now we will print the honeypot log:
    else echo bye
fi

#function LOG makes a log file that contains the ip, date, location and time attempt of breach and makes another file with ip's only for another ongoing analysis,
function LOG()
{
sudo cat /home/kali/Desktop/pentbox/honeypot_log.txt ; sudo cat /home/kali/Desktop/pentbox/honeypot_log.txt | grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | 
sort -u >> /home/kali/Desktop/pentbox/ip_honeypot_log.txt ; echo ; echo ; sleep 2 ; echo attacker location: ; ip=$(curl -s https://ipinfo.io/timezone) ; echo -e "\e[1;31m $ip \e[m" 
}

#the SCANNING function do nmap to ip's file that created earlier and try to find open ports, services and operating software and save the data in txt file.
function SCANNING()
{
echo now we will scan the malicious  ip\'s: ; 
nmap -O -Pn -sC -iL /home/kali/Desktop/pentbox/ip_honeypot_log.txt -o ip_nmap_scan.txt
}

LOG
SCANNING 

