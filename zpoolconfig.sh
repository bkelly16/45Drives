#!/bin/bash
#WritBy:CAuCoin, Additions:BK
#45DRIVES
############
#--------------------
#         Zpool Configuration tool
#         1) Set up Drive Aliasing
#         2) List All Configuartion by Physical Location
#         3) Use Recommended Configuration
#         4) Use Custom Configuration
#         5) View Zpool Status
#         6) Exit Zpool Configuartion
#--------------------
############
NODE=$1
BLACK='\033[0;30m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
BROWN='\033[0;33m'
LGREY='\033[0;37m'
DGREY='\033[1;30m'
LBLUE='\033[1;34m'
LGREEN='\033[1;32m'
LCYAN='\033[1;36m'
LRED='\033[1;31m'
LPURPLE='\033[1;35m'
YELLOW='\033[1;33m'
NC='\033[0m'
COLORS=("" "$BLUE" "$GREEN" "$CYAN"  "$PURPLE" "$LBLUE" "$BROWN" "$LBLUE" "$LGREEN" "$LCYAN" "$LRED" "$RED" "$LPURPLE" "$YELLOW")
line() { # takes a number as first input Length, and any character as second input, defaults to "-" if no option
	if [ -z $2 ]; then
		printf -v line '%*s' "$1"
		echo ${line// /-}
	else
		printf -v line '%*s' "$1"
		echo ${line// /$2}
	fi		
}
while :
check=$(zpool list | wc -l) #1 if no pool; and bigger than than pool present
clear
do
echo -e "\nZpool Configuration"
line 30 -
if [ "$check" -gt 1 ];then
	echo -e "Working Node: "$GREEN$NODE$NC

elif [ -e /etc/zfs/vdev_id.conf ];then
	echo -e "Working Node: "$YELLOW$NODE$NC
else
	echo -e "Working Node: "$LGREY$NODE$NC
fi
line 30 -
echo -e "1) Configure Drive Aliasing"
echo -e "2) List All Drives by Physical Location"
echo -e "3) Use Recommended Configuration" 
echo -e "4) Use Custom Configuration" 
echo -e "5) View Status"
echo -e "6) Exit Zpool Configuration"
line 30 -
if [ "$check" -gt 1 ];then
	sh lsvdev.sh
fi
read -p "Enter an Option From 1-6: " op0
case $op0 in
1)
	clear
	if [ -e /etc/zfs/vdev_id.conf ]; then
		read -p "Aliasing is already configured, are you sure you want to reconfigure? [Y/n] " yn2
		case $yn2 in
		[Yy]*)
			read -p "Which HBA cards are you using? (r750 or LSI) :  " op13
			read -p "Which Size Storinator is $NODE? (30, 45, or 60) :  " op14
			if [ $op13 == r750 ] && [ $op14 == 30 ]; then
				cp /etc/zfs/vdev_id.conf.r750_q30 /etc/zfs/vdev_id.conf
				udevadm trigger
			fi
			if [ $op13 == r750 ] && [ $op14 == 45 ]; then
				cp /etc/zfs/vdev_id.conf.r750_s45 /etc/zfs/vdev_id.conf
				udevadm trigger
			fi
			if [ $op13 == r750 ] && [ $op14 == 60 ]; then
				cp /etc/zfs/vdev_id.conf.r750_xl60 /etc/zfs/vdev_id.conf
				udevadm trigger
			fi
			if [ $op13 == LSI ] && [ $op14 == 30 ]; then
				cp /etc/zfs/vdev_id.conf.LSIq30 /etc/zfs/vdev_id.conf
				udevadm trigger
			fi
			if [ $op13 == LSI ] && [ $op14 == 45 ]; then
				cp /etc/zfs/vdev_id.conf.LSIs45 /etc/zfs/vdev_id.conf
				udevadm trigger
			fi
			if [ $op13 == LSI ] && [ $op14 == 60 ]; then
				cp /etc/zfs/vdev_id.conf.LSIxl60 /etc/zfs/vdev_id.conf
				udevadm trigger
			fi
			;;
		[nN]*)
			;;
		esac		
	else	
		read -p "Which HBA cards are you using? (r750 or LSI) :  " op13
		read -p "Which Size Storinator is $NODE? (30, 45, or 60) :  " op14
		if [ $op13 == r750 ] && [ $op14 == 30 ]; then
			cp /etc/zfs/vdev_id.conf.r750_q30 /etc/zfs/vdev_id.conf
			udevadm trigger
		fi
		if [ $op13 == r750 ] && [ $op14 == 45 ]; then
			cp /etc/zfs/vdev_id.conf.r750_s45 /etc/zfs/vdev_id.conf
			udevadm trigger
		fi
		if [ $op13 == r750 && $op14 == 60 ]; then
			cp /etc/zfs/vdev_id.conf.r750_xl60 /etc/zfs/vdev_id.conf
			udevadm trigger
		fi
		if [ $op13 == LSI && $op14 == 30 ]; then
			cp /etc/zfs/vdev_id.conf.LSIq30 /etc/zfs/vdev_id.conf
			udevadm trigger
		fi
		if [ $op13 == LSI && $op14 == 45 ]; then
				cp /etc/zfs/vdev_id.conf.LSIs45 /etc/zfs/vdev_id.conf
			udevadm trigger
		fi
		if [ $op13 == LSI && $op14 == 60 ]; then
			cp /etc/zfs/vdev_id.conf.LSIxl60 /etc/zfs/vdev_id.conf
			udevadm trigger
		fi
	fi
	;;
