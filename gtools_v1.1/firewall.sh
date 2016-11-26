#!/bin/bash
#Bkelly
gfirewall(){
	fwcheck=$(ssh $node firewall-cmd --zone=public --list-ports | grep 24007-24008| awk '{print $1}')
	if [ -z "$fwcheck" ];then
		echo -e "$1 ports 24007,24008 in firewall on $node. (Gluster Daemon, Gluster Management)"
		ssh $node firewall-cmd --zone=public --$1-port=24007-24008/tcp
	fi
}
bfirewall(){
	echo -e "$3$ing ports $1-$2 in firewall on $node"
	ssh $node firewall-cmd --zone=public --$3-port=$1-$2/tcp
}
getnodes(){
	i=0
	j=3
	numbernodes=$(cat /etc/hosts | awk 'NR>2{print $2}' | wc -l)
	while [ "$numbernodes" -gt "$i" ];do
		nodes=$(cat /etc/hosts | awk -v j=$j 'NR==j{print $2}')
		NODES[$i]=$nodes
		let i=i+1
		let j=j+1
	done
}
getinfo(){
	volname=$((ssh root@"${NODES[0]}" gluster vol info | awk 'NR==2{print $3}')2>/dev/null )
	totalbrick=$((ssh root@"${NODES[0]}" gluster vol info | grep Brick | awk 'NR>2' | wc -l)2>/dev/null )
	brick_=$(expr $totalbrick / $numbernodes)
	brick=$(expr $brick_ - 1)	
	fport=$((ssh root@"${NODES[0]}" gluster vol status $volname | awk 'NR==4{print $3}')2>/dev/null )
	lport=$(expr $fport + $brick)
}

getnodes
if [ -z "$2" ]; then
	getinfo
	for node in "${NODES[@]}";do
		if [ $# -eq 0 ];then
			gfirewall $1
		else
			gfirewall $1
			bfirewall $fport $lport $1
		fi
	done
else
		for node in "${NODES[@]}";do
		if [ $# -eq 0 ];then
			gfirewall $1
		else
			gfirewall $1
			bfirewall $2 $3 $1
		fi
	done
fi
	
	 
