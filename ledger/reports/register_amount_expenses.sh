#!/bin/bash

set -o errexit
set -u nounset

current_month=$(date +%Y-%m)

ledger \
    --begin="$current_month" \
    --subtotal \
    --monthly \
    --period-sort='(amount)' \
    register '^expenses'
