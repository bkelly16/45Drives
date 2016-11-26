#!/bin/bash
#BKelly

declare -A HOSTS
declare -A BRICKS

pause(){ # Waits for user input to continue
read -p "Press Enter to continue" con
case $con in
*)
	;;
esac
}

line() { # takes a number as first input Length, and any character as second input, defaults to "-" if no option
	if [ -z $2 ]; then
		printf -v line '%*s' "$1"
		echo ${line// /-}
	else
		printf -v line '%*s' "$1"
		echo ${line// /$2}
	fi		
}
bcheck() {
	if [ $(($1%2)) -eq 0 ];then
		:
	else
		echo -e "Bricks must be an even number for this configuration"
		read -p "Bricks per Node: " bricks
		bcheck $bricks
	fi
}	
#If no input read /etc/hosts to fill HOSTS array, if input present each repersns nodes hostname
i=0
if [ $# -eq 0 ];then	
	j=3
	numberhosts=$(cat /etc/hosts | awk 'NR>2{print $2}' | wc -l)
	while [ "$numberhosts" -gt "$i" ];do
		hosts=$(cat /etc/hosts | awk -v j=$j 'NR==j{print $2}')
		HOSTS[$i]=$hosts
		let i=i+1
		let j=j+1
	done
else
	numberhosts=$#	
	for hosts in "$@";do
		HOSTS[$i]=$hosts
		let i=i+1
	done
fi
clear

echo -e "Linked List Topology allows an even or odd number of servers to work together\nAllowing the ability to add a single server at a time.\n"
echo -e "Distributed Replica Volume - Linked List Topology :\n--- Bricks mirrored with brick pair on adjacent server\n--- Capacity is total staorage across all nodes divided by replica count\n--- High Availablility, 1 server can go down with no interruption in\n\tavailability (Number varies on # of nodes and replication level)\n--- Underlying ZFS protects against device failure\n--- Linked list topology allows for nodes to added one at a time\n--- Support for a odd number of servers yet still fully replicated\n--- Bricks per node must be a multiple of 2\n"
pause

read -p "Enter a name for your Gluster Volume: " volname

read -p "Bricks per Node: " bricks
bcheck $bricks
for host in "${HOSTS[@]}";do # For each node destroy, create and tune bricks based on user input
	echo -e "Working Node: $host"
	line 25 -
	ssh $host systemctl restart glusterd # Restart glusterd so tcp port assignment resets
	ssh $host sh /setup/destroyBricks.sh # Destroy any present bricks on the zpool
	ssh $host sh /setup/createBricks.sh $bricks # Create bricks,takes user input as brick count.
	echo
	ssh $host /setup/tuneDataset.sh # apply tweaks to zpool, each dataset will inherit the value.
	line 25 -
done
pause

read -p "Replication Level:(2) " rep
rep=2 # Right now rep level defaults to "2" if higher rep level needed create volume manually

if [ "$numberhosts" -lt "$rep" ];then #Check to mak sure right amount of nodes are present
	echo -e "You need at least $rep Nodes\n"
	case $con1 in
	*)
		exit
		;;
	esac
fi 

#bset is used to create linked list command, every two bricks the process resets. ( i.e for each bset do the same loop to create command)
bset=$(expr $bricks / 2) 

i=0
b=1
# Create array of bricks , (1 2 3 4 .... brickn)
while [ "$bricks" -gt "$i" ];do
	BRICKS[$i]=$b
	let i=i+1
	let b=b+1
done	

#check to see if g.conf is present, if not make it, if it is delete and remake
if [ ! -e /setup/g.conf ];then
	touch /setup/g.conf
else
	rm -f /setup/g.conf
	touch /setup/g.conf
fi

# Print the first part of the gluster command, "gluster volume create" starts the process, volume name and replica level is passed in.
# This is outputted into g.conf
printf "gluster volume create %s replica %s " $volname $rep >> g.conf

# Loop through bset and output brick pairs into g.conf, 
# each node is paired next node in the list (gluster1 -> gluster2)
# If the "next" node in the list doesnt exist, then pair that node with the first node, to make a linked list.
# each the bricks are always (brick 1 -> brick 2, brick 3 -> brick4) and so on for the number of bricks present.
i=0
bcount=0
while [ "$bset" -gt "$i" ];do
	j=0
	for host in "${HOSTS[@]}";do
		f=$(expr $j + 1)
		bcount1=$(expr $bcount + 1)
		if [ "$f" -eq "$numberhosts" ];then
			printf "%s:/zpool/vol%s/brick %s:/zpool/vol%s/brick " ${HOSTS[$j]} ${BRICKS[$bcount]} ${HOSTS[0]} ${BRICKS[$bcount1]} >> g.conf
		else
			printf "%s:/zpool/vol%s/brick %s:/zpool/vol%s/brick " ${HOSTS[$j]} ${BRICKS[$bcount]} ${HOSTS[$f]} ${BRICKS[$bcount1]} >> g.conf
		fi		
		let j=j+1
	done
	let bcount=bcount+2
	let i=i+1
done
printf "%s\n" force >> g.conf

echo
cat /setup/g.conf
echo
read -p "Create a Gluter Volume named $volname, with above Configuration?(y/n) " con2

case $con2 in
y)
	# cat the g.conf made earlier and pipe it into /bin/bash to execute the create volume command.
	cat /setup/g.conf | /bin/bash 
	gluster volume info $volname
	echo
	# prompt if user wants to start volume now.
	read -p "Start Volume?(y/n) " con3
		case $con3 in
		y)
			sh /setup/startVolume.sh $volname
			;;
		*)
		;;
	esac
	;;
*)
	exit
	;;	
esac
