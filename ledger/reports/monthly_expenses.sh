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
Monthly Expenses Report
=======================

Simple Report:
--------------
EOF
for month in "${months[@]}"; do
    ledger                  \
        --period="$month"   \
        --depth=1           \
        balance '^expenses' |
    sed 's/^ \{7\}/'"$month"' =>/'
done

cat <<'EOF'

Detailed Report:
----------------
EOF
# for month in "${months[@]}"; do
#     while IFS=$'\n' read account; do
#         ledger                    \
#             --period="$month"     \
#             --flat                \
#             --depth=2             \
#             balance "^${account}"  |
#         sed 's/^ \{7\}/'"$month"' =>/;s/\s\+\(Expenses\)/\t\1/'
#     done < <(ledger --depth 2 accounts '^expenses')
# done |
# sort -t$'\t' -k2,2 -k1,1

for month in "${months[@]}"; do
    ledger                   \
        --period="$month"    \
        --no-total           \
        --flat               \
        --depth=2            \
        balance "^expenses" |
    sed 's/^ \{7\}/'"$month"' =>/;s/\s\+\(Expenses\)/\t\1/'
done |
sort -t$'\t' -k2,2 -k1,1
