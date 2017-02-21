This is a modifiction of /udev/vdev_id from ZFS on Linux. Udev rule remains unchanged.
https://github.com/zfsonlinux/zfs/blob/87f9371aefca857e7091dfdee3ec2d36b0de54c4/cmd/vdev_id/vdev_id

This is meant for device to phycial slot mapping without the need to install ZFS.

Parses file /etc/gtools/vdev_id.conf to map a physical path to a device to a slot name.
Then creates symlink in /dev/ to existing device symlinks ( /dev/1-1 -> /dev/sdb )  

Directory can be changed from /dev/ by editing $ID_VDEV_PATH in "vdev_id"
	ex)
	CHANGE->	echo "ID_VDEV_PATH=${ID_VDEV}" 
	TO->		echo "ID_VDEV_PATH=disk/by-alias/${ID_VDEV}"

By default:
CONFIG=/etc/gtools/vdev_id
ID_VDEV_PATH=${ID_VDEV}

INSTALL:
- Copy "69-vdev.rules" to "/usr/lib/udev/rules.d/"
- Copy "vdev_id" to "/usr/lib/udev/"
- Create "/etc/gtools/vdev_id.conf" 
- Define alias for each device
- dmap & matching mapX script in gtools can be adapted for different ID_VDEV_PATH.
	default in gtools is "/dev/disk/by-vdev"	

EXAMPLE:

# #
# # Example vdev_id.conf - alias
# #
#
# #     by-vdev
# #     name     fully qualified or base name of device link
# alias d1       /dev/disk/by-id/wwn-0x5000c5002de3b9ca
# alias d2       wwn-0x5000c5002def789e

NOTES:

These udev_rules are unnecessary if using ZFS as they are already built in.
By default zfs uses:
CONFIG=/etc/zfs/vdev_id
ID_VDEV_PATH/=disk/by-vdev/${ID_VDEV}
