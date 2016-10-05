# 45Drives

Requires CentOS7.2

- Setup networking, Internet connection required
- Update system 
- Only preconfig file is required
- Execute on each server
- ./preconfig

- Installs
----------------------------
* Kernel Development Packages
* EPEL Repo
* CentOS GLuster Repo
* Gluster 3.8
* Gluster FUSE 
* Gluster Server
* zfs repo
* zfs (DKMS packages)
* gtools
* Drive Mapping Alias files
* R750 Driver

- Drive Alias Configuration:
----------------------------
* vdev_id.conf

- Using gtools:
----------------------------
* Congifuration can be done on any computer on the same network as the cluster including the nodes themselves
* /etc/hosts file must contain each host used in config if no DNS coinfigured
* Passwordless SSH needs to be setup between each node as well as the computer running the config script
---
* cd /setup/
* ./config host1 host2 .... hostn



