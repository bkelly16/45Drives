# !/bin/bash
#CAuCoin
#45DRIVES
############
#--------------------
#         Gluster Configuration tool
#         1) Create Bricks
#         2) Set up Linked List Topology  
#         3) Expand Linked List Topology
#         4) Set up Paired Server Topology 
#         5) Expand Paired Server Topology
#         6) Exit Gluster Configuartion
#--------------------
############
while :
clear
do
echo -e "\n Gluster Configuration\n-------------------------------\n"
echo -e " 1) Create Bricks"
echo -e " 2) Set up Linked List Topology" 
echo -e " 3) Expand Linked List Topology" 
echo -e " 4) Set up Paired Server Topology" 
echo -e " 5) Expand Paired Server Topology"
echo -e " 6) Exit Gluster Configuration\n"
read -p " Enter an Option From 1-5: " op0
case $op0 in
1)
	clear
	zfs create -o sync=disabled zpool/vol1
	zfs create -o sync=disabled zpool/vol2
	mkdir /zpool/vol1/brick /zpool/vol2/brick
	;;
2)
	clear
	echo -e "\n"
	sh linkedlist.sh
	echo -e "\n"
	read -p "Press Enter to continue" con1
	case $con1 in
	*)
		;;
	esac
	;;
3) 
	clear
	echo -e "\n"
	sh addlink.sh
	echo -e "\n"
	read -p "Press Enter to continue" con1
	case $con1 in
	*)
		;;
	esac
	;;
4)	
	clear
	echo -e "\n"
	sh pairedserver.sh
	echo -e "\n"
	read -p "Press Enter to continue" con1
	case $con1 in
	*)
		;;
	esac
	;;
5)
	clear
	echo -e "\n"
	sh addpair.sh
	echo -e "\n"
	read -p "Press Enter to continue" con1
	case $con1 in
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
