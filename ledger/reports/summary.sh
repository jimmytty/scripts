#!/bin/bash

set -o errexit
set -u nounset

hr=$(printf '=%.0s' {1..79})

echo '# [CASH]'
ledger --flat balance assets:cash

echo $hr
echo '# [EXPENSES]'
ledger \
    register '^expenses' \
    --flat \
    --period=$(date +%Y-%m) \
    --subtotal \
    --monthly \
    --period-sort='(amount)'

echo '----------'
formats=(
    '%/'
    '%(T) / 12 = %(display_total/12)\n'
)
format=$(printf '%s' "${formats[@]}")
ledger \
    balance '^expenses' \
    --empty \
    --flat \
    --period='this year' \
    --balance-format="$format"

echo $hr
echo '# [INCOME]'
ledger \
    register '^income' \
    --flat \
    --monthly \
    --period-sort='(amount)' \
    --period=$(date +%Y-%m) \
    --subtotal

echo '----------'
echo '# [yearly]'
formats=(
    '%/'
    '%P%(T) / 12 = %(display_total/12)\n'
)
format=$(printf '%s' "${formats[@]}")
ledger \
    balance '^income' \
    --empty \
    --flat \
    --period='this year' \
    --balance-format="$format"

echo $hr
# echo '# [BUDGET]'
# ledger \
#     balance '^expenses' \
#     --budget \
#     --effective \
#     --flat \
#     --period="$(date +%Y-%m)" \
#     --prepend-format="[$(date +%Y-%m)]"
