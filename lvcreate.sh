#!/bin/sh
#set -x

export workfile="./work.txt"
export execfile="./exec_lvcreate.sh"
export vgname="VG00"
export todate=`date +%m%d-%H%M%S`
export rulesfile="./60-raw.rules"

### work file check 
if [ ! -f $workfile ]; then
	echo "$workfile File Not Found... "
	exit;
fi

lvcreate()
{
echo "lvcreate Start..."
cat $workfile |awk -v vgname=$vgname '{print "lvcreate -L "$3"M -n "$1" " vgname}'  > $execfile
chmod +x $execfile
echo "lvcreate Done..."
}

rawcreate()
{

rm -f $rulesfile
touch $fulesfile

echo "raw create Start..."
NUM=1
for lvname in $(cat $workfile|awk '{print $1}')
do
        echo "ACTION==\"add|change\",ENV{DM_VG_NAME}==\"$vgname\",ENV{DM_LV_NAME}==\"$lvname\",RUN+=\"/bin/raw /dev/raw/raw$NUM %N\"" >>  $rulesfile
        echo "ACTION==\"add|change\",KERNEL==\"raw$NUM\",SYMLINK+=\"$vgname/$lvname\"" >> $rulesfile
        NUM=`expr $NUM + 1`
done
echo "ACTION==\"add|change\",KERNEL==\"raw*\",OWNER==\"$vgname\",GROUP==\"dba\",MODE==\"0660\"" >> $rulesfile
echo "raw create Done..."
}


echo " 1) lvcreate workfile create"
echo " 2) lvcreate workfile execute"
echo " 3) raw device rules file create"
echo " q) Good Bye..."
while :
do
	read INPUT_STRING

case $INPUT_STRING in
	1)
		echo "lvcreate workfile create..."
		lvcreate
		ls -al $execfile
		;;

	2)
		echo "lvcreate workfile execute..."
		### work file check
		if [ ! -f $execfile ]; then
        		echo "$execfile File Not Found... "
        		continue;
		fi

		sh -x $execfile
		lvs
		;;
	3)
		echo "raw device rules file create..."
		rawcreate
		ls -al $rulesfile
		;;

	q)
		echo "Good Bye..."
		break
		;;

	*)
		echo "choice number...[1/2/3]"
		;;

esac
done





