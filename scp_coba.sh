tanggal=$1;

thn=`echo ${tanggal} | cut -c1-4`;
bln=`echo ${tanggal} | cut -c5-6`;
tgl=`echo ${tanggal} | cut -c7-8`;

for i in `sshpass -p 'Tselbi#123' ssh automationrpt@10.54.3.28 find /abusers/tsel/g_ops/L1/req/aji/*txt -type f -newermt ${thn}-${bln}-${tgl}`
do
   sshpass -p 'Tselbi#123' ssh automationrpt@10.54.3.28 'find $i -exec wc -c {} \;'
done

echo "SCP Complete"
echo "============"
