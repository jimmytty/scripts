#!/bin/bash

title="$1"

declare -a titles
declare -A rtitle

rtitle['Balance - Assets:Cash']="ledger balance assets:cash"
rtitle['Register - Amount Expenses']="~/bin/ledger/reports/register_amount_expenses.sh"
rtitle['Balance - Savings']="ledger --begin 'last month' balance savings"
rtitle['Budget - Expenses']="~/bin/ledger/reports/budget_expenses.sh"
rtitle['Monthly - Expenses']="~/bin/ledger/reports/monthly_expenses.sh"
rtitle['Monthly - Income']="~/bin/ledger/reports/monthly_income.sh"

if [[ -z "$title" ]]; then
    titles=( "${!rtitle[@]}" )
elif [[ -z "${rtitle[$title]}" ]]; then
    echo 'Invalid "title".'
    echo 'Valid "title" are one of:'
    for title in "${!rtitle[@]}"; do
        echo "$title"
    done
    exit 1
else
    titles=( "$title" )
fi

source $HOME/profile &>/dev/null

for rtitle in "${titles[@]}"; do
    cmd="${rtitle[$rtitle]}"
    eval "$cmd" |
    /usr/bin/mailx \
        -s '[LEDGER] '"$rtitle" \
        -r $(basename $0)'@textmode.org' \
        'jimmy@textmode.org'
done
