#!/bin/bash
#CAuCoin
#45DRIVES
##########
#Linked List Gluster Set up
#
clear
	echo -e "Linked List Topology allows an even or odd number of servers to work together, and the functionality to add a single server at a time.\n"
	read -p "Press Enter to Continue " con1
	case $con1 in
	*)
		;;
	esac
	
	read -p "Enter a name for your Gluster Volume:  " op1
	read -p "How many servers are you adding:  " op2
	if [ $op2 == 2 ]; then
		gluster volume create $op1 replica 2 gluster1:/zpool/vol1/brick gluster2:/zpool/vol2/brick gluster2:/zpool/vol1/brick gluster1:/zpool/vol2/brick
    	gluster volume info $op1
	fi
	if [ $op2 == 3 ]; then
		gluster volume create $op1 replica 2 gluster1:/pool/vol1/brick gluster2:/pool/vol2/brick gluster2:/pool/vol1/brick gluster3:/pool/vol2/brick gluster3:/zpool/vol1/brick gluster1:/zpool/vol2/brick
    	gluster volume info $op1
	fi
	if [ $op2 == 4 ]; then
		gluster volume create $op1 replica 2 gluster1:/pool/vol1/brick gluster2:/pool/vol2/brick gluster2:/pool/vol1/brick gluster3:/pool/vol2/brick gluster3:/zpool/vol1/brick gluster4:/zpool/vol2/brick gluster4:/zpool/vol1/brick gluster1:/zpool/vol2/brick
    	gluster volume info $op1
	fi
	if [ $op2 == 5 ]; then
		gluster volume create $op1 replica 2 gluster1:/pool/vol1/brick gluster2:/pool/vol2/brick gluster2:/pool/vol1/brick gluster3:/pool/vol2/brick gluster3:/zpool/vol1/brick gluster4:/zpool/vol2/brick gluster4:/zpool/vol1/brick gluster5:/zpool/vol2/brick gluster5:/zpool/vol1/brick gluster1:/zpool/vol2/brick
    	gluster volume info $op1
	fi
	if [ $op2 == 6 ]; then
		gluster volume create $op1 replica 2 gluster1:/pool/vol1/brick gluster2:/pool/vol2/brick gluster2:/pool/vol1/brick gluster3:/pool/vol2/brick gluster3:/zpool/vol1/brick gluster4:/zpool/vol2/brick gluster4:/zpool/vol1/brick gluster5:/zpool/vol2/brick gluster5:/zpool/vol1/brick gluster6:/zpool/vol2/brick gluster6:/zpool/vol1/brick gluster1:/zpool/vol2/brick
    	gluster volume info $op1
	fi
	if [ $op2 == 7 ]; then
		gluster volume create $op1 replica 2 gluster1:/pool/vol1/brick gluster2:/pool/vol2/brick gluster2:/pool/vol1/brick gluster3:/pool/vol2/brick gluster3:/zpool/vol1/brick gluster4:/zpool/vol2/brick gluster4:/zpool/vol1/brick gluster5:/zpool/vol2/brick gluster5:/zpool/vol1/brick gluster6:/zpool/vol2/brick gluster6:/zpool/vol1/brick gluster7:/zpool/vol2/brick gluster7:/zpool/vol1/brick gluster1:/zpool/vol2/brick
    	gluster volume info $op1
	fi
	if [ $op2 == 8 ]; then
		gluster volume create $op1 replica 2 gluster1:/pool/vol1/brick gluster2:/pool/vol2/brick gluster2:/pool/vol1/brick gluster3:/pool/vol2/brick gluster3:/zpool/vol1/brick gluster4:/zpool/vol2/brick gluster4:/zpool/vol1/brick gluster5:/zpool/vol2/brick gluster5:/zpool/vol1/brick gluster6:/zpool/vol2/brick gluster6:/zpool/vol1/brick gluster7:/zpool/vol2/brick gluster7:/zpool/vol1/brick gluster8:/zpool/vol2/brick gluster8:/zpool/vol1/brick gluster1:/zpool/vol2/brick
    	gluster volume info $op1
	fi
	if [ $op2 == 9 ]; then
		gluster volume create $op1 replica 2 gluster1:/pool/vol1/brick gluster2:/pool/vol2/brick gluster2:/pool/vol1/brick gluster3:/pool/vol2/brick gluster3:/zpool/vol1/brick gluster4:/zpool/vol2/brick gluster4:/zpool/vol1/brick gluster5:/zpool/vol2/brick gluster5:/zpool/vol1/brick gluster6:/zpool/vol2/brick gluster6:/zpool/vol1/brick gluster7:/zpool/vol2/brick gluster7:/zpool/vol1/brick gluster8:/zpool/vol2/brick gluster8:/zpool/vol1/brick gluster9:/zpool/vol2/brick gluster9:/zpool/vol1/brick gluster1:/zpool/vol2/brick
    	gluster volume info $op1
	fi
	if [ $op2 == 10 ]; then
		gluster volume create $op1 replica 2 gluster1:/pool/vol1/brick gluster2:/pool/vol2/brick gluster2:/pool/vol1/brick gluster3:/pool/vol2/brick gluster3:/zpool/vol1/brick gluster4:/zpool/vol2/brick gluster4:/zpool/vol1/brick gluster5:/zpool/vol2/brick gluster5:/zpool/vol1/brick gluster6:/zpool/vol2/brick gluster6:/zpool/vol1/brick gluster7:/zpool/vol2/brick gluster7:/zpool/vol1/brick gluster8:/zpool/vol2/brick gluster8:/zpool/vol1/brick gluster9:/zpool/vol2/brick gluster9:/zpool/vol1/brick gluster10:/zpool/vol2/brick gluster10:/zpool/vol1/brick gluster1:/zpool/vol2/brick
    	gluster volume info $op1
	fi
    ;;
