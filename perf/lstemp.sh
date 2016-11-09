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
BLUE='\033[0;36m'
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


setBAYtemp() {
	
	temp=$(hddtemp /dev/disk/by-vdev/${BAY[$1]} | awk '{print $4}')
	tempstatus=$(cat $temp | tr -dc '[:alnum:]\n\r' | cut -f1 -d"C")
	if [ -z $temp ];then
		printf -v notemp "$GREY%-5s$NC" "notemp"
		BAYSTATUS[$1]=$notemp	
	elif [ "$tempstatus" -lt "41" ];then
		printf -v good "$GREEN%-5s$NC" $temp  
		BAYSTATUS[$1]=$good
	elif [ "$tempstatus" -lt "60" ];then
		printf -v caution "$YELLOW%-5s$NC" $temp 	
		BAYSTATUS[$1]=$caution
	else
		printf -v toohot "$RED%-5s$NC" $temp 
		BAYSTATUS[$1]=$toohot
	fi
}

BAYS=$((cat /etc/zfs/vdev_id.conf| awk "NR>2" | wc -l) 2>/dev/null)
#BAYS=$(expr $BAYS_  ) #Exclude comments at top of config file

#Check which controller present are in the system

check=0
if [ -e /proc/scsi/r750/10 ] || [ -e /proc/scsi/r750/11 ];then
	check=1
fi
#scsi=$(cat /etc/zfs/vdev_id.conf 2>/dev/null | grep scsi | awk 'NR=1{print$1}')
#card=$?
#Controller Info
lsitag="Disk Controller: LSI9201-24e"
r750tag="Disk Controller: HighPointR750"
lsidriver=$(modinfo mpt2sas | grep version | awk 'NR==1{print $2}')
if [ -e /proc/scsi/r750/10 ];then
	r750driver=$(cat /proc/scsi/r750/10 2>/dev/null | awk 'NR==1{print $5}')
elif [ -e /proc/scsi/r750/11 ];then
	r750driver=$(cat /proc/scsi/r750/11 2>/dev/null | awk 'NR==1{print $5}')
fi
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


if [ "$check" -eq 1 ];then
	echo	
	printf "| %s %s %s |\n" $r750tag DriverVersion: $r750driver 
else
	echo
	printf "| %s %s %s  |\n" $lsitag DriverVersion: $lsidriver
fi


# initialize 4 counters, one for each potenital row in the server
# 

WIDTH=15
WIDTH_=$(expr $WIDTH - 1)
i=0 # first row, start at 0
j=$(expr $i + $WIDTH) #2nd row offset i by width of the server
k=$(expr $i + $WIDTH + $WIDTH) # 3rd row offset i by 2 widths
l=$(expr $i + $WIDTH + $WIDTH + $WIDTH) # 4th row, offset by 3 widths

case $BAYS in
30)
	#30unit

	line 24 _
	while [ $i -lt $WIDTH ];do
		i_=$(expr $WIDTH_ - $i ) # invert counter for first row
		setBAYtemp $i_
		setBAYtemp $j
		printf "| %s | %s |\n" "${BAYSTATUS[$i_]}" "${BAYSTATUS[$j]}" #displays drives in a snake pattern 
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
		k_=$(expr $WIDTH + $WIDTH + $WIDTH_ - $i ) #invert counter for 3rd row
		i_=$(expr $WIDTH_ - $i ) # invert counter for first row
		setBAYtemp $i_
		setBAYtemp $j
		setBAYtemp $k_
		printf "| %s | %s | %s |\n" "${BAYSTATUS[$i_]}" "${BAYSTATUS[$j]}" "${BAYSTATUS[$k_]}"	
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

	line 32 _
	while [ $i -lt $WIDTH ];do
		k_=$(expr $WIDTH + $WIDTH + $WIDTH_ - $i )
		i_=$(expr $WIDTH_ - $i )
		setBAYtemp $i_
		setBAYtemp $j
		setBAYtemp $k_
		setBAYtemp $l
		printf "| %s | %s | %s | %s |\n" "${BAYSTATUS[$i_]}" "${BAYSTATUS[$j]}" "${BAYSTATUS[$k_]}" "${BAYSTATUS[$l]}"	
		#printf "| %-7s | %-7s | %-7s |\n" ${BAY[$i]} ${BAY[$j]} ${BAY[$k]}
		let i=i+1
		let j=j+1
		let k=k+1
		let l=l+1
	done
	line 32 -
	printf "| %-5s | %-5s | %-5s | %-5s |\n" ROW1 ROW2 ROW3 ROW4
	line 32 =
	echo	
	;;
*)
	echo -e "\nError!\n\tUnable to Display Drive Map\n\tConfigure Drive Aliasing (1)\n"
	;;
esac

