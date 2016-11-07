-----------------------------------------------------------------------------------------------------------

* To Make A Bootable sdcard (Boot from SD card):

  sudo su
  cd Prebuilt-android-JB-Chipsee/prebuilt-sd/
  ./mkmmc-android.sh /dev/sdX

  First switch SW1 to 'SD', then insert the TF card and power on the board by hold SW5 for about 2 seconds.

-----------------------------------------------------------------------------------------------------------

* To Make An sdcard For NAND Flashing (Boot from NAND):

  sudo su
  cd Prebuilt-android-JB-Chipsee/prebuilt-nand/
  ./mkmmc-android-nand.sh /dev/sdX

  First switch SW1 to 'SD', then insert the TF card and power on the board by hold SW5 for about 2 seconds.
  The bootscript on the TF card will erase the NAND partition and flashing the new system on it.
  First boot will take about 5 minutes until the desktop show up. 
  From next boot, remove the TF card and switch SW1 to 'NAND'.

  NOTICE: If the above flashing procedure is accidently interruptted, you may not be able to boot from
          either SD or NAND. On this condition, switch SW1 to 'SD', insert an SD card containing the
          bootloader, then use the U-Boot command 'nand erase.chip' to clean the entire NAND data. 
          After that you can normally do the above NAND flashing or just boot from SD card again.

-----------------------------------------------------------------------------------------------------------

* Calibrate the Compass Using Chipsee Compass Tool:

  First launch the Compass Tool apk.

  Head the board to North, keep it level and still, click "Calib North";
  Head the board to East, keep it level and still, click "Calib East";
  Face the board to West, keep it vertical and still, click "Calib West".

  After the above steps, the compass on board should work fine.

-----------------------------------------------------------------------------------------------------------

* NOTICE:

 1. Before running the NFS_Shift game(Only on the SD boot image), please use the Chipsee Sensor Tool
    application and set 'Invert X & Swap X/Y'.
 2. The Chipsee Touchscreen Calibration Tool only works for resistive touch screen.
 3. Wired network should be connected before system bootup, DHCP needed.
 4. Some USB cameras need to be conneted before system bootup.

-----------------------------------------------------------------------------------------------------------

* File List:

  ./README.txt                              		[This document]
  ./JB-Chipsee-SOM335x-Dev-Guide-2013-02-01.txt		[Developer guide]
  ./Prebuilt-android-JB-Chipsee/              		[Prebuilt image for SDCARD and NAND]
  ./Chipsee_APK/                            		[Chipsee Android Tools]
  ./Source/                                 		[Bootloader, Kernel and Filesystem source code]
  ./UBIFS/ubinize.cfg					[Configuration file for UBIFS image]

-----------------------------------------------------------------------------------------------------------

By Chipsee 2013.2.1
