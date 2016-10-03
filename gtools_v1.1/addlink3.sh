#!/bin/bash
#CAuCoin & BK
#45DRIVES
##########
#Adding to a Linked List Gluster
#
pause(){ # Waits for user input to continue
read -p "Press Enter to continue" con
case $con in
*)
	;;
esac
}

declare -A HOSTS
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

clear

read -p "What is the name of your Gluster Volume:  " volname
read -p "How many nodes are currently in your Gluster? " count
read -p "Press Enter to confirm that you want to add ${HOSTS[$count]} to $volname " con2
case $con2 in
	*)
		;;
esac	

i=0
for host in "${HOSTS[@]}";do
	if ping -c 1 -W 1 $host >/dev/null; then
		bricks=$(gluster vol info vol | grep $host | wc -l)
	else
		:
	fi
	let i=i+1
done

count0=$(expr $count - 1)
bset=$(expr $bricks / 2)
i=0
bcount=1
while [ "$bset" -gt "$i" ];do
	bcount1=$(expr $bcount + 1)
	gluster volume remove-brick $volname replica 2 ${HOSTS[0]}:/zpool/vol$bcount1/brick ${HOSTS[$count0]}:/zpool/vol$bcount/brick start
	echo "Use Ctrl+C to quit once data migration is finished"
	pause
	watch /bin/bash -c gluster volume remove-brick $volname replica 2 ${HOSTS[0]}:/zpool/vol$bcount1/brick ${HOSTS[$count0]}:/zpool/vol$bcount/brick status
	ssh ${HOSTS[$count0]} rm -rf /zpool/vol$bcount/brick && mkdir /zpool/vol$bcount/brick
  	ssh ${HOSTS[0]} rm -rf /zpool/vol$bcount1/brick && mkdir /zpool/vol$bcount1/brick
	let bcount=bcount+2
	let i=i+1
done

i=0
bcount=1
while [ "$bset" -gt "$i" ];do
	bcount1=$(expr $bcount + 1)
	gluster volume add-brick $volname replica 2 \
	${HOSTS[$count0]}:/zpool/vol$bcount/brick ${HOSTS[$count]}:/zpool/vol$bcount1/brick \
	${HOSTS[$count0]}:/zpool/vol$bcount/brick ${HOSTS[$count]}:/zpool/vol$bcount1/brick \
	force
	
	let bcount=bcount+2
	let i=i+1
done

