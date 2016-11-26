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
elif [ -d /dev/disk/by-vdev/ ];then
	sh lsdev.sh
fi
read -p "Enter an Option: " op0
case $op0 in
1)
	clear
	if [ -e /etc/zfs/vdev_id.conf ]; then
		read -p "Aliasing is already configured, are you sure you want to reconfigure? [Y/n] " yn2
		case $yn2 in
		[Yy]*)
			dmap 
			pause
			;;
		[nN]*)
			;;
		esac		
	else	
		dmap
		pause
	fi
	;;

2)
	clear

	echo -e "\nMake sure you have an equal number of drives in each Vdev.\n"
	echo -e "Working Node: $NODE "
	line 30 -
	zcreate -bc
	;;

3)
	clear
	zcreate -b
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
[root@gluster1 setup]# vi zpoolconfig.sh 
[root@gluster1 setup]# cat zpoolconfig.sh 
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
elif [ -d /dev/disk/by-vdev/ ];then
	sh lsdev.sh
fi
read -p "Enter an Option: " op0
case $op0 in
1)
	clear
	if [ -e /etc/zfs/vdev_id.conf ]; then
		read -p "Aliasing is already configured, are you sure you want to reconfigure? [Y/n] " yn2
		case $yn2 in
		[Yy]*)
			dmap 
			pause
			;;
		[nN]*)
			;;
		esac		
	else	
		dmap
		pause
	fi
	;;

2)
	clear

	echo -e "\nMake sure you have an equal number of drives in each Vdev.\n"
	echo -e "Working Node: $NODE "
	line 30 -
	zcreate -bc
	;;

3)
	clear
	zcreate -b
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

