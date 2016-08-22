#!/bin/bash
#45DRIVES
#BK
############
############

declare -A BAY
declare -A BAYSTATUS
RED='\033[0;31m'
GREEN='\033[0;32m'
LGREEN='\033[1;32m'
LGREY='\033[1;37m'
DGREY='\033[1;30m'
YELLOW='\033[0;33m'
BLUE='033[0;36m'
NC='\033[0m'

line() { # takes a number as first input Length, and any character as second input, defaults to "-" if no option
	if [ -z $2 ]; then
		printf -v line '%*s' "$1"
		echo ${line// /-}
	else
		printf -v line '%*s' "$1"
		echo ${line// /$2}
	fi		
}


setBAYstatus() {
	
	partcount=$(ls /dev/disk/by-vdev/ | grep -w ${BAY[$1]} | wc -l)
	# If $partcount = : 
	# 0 = Empty slot
	# 1 = Blank Disk
	# 3 = ZFS member (most likely) therefore in use
	# anything else would be recognized as unknown, wipe first.
	if [ "$partcount" -eq "0" ];then
		printf -v absent "$DGREY%-5s$NC" ${BAY[$1]}  
		#absent=$(echo -e "${DGREY}${BAY[$1]}${NC}")
		BAYSTATUS[$1]=$absent
	elif [ "$partcount" -eq "1" ];then
		printf -v blank "$BLUE%-5s$NC" ${BAY[$1]}  	
		#blank=$(echo -e "${BLUE}${BAY[$1]}${NC}")
		BAYSTATUS[$1]=$blank
	elif [ "$partcount" -eq "3" ];then
		printf -v inuse "$LGREEN%-5s$NC" ${BAY[$1]} 
		#inuse=$(echo -e "${LGREEN}${BAY[$1]}${NC}")
		BAYSTATUS[$1]=$inuse
	else
		printf -v unknown "$YELLOW%-5s$NC" ${BAY[$1]} 
		#unknown=$(echo -e "${YELLOW}${BAY[$1]}${NC}")
		BAYSTATUS[$1]=$unknown
	fi
}

i=2 
BAYS_=$(cat /etc/zfs/vdev_id.conf | wc -l)
BAYS=$(expr $BAYS_ - $i ) #Exclude comments at top of config file

#Check which controller present are in the system
cat /etc/zfs/vdev_id.conf | grep scsi >/dev/null
card=$?
#Controller Info
lsitag="Disk Controller: LSI9201-24e"
r750tag="Disk Controller: HighPointR750"
lsidriver=$(modinfo mpt2sas | grep version | awk 'NR==1{print $2}')
r750driver=$(cat /proc/scsi/r750/10 2>/dev/null | awk 'NR==1{print $5}')


i=0
j=3
## LOOP THROUGH BAYS
while [ $i -lt $BAYS ];do
	bay=$(cat /etc/zfs/vdev_id.conf | awk -v j=$j 'NR==j{print $2}')
	BAY[$i]=$bay
	let i=i+1
	let j=j+1
done


WIDTH=15
WIDTH_=$(expr $WIDTH + 1)
i=0
j=$(expr $i + $WIDTH)
k=$(expr $i + $WIDTH + $WIDTH)
l=$(expr $i + $WIDTH + $WIDTH + $WIDTH)

if [ $card -eq 0 ];then
	echo	
	printf "| %s %s %s |\n" $r750tag DriverVersion: $r750driver 
else
	echo
	printf "| %s %s %s  |\n" $lsitag DriverVersion: $lsidriver
fi

case $BAYS in
30)
	#30unit

	line 24 _
	while [ $i -lt $WIDTH ];do
		setBAYstatus $i
		setBAYstatus $j
		printf "| %s | %s |\n" "${BAYSTATUS[$i]}" "${BAYSTATUS[$j]}"
		#printf "| %-7s | %-7s | %-7s |\n" ${BAY[$i]} ${BAY[$j]} ${BAY[$k]}
		let i=i+1
		let j=j+1
	done
	line 24 -
	printf "| %-5s | %-5s |\n" ROW1 ROW2
	line 24 =
	;;
45)
	#45Unit

	line 24 _
	while [ $i -lt $WIDTH ];do
		setBAYstatus $i
		setBAYstatus $j
		setBAYstatus $k
		printf "| %s | %s | %s |\n" "${BAYSTATUS[$i]}" "${BAYSTATUS[$j]}" "${BAYSTATUS[$k]}"	
		#printf "| %-7s | %-7s | %-7s |\n" ${BAY[$i]} ${BAY[$j]} ${BAY[$k]}
		let i=i+1
		let j=j+1
		let k=k+1
	done
	line 24 -
	printf "| %-5s | %-5s | %-5s |\n" ROW1 ROW2 ROW3
	line 24 =
	;;
60)
	#60unit

	line 24 _
	while [ $i -lt $WIDTH ];do
		setBAYstatus $i
		setBAYstatus $j
		setBAYstatus $k
		setBAYstatus $l
		printf "| %s | %s | %s | %s |\n" "${BAYSTATUS[$i]}" "${BAYSTATUS[$j]}" "${BAYSTATUS[$k]}" "$BAYSTATUS[$l]}"	
		#printf "| %-7s | %-7s | %-7s |\n" ${BAY[$i]} ${BAY[$j]} ${BAY[$k]}
		let i=i+1
		let j=j+1
		let k=k+1
		let l=l+1
	done
	line 24 -
	printf "| %-5s | %-5s | %-5s | %-5s |\n" ROW1 ROW2 ROW3 ROW4
	line 24 =
	echo	
	;;
*)
	echo -e "\nError: Unable to Display Drive Map\nConfigure vdev_id.conf\n"
	;;
esac

