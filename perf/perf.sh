#!/bin/bash

if [ $# -eq 0 ];then
	echo "Usage ./perf.sh {blocksize} {filesize}"
	exit 1
fi
bs=$1
fs=$2

if [ ! -e run_results ];then
	touch run_results
else
	rm -f run_results
	touch run_results
fi

i=0
while :
do
let i=i+1
length=$(cat run_results | wc -l)
if [ $length -gt 1 ];then
	r1=$(cat run_results | awk -v l="$length" 'NR==l{print $4}')	
	r0=$(cat run_results | awk -v l="$(expr $length - 1 )" 'NR==l{print $4}') 
	w1=$(cat run_results | awk -v l="$length" 'NR==l{print $6}')
	w0=$(cat run_results | awk -v l="$(expr $length - 1 )" 'NR==l{print $6}')
fi
if [ $length -gt 1 ] && [ $r1 -lt $r0 ] && [ $w1 -lt $w0 ];then
	sh bench.sh $i $bs $fs
	echo "Saturation reached"
	exit 1
fi

sh bench.sh $i $bs $fs

done

