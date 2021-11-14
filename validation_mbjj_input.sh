#!/bin/bash
a="${$}"
tanggal="${1}"
type="${2^^}"
. /data4/script_L1/linux_util_rifq.sh &>/dev/null
if [[ -z "${tanggal}" || -z "${type}" ]]
then
	echo "Parameter Kosong"
	echo "Silahkan input parameter tanggal dan tipe"
	exit 1
fi

xtanggal="${tanggal:0:4}-${tanggal:4:2}-${tanggal:6:2}"
ytanggal="$(date -d "${xtanggal} +1 days" '+%Y-%m-%d')"

cd /data4/itops/upcc_script
FILENAME="$(find -maxdepth '1' -type 'f' -name '*_upcc.txt' -newermt "${xtanggal}" ! -newermt "${ytanggal}" -exec ls -1 {} +)"

if [ "${type}" == "MSISDN" ]
then
	echo 'FILENAME|MSISDN DUPLIKAT|TOTAL MSISDN' >msisdn_validation_${a}.tmp
	for i in ${FILENAME}
	do
		echo -n "$(basename "${i}")|" >>msisdn_validation_${a}.tmp
		echo -n "$(awk -F, '{print$1}' "${i}" |sort |uniq -cd |wc -l |numfmt --g)|" >>msisdn_validation_${a}.tmp
		echo "$(wc -l <"${i}" |numfmt --g)" >>msisdn_validation_${a}.tmp
	done
	printTable '|' <msisdn_validation_${a}.tmp
	rm -f msisdn_validation_${a}.tmp
elif [ "${type}" == "PDID" ]
then
	echo 'FILENAME|PDID DUPLIKAT|TOTAL PDID' >pdid_validation_${a}.tmp
	for i in ${FILENAME}
	do
		echo -n "$(basename "${i}")|" >>pdid_validation_${a}.tmp
		echo -n "$(awk -F, '{print$2}' "${i}" |sort |uniq -cd |wc -l |numfmt --g)|" >>pdid_validation_${a}.tmp
		echo "$(wc -l <"${i}" |numfmt --g)" >>pdid_validation_${a}.tmp
	done
	printTable '|' <pdid_validation_${a}.tmp
	rm -f pdid_validation_${a}.tmp
else
	echo "Maaf Anda Salah Input Parameter, Param YG digunakan MSISDN OR PDID"
fi
