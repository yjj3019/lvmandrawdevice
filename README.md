# lvmandrawdevice

엑셀에서 아래와 같은 포멧으로 데이터를 만듬.
해당 내용을 복사하여 아래의 work.txt 파일에 붙여넣기 

file work.txt ( 예제 ) 
vg00 / lvol01 / 300
vg00 / lvol02 / 300
vg01 / lvol03 / 300
vg00 / lvol05 / 300
vg00 / lvol05 / 300
vg05 / lvol06 / 300

해당 파일에는 공백과 빈줄이 존재할 수 있음.  ( 해당 내용 스크립트에서 조치 )

# cat work.txt
vg00    /       lvol01  /       300
vg00    /       lvol02  /       300
vg01    /       lvol03  /       300
vg00    /       lvol05  /       300
vg00    /       lvol05  /       300
vg05    /       lvol06  /       300
 
# 엑셀에서 붙여 넣기한 실 데이타
 
# chmod +x raw_create.sh
# 실행 권한 설정
 
file : raw_create.sh
# Check Plase...
export workfile="./work.txt"
export execfile="./exec_lvcreate.sh"
export todate=`date +%m%d-%H%M%S`
export rulesfile="./60-raw.rules"
export NUM=64  ### raw device start number
export owner="tibero" ### raw device ownership
export group="dba" ### raw device ownership
# 파일 상단의 위 내용은 환경에 맞게 수정 필요.
 
 
 
# ./raw_create.sh
 1) Raw Data Converting...
 2) lvcreate workfile create
 3) lvcreate workfile execute
 4) raw device rules file create
 q) Good Bye...
1   
# 1번 work.txt 파일 가공 및 검증 시작
 
 Raw Data Converting and Check...
 
 
vg00/lvol01/300
vg00/lvol02/300
vg01/lvol03/300
vg00/lvol05/300
vg00/lvol05/300
vg05/lvol06/300
 
 
 
 
 Raw Data Converting and Check End...
# 1번 work.txt 파일 가공 및 검증 완료
 
 
2
lvcreate workfile create...
lvcreate Start...
lvcreate Done...
-rwxr-xr-x 1 root root 192 Jan 12 04:45 ./exec_lvcreate.sh
# lv 생성 스크립트 작성 완료
 
 
3
lvcreate workfile execute...
+ lvcreate -L 300M -n lvol01 vg00
+ lvcreate -L 300M -n lvol02 vg00
+ lvcreate -L 300M -n lvol03 vg01
+ lvcreate -L 300M -n lvol05 vg00
+ lvcreate -L 300M -n lvol05 vg00
+ lvcreate -L 300M -n lvol06 vg05
 
LVM Info...
  LV   VG   Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  root rhel -wi-ao---- 17.47g
  swap rhel -wi-ao----  2.00g
 
# 2번에서 생성된 스크립트를 실행함. ( 필요한 경우 수동 실행 )
 
 
4
raw device rules file create...
raw create Start...
raw create Done...
-rw-r--r-- 1 root root 1068 Jan 12 04:46 ./60-raw.rules
# 60-raw.rules 룰 파일 생성 ( Symlink 구문을 포함 )
 
 
q
Good Bye...
# 종료
 
 
# ls -al 60-raw.rules exec_lvcreate.sh
-rw-r--r-- 1 root root 1068 Jan 12 04:46 60-raw.rules
-rwxr-xr-x 1 root root  192 Jan 12 04:45 exec_lvcreate.sh
# 2개의 결과 파일 생성 확인
 
 
# cat exec_lvcreate.sh
lvcreate -L 300M -n lvol01 vg00
lvcreate -L 300M -n lvol02 vg00
lvcreate -L 300M -n lvol03 vg01
lvcreate -L 300M -n lvol05 vg00
lvcreate -L 300M -n lvol05 vg00
lvcreate -L 300M -n lvol06 vg05
 
# cat 60-raw.rules
ACTION=="add|change",ENV{DM_VG_NAME}=="vg00",ENV{DM_LV_NAME}=="lvol01",RUN+="/bin/raw /dev/raw/raw64 %N"
ACTION=="add|change",KERNEL=="raw64",SYMLINK+="vg00/lvol01"
ACTION=="add|change",ENV{DM_VG_NAME}=="vg00",ENV{DM_LV_NAME}=="lvol02",RUN+="/bin/raw /dev/raw/raw65 %N"
ACTION=="add|change",KERNEL=="raw65",SYMLINK+="vg00/lvol02"
ACTION=="add|change",ENV{DM_VG_NAME}=="vg01",ENV{DM_LV_NAME}=="lvol03",RUN+="/bin/raw /dev/raw/raw66 %N"
ACTION=="add|change",KERNEL=="raw66",SYMLINK+="vg01/lvol03"
ACTION=="add|change",ENV{DM_VG_NAME}=="vg00",ENV{DM_LV_NAME}=="lvol05",RUN+="/bin/raw /dev/raw/raw67 %N"
ACTION=="add|change",KERNEL=="raw67",SYMLINK+="vg00/lvol05"
ACTION=="add|change",ENV{DM_VG_NAME}=="vg00",ENV{DM_LV_NAME}=="lvol05",RUN+="/bin/raw /dev/raw/raw68 %N"
ACTION=="add|change",KERNEL=="raw68",SYMLINK+="vg00/lvol05"
ACTION=="add|change",ENV{DM_VG_NAME}=="vg05",ENV{DM_LV_NAME}=="lvol06",RUN+="/bin/raw /dev/raw/raw69 %N"
ACTION=="add|change",KERNEL=="raw69",SYMLINK+="vg05/lvol06"
ACTION=="add|change",KERNEL=="raw*",OWNER=="tibero",GROUP=="dba",MODE=="0660"
