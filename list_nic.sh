#!/bin/bash

nic1=$(cat /proc/net/dev | awk 'NR==3{print $1;}' | sed 's/://')
nic2=$(cat /proc/net/dev | awk 'NR==4{print $1;}' | sed 's/://')
nic3=$(cat /proc/net/dev | awk 'NR==5{print $1;}' | sed 's/://')
nic4=$(cat /proc/net/dev | awk 'NR==6{print $1;}' | sed 's/://')

nic1IP=$(ifconfig $nic1 | awk 'NR==2{print $2;}')
nic1sub=$(ifconfig $nic1 | awk 'NR==2{print $4;}')
nic1MAC=$(ifconfig $nic1 | awk 'NR==4{print $2;}')

nic2IP=$(ifconfig $nic2 | awk 'NR==2{print $2;}')
nic2sub=$(ifconfig $nic2 | awk 'NR==2{print $4;}')
nic2MAC=$(ifconfig $nic2 | awk 'NR==4{print $2;}')

nic3IP=$(ifconfig $nic3 | awk 'NR==2{print $2;}')
nic3sub=$(ifconfig $nic3 | awk 'NR==2{print $4;}')
nic3MAC=$(ifconfig $nic3 | awk 'NR==4{print $2;}')

nic4IP=$(ifconfig $nic4 | awk 'NR==2{print $2;}')
nic4sub=$(ifconfig $nic4 | awk 'NR==2{print $4;}')
nic4MAC=$(ifconfig $nic4 | awk 'NR==4{print $2;}')

#echo $nic1 $nic2 $nic3 $nic4

printf "Interface: %s\n\t IP: %s\n\t Subnet: %s\n\t MAC: %s\n" "$nic1" "$nic1IP" "$nic1sub" "$nic1MAC"
printf "Interface: %s\n\t IP: %s\n\t Subnet: %s\n\t MAC: %s\n" "$nic2" "$nic2IP" "$nic2sub" "$nic2MAC"
printf "Interface: %s\n\t IP: %s\n\t Subnet: %s\n\t MAC: %s\n" "$nic3" "$nic3IP" "$nic3sub" "$nic3MAC"
printf "Interface: %s\n\t IP: %s\n\t Subnet: %s\n\t MAC: %s\n\n" "$nic4" "$nic4IP" "$nic4sub" "$nic4MAC"
