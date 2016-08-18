#!/bin/bash
#BKELLY
#45DRIVES
############

for i in "$@"
do
case $i in
    -n=*|--nodes=*)
    NODES="${i#*=}"
    shift # past argument=value
    ;;
    *)
            # unknown option
    ;;
esac
done
echo ${NODES[@]}
