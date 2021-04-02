tanggal=$1
thn=${tanggal:0:4}
bln=${tanggal:4:2}
tgl=${tanggal:6:2}
xtanggal="${thn}-${bln}-${tgl}"

FILENAME="$(sshpass -p 'Tselbi#123' ssh automationrpt@10.54.3.28 find /abusers/tsel/g_ops/L1/req/aji/*txt -type f -newermt $xtanggal)"

for i in $FILENAME
do
	sshpass -p 'Tselbi#123' ssh automationrpt@10.54.3.28 'find $i -exec wc -c {} \;'
done

echo "SCP Complete"
echo "============"
