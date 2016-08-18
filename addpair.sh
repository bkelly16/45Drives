#!/bin/bash
#CAuCoin
#45DRIVES
##########
#Adding to a Paired Server Gluster
#

clear
	echo -e "This will only work if are capable of adding two servers to your topology and you've already Created the Bricks on these new servers.\n"
	read -p "Do you want to continue? (Y/n) " yn2
	case $yn2 in
	[Yy]*)		
		read -p "What is the name of your Gluster Volume:  " op5
		read -p "How many servers are currently in your Gluster? " op6
		rem=$(( $op6 % 2 ))
		add1=$(( $op6 + 1 ))
		add2=$(( $op6 + 2 ))
		until [ $rem == 0 ]; do
			echo -e "\nNot a valid number of servers in Gluster, Must be an even number.\n " 
			read -p "How many servers are currently in your Gluster? " op6
			rem=$(( $op6 % 2 ))
			add1=$(( $op6 + 1 ))
			add2=$(( $op6 + 2 ))
		done		
		read -p "Press Enter to confirm that you want to add gluster$add1 and gluster$add2 to $op5 " con2
		case $con2 in
			*)
				;;
		esac
		gluster volume add-brick $op5 gluster$add1:/zpool/vol1/brick gluster$add2:/zpool/vol1/brick gluster$add1:/zpool/vol2/brick gluster$add2:/zpool/vol2/brick
		gluster volume info $op5
		read -p "Press Enter to Continue " con3
		case $con3 in
		*)
			;;
		esac	
			;;
	[nN]*)
			;;
	esac

	
