#!/bin/bash

CHECK=$(df | grep zpool | awk '{print $1}')
if [ ! -z $CHECK ];then
	for i in 1 2 3 4 5 6; do
		echo "Writing Test File $i"
		dd if=/dev/zero of=/zpool/test$i bs=$1 count=$2 2>&1 | awk 'NR==3'
	done
	echo
	for i in 1 2 3 4 5 6; do
		echo "Reading Test File $i"
		dd if=/zpool/test$i of=/dev/null bs=$1 2>&1 | awk 'NR==3'
	done
else
	echo "Pool Not Mounted"
fi

