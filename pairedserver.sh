#!/bin/bash
#CAuCoin
#45DRIVES
##########
#Paired Server Gluster Set up
#


clear
	echo -e "Paired Server Topology completely pairs servers together (mirrored), servers must be added in pairs meaning you cannot haven an odd number of servers linked togehther in this topology.\n"
	read -p "Press Enter to Continue " con2
	case $con2 in
	*)
		;;
	esac
		
	read -p "Enter a name for your Gluster Volume:  " op1
	read -p "How many servers are you adding:  " op2
	rem=$(( $op2 % 2 ))
	if [ $op2 == 2 ]; then
		gluster volume create $op1 replica 2 gluster1:/zpool/vol1/brick gluster2:/zpool/vol1/brick gluster1:/zpool/vol2/brick gluster2:/zpool/vol2/brick
		gluster volume info $op1
	fi
	if [ $op2 == 4 ];then
		gluster volume create $op1 replica 2 gluster1:/zpool/vol1/brick gluster2:/zpool/vol1/brick gluster1:/zpool/vol2/brick gluster2:/zpool/vol2/brick gluster3:/zpool/vol1/brick gluster4:/zpool/vol1/brick gluster3:/zpool/vol2/brick gluster4:/zpool/vol2/brick
		gluster volume info $op1
	fi
	if [ $op2 == 6 ];then
		gluster volume create $op1 replica 2 gluster1:/zpool/vol1/brick gluster2:/zpool/vol1/brick gluster1:/zpool/vol2/brick gluster2:/zpool/vol2/brick gluster3:/zpool/vol1/brick gluster4:/zpool/vol1/brick gluster3:/zpool/vol2/brick gluster4:/zpool/vol2/brick gluster5:/zpool/vol1/brick gluster6:/zpool/vol1/brick gluster5:/zpool/vol2/brick gluster6:/zpool/vol2/brick
		gluster volume info $op1
	fi
	if [ $op2 == 8 ];then
		gluster volume create $op1 replica 2 gluster1:/zpool/vol1/brick gluster2:/zpool/vol1/brick gluster1:/zpool/vol2/brick gluster2:/zpool/vol2/brick gluster3:/zpool/vol1/brick gluster4:/zpool/vol1/brick gluster3:/zpool/vol2/brick gluster4:/zpool/vol2/brick gluster5:/zpool/vol1/brick gluster6:/zpool/vol1/brick gluster5:/zpool/vol2/brick gluster6:/zpool/vol2/brick gluster7:/zpool/vol1/brick gluster8:/zpool/vol1/brick gluster7:/zpool/vol2/brick gluster8:/zpool/vol2/brick 
		gluster volume info $op1
	fi
	if [ $op2 == 10 ];then
		gluster volume create $op1 replica 2 gluster1:/zpool/vol1/brick gluster2:/zpool/vol1/brick gluster1:/zpool/vol2/brick gluster2:/zpool/vol2/brick gluster3:/zpool/vol1/brick gluster4:/zpool/vol1/brick gluster3:/zpool/vol2/brick gluster4:/zpool/vol2/brick gluster5:/zpool/vol1/brick gluster6:/zpool/vol1/brick gluster5:/zpool/vol2/brick gluster6:/zpool/vol2/brick gluster7:/zpool/vol1/brick gluster8:/zpool/vol1/brick gluster7:/zpool/vol2/brick gluster8:/zpool/vol2/brick gluster9:/zpool/vol1/brick gluster10:/zpool/vol1/brick gluster9:/zpool/vol2/brick gluster10:/zpool/vol2/brick 
		gluster volume info $op1
	fi
    if [ $rem != 0 ];then
		echo -e "Number of servers has to be an even number for the Paired Server Topology."
	fi
