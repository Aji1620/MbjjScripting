#!/bin/sh
#Created by AJI 2021????

tanggal=$1;
type=$2;

thn=`echo ${tanggal} | cut -c1-4`;
bln=`echo ${tanggal} | cut -c5-6`;
tgl=`echo ${tanggal} | cut -c7-8`;

clear
function_print()
{
echo "=================++++++ WELCOME +++++++================="
if [ $pilih -eq 1 ]; then
       echo "Cek File MBJJ Server BI"
elif [ $pilih -eq 2 ]; then
       echo "SCP File"
elif [ $pilih -eq 3]; then
       echo "EXIT"	
fi
echo "=================++ WKWKWK MUMET BAR DADI QC ++================="

}
echo "  ########################################";
echo "  ########### "Multi Run MBJJ" ###########";
echo "  ########################################";
echo "  ########################################";
echo "  # 1. Cek File MBJJ Server BI           #";
echo "  # 2. SCP File                          #";
echo "  # 3. Cek Record Duplikat               #";
echo "  # 5. Sorted And Split File             #"; 
echo "  # 4. EXIT                              #";
echo "  ########################################";
echo -n "  Please...enter your choice : "; read pilih

case $pilih in
    1)clear
     wc -l `find /u08/hnat_ocs/adhoc/L1/Aji/*txt -type f -newermt ${thn}-${bln}-${tgl}` | awk 'BEGIN{print "FILENAME|TOTAL RECORD"}; OFS="|" {split ($5,a,"/");print$2,$1}' | sed 's/[- ]*\([+|]\)/'$'\x01''\1/g' | column -ts $'\x01' | sed '/^[-+ ]*$/s/ /-/g'
     #wc -l `find /u08/hnat_ocs/adhoc/L1/Aji/*txt -type f -newermt ${thn}-${bln}-${tgl}` > raw_file.tx
     #echo "Jumlah File : `find /u08/hnat_ocs/adhoc/L1/Aji/*txt -type f -newermt ${thn}-${bln}-${tgl} -ls | wc -l
     echo " "
     echo "Jumlah File : `find /u08/hnat_ocs/adhoc/L1/Aji/*txt -type f -newermt ${thn}-${bln}-${tgl} -ls | wc -l`"
     	
      ;;
    2)clear
      bash scp_coba.sh ${tanggal}
      echo " "
      echo "Berikut List Filenya : "
      echo " "
      date=`date +"%Y-%m-%d"`
      wc -l `find /u08/hnat_ocs/adhoc/L1/Aji/*txt -type f -newermt ${date}` | awk 'BEGIN{print "FILENAME|TOTAL RECORD"}; OFS="|" {split ($5,a,"/");print$2,$1}' | sed 's/[- ]*\([+|]\)/'$'\x01''\1/g' | column -ts $'\x01' | sed '/^[-+ ]*$/s/ /-/g'
      echo " "
      echo "Jumlah File : `find /u08/hnat_ocs/adhoc/L1/Aji/*txt -type f -newermt ${date} -ls | wc -l`"
      ;;
    3)clear
      bash validasi_file_duplikat.sh ${tanggal} ${type}
      ;;
    4)clear
      bash sorted_split_file.sh
      echo "Selesai Proses";
      ;;
    5)exit
      ;;
esac
