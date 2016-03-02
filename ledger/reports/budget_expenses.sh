#!/bin/bash

set -o errexit
set -u nounset

current_month="$(date +%Y-%m)"

ledger \
    --no-total \
    --prepend-format="[$current_month]" \
    --budget \
    --flat \
    --effective \
    --period="$current_month" \
    balance '^expenses'
