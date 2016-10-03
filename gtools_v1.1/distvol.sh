#!/bin/bash

declare -A HOSTS
declare -A BRICKS

pause(){
read -p "Press Enter to continue" con5
case $con5 in
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

echo -e "Distributed Gluster Volume:\n--- Files randomly distributed across bricks\n--- Capacity is sum of available storage across all nodes\n--- No redundancy for High Availability\n--- Underlying ZFS protects against device failure\n--- Best for easy scalability"
read -p "Press Enter to Continue " con1
case $con1 in *) 
;;
esac
read -p "Enter a name for your Gluster Volume: " volname
read -p "Bricks per Node: " bricks

for host in "${HOSTS[@]}";do
	echo -e "Working Node: $host"
	line 25 -
	ssh $host systemctl restart glusterd
	ssh $host sh /setup/destroyBricks.sh
	ssh $host sh /setup/createBricks.sh $bricks
	ssh $host /setup/tuneDataset.sh
	line 25 -
done
pause

#bset=$(expr $bricks / 2)

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

printf "gluster volume create %s " $volname >> g.conf
for host in "${HOSTS[@]}";do
	for brick in "${BRICKS[@]}";do
		printf "%s:/zpool/vol%s/brick " $host $brick >> g.conf
	done		
done
printf "%s\n" force >> g.conf

echo
cat /setup/g.conf
echo

read -p "Create a Gluter Volume named $volname, with above Configuration?(y/n) " con2

case $con2 in
y)
	cat /setup/g.conf | /bin/bash
	gluster volume info $volname
	echo
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
