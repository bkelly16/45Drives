#!/bin/bash
ntppause(){ # Waits for user input to continue
read -p "Press Enter to edit /etc/ntp.conf" con
case $con in
*)
	;;
esac
}
ntp=$(rpm -qa | grep ntp- )
ntpdate=$(rpm -qa | grep ntpdate )
if [ -z $ntp ] && [ -z $ntpdate ] ;then
	yum install ntp ntpdate -y
elif [ -z $ntp ];then
	yum install ntp -y
elif [ -z $ntpdate ];then
	yum install ntpdate -y
fi

read -p "Enter the name of NTP server you want to use:(pool.ntp.org) " $timeserver
if [ -z $timeserver ];then
	ntpdate pool.ntp.org
	echo
else 
	ntpdate $timeserver
	echo
	echo "You need to update ntp.conf with the alternate timeserver(s)\nReplace the default timeservers(pool.ntp.org) on lines 19-23"
	ntppause
	vi /etc/ntp.conf
fi

systemctl enable ntpd
systemctl restart ntpd 


