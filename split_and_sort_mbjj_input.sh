tanggal=$1

if [ -z $tanggal ]
then
	echo "Parameternya Harus Tanggal"
	exit 1
fi

thn=${tanggal:0:4}
bln=${tanggal:4:2}
tgl=${tanggal:6:2}
xtanggal="${thn}-${bln}-${tgl}"
ytanggal="$(date -d "$tanggal +1 days" +"%Y-%m-%d")"

cd /data4/itops/upcc_script
FILENAME="$(find *_upcc.txt -newermt $xtanggal ! -newermt $ytanggal)"

for i in $FILENAME
do
	COUNTLINE=$(wc -l <$i)
	xFILENAME="$(basename $i |awk -F. '{print$1}')"
	
	if [[ $COUNTLINE -gt 1000000 && $COUNTLINE -lt 1200000 ]]
	then
		sort -t ',' -k 2,2 -u $i >${xFILENAME}_sorted.tmp
		split -n l/2 -d --additional-suffix=.txt ${xFILENAME}_sorted.tmp ${xFILENAME}_sorted_
		rm ${xFILENAME}_sorted.tmp
		echo "File $i sorted. Dan sudah di split."
	elif [ $COUNTLINE -ge 699999 ]
	then
		sort -t ',' -k 2,2 -u $i >${xFILENAME}_sorted.tmp
		split -l 500000 -d --additional-suffix=.txt ${xFILENAME}_sorted.tmp ${xFILENAME}_sorted_
		rm ${xFILENAME}_sorted.tmp
		echo "File $i sorted. Dan sudah di split."
	elif [ $COUNTLINE -lt 699999 ]
	then
		sort -t ',' -k 2,2 -u $i >${xFILENAME}_sorted.txt
		echo "File $i sorted. Tidak perlu di split."
	fi
done
