#!/bin/bash
name=$(hostname -s)
zfs set atime=off zpool
zfs set xattr=sa zpool
zfs set exec=off zpool
zfs set sync=disabled zpool
zfs set compression=lz4 zpool
echo -e "Applied the Following Tunables on $name:\n"
zfs get atime zpool | awk 'NR==2'
zfs get xattr zpool | awk 'NR==2'
zfs get exec zpool | awk 'NR==2'
zfs get sync zpool | awk 'NR==2'
zfs get compression zpool | awk 'NR==2'	
echo
