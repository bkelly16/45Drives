#!/bin/bash
if [ ! -d "~/.ssh/" ];then
	mkdir ~/.ssh/ 2>/dev/null
fi
echo
if [ ! -e "~/.ssh/id_rsa.pub" ];then
	ssh-keygen -t rsa
fi
echo
for host in $@;do
	echo -e "SSH into $host and copy the authorized key"
	ssh $host mkdir -p .ssh/
	cat ~/.ssh/id_rsa.pub | ssh $host 'cat >> .ssh/authorized_keys'
	echo "Done"
	echo
done

