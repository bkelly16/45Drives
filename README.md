# 45Drives

Requires CentOS7.2

- Setup networking, Internet connection required
- Update system
	yum update
- Only preconfig file is required
- Execute on each server
	./preconfig

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
* ./config host[@]



