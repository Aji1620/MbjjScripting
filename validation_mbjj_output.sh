#!/usr/bin/env bash
. /data4/script_L1/linux_util_rifq.sh &>/dev/null
a="${$}"
FILENAME="${@}"

cd /data4/itops/upcc_script
if [ ! -t 0 ]; then
    FILENAME="$(cat)"
else
    if [ -z "${FILENAME}" ]; then
        echo -e 'Cannot continue. The given parameter is not complete'
        exit 1
    fi
fi

for i in ${FILENAME}; do
    cat <<EOF
--------------------------------------------------------------------------------------------------------------
FILENAME   : $(basename ${i})
START TIME : $(awk -F '|' 'NF >= "5" {print $1}' ${i} | sort -t ',' -k 4 | awk '{print $2}' | head -1)
END TIME   : $(awk -F '|' 'NF >= "5" {print $1}' ${i} | sort -t ',' -k 4 | awk '{print $2}' | tail -1)
RESULT     : $(awk -F '|' 'NF >= "5" {col[$2"|"$3"|"$4"|"$5]++} END {for (i in col) print i" = "col[i]}' ${i})
--------------------------------------------------------------------------------------------------------------
EOF
done
