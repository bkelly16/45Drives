
#!/bin/bash
#BK
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
line() { # takes a number as first input Length, and any character as second input, defaults to "-" if no option
	if [ -z $2 ]; then
		printf -v line '%*s' "$1"
		echo ${line// /-}
	else
		printf -v line '%*s' "$1"
		echo ${line// /$2}
	fi		
}

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
read -p "Press Enter to confirm that you want to add ${HOSTS[$count]} to $volname: " con2
case $con2 in
	*)
		;;
esac	


count2=$(expr $count - 1 )
if ping -c 1 -W 1 ${HOSTS[$count2]} >/dev/null; then
		bricks=$(gluster vol info $volname | grep ${HOSTS[$count2]} | wc -l)
else
	:
fi


line 25 -
ssh ${HOSTS[$count]} sh /setup/destroyBricks.sh # Destroy any present bricks on the zpool
ssh ${HOSTS[$count]} sh /setup/createBricks.sh $bricks # Create bricks,takes user input as brick count.
echo
ssh ${HOSTS[$count]} sh /setup/tuneDataset.sh # apply tweaks to zpool, each dataset will inherit the value.
line 25 -

i=0
b=1
while [ "$bricks" -gt "$i" ];do
	BRICKS[$i]=$b
	let i=i+1
	let b=b+1
done	

if [ ! -e /setup/g.conf ];then
	touch /setup/g.conf
else
	rm -f /setup/g.conf
	touch /setup/g.conf
fi

printf "gluster volume add-brick %s " $volname >> g.conf

for brick in "${BRICKS[@]}";do
	printf "%s:/zpool/vol%s/brick " ${HOSTS[$count]} $brick >> g.conf
done

printf "%s\n" force >> g.conf

echo
cat /setup/g.conf
echo

read -p "Expand a Gluter Volume named $volname?(y/n) " con2

case $con2 in
y)
	# cat the g.conf made earlier and pipe it into /bin/bash to execute the create volume command.
	ssh ${HOSTS[$count]} sh /setup/firewall.sh add 
	cat /setup/g.conf | /bin/bash 
	gluster volume info $volname
	pause
	echo
	;;
*)
	exit
	;;	
esac




