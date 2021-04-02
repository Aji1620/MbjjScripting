tanggal=$1;

if [ -z $tanggal ]
then 
   tanggal=`date +Y%m%d`
fi

for i in `sshpass -p 'Tselbi#123' ssh automationrpt@10.54.3.28 find /abusers/tsel/g_ops/L1/req/aji/*txt -type f -newermt ${thn}-${bln}-${tgl}`
do
   sshpass -p 'Tselbi#123' scp automationrpt@10.54.3.28 'find $i -exec wc -c {} \;'
done

echo "SCP Complete"
echo "============"