2)
	clear
	#ls /dev/disk/by-vdev/
	echo -e "Working Node: "$NODE"\n------------------"
	sh lsdev.sh	
	read -p "Press Enter to contine" con1
	case $con1 in
	*)
		;;
	esac
	;;
3)
	clear
	read -p "Are you sure you want to use the recommended configuration? (Y/n)" yn0
	case $yn0 in
	[Yy]*)
		read -p "Which Size Storinator is $NODE? (30, 45, or 60) :  " op15
		read -p "Configure to maximize (storage or IO)? :  " op16
		echo "$o15"
		case $op15 in
		30)
			if [ "$op16" == IO ]; then
				echo -e "\nCreating Zpool"
				zpool create -o ashift=12 raidz1 1-1 1-2 1-3 1-4 1-5 1-6 raidz1 1-7 1-8 1-9 1-10 1-11 1-12 raidz1 1-13 1-14 1-15 1-16 1-17 1-18 raidz1 1-19 1-20 1-21 1-22 1-23 1-24 raidz1 1-25 1-26 1-27 1-28 1-29 1-30 
			elif [ "$op16" == storage ]; then
				echo -e "\nCreating Zpool"
				zpool create -o ashift=12 raidz1 1-1 1-2 1-3 1-4 1-5 1-6 1-7 1-8 1-9 1-10 raidz1 1-11 1-12 1-13 1-14 1-15 1-16 1-17 1-18 1-19 1-20 raidz1 1-21 1-22 1-23 1-24 1-25 1-26 1-27 1-28 1-29 1-30
			fi
			;;
		45)
			if [ "$op16" == IO ]; then
				echo -e "\nCreating Zpool"
				zpool create -o ashift=12 raidz1 1-1 1-2 1-3 1-4 1-5 raidz1 1-6 1-7 1-8 1-9 1-10 raidz1 1-11 1-12 1-13 1-14 1-15 raidz1 1-16 1-17 1-18 1-19 1-20 raidz1 1-21 1-22 1-23 1-24 2-1 raidz1 2-2 2-3 2-4 2-5 2-6 raidz1 2-7 2-8 2-9 2-10 2-11 raidz1 2-12 2-13 2-14 2-15 2-16 raidz1 2-17 2-18 2-19 2-20 2-21
			elif [ "$op16" == storage ]; then
				echo -e "\nCreating Zpool"
				zpool create -o ashift=12 raidz1 1-1 1-2 1-3 1-4 1-5 1-6 1-7 1-8 1-9 1-10 1-11 1-12 1-13 1-14 1-15 raidz1 1-16 1-17 1-18 1-19 1-20 1-21 1-22 1-23 1-24 2-1 2-2 2-3 2-4 2-5 2-6 raidz1  2-7 2-8 2-9 2-10 2-11 2-12 2-13 2-14 2-15 2-16 2-17 2-18 2-19 2-20 2-2
			fi
			;;
		60)
			if [ "$op16" == IO ]; then
				echo -e "\nCreating Zpool"
				zpool create -o ashift=12 raidz1 1-1 1-2 1-3 1-4 1-5 1-6 1-7 1-8 1-9 1-10 raidz1 1-11 1-12 1-13 1-14 1-15 1-16 1-17 1-18 1-19 1-20 raidz1 1-21 1-22 1-23 1-24 1-25 1-26 1-27 1-28 1-29 1-30 raidz1 1-31 1-32 2-1 2-2 2-3 2-4 2-5 2-6 2-7 2-8 raidz1 2-9 2-10 2-11 2-12 2-13 2-14 2-15 2-16 2-17 2-18 raidz1 2-19 2-20 2-21 2-22 2-23 2-24 2-25 2-26 2-27 2-28
			elif [ "$op16" == storage ]; then
				echo -e "\nCreating Zpool"
				zpool create -o ashift=12 raidz1 1-1 1-2 1-3 1-4 1-5 1-6 1-7 1-8 1-9 1-10 1-11 1-12 1-13 1-14 1-15 raidz1 1-16 1-17 1-18 1-19 1-20 1-21 1-22 1-23 1-24 1-25 1-26 1-27 1-28 1-29 1-30 raidz1 1-31 1-32 2-1 2-2 2-3 2-4 2-5 2-6 2-7 2-8 2-9 2-10 2-11 2-12 2-13 raidz1 2-14 2-15 2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 2-24 2-25 2-26 2-27 2-29
			fi
			;;
		*)
			;;
		esac
		;;
	[nN]*)
			;;
	esac
	;;
