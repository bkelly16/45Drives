# !/bin/bash
#CAuCoin
#45DRIVES
##############################################
#--------------------------------------------#
#     Gluster Configuration tool        	 #
#     1) Set up Linked List Topology    	 #
#     2) Expand Linked List Topology    	 #
#     3) Set up Paired Server Topology  	 #
#     4) Expand Paired Server Topology  	 #
#     5) Start Volume                    	 #
#     6) Gluster Volume Status           	 #
#     7) Delete Volume                   	 #
#     q) Exit Gluster Configuartion      	 # 
#--------------------------------------------#
##############################################

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

NODE=$1

while :
for n in $@;do
	volstatus=$((ssh root@$n gluster vol info | awk 'NR==5{print $2}')2>/dev/null )
done
clear
do
echo -e "\nGluster Volume Configuration"
line 30 -
if [ "$volstatus" == "Started" ];then
	stat="Started"
	echo -e "Volume Status: " $GREEN$stat$NC
elif [ "$volstatus" == "Stopped" ];then
	stat="Stopped"
	echo -e "Volume Status: " $RED$stat$NC
elif [ "$volstatus" == "Created" ];then
	stat="Created"
	echo -e "Volume Status: " $LBLUE$stat$NC
else
	stat="No Volume"
	echo -e "Volume Status: " $GREY$stat$NC
fi
line 30 -
echo -e "1) Create Distributed Replica Volume - Linked List Topology" 
echo -e "2) Create Distributed Volume "
echo -e "2a) Expand Distributed Volume " 
line 20 -
echo -e "start) Start Volume"
echo -e "status) Gluster Volume Status"
echo -e "info) Gluster Volume Information"
echo -e "delete) Delete Volume"
line 20 -
echo -e "q) Exit Gluster Configuration"
line 30 -
## ADD STATUS TABLE
gluster peer status
line 30 -

read -p "Enter an Option: " op0
case $op0 in
1)
	clear
	echo -e "\n"
	sh linkedlist3.sh $@
	echo -e "\n"
	read -p "Press Enter to continue" con1
	case $con1 in
	*)
		;;
	esac
	;;

2)
	clear
	sh distvol.sh $@
	;;
2a)
	sh expanddist.sh $@
	;;
start)
	clear
	read -p "Enter Volume Name: " name
	sh /setup/startVolume.sh $name
	read -p "Press Enter to Continue " con5
	case $con5 in
	*) 
		;;
	esac
	;;

status)
	clear
	volname=$((ssh root@ gluster vol info | awk 'NR==2{print $3}')2>/dev/null )
	gluster volume status $volname 
	read -p "Press Enter to Continue " con6
	case $con6 in
	*) 
		;;
	esac
	;;
info)
	clear
	gluster vol info
	read -p "Press Enter to Continue " info
	case $info in
	*) 
		;;
	esac
	;;
delete)
	clear
	echo "Present Volumes:"
	gluster volume list
	echo
	read -p "Enter Volume Name to delete: " name2
	status=$(gluster volume info $name2 | awk 'NR==5{print $2}')
	sh /setup/firewall.sh remove
	if [ "$status" == "Started" ]; then
		gluster volume stop $name2
	fi	
	gluster volume delete $name2
	for n in $@;do
		ssh root@$n systemctl restart glusterd
	done
	read -p "Press Enter to Continue " con7
	case $con7 in
	*)
		;;
	esac
	;;
	
[qQ]*)
	clear
	exit 1
	;;
*)
	;;
	
esac
done
