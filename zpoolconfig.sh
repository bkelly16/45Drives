#!/bin/bash
#CAuCoin
#45DRIVES
############
#--------------------
#         Zpool Configuration tool
#         1) List All Configuartion by Physical Location
#         2) Use Recommended Configuration
#         3) Use Custom Configuration
#         4) View Zpool Status
#         5) Exit Zpool Configuartion
#--------------------
############

while :
clear
do
echo -e "\n Zpool Configuration\n----------------------------------------\n"
echo -e " 1) List All Drives by Physical Location"
echo -e " 2) Use Recommended Configuration" 
echo -e " 3) Use Custom Configuration" 
echo -e " 4) View Status"
echo -e " 5) Exit Zpool Configuration\n"
read -p " Enter an Option From 1-5: " op0

case $op0 in
1)
	clear
	ls -1 /dev/disk/by-vdev/	
	read -p "Press Enter to contine" con1
	case $con1 in
	*)
		;;
	esac
	;;
2)
	clear
	read -p "Are you sure you want to use the recommended configuration? (Y/n)" yn0
	case $yn0 in
	[Yy]*)
		echo -e "\nCreating Zpool"
		zpool create -o ashift=12 raidz1 1-1 1-2 1-3 1-4 1-5 1-6 1-7 1-8 1-9 1-10 1-11 1-12 1-13 1-14 1-15 raidz1 1-16 1-17 1-18 1-19 1-20 1-21 1-22 1-23 1-24 1-25 1-26 1-27 1-28 1-29 1-30 raidz1 1-31 1-32 2-1 2-2 2-3 2-4 2-5 2-6 2-7 2-8 2-9 2-10 2-11 2-12 2-13 raidz1 2-14 2-15 2-16 2-17 2-18 2-19 2-20 2-21 2-22 2-23 2-24 2-25 2-26 2-27 2-29
		;;
	[nN]*)
		;;
	esac
	;;
	
3)
	clear
	read -p "Start Configuring Custom Zpool? (Y/n)" yn1
	case $yn1 in
	[Yy]*)
	echo -e "\nMake sure you have an equal number of drives in each Vdev.\n" 
	read -p "Press Enter to Continue" con2
	case $con2 in
	*)
		;;
	esac

	read -p "Please enter desired number of Vdevs (2 to 10) :  " op1
	read -p "Please enter desired RAID level (raidz1,raidz2,raidz3):  " op2		
	echo -e "\nBelow are locations of all drives in the server.\n"
	ls -1 /dev/disk/by-vdev/
	
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

4)
	clear
	zpool status
	read -p "Press Enter to continue" con5
	case $con5 in
	*)
		;;
	esac
	;;

5)
	clear
	exit 1
	;;
*)
	;;
esac
done