4)
	clear
	read -p "Start Configuring Custom Zpool? (Y/n)" yn1
	case $yn1 in
	[Yy]*)
	echo -e "\nMake sure you have an equal number of drives in each Vdev.\n"
	echo -e "Working Node: "$NODE"\n------------------"
	sh lsdev.sh 
	read -p "Press Enter to Continue" con2
	case $con2 in
	*)
		;;
	esac

	read -p "Please enter desired number of Vdevs (2 to 10) :  " op1
	read -p "Please enter desired RAID level (raidz1,raidz2,raidz3):  " op2		
	echo -e "\nIndicating drives in a Vdev should be done using physical location shown above while space seperating each drive ( 1-1 1-2 1-3 1-4 ... etc)\n"
	read -p "First Vdev:  " op3
	read -p "Second Vdev:  " op4
	if [ $op1 -gt 2 ]; then
		read -p "Third Vdev:  " op5
	fi
	if [ $op1 -gt 3 ]; then
		read -p "Fourth Vdev:  " op6
	fi
	if [ $op1 -gt 4 ]; then
		read -p "Fifth Vdev:  " op7
	fi
	if [ $op1 -gt 5 ]; then
		read -p "Sixth Vdev:  " op8
	fi
	if [ $op1 -gt 6 ]; then
		read -p "Seventh Vdev:  " op9
	fi
	if [ $op1 -gt 7 ]; then
		read -p "Eighth Vdev:  " op10
	fi
	if [ $op1 -gt 8 ]; then
		read -p "Ninth Vdev:  " op11
	fi
	if [ $op1 -gt 9 ]; then
		read -p "Tenth Vdev:  " op12
	fi
	
	if [ $op1 == 2 ]; then
		sudo zpool create -f -o ashift=12 zpool $op2 $op3 $op2 $op4
	elif [ $op1 == 3 ]; then
		sudo zpool create -o ashift=12 zpool $op2 $op3 $op2 $op4 $op2 $op5
	elif [ $op1 == 4 ]; then
		sudo zpool create -o ashift=12 zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6
	elif [ $op1 == 5 ]; then
		sudo zpool create -o ashift=12 zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7	
	elif [ $op1 == 6 ];	then
		sudo zpool create -o ashift=12 zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7 $op2 $op8
	elif [ $op1 == 7 ]; then
		sudo zpool create -o ashift=12 zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7 $op2 $op8 $op2 $op9
	elif [ $op1 == 8 ]; then
		sudo zpool create -o ashift=12 zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7 $op2 $op8 $op2 $op9 $op2 $op10
	elif [ $op1 == 9 ]; then
		sudo zpool create -o ashift=12 zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7 $op2 $op8 $op2 $op9 $op2 $op10 $op2 $op11
	elif [ $op1 == 10 ]; then
		sudo zpool create -o ashift=12 zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7 $op2 $op8 $op2 $op9 $op2 $op10 $op2 $op11 $op2 $op12		
	fi
	;;
	[Nn]*)
		return 0
		;;
	*)
		return 0
		;;
	esac
	;;	

5)
	clear
	zpool status
	read -p "Press Enter to continue" con5
	case $con5 in
	*)
		;;
	esac
	;;

6)
	clear
	exit 1
	;;
*)
	;;
esac
done
