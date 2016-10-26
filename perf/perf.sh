#!/bin/bash

if [ $# -eq 0 ];then
	echo "Usage ./perf.sh {blocksize} {filesize} optional {IO/s Mode (-O)}"
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
	cat run_results
	echo
	echo "Saturation reached"
	echo "One more run...."
	sh bench.sh $i $bs $fs $3
	cat run_results
	exit 1
fi
cat run_results
echo
sh bench.sh $i $bs $fs $3

done

