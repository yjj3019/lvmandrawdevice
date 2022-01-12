#!/bin/sh
#set -x
####################################################################################
# work.txt example
# VGNAME/LVNAME/Size
# ex)
# vg01/lvol01/300
####################################################################################

# Check Plase...
export workfile="./work.txt"
export execfile="./exec_lvcreate.sh"
export todate=`date +%m%d-%H%M%S`
export rulesfile="./60-raw.rules"
export NUM=64  ### raw device start number
export owner="tibero" ### raw device ownership
export group="dba" ### raw device ownership

### work file check
if [ ! -f $workfile ]; then
        echo "$workfile File Not Found... "
        exit;
fi


chk()
{
cat $workfile | sed 's/ //g' | sed 's/  //g'|sed 's/\t//g' | sed '/^$/d' > /tmp/rawtmp.txt
cat /tmp/rawtmp.txt > $workfile
echo ""
echo ""

cat $workfile | while read line
do
        if [ "$line" != "" ]
        then
                echo "$line"
        else
                echo "blank line Found..."
                exit;
        fi
done
echo ""
echo ""

chkif=$(grep " " $workfile |wc -l)
if [ $chkif -ge 1 ]
then
        echo "Space Found..."
        grep " " $workfile
        exit;
fi

echo ""
echo ""

echo " Raw Data Converting and Check End... "

}

lvcreate()
{
echo "lvcreate Start..."
cat $workfile |awk -F\/ '{print "lvcreate -L "$3"M -n "$2" " $1}'  > $execfile
chmod +x $execfile
echo "lvcreate Done..."
}

rawcreate()
{

rm -f $rulesfile
touch $rulesfile

echo "raw create Start..."

while IFS='/' read -r -a array || [ -n "$array" ]
do
        echo "ACTION==\"add|change\",ENV{DM_VG_NAME}==\"${array[0]}\",ENV{DM_LV_NAME}==\"${array[1]}\",RUN+=\"/bin/raw /dev/raw/raw$NUM %N\"" >>  $rulesfile
        echo "ACTION==\"add|change\",KERNEL==\"raw$NUM\",SYMLINK+=\"${array[0]}/${array[1]}\"" >> $rulesfile
        ((NUM+=1))
done < $workfile

echo "ACTION==\"add|change\",KERNEL==\"raw*\",OWNER==\"$owner\",GROUP==\"$group\",MODE==\"0660\"" >> $rulesfile
echo "raw create Done..."
}


echo " 1) Raw Data Converting..."
echo " 2) lvcreate workfile create"
echo " 3) lvcreate workfile execute"
echo " 4) raw device rules file create"
echo " q) Good Bye..."
while :
do
        read INPUT_STRING

case $INPUT_STRING in
        1)
                echo " Raw Data Converting and Check... "
                chk

                ;;
        2)
                echo "lvcreate workfile create..."
                lvcreate
                ls -al $execfile
                ;;

        3)
                echo "lvcreate workfile execute..."
                ### work file check
                if [ ! -f $execfile ]; then
                        echo "$execfile File Not Found... "
                        continue;
                fi

                sh -x $execfile
                echo ""
                echo "LVM Info..."
                lvs
                ;;
        4)
                echo "raw device rules file create..."
                rawcreate
                ls -al $rulesfile
                ;;

        q)
                echo "Good Bye..."
                break
                ;;

        *)
                echo "choice number...[1/2/3//4/q]"
                ;;

esac
done
