# AnyKernel3 Ramdisk Mod Script
# osm0sis @ xda-developers

## AnyKernel setup
# begin properties
properties() { '
kernel.string=
do.devicecheck=1
do.modules=0
do.systemless=0
do.cleanup=1
do.cleanuponabort=0
device.name1=surya
device.name2=karna
device.name3=surya_in
device.name4=karna_in
device.name5=
supported.versions=
supported.patchlevels=
'; } # end properties

# shell variables
block=/dev/block/bootdevice/by-name/boot;
is_slot_device=0;
ramdisk_compression=none;

## AnyKernel methods (DO NOT CHANGE)
# import patching functions/variables - see for reference
. tools/ak3-core.sh;

## AnyKernel install
# dump_boot;
split_boot;

if [ -f $split_img/ramdisk.cpio ]; then
  unpack_ramdisk;
  repack_ramdisk;
fi;

flash_boot;
flash_dtbo;
# backup_file init.rc;

mount -o remount,rw /vendor
TARGET="/vendor/etc/init/hw/init.target.rc"
if grep '/dev/cpuset/top-app/uclamp.max' "${TARGET}" > /dev/null; then
    ui_print " " " - Skipping Uclamp tuning script..."
else
    if [[ -d "/data/adb/modules/uclamp_tuning" ]]; then
        ui_print " " " - Updating Uclamp tuning module..." " "
        rm -rf /data/adb/modules/uclamp_tuning
    else
        ui_print " " " - Installing Uclamp tuning module..." " "
    fi
    mkdir -p /data/adb/modules/uclamp_tuning
    cp -rf uclamp_tuning/ /data/adb/modules/
fi

## end install
