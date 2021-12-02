#!/usr/bin/env bash
datex="${1}"

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

for i in ${FILENAME}; do
    COUNTLINE="$(wc -l <${i})"
    xFILENAME="$(basename ${i} | awk -F'.' '{print $1}')"
    if [[ "${COUNTLINE}" -gt '1000000' && "${COUNTLINE}" -lt '1200000' ]]; then
        sort -t ',' -k 2,2 ${i} >${xFILENAME}_sorted.tmp
        split -n l/2 -d --additional-suffix=.txt ${xFILENAME}_sorted.tmp ${xFILENAME}_sorted_
        rm ${xFILENAME}_sorted.tmp
        echo "File ${i} sorted. Dan sudah di split."
    elif [ "${COUNTLINE}" -ge '699999' ]; then
        sort -t ',' -k 2,2 ${i} >${xFILENAME}_sorted.tmp
        split -l 500000 -d --additional-suffix=.txt ${xFILENAME}_sorted.tmp ${xFILENAME}_sorted_
        rm ${xFILENAME}_sorted.tmp
        echo "File $i sorted. Dan sudah di split."
    elif [ "${COUNTLINE}" -lt '699999' ]; then
        sort -t ',' -k 2,2 ${i} >${xFILENAME}_sorted.txt
        echo "File ${i} sorted. Tidak perlu di split."
    fi
done
