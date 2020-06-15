#!/bin/bash
#
# Author: warning
# userManager v1.0

red='\e[31m'   # red
green='\e[32m' # green
cyan='\e[96m'  # cyan
def='\e[0m'    # default
bold='\e[1m'   # bold
yel='\e[93m'   # yellow	

# Making sure Captain is on board
if [[ $(id -u) -ne 0 ]]
	then 
		echo -e "${red}Please run as root${def}"
		exit 
fi

case $1 in
	# Displaying Welcome message
	"")
		figlet UserManager
		echo -e "${cyan}\nWelcome to userManager utility\n\nAvailable keys are: \n${red}-a ${cyan}[add a user]\n${red}-b ${cyan}[delete a user]\n${red}-h ${cyan}[print help mesage]\nexample: myuseradd.sh -h\n${def}"
		;;
	# Got lost? Need help? 
	"-h" | "--help")
		echo -e "\n${cyan}USAGE: \n${red}myuseradd.sh -a${cyan}    - add a user account \n${red}myuseradd.sh -d${cyan}    - remove a user account \n${red}myuseradd.sh -h${cyan}    - display this usage message\n${def}"
		;;
	# Adding user to the system
	"-a" | "--add")
		echo -e "${cyan}Type name of a user to add${red}"
		read -r name
	# Making sure the username does not have a twin		
		user=$(grep "$name" /etc/passwd | cut -d":" -f1)
		if [[ $user = "$name" ]]	
			then
				echo -e "${red}Operation forbidden. \nUser $name already exists on the system\nExiting${cyan}"	
				exit
			else
	# Creating user & user home directory					
				mkdir /home/"$name"
				useradd -d /home/"$name" -s /bin/bash "$name"
				passwd "$name"
				chown "$name":"$name" /home/"$name"
	# Cool effect to visualize running operation						
				count=50
				while ((count>0))
				do
				echo -e "${cyan}#\c\t100%${def}"
				sleep 0.02
				((count--))
				done
				echo -e "\n${green}${bold}｡^‿^｡ [User $name was successfully added]${def}"
		fi
		;;
	# If user ate your yogurt and not welcome anymore 
	"-d" | "--del" | "--delete")
		echo -e "${cyan}Type name of a user to delete${red}"
		read -r name
	# Making sure someone else did not do this for you in the past		
		user=$(grep "$name" /etc/passwd | cut -d":" -f1)
		if [[ $user = "$name" ]]
	# Last chance to apologize			
			then
				echo -e "${cyan}◔_◔ Do you really want to delete user $name ? (y/n)"
				read -r answer
				if [[ $answer = y ]] || [[ $answer = "" ]]
					then 
						userdel -r "$name"
	# Can you follow '#' each time they appear on the sreen?						
						count=50
						while ((count>0))
						do
						echo -e "#\c"
						sleep 0.02
						((count--))
						done
						echo -e "\n${green}${bold}｡^‿^｡ [User $name was successfully deleted]${def}"
					else
						echo -e "${red}${bold}[Operation canceled. User $name was not deleted]${def}"
				fi
			else 
				echo -e "${red}${bold}¯\_(ツ)_/¯  User $name not found. Exiting${def}"		
		fi
		;;
	
	"--pikachu")
	echo -e "\n${yel}
█▀▀▄           ▄▀▀█
 █   ▀▄ ▄▄▄▄▄ ▄▀   █
  ▀▄   ▀     ▀   ▄▀
    ▌ ▄▄   ▄▄ ▐▀▀
   ▐  █▄   ▄█  ▌▄▄▀▀▀▀█ 
   ▌▄▄▀▀ ▄ ▀▀▄▄▐      █
▄▀▀▐▀▀ ▄▄▄▄▄ ▀▀▌▄▄▄   █
█   ▀▄ █   █ ▄▀    █▀▀▀
 ▀▄  ▀  ▀▀▀  ▀   ▄█▀
   █           ▄▀▄ ▀▄
   █         ▄▀█  █  █
   █           █▄█  ▄▀
   █           ████▀
   ▀▄▄▀▀▄▄▀▀▄▄▄█\n${def}"	
	;;
	*)
		echo -e "${red}${bold}¯\_(ツ)_/¯  Command not found. Exiting${def}\n${red}For help use ${green}${bold}--help${def}"
		;;

esac
