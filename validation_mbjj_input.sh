tanggal=$1
type=$2

if [[ -z $tanggal || -z $type ]]
then
	echo "Parameter Kosong"
	echo "Silahkan input parameter tanggal dan tipe"
	exit 1
fi

thn=${tanggal:0:4}
bln=${tanggal:4:2}
tgl=${tanggal:6:2}
xtanggal="${thn}-${bln}-${tgl}"
ytanggal="$(date -d "$tanggal +1 days" +"%Y-%m-%d")"

cd /data4/itops/upcc_script
FILENAME="$(find *_upcc.txt -newermt $xtanggal ! -newermt $ytanggal)"

if [ $type == "MSISDN" ]
then
	echo 'FILENAME|MSISDN DUPLIKAT|TOTAL MSISDN' >msisdn_validation.tmp
	for i in $FILENAME
	do
		echo -n "$(basename $i)|" >>msisdn_validation.tmp
		echo -n "$(cat $i |awk -F, '{print$1}' |sort |uniq -cd |wc -l)|" >>msisdn_validation.tmp
		echo "$(cat $i |wc -l)" >>msisdn_validation.tmp
	done
	cat msisdn_validation.tmp |sed 's/[- ]*\([+|]\)/'$'\x01''\1/g' |column -ts $'\x01' |sed '/^[-+ ]*$/s/ /-/g' ;rm msisdn_validation.tmp
elif [ $type == "PDID" ]
then
	echo 'FILENAME|PDID DUPLIKAT|TOTAL PDID' >pdid_validation.tmp
	for i in $FILENAME
	do
		echo -n "$(basename $i)|" >>pdid_validation.tmp
		echo -n "$(cat $i |awk -F, '{print$2}' |sort |uniq -cd |wc -l)|" >>pdid_validation.tmp
		echo "$(cat $i |wc -l)" >>pdid_validation.tmp
	done
	cat pdid_validation.tmp |sed 's/[- ]*\([+|]\)/'$'\x01''\1/g' |column -ts $'\x01' |sed '/^[-+ ]*$/s/ /-/g' ;rm pdid_validation.tmp
else
	echo "Maaf Anda Salah Input Parameter, Param YG digunakan MSISDN OR PDID"
fi

