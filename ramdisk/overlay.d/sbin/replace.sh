#!/system/bin/sh

# Replace file conflicted with bind

echo "#empty" > /dev/fstab.enableswap

chmod 644 /dev/fstab.enableswap

mount --bind /dev/fstab.enableswap /vendor/etc/fstab.enableswap
if [ $? -eq 0 ]; then
  echo "[Genom] Replaced fstab.enableswap with empty file" > /proc/bootprof
else
  echo "[Genom] Failed replacing fstab.enableswap" > /proc/bootprof
fi
