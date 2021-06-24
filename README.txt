LVM with rawdevice create script

# cat work.txt 
lv01		/	504
lv02		/	505
lv03		/	506
lv04		/	507


# cat test.txt |awk hhhhh'{print "lvcreate -L "$3"M -n "$1" VG00"}'
lvcreate -L 504M -n lv01 VG00
lvcreate -L 504M -n lv02 VG00
lvcreate -L 504M -n lv03 VG00
lvcreate -L 504M -n lv04 VG00

# excute lvcreate.sh
1) lvcreate workfile create
2) lvcreate workfile execute
3) raw device rules file create
q) Good Bye...


# Comment
This script is lvcreate and rawdevice create ( raw, symlink )
