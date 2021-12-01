#!/usr/bin/env bash
. /data4/script_L1/linux_util_rifq.sh &>/dev/null
a="${$}"
tanggal="${1}"

cd /data4/itops/upcc_script
if [ ! -t 0 ]; then
    FILENAME="$(cat)"
else
    if [ -z "${tanggal}" ]; then
        echo -e 'Cannot continue. The given parameter is not complete'
        exit 1
    elif [ -n "${tanggal}" ]; then
        truedate="$(date -d "${tanggal}" '+%Y%m%d' 2>/dev/null)"
        if [ "${truedate}" != "${tanggal}" ]; then
            echo -e 'Format tanggal tidak sesuai, mohon dicek kembali'
            exit 1
        else
            xtanggal="${tanggal:0:4}-${tanggal:4:2}-${tanggal:6:2}"
            ytanggal="$(date -d "${xtanggal} +1 days" '+%Y-%m-%d' 2>/dev/null)"
            FILENAME="$(find -maxdepth '1' -type 'f' -name '*_upcc.txt' -newermt "${xtanggal}" ! -newermt "${ytanggal}" -exec ls -1 {} +)"
        fi
    fi
fi

{
    echo 'FILENAME|MSISDN DUPLIKAT|UNIQ MSISDN|PDID DUPLIKAT|UNIQ PDID|TOTAL RECORD'
    for i in ${FILENAME}; do
        echo -n "$(basename ${i})|"
        echo -n "$(awk -F ',' '{print $1}' ${i} | sort | uniq -cd | wc -l | numfmt --g)|"
        echo -n "$(awk -F ',' '!x[$1]++ {print $1}' ${i} | wc -l | numfmt --g)|"
        echo -n "$(awk -F ',' '{print $2}' ${i} | sort | uniq -cd | wc -l | numfmt --g)|"
        echo -n "$(awk -F ',' '!x[$2]++ {print $2}' ${i} | wc -l | numfmt --g)|"
        echo "$(wc -l <${i} | numfmt --g)"
    done
} | printTable '|'
