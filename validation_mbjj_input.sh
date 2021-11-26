#!/bin/bash
a="${$}"
tanggal="${1}"
type="${2^^}"
. /data4/script_L1/linux_util_rifq.sh &>/dev/null
if [ "${#}" -lt '2' ]; then
    echo -e "Cannot continue. The given parameter is not complete"
    exit 1
fi

xtanggal="${tanggal:0:4}-${tanggal:4:2}-${tanggal:6:2}"
ytanggal="$(date -d "${xtanggal} +1 days" '+%Y-%m-%d')"

cd /data4/itops/upcc_script
FILENAME="$(find -maxdepth '1' -type 'f' -name '*_upcc.txt' -newermt "${xtanggal}" ! -newermt "${ytanggal}" -exec ls -1 {} +)"

case "${type}" in
"MSISDN")
    {
        echo 'FILENAME|MSISDN DUPLIKAT|TOTAL MSISDN'
        for i in ${FILENAME}; do
            echo -n "$(basename ${i})|"
            echo -n "$(awk -F, '{print $1}' ${i} | sort | uniq -cd | wc -l | numfmt --g)|"
            echo "$(wc -l <${i} | numfmt --g)"
        done
    } | printTable '|'
    ;;
"PDID")
    {
        echo 'FILENAME|PDID DUPLIKAT|TOTAL PDID'
        for i in ${FILENAME}; do
            echo -n "$(basename ${i})|"
            echo -n "$(awk -F, '{print$2}' ${i} | sort | uniq -cd | wc -l | numfmt --g)|"
            echo "$(wc -l <${i} | numfmt --g)"
        done
    } | printTable '|'
    ;;
*)
    echo -e "Invalid Type"
    echo -e "Type entered: ${type}"
    echo -e "Valid Type:"
    echo -e "1. MSISDN"
    echo -e "2. PDID"
    exit 1
    ;;
esac
