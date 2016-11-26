#!/bin/bash
echo
gluster volume start $1
sh /setup/firewall.sh add
