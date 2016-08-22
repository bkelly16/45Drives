#!/bin/bash
##45Drives
##BK

#!/bin/bash
#45DRIVES
#BK
############
############

declare -A BAY
declare -A BAYSTATUS

##FUNCTION DEFINITIONS

line() { # takes a number as first input Length, and any character as second input, defaults to "-" if no option
	if [ -z $2 ]; then
		printf -v line '%*s' "$1"
		echo ${line// /-}
	else
		printf -v line '%*s' "$1"
		echo ${line// /$2}
	fi		
}

arrays() { # take vdev count as input and declare that many arrays
	i=0
	until [ "$i" -eq "$1" ];do
		declare -A "vdev$1"
		let i=i+1
	done	
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

sortdev() {
	case $VDEVCOUNT in
	1)
		j=0
		k=1
		i=2
		while [ $j -lt "$VDEVSIZE" ];do
			t=$(echo $ZPOOL | awk -v i=$i '{print $i'})
			vdev1[$j]=$t
			let i=i+1
			let j=j+1
			let k=k+1
		done
		;;
	2)		
		;;
	3)
		j=0
		i_1=2
		i_2=$(expr $i_1 + $denom)
		i_3=$(expr $i_1 + $denom + $denom)

		while [ $j -lt "$VDEVSIZE" ];do
			t_1=$(echo $ZPOOL | awk -v i=$i_1 '{print $i}')
			echo $i_1
			vdev1[$j]=$t_1
			t_2=$(echo $ZPOOL | awk -v i=$i_2 '{print $i}')
			echo $i_2
			vdev2[$j]=$t_2
			t_3=$(echo $ZPOOL | awk -v i=$i_3 '{print $i}')
			echo $i_3
			vdev3[$j]=$t_3

			let i_1=i_1+1
			let i_2=i_2+1
			let i_3=i_3+1
			let j=j+1
		done
		;;
	4)
		j=0
		i_1=2
		i_2=$(expr $i_1 + $denom)
		i_3=$(expr $i_1 + $denom + $denom)
		i_4=$(expr $i_1 + $denom + $denom + $denom) 
				
		while [ $j -lt "$VDEVSIZE" ];do
			t_1=$(echo $ZPOOL | awk -v i=$i_1 '{print $i}')
			vdev1[$j]=$t_1
			t_2=$(echo $ZPOOL | awk -v i=$i_2 '{print $i}')
			vdev2[$j]=$t_2		
			t_3=$(echo $ZPOOL | awk -v i=$i_3 '{print $i}')
			vdev3[$j]=$t_3
			t_4=$(echo $ZPOOL | awk -v i=$i_4 '{print $i}')
			vdev4[$j]=$t_4
	
			let i_1=i_1+1
			let i_2=i_2+1
			let i_3=i_3+1
			let i_4=i_4+1		
			let j=j+1
		done
	
		;;
	5)
		;;
	6)
		;;
	7)
		;;
	8)
		;;
	9)
		;;
	10)
		;;
	*)
		echo "Fck off would ya"
		;;
	esac	
}



##MAIN

ZPOOL=$(zpool list zpool -v | awk 'NR>2{print $1}')
SIZE=$(zpool list zpool -v | awk 'NR>2{print $1}' | wc -l)


RAIDTYPE=$(echo $ZPOOL | awk '{print $1}')

i=2
j=0
line="none"
until [ "$line" == "$RAIDTYPE" ] || [ "$j" -eq "$SIZE" ] ; do
	line=$(echo $ZPOOL | awk -v i=$i '{print $i}')
	let i=i+1
	let j=j+1
done
VDEVSIZE=$(expr $i - 3 )
denom=$(expr $VDEVSIZE + 1)
VDEVCOUNT=$(expr $SIZE / $denom )

arrays $VDEVCOUNT
sortdev 
getbays

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
45)
	line 24 _
	while [ $i -lt $WIDTH ];do
		#getVDEVmember $i
		#getVDEVmember $j
		#getVDEVmember $k
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
*)
	echo "fuck off for now"

echo ${vdev1[@]}
echo ${vdev2[@]}
echo ${vdev3[@]}
echo ${vdev4[@]}
