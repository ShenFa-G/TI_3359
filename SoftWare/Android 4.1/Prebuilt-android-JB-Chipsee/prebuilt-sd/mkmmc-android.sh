#!/bin/bash

EXPECTED_ARGS=1

if [[ -z $1 ]]
then
	echo "mkmmc-android Usage:"
	echo "	mkmmc-android <device>"
	echo "	Example: mkmmc-android /dev/sdc"
	exit
fi

echo "All data on "$1" now will be destroyed! Continue? [y/n]"
read ans
if ! [ $ans == 'y' ]
then
	exit
fi

echo "[Unmounting all existing partitions on the device ]"

umount $1*

echo "[Partitioning $1...]"

DRIVE=$1
dd if=/dev/zero of=$DRIVE bs=1024 count=1024 &>/dev/null

SIZE=`fdisk -l $DRIVE | grep Disk | awk '{print $5}'`

echo DISK SIZE - $SIZE bytes

CYLINDERS=`echo $SIZE/255/63/512 | bc`

echo CYLINDERS - $CYLINDERS
{
echo ,9,0x0C,*
echo ,$(expr $CYLINDERS / 2),,-
echo ,,0x0C,-
} | sfdisk -D -H 255 -S 63 -C $CYLINDERS $DRIVE &> /dev/null

echo "[Making filesystems...]"

if [[ ${DRIVE} == /dev/*mmcblk* ]]
then
	DRIVE=${DRIVE}p
fi

mkfs.vfat -F 32 -n boot ${DRIVE}1 &> /dev/null
mkfs.ext4 -L rootfs ${DRIVE}2 &> /dev/null
mkfs.vfat -F 32 -n data ${DRIVE}3 &> /dev/null

echo "[Copying boot files...]"

mount ${DRIVE}1 /mnt
cp boot/MLO /mnt/MLO
cp boot/u-boot.img /mnt/u-boot.img
cp boot/uImage /mnt/uImage
cp boot/uEnv.txt /mnt/uEnv.txt
umount ${DRIVE}1

echo "[Extracting rootfs files...]"

mount ${DRIVE}2 /mnt
tar zxvf rootfs.tar.gz -C /mnt &> /dev/null
chmod 755 /mnt
umount ${DRIVE}2

echo "[Extracting data files...]"

mount ${DRIVE}3 /mnt
tar zxvf data.tar.gz -C /mnt &> /dev/null
umount ${DRIVE}3

echo "[Done]"
