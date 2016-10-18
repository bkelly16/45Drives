#!/bin/bash
if [ $# -eq 0 ];then
	echo "Usage ./bench.sh {thread} {blocksize} {filesize}"
	exit 1
fi

iozone -t $1 -i 0 -i 1 -r $2 -s $3 -+n $4 | tee tmp_results

write=$(cat tmp_results | grep writers | awk 'NR==1{print $9}' | cut -f1 -d".")
read=$(cat tmp_results | grep readers | awk 'NR==1{print $8}'| cut -f1 -d".")

echo "Threads: $1 Read: $read Write: $write" >> run_results
rm tmp_results




