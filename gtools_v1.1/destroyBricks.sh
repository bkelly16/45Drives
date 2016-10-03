#!/bin/bash
dir=$(pwd)
cd /
for brick in zpool/vol*;do
	zfs destroy -rf $brick 2>/dev/null
	echo "Destroyed brick: $brick"
done
cd $dir
