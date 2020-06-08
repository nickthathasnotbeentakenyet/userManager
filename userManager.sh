#! /bin/bash
#
# Author: warning
# userManager v1.0

red='\e[31m'   # red
green='\e[32m' # green
cyan='\e[96m'  # cyan
blink='\e[5m'  # blink
def='\e[0m'    # default
bold='\e[1m'   # bold

# Making sure Captain is on board
if [[ $(id -u) -ne 0 ]]
	then 
		echo -e "${red}Please run as root${def}"
		exit 
fi
# Displaying Welcome message
if [[ "$1" = "" ]]
	then
		echo -e "${cyan}\nWelcome to userManager utility\n\nAvailable keys are: \n${red}-a ${cyan}[add a user]\n${red}-b ${cyan}[delete a user]\n${red}-h ${cyan}[print help mesage]\nexample: myuseradd.sh -h\n${def}"
fi
# Got lost? Need help? 
if [[ "$1" = -h ]] || [[ "$1" = --help ]]
	then 
		echo -e "\n${cyan}USAGE: \n${red}myuseradd.sh -a${cyan}    - add a user account \n${red}myuseradd.sh -d${cyan}    - remove a user account \n${red}myuseradd.sh -h${cyan}    - display this usage message\n${def}"
fi
# Adding user to the system
if [[ "$1" = -a ]]
	then
		echo -e "${cyan}Type name of a user to add${red}"
		read name
# Making sure the username does not have a twin		
		user=$(cat /etc/passwd | grep $name | cut -d":" -f1)
		if [[ $user = "$name" ]]	
			then
				echo -e "${red}Operation forbidden. \nUser $name already exists on the system\nExiting${def}"	
				exit
# Just use 'qwerty'. Nobody cares about the passwords. LOL
			else
				echo -e "${cyan}Type password for user $name${def}"
				read -s password
				echo -e "${cyan}Confirm the password${def}"
				read -s password2
				if [[ $password = $password2 ]]
# Creating user & user home directory					
					then
						mkdir /home/$name
						useradd $name -d /home/$name -p $password -s /bin/bash
						chown $name:$name /home/$name
# Cool effect to visualize running operation						
						count=50
						while ((count>0))
						do
						echo -e "${cyan}#\c\t100%${def}"
						sleep 0.02
						((count--))
						done
						echo -e "\n${green}${bold}[User $name was successfully added]${def}"
# Can't type a few characters correct ? The following message is for you then!					
					else
						echo -e "${red}${bold}${blink}[ERROR] ${def}${red}${bold}Passwords for $name did not match\nOperation canceled${def}"
						exit
				fi		
		fi
fi
# If user ate your yogurt and not welcome anymore 
if [[ "$1" = -d ]]
	then
		echo -e "${cyan}Type name of a user to delete${red}"
		read name
# Making sure someone else did not do this for you in the past		
		user=$(cat /etc/passwd | grep $name | cut -d":" -f1)
		if [[ $user = "$name" ]]
# Last chance to apologize			
			then
				echo -e "${cyan}Do you really want to delete user $name ? (y/n)"
				read answer
				if [[ $answer = y ]] || [[ $answer = "" ]]
					then 
						userdel -r $name
# Can you follow '#' each time they appear on the sreen?						
						count=50
						while ((count>0))
						do
						echo -e "#\c"
						sleep 0.02
						((count--))
						done
						echo -e "\n${green}${bold}[User $name was successfully deleted]${def}"
					else
						echo -e "${red}${bold}[Operation canceled. User $name was not deleted]${def}"
				fi
			else 
				echo -e "${red}${bold}User $name not found. Exiting${def}"		
		fi
fi
