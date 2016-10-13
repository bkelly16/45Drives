#!/bin/bash
#WritBy:CAuCoin, Additions:BK
#45DRIVES
############
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
pause(){ # Waits for user input to continue
read -p "Press Enter to continue" con
case $con in
*)
	;;
esac
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
echo -e "2) Use Custom Configuration"
echo -e "3) Use Recommended Configuration" 
line 5 - 
echo -e "4) List All Drives by Physical Location"
echo -e "5) View Zpool Status"
echo -e "6) Delete Zpool"
echo -e "q) Exit Zpool Configuration"
line 30 -
if [ "$check" -gt 1 ];then
	sh lsvdev.sh
fi
read -p "Enter an Option: " op0
case $op0 in
1)
	clear
	if [ -e /etc/zfs/vdev_id.conf ]; then
		read -p "Aliasing is already configured, are you sure you want to reconfigure? [Y/n] " yn2
		case $yn2 in
		[Yy]*)
			sh /setup/dmap.sh 
			pause
			;;
		[nN]*)
			;;
		esac		
	else	
		sh /setup/dmap.sh
		pause
	fi
	;;

2)
	clear

	echo -e "\nMake sure you have an equal number of drives in each Vdev.\n"
	echo -e "Working Node: $NODE "
	line 30 -
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
		sudo zpool create zpool $op2 $op3 $op2 $op4 -f
	elif [ $op1 == 3 ]; then
		sudo zpool create zpool $op2 $op3 $op2 $op4 $op2 $op5 -f
	elif [ $op1 == 4 ]; then
		sudo zpool create zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 -f
	elif [ $op1 == 5 ]; then
		sudo zpool create zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7 -f	
	elif [ $op1 == 6 ];then
		sudo zpool create zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7 $op2 $op8 -f
	elif [ $op1 == 7 ]; then
		sudo zpool create zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7 $op2 $op8 $op2 $op9 -f
	elif [ $op1 == 8 ]; then
		sudo zpool create zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7 $op2 $op8 $op2 $op9 $op2 $op10 -f
	elif [ $op1 == 9 ]; then
		sudo zpool create zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7 $op2 $op8 $op2 $op9 $op2 $op10 $op2 $op11 -f
	elif [ $op1 == 10 ]; then
		sudo zpool create zpool $op2 $op3 $op2 $op4 $op2 $op5 $op2 $op6 $op2 $op7 $op2 $op8 $op2 $op9 $op2 $op10 $op2 $op11 $op2 $op12 -f		
	fi
	;;

3)
	clear

	read -p "Which Size Storinator is $NODE? (30, 45, or 60) :  " op15
	read -p "Which RAID type? : " rlevel
	read -p "Configure to maximize (storage or IO)? :  " op16
	echo "$o15"
	case $op15 in
	30)
		if [ "$op16" == IO ]; then
			echo -e "Creating Zpool..."
			zpool create zpool $rlevel 1-1 1-2 1-3 1-4 1-5 1-6 $rlevel 1-7 1-8 1-9 1-10 1-11 1-12 $rlevel 1-13 1-14 1-15 1-16 1-17 1-18 $rlevel 1-19 1-20 1-21 1-22 1-23 1-24 $rlevel 1-25 1-26 1-27 1-28 1-29 1-30 -f
		elif [ "$op16" == storage ]; then
			echo -e "Creating Zpool..."
			zpool create zpool $rlevel 1-1 1-2 1-3 1-4 1-5 1-6 1-7 1-8 1-9 1-10 $rlevel 1-11 1-12 1-13 1-14 1-15 1-16 1-17 1-18 1-19 1-20 $rlevel 1-21 1-22 1-23 1-24 1-25 1-26 1-27 1-28 1-29 1-30 -f
		fi
		;;
	45)
		if [ "$op16" == IO ]; then
			echo -e "Creating Zpool..."
			zpool create zpool $rlevel 1-1 1-2 1-3 1-4 1-5 $rlevel 1-6 1-7 1-8 1-9 1-10 $rlevel 1-11 1-12 1-13 1-14 1-15 $rlevel 1-16 1-17 1-18 1-19 1-20 $rlevel 1-21 1-22 1-23 1-24 2-1 $rlevel 2-2 2-3 2-4 2-5 2-6 $rlevel 2-7 2-8 2-9 2-10 2-11 $rlevel 2-12 2-13 2-14 2-15 2-16 $rlevel 2-17 2-18 2-19 2-20 2-21 -f
		elif [ "$op16" == storage ]; then
			echo -e "Creating Zpool..."
			zpool create zpool $rlevel 1-1 1-2 1-3 1-4 1-5 1-6 1-7 1-8 1-9 1-10 1-11 1-12 1-13 1-14 1-15 $rlevel 1-16 1-17 1-18 1-19 1-20 1-21 1-22 1-23 1-24 2-1 2-2 2-3 2-4 2-5 2-6 $rlevel  2-7 2-8 2-9 2-10 2-11 2-12 2-13 2-14 2-15 2-16 2-17 2-18 2-19 2-20 2-21 -f
		fi
		;;
	60)
		if [ "$op16" == IO ]; then
			echo -e "Creating Zpool..."
			zpool create zpool $rlevel 1-1 1-2 1-3 1-4 1-5 1-6 1-7 1-8 1-9 1-10 $rlevel 1-11 1-12 1-13 1-14 1-15 1-16 1-17 1-18 1-19 1-20 $rlevel 1-21 1-22 1-23 1-24 1-25 1-26 1-27 1-28 1-29 1-30 $rlevel 1-31 1-32 2-1 2-2 2-3 2-4 2-5 2-6 2-7 2-8 $rlevel 2-9 2-10 2-11 2-12 2-13 2-14 2-15 2-16 2-17 2-18 $rlevel 2-19 2-20 2-21 2-22 2-23 2-24 2-25 2-26 2-27 2-28 -f
		elif [ "$op16" == storage ]; then
			echo -e "\nCreating Zpool..."
			zpool create zpool $rlevel 1-1 1-2 1-3 1-4 1-5 1-6 1-7 1-8 1-9 1-10 1-11 1-12 1-13 1-14 1-15 $rlevel 1-16 1-17 1-18 1-19 1-20 1-21 1-22 1-23 1-24 1-25 1-26 1-27 1-28 1-29 1-30 $rlevel 1-31 1-32 2-1 2-2 2-3 2-4 2-5 2-6 2-7 2-8 2-9 2-10 2-11 2-12 2-13 $rlevel 2-14 2-15 2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 2-24 2-25 2-26 2-27 2-29 -f
		fi
		;;
	*)
		;;
	esac
	;;

4)
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
	read -p "Delete Zpool? (y/n) " con6
	case $con6 in
	y)
		zpool destroy zpool -f
		;;
		
	*)
		;;
	esac

	;;
q)
	clear
	exit 1
	;;
*)
	;;
esac
done
