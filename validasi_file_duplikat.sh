tanggal=$1
type=$2

thn=${tanggal:0:4}
bln=${tanggal:4:2}
tgl=${tanggal:6:2}
xtanggal="${thn}-${bln}-${tgl}"

if [ $type == "MSISDN" ]
then
	echo 'FILENAME|MSISDN DUPLIKAT|TOTAL MSISDN' >tes1.tmp
	for i in $(find /u08/hnat_ocs/adhoc/L1/Aji/*txt -type f -newermt $xtanggal)
	do
		echo -n "$(basename $i)|" >>tes1.tmp
		echo -n "$(cat $i |awk -F, '{print$1}' |sort |uniq -cd |wc -l)|" >>tes1.tmp
		echo "$(cat $i |wc -l)" >>tes1.tmp
	done
	cat tes1.tmp |sed 's/[- ]*\([+|]\)/'$'\x01''\1/g' |column -ts $'\x01' |sed '/^[-+ ]*$/s/ /-/g' ;rm tes1.tmp
elif [ $type == "PDID" ]
then
	echo 'FILENAME|PDID DUPLIKAT|TOTAL PDID' >tes2.tmp
	for i in $(find /u08/hnat_ocs/adhoc/L1/Aji/*txt -type f -newermt $xtanggal)
	do
		echo -n "$(basename $i)|" >>tes2.tmp
		echo -n "$(cat $i |awk -F, '{print$2}' |sort |uniq -cd |wc -l)|" >>tes2.tmp
		echo "$(cat $i |wc -l)" >>tes2.tmp
	done
	cat tes2.tmp |sed 's/[- ]*\([+|]\)/'$'\x01''\1/g' |column -ts $'\x01' |sed '/^[-+ ]*$/s/ /-/g' ;rm tes2.tmp
else
then
	echo "Maaf Anda Salah Input Parameter, Param YG digunakan MSISDN OR PDID"
fi
