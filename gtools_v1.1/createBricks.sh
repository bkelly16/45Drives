#!/bin/bash
capacity=$(df | grep zpool | awk 'NR==1{print $2}')
bsize=$(expr $capacity / $1)
i=0	
j=$(expr $i + 1 )
e="k"

until [ $i -eq $1 ];do
	zfs create zpool/vol$j 2>/dev/null
	mkdir /zpool/vol$j/brick 2>/dev/null
	echo "Created brick: zpool/vol$j"
	zfs set quota=$bsize$e zpool/vol$j 2>/dev/null
	let i=i+1
	let j=j+1
done

