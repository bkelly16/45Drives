#!/bin/bash
##45Drives
##BK

############
# VDEVMATRIX is i by j matrix where:
# j = VDEVCOUNT
# i = VDEVSIZE
############

declare -A VDEVMATRIX
#declare -A COLORS
BLACK='\033[0;30m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
RED='\033[0;31m'
PURPLE='\033[0;35m'
BROWN='\033[0;33m'
LGREY='\033[0;37m'
DGREY='\033[1;30m'
LBLUE='\033[1;34m'
LGREEN='\033[1;32m'
LCYAN='\033[1;36m'
LRED='\033[1;31m'
LPURPLE='\033[1;35m'
YELLOW='\033[1;33m'
NC='\033[0m'
COLORS=("" "$BLUE" "$GREEN" "$CYAN"  "$PURPLE" "$LBLUE" "$BROWN" "$LBLUE" "$LGREEN" "$LCYAN" "$LRED" "$RED" "$LPURPLE" "$YELLOW")

line() { # takes a number as first input Length, and any character as second input, defaults to "-" if no option
	if [ -z $2 ]; then
		printf -v line '%*s' "$1"
		echo ${line// /-}
	else
		printf -v line '%*s' "$1"
		echo ${line// /$2}
	fi		
}
getbays(){
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
}
echo break3
getvdevmember() {
	for ((c1=1;c1<=VDEVCOUNT;c1++)); do
    		for ((c2=1;c2<=VDEVSIZE;c2++)); do
        		if [ "${BAY[$1]}" == "${VDEVMATRIX[$c2,$c1]}" ];then
				#printf "%s|%s\n" ${BAY[$1]} ${VDEVMATRIX[$c2,$c1]}
				printf -v member "${COLORS[$c1]}%-5s$NC" ${BAY[$1]}
				BAYSTATUS[$1]=$member
				return
			else
				#printf "%s |%s \n" ${BAY[$1]} ${VDEVMATRIX[$c2,$c1]}
				printf -v no "$DGREY%-5s$NC" ${BAY[$1]}
				BAYSTATUS[$1]=$no
			fi
 	   	done
	done		

}

printARRAY(){
	## PRINT ARRAY
	f1="%$((${#VDEV_SIZE}+1))s"
	f2=" %9s"

	printf "$f1" ''
	for ((i=1;i<=VDEVSIZE;i++)) do
    	printf "$f2" $i
	done
	echo

	for ((j=1;j<=VDEVCOUNT;j++)) do
    	printf "$f1" $j
    	for ((i=1;i<=VDEVSIZE;i++)) do
        	printf "$f2" ${VDEVMATRIX[$i,$j]}
 	   done
 	   echo	
	done
}

##MAIN
# Get a list of vdev and each drive in it
# Get SIZE for loop purposes
# Get RAIDTYPE
ZPOOL=$(zpool list zpool -v | awk 'NR>2{print $1}')
SIZE=$(zpool list zpool -v | awk 'NR>2{print $1}' | wc -l)
RAIDTYPE=$(echo $ZPOOL | awk '{print $1}')

## Get VDEVSIZE (# of drives per vdev ) & VDEVCOUNT (# of vdevs)
i=2
j=0
line="none"
until [ "$line" == "$RAIDTYPE" ] || [ "$j" -eq "$SIZE" ]; do
	line=$(echo $ZPOOL | awk -v i=$i '{print $i}')
	let i=i+1
	let j=j+1
done
VDEVSIZE=$(expr $i - 3 )
denom=$(expr $VDEVSIZE + 1)
VDEVCOUNT=$(expr $SIZE / $denom)
#echo $VDEVSIZE
#echo $VDEVCOUNT
# Fill VDEVMATRIX where the rows(i) are VDEVs and the coloumns(i) are drives
j=1
j_=$(expr $j + 1) 
for ((j;j<=VDEVCOUNT;j++)) do
    	for ((i=1;i<=VDEVSIZE;i++)) do
		t=$(echo $ZPOOL | awk -v i=$j_ '{print $i}')
		#echo "$j | $i | $j_"
        	VDEVMATRIX[$i,$j]=$t
		let j_=j_+1
    	done
	let j_=j_+1
done
#printARRAY
#Get complete list of bays
getbays

if [ "$card" -eq "0" ];then
	echo	
	printf "| %s %s %s |\n" $r750tag DriverVersion: $r750driver 
else
	echo
	printf "| %s %s %s  |\n" $lsitag DriverVersion: $lsidriver
fi


WIDTH=15

i=0
j=$(expr $i + $WIDTH)
k=$(expr $i + $WIDTH + $WIDTH)
l=$(expr $i + $WIDTH + $WIDTH + $WIDTH)

## Prints maps of drives colored based on which vdev it belongs to

case $BAYS in
30)
	#30unit

	line 24 _
	while [ $i -lt $WIDTH ];do
		getvdevmember $i
		getvdevmember $j
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
		#echo "$i | $j | $k "
		getvdevmember $i
		getvdevmember $j
		getvdevmember $k
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
		getvdevmember $i
		getvdevmember $j
		getvdevmember $k
		getvdevmember $l
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

