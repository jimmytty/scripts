#!/bin/bash

/usr/bin/find ~/.mailbox/ \
    -type f \
    -not \( \
        -name '*.archive' -o \
        -name '*.lock' -o \
        -regex '.*/\(inbox\|duplicates\|postponed\|spam\|social-engineer.org\)' \
    \) \
    -printf '%f\n' |
while read m; do
    mailx -R -H -f +$m |
    grep -H --label=$m -e '^N '
done |
sed -r 's/^\s+//;s/\bRe:\s//g;s/\s+/ /g' |
sort |
uniq -c |
sed -r 's/^\s+//;s/\s/\t/;s/:/:\t/' |
sort -t$'\t' -k2,2 -k1,1nr |
column -s$'\t' -t |
less
