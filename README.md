# 45Drives

Requires CentOS7.2

* Setup networking, Internet connection required
* Update system 
* Only preconfig file is required
* Execute on each server
 * ./preconfig

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
* Example vdev_id.conf files for each 45drives server chassis (slot/HBA). /alias
* Need to manually change the PCI bus ID in the alias files (vdev_id.conf) depending where the cards are physically located in the motherboard before drive mapping will take effect.
 * pci-0000:03:00.0-scsi-0:0:1:0
 * "0.30.0" is the card PCI bus ID, this can identifed using: lspci | grep HighPoint (LSI)
 * "0:0:1:0"  is the drive ID.This does not need ot be changed in the example files except for the second card. 
 * Change "0:0:20:0" to "0:0:23:0", due to the physical layout of the system.
 
- Using gtools:
----------------------------
* Configuration can be done on any computer on the same network as the cluster including the nodes themselves
* /etc/hosts file must contain each host used in config if no DNS configured
* Passwordless SSH needs to be setup between each node as well as the computer running the config script
  * cd /setup/
  * ./config host1 host2 .... hostn
* Options  
 * First build zpool on each node (option "1"), then gluster volume (option "2"), then mount (option "3") and answer the question presented by UI.
 * "hosts" options will generate /etc/hosts file on each node to contain loclahosts and each node. If other entries were present in each node they will be need to be replaced. If using other hosts in the /etc/hosts file than add the hosts to the the script /gtools_v1.1/config after line 316 (i.e printf "otherhost 192.168.10.10" >> >> /tmp/ip   
 * "ssh" ssh's into each node
 * "ntp" configure ntp time servers on each node. It defaults to "centos.pool.ntp.org" but prompts for other options.


