tanggal=$1

thn=`echo ${tanggal} | cut -c1-4`
bln=`echo ${tanggal} | cut -c5-6`
tgl=`echo ${tanggal} | cut -c7-8`

FILENAME="`find *.txt -type f -newermt ${thn}-${bln}-${tgl}`"

for j in $FILENAME
do
        FILESIZE=`wc -l $j |awk '{print$1}'`

        if [ $FILESIZE -ge 20 ]
        then
                xFILENAME="`echo $j |awk -F. '{print$1}'`"
                sort -t ',' -k 2,2 -u $j > ${xFILENAME}_sorted.txt
                split -l 10 -d --additional-suffix=.txt ${xFILENAME}_sorted.txt ${xFILENAME}_sorted_
                echo "File ${xFILENAME}.txt Sudah selesai di split"
        elif [ $FILESIZE -lt 20 ]
		then
                xFILENAME="`echo $j |awk -F. '{print$1}'`"
                sort -t ',' -k 2,2 -u $j > ${xFILENAME}_sorted.txt
                echo "File ${xFILENAME}.txt Tidak perlu di split"
        fi
done
