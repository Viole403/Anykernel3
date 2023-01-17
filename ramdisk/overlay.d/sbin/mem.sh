#!/system/bin/sh

# swapfile
file=/data/swapfile
if [ -f "$file" ]; then
    rm $file
fi

# zram writeback
resetprop ro.zram.mark_idle_delay_mins 60
resetprop ro.zram.first_wb_delay_mins 180
resetprop ro.zram.periodic_wb_delay_hours 24

echo 130 > /proc/sys/vm/swappiness
