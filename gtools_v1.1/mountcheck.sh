#!/bin/bash

mount -t glusterfs $1:test /data/data1
exit $?
