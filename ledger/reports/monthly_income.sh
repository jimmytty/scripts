#!/bin/bash

set -o errexit
set -u nounset

first_month="$(ledger --total-data register | cut -c-7 | line)"
last_month="$(date +%Y-%m)"
cur_month="$first_month"

while [[ "$cur_month" != "$last_month" ]]; do
    months+=( "$cur_month" )
    cur_month=$(date -d"$cur_month-01 + 1 month" '+%Y-%m')
done

cat <<'EOF'
Monthly Income Report
=======================

Simple Report:
--------------
EOF

for month in "${months[@]}"; do
    ledger \
        --period="$month" \
        --depth=1 \
        balance '^income' |
    sed 's/^ \{7\}/'"$month"' =>/'
done

cat <<'EOF'

Detailed Report:
----------------
EOF
for month in "${months[@]}"; do
    while IFS=$'\n' read account; do
        ledger \
            --period="$month" \
            --flat \
            balance "${account}$" |
        sed 's/^ \{7\}/'"$month"' =>/;s/\s\+\(Income\)/\t\1/'
    done < <(ledger --depth 2 accounts '^income')
done |
sort -t$'\t' -k2,2 -k1,1
