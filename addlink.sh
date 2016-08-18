#!/bin/bash
#CAuCoin
#45DRIVES
##########
#Adding to a Linked List Gluster
#
clear
	echo -e "This will work as long as you currently have a Linked List Topology and have already created bricks on the server being added.\n"
	read -p "Do you want to continue? (Y/n) " yn2
	case $yn2 in
	[Yy]*)		
		read -p "What is the name of your Gluster Volume:  " op7
		read -p "How many servers are currently in your Gluster? " op8
		add=$(( $op8 + 1 ))
		read -p "Press Enter to confirm that you want to add gluster$add to $op7 " con2
		case $con2 in
			*)
				;;
		esac
		
		gluster volume replace-brick $op5 gluster1:/zpool/vol2/brick gluster$add:/zpool/vol1/brick start
		gluster volume replace-brick $op5 gluster1:/zpool/vol2/brick gluster$add:/zpool/vol1/brick force commit
		ssh@gluster1 setfattr -x trusted.glusterfs.volume-id /zpool/vol2/brick 
		ssh@gluster1 setfattr -x trusted.gfid /zpool
		ssh@gluster1 rm -rf /zpool/vol2/brick/.glusterfs/
		gluster volume add-brick $op5 gluster$add:/zpool/vol1/brick gluster1:/zpool/vol2/brick
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

