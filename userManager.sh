#! /bin/bash
#
# Author: warning
# userManager v1.0

# \e[5m  - blink
# \e[0m  - default
# \e[1m  - bold
# \e[31m - red
# \e[32m - green
# \e[96m - light cyan

# Making sure Captain is on board
if [[ $(id -u) -ne 0 ]]
	then 
		echo -e "\e[31m\e[1mPlease run as root\e[0m"
		exit 
fi
# Displaying Welcome message
if [[ "$1" = "" ]]
	then
		echo -e "\e[96m\nWelcome to userManager utility\n\nAvailable keys are: \n\e[31m-a\e[0m \e[96m[add a user]\n\e[31m-b\e[0m \e[96m[delete a user]\n\e[31m-h\e[0m \e[96m[print help mesage]\nexample: myuseradd.sh -h\n\e[0m"
fi
# Got lost? Need help? 
if [[ "$1" = -h ]] || [[ "$1" = --help ]]
	then 
		echo -e "\n\e[96mUSAGE: \n\e[31mmyuseradd.sh -a\e[96m    - add a user account \n\e[31mmyuseradd.sh -d\e[96m    - remove a user account \n\e[31mmyuseradd.sh -h\e[96m    - display this usage message\n\e[0m"
fi
# Adding user to the system
if [[ "$1" = -a ]]
	then
		echo -e "\e[96mType name of a user to add\e[31m"
		read name
# Making sure the username does not have a twin		
		user=$(cat /etc/passwd | grep $name | cut -d":" -f1)
		if [[ $user = "$name" ]]	
			then
				echo -e "\e[31mOperation forbidden. \nUser $name already exists on the system\nExiting\e[0m"	
				exit
# Just use 'qwerty'. Nobody cares about the passwords. LOL
			else
				echo -e "\e[96mType password for user $name\e[0m"
				read -s password
				echo -e "\e[96mConfirm the password\e[0m"
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
						echo -e "\e[96m#\c\t100%\e[0m"
						sleep 0.02
						((count--))
						done
						echo -e "\n\e[32m\e[1m[User $name was successfully added]\e[0m"
# Can't type a few characters correct ? The following message is for you then!					
					else
						echo -e "\e[31m\e[1m\e[5m[ERROR] \e[0m\e[31m\e[1mPasswords for $name did not match\nOperation canceled\e[0m"
						exit
				fi		
		fi
fi
# If user ate your yogurt and not welcome anymore 
if [[ "$1" = -d ]]
	then
		echo -e "\e[96mType name of a user to delete\e[31m"
		read name
# Making sure someone else did not do this for you in the past		
		user=$(cat /etc/passwd | grep $name | cut -d":" -f1)
		if [[ $user = "$name" ]]
# Last chance to apologize			
			then
				echo -e "\e[96mDo you really want to delete user $name ? (y/n)"
				read answer
				if [[ $answer = y ]] || [[ $answer = "" ]]
					then 
						userdel -r $name
# Can you follow '#' each time they appear on the sreen?						
						count=50
						while ((count>0))
						do
						echo -e "\e[96m#\c\e[0m"
						sleep 0.02
						((count--))
						done
						echo -e "\n\e[32m\e[1m[User $name was successfully deleted]\e[0m"
					else
						echo -e "\e[31m\e[1m[Operation canceled. User $name was not deleted]\e[0m"
				fi
			else 
				echo -e "\e[32m\e[1mUser $name not found. Exiting\e[0m"		
		fi
fi