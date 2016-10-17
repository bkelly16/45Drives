
#!/bin/bash
gethba() {
	case $1 in
	R750|r750|r)
		hba="0750"
		;;
	LSI|lsi|l)
		hba="LSI"
		;;
	Adaptec|adaptec|a) 
		hba="Adaptec"
		;;
	*)
		echo "Unsupported controller, try configurating manually"
		exit
		;;	
	esac
}

if [ -e /etc/zfs/vdev_id.conf ];then
        rm -f /etc/zfs/vdev_id.conf
fi

if [ $# -eq 0 ]; then
	read -p "Disk Controller? " hba
	gethba $hba
	read -p "Chassis Type? (30,45, or 60) " chassis
else
	hba=$1
	gethba $hba
	chassis=$2
fi

if [ "$chassis" -eq 30 ] || [ "$chassis" -eq 45 ] || [ "$chassis" -eq 60 ];then
	:
else
	echo "$chassis is not an available chassis size, (30,45, or 60)"
fi

echo "# by-vdev" >> /etc/zfs/vdev_id.conf
echo "# name     fully qualified or base name of device link" >> /etc/zfs/vdev_id.conf

case $chassis in
30)	
	case $hba in
	0750)
		card1=$(lspci | grep $hba | awk 'NR==1{print $1}')
		#Card 1
		slot=1
		while [ $slot -lt 31 ];do
        		echo "alias 1-$slot     /dev/disk/by-path/pci-0000:$card1-scsi-0:0:$(expr $slot - 1):0" >> /etc/zfs/vdev_id.conf
        		let slot=slot+1
		done
		;;
	Adaptec)
		card1=$(lspci | grep $hba | awk 'NR==1{print $1}')
		card2=$(lspci | grep $hba | awk 'NR==2{print $1}')

		#Card 1
		slot=1
		while [ $slot -lt 17 ];do	
        		echo "alias 1-$slot     /dev/disk/by-path/pci-0000:$card1-scsi-0:2:$(expr $slot - 1):0" >> /etc/zfs/vdev_id.conf
        		let slot=slot+1
		done
		#Card 2
		slot=1
		while [ $slot -lt 15 ];do	
        		echo "alias 2-$slot     /dev/disk/by-path/pci-0000:$card2-scsi-0:2:$(expr $slot - 1):0" >> /etc/zfs/vdev_id.conf
        		let slot=slot+1
		done
		;;
	LSI)
		echo "Not implemented yet :("
		;;
	esac
	;;

45)
	case $hba in
	0750)	
		card1=$(lspci | grep $hba | awk 'NR==1{print $1}')
		card2=$(lspci | grep $hba | awk 'NR==2{print $1}')
		#Card 1
		slot=1
		while [ $slot -lt 25 ];do	
        		echo "alias 1-$slot     /dev/disk/by-path/pci-0000:$card1-scsi-0:0:$(expr $slot - 1):0" >> /etc/zfs/vdev_id.conf
        		let slot=slot+1
		done
		#Card 2
		slot=1
		while [ $slot -lt 22 ];do
        		if [ $slot -eq 21 ];then
        		        echo "alias 2-$slot     /dev/disk/by-path/pci-0000:$card2-scsi-0:0:23:0" >> /etc/zfs/vdev_id.conf
        		else
        		        echo "alias 2-$slot     /dev/disk/by-path/pci-0000:$card2-scsi-0:0:$(expr $slot - 1):0" >> /etc/zfs/vdev_id.conf
        		fi
        		let slot=slot+1
		done
		;;
	Adaptec)
		card1=$(lspci | grep $hba | awk 'NR==1{print $1}')
		card2=$(lspci | grep $hba | awk 'NR==2{print $1}')
		card3=$(lspci | grep $hba | awk 'NR==3{print $1}')

		#Card 1
		slot=1
		while [ $slot -lt 17 ];do	
        		echo "alias 1-$slot     /dev/disk/by-path/pci-0000:$card1-scsi-0:2:$(expr $slot - 1):0" >> /etc/zfs/vdev_id.conf
        		let slot=slot+1
		done
		#Card 2
		slot=1
		while [ $slot -lt 17 ];do	
        		echo "alias 2-$slot     /dev/disk/by-path/pci-0000:$card2-scsi-0:2:$(expr $slot - 1):0" >> /etc/zfs/vdev_id.conf
        		let slot=slot+1
		done
		#Card 3
		slot=1
		while [ $slot -lt 14 ];do	
        		echo "alias 1-$slot     /dev/disk/by-path/pci-0000:$card3-scsi-0:2:$(expr $slot - 1):0" >> /etc/zfs/vdev_id.conf
        		let slot=slot+1
		done
		;;
	LSI)	
		echo "Not implemented yet :("
		;;
	esac	
	;;
60)
	card1=$(lspci | grep $hba | awk 'NR==1{print $1}')
	card2=$(lspci | grep $hba | awk 'NR==2{print $1}')
	#Card 1
	slot=1
	while [ $slot -lt 33 ];do
        	echo "alias 1-$slot     /dev/disk/by-path/pci-0000:$card1-scsi-0:0:$(expr $slot - 1):0" >> /etc/zfs/vdev_id.conf
        	let slot=slot+1
	done
	#Card 2
	slot=1
	while [ $slot -lt 29 ];do
        	echo "alias 2-$slot     /dev/disk/by-path/pci-0000:$card2-scsi-0:0:$(expr $slot - 1):0" >> /etc/zfs/vdev_id.conf
        	let slot=slot+1
	done
	;;
esac

cat /etc/zfs/vdev_id.conf
udevadm trigger