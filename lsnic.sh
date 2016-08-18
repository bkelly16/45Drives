#!/bin/bash
#BKELLY
#45DRIVES
############
## lsnic.sh
#----------
# Displays Network Interface Information 
#	INTERFACE NAME  | IP/SUBNET            | MAC ADDRESS          | LINK STATUS         
#	=================================================================================
#	bond0           | 192.168.4.60/32      | b6:7b:a9:0c:b1:6d    | UNKNOWN             
#	eth0            | 192.168.3.101/16     | 0c:c4:7a:c3:59:1c    | UP                  
#	eth1            | 192.168.2.194/16     | 0c:c4:7a:c3:59:1d    | UP                  
#	eth2            | 0.0.0.0/0            | a0:36:9f:51:be:c8    | DOWN                
#	eth3            | 0.0.0.0/0            | a0:36:9f:51:be:ca    | DOWN                
#----------
############


declare -A NICLIST
declare -A NICIP
declare -A MAC
declare -A STATUS

lo=1
NICCOUNT_=$(cat /proc/net/dev | awk 'NR>2{print $1}' | sed 's/://' | wc -l)
COUNT=$(expr $NICCOUNT_ - $lo) # Exclude loopback address

i=0
## Read Interface Names
while [ $i -lt $COUNT ];do
	j=$(expr $i + 3)
	nic=$(cat /proc/net/dev | awk -v j=$j 'NR==j{print $1}' | sed 's/://')
	NICLIST[$i]=$nic
	let i=i+1
done

i=0
## Read link status
while [ $i -lt $COUNT ];do
	status=$(ip addr show ${NICLIST[$i]} | awk 'NR==1{print $9;}')
	STATUS[$i]=$status
	let i=i+1
done

i=0
## Read IP/SUBNET
while [ $i -lt $COUNT ];do
	nicip=$(ip addr show ${NICLIST[$i]} | awk 'NR==3{print $2;}')
	if [ -z ${nicip} ];then
		 nicip="0.0.0.0/0" # If IP is null default to 0.0.0.0/0
	fi
	NICIP[$i]=$nicip
	let i=i+1
done

i=0
## Read MAC Address
while [ $i -lt $COUNT ];do
	mac=$(ip addr show ${NICLIST[$i]} | awk 'NR==2{print $2;}')
	MAC[$i]=$mac
	let i=i+1
done

### Display Formating

#printf "INTERFACE NAME\t IP/SUBNET\t\t MAC ADDRESS\t LINK STATUS\n"
printf "%-15s | %-20s | %-20s | %-20s\n" INTERFACE\ NAME IP/SUBNET MAC\ ADDRESS LINK\ STATUS

printf "=================================================================================\n"

i=0
while [ $i -lt $COUNT ];do
	
	#printf  "%s\t\t %s\t %s\t %s\n" \
		#"${NICLIST[$i]}" "${NICIP[$i]}" "${MAC[$i]}" "${STATUS[$i]}"
	printf "%-15s | %-20s | %-20s | %-20s\n" "${NICLIST[$i]}" "${NICIP[$i]}" "${MAC[$i]}" "${STATUS[$i]}"

	let i=i+1
done


