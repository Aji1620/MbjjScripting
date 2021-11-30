#!/bin/bash
tanggal="${1}"
if [ -z "${tanggal}" ]; then
    echo -e 'Cannot continue. The given parameter is not complete'
    exit 1
fi
thn="${tanggal:0:4}"
bln="${tanggal:4:2}"
tgl="${tanggal:6:2}"
xtanggal="${thn}-${bln}-${tgl}"
ytanggal="$(date -d "${tanggal} +1 days" '+%Y-%m-%d')"

listfile="$(ssh upcc_user@10.54.3.252 "find /data9/higt_bi/landing/pusdatin_mbjj_sptjm/upcc/input/*_upcc.txt -newermt '${xtanggal}' ! -newermt '${ytanggal}'")"
for i in ${listfile}; do
    scp "upcc_user@10.54.3.252:${i}" .
done
