#!/bin/bash
datex="${1}"
xtanggal="${datex:0:4}-${datex:4:2}-${datex:6:2}"
ytanggal="$(date -d "${tanggal} +1 days" '+%Y-%m-%d')"

if [ -z "${datex}" ]; then
    echo 'Cannot continue. The given parameter is not complete'
    exit 1
fi
cd /data4/itops/upcc_script
FILENAME="$(find -maxdepth '1' -type 'f' -name '*_upcc.txt' -newermt "${xtanggal}" ! -newermt "${ytanggal}" -exec ls -1 {} +)"

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
