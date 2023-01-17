#!/system/bin/sh
# by arter97 <Park Ju Hyung <qkrwngud825@gmail.com>

# patch fstab
if ! grep -v '#' /vendor/etc/fstab.mt6768 | grep -q f2fs; then
  # ECD18g== is the f2fs magic code under little-endian
  if [[ $(dd if=/dev/block/platform/bootdevice/by-name/userdata bs=4 skip=256 count=1 2>/dev/null | base64) == "ECD18g==" ]]; then
    echo "[Genom] data is using F2FS, patching fstab" > /proc/bootprof
    # fstab is missing entry for f2fs, add one
    sed -e "s@/dev/block/platform/bootdevice/by-name/userdata.*@$(cat /vendor/etc/fstab.mt6768 | grep ext4 | grep /data | grep -v '#' | while read a b c d e; do echo $a $b f2fs noatime,nosuid,nodev,discard,reserve_root=32768,resgid=1065,fsync_mode=nobarrier,inlinecrypt latemount,wait,check,quota,formattable,reservedsize=128m,checkpoint=fs,fileencryption=aes-256-xts:aes-256-cts:v1; done)@g" /vendor/etc/fstab.mt6768 | uniq > /dev/fstab.mt6768
    sed -i "/zram0/d" /dev/fstab.mt6768 && echo "[Genom] Removed zram setup from fstab.mt6768" > /proc/bootprof
    chmod 644 /dev/fstab.mt6768
    mount --bind /dev/fstab.mt6768 /vendor/etc/fstab.mt6768
    chcon u:object_r:vendor_configs_file:s0 /vendor/etc/fstab.mt6768
    cat /dev/fstab.mt6768 | while read a; do echo $a; done
    if [ $? -eq 0 ]; then
      echo "[Genom] Patched /vendor/etc/fstab.mt6768 for f2fs" > /proc/bootprof
    else
      echo "[Genom] Patching fstab failed" > /proc/bootprof
    fi
  else
    echo "[Genom] data is using EXT4, patching skipped" > /proc/bootprof
    cp /vendor/etc/fstab.mt6768 /dev/fstab.mt6768
    sed -i "/zram0/d" /dev/fstab.mt6768 && echo "[Genom] Removed zram setup from fstab.mt6768" > /proc/bootprof
    chmod 644 /dev/fstab.mt6768
    mount --bind /dev/fstab.mt6768 /vendor/etc/fstab.mt6768
    chcon u:object_r:vendor_configs_file:s0 /vendor/etc/fstab.mt6768
  fi
fi
