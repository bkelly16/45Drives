#!/bin/bash
#BKELLY
#45DRIVES
############
## netconfig.sh
#---------------
# 	Network Configuration tool 
#	1) List Current Interfaces
#	2) Edit Network Interfaces
#	3) Restart Networking Service
#	4) Exit Network Configuration
#---------------
############

dir=/root/setup
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

while :
clear
do
echo -e "\nNetwork Configuration\n---------------------------------------\n"
echo -e "1) List Current Interfaces"
echo -e "2) Edit Network Interfaces"
echo -e "3) Restart Networking Service"
echo -e "4) Exit Network Configuration\n"
read -p "Enter Option from 1-4: " op0

case $op0 in
1)
	clear
	echo -e "\n"
	sh $dir/lsnic.sh
	echo -e "\n"
	read -p "Press Enter to continue" con1
	case $con1 in
	*)
		;;
	esac
	;;
2)
	nmtui
	;;
3)
	read -p "You may lose connection, are you sure? (Y/n) " yn0
	case $yn0 in
	[yY]*)
		echo  -e "\nRestarting Network Sevices"
		systemctl restart network 2>/dev/null
		;;
	*)
		;;
		esac
	STATUS=$(systemctl status network | awk 'NR==3{print $2;}')
	if [ "$STATUS" == "active" ]; then
		printf "\nNetwork Status: \n\t\t$GREEN%s$NC\n\n" $STATUS
	elif [ "$STATUS" == "inactive" ]; then
		printf "\nNetwork Status: \n\t\t$YELLOW%s$NC\n\n" $STATUS
	elif [ "$STATUS" == "failed" ]; then
		printf "\nNetwork Status: \n\t\t$RED%s$NC\n\n" $STATUS
	fi

	read -p "Press Enter to continue" con2
	case $con2 in
	*)
		;;
	esac
	;;
4)
	clear
	exit 1
	;;
*)
	;;
esac
done
