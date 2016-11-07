#!/bin/bash

EXPECTED_ARGS=1

if [[ -z $1 ]]
then
	echo "mkmmc-android-nand.sh Usage:"
	echo "	sudo ./mkmmc-android-nand.sh <device>"
	echo "	Example: sudo ./mkmmc-android-nand.sh /dev/sdc"
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
dd if=/dev/zero of=$DRIVE bs=1024 count=1024
	 
SIZE=`fdisk -l $DRIVE | grep Disk | awk '{print $5}'`
	 
echo DISK SIZE - $SIZE bytes
 
CYLINDERS=`echo $SIZE/255/63/512 | bc`
 
echo CYLINDERS - $CYLINDERS
{
echo ,45,0x0C,*
echo ,1,0x0C,-
echo ,,,-
} | sfdisk -D -H 255 -S 63 -C $CYLINDERS $DRIVE

echo "[Making filesystems...]"

if [[ ${DRIVE} == /dev/*mmcblk* ]]
then
        DRIVE=${DRIVE}p
fi

mkfs.vfat -F 32 -n boot ${DRIVE}1 &> /dev/null
mkfs.vfat -F 32 -n dummy ${DRIVE}2 &> /dev/null
mkfs.vfat -F 32 -n data ${DRIVE}3 &> /dev/null

echo "[Copying files...]"

mount ${DRIVE}1 /mnt
echo "[Copying boot files...]"
cp boot/MLO /mnt/MLO
cp boot/u-boot.img /mnt/u-boot.img
cp boot/uImage /mnt/uImage
cp boot/uEnv.txt /mnt/uEnv.txt
cp boot/boot.scr /mnt/boot.scr
echo "[Copying ubifs image...]"
cp ubi.img /mnt/ubi.img
sync
umount ${DRIVE}1

echo "[Done]"
