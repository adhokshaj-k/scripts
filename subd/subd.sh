#!/bin/bash

#need input
domain=$1


curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > $domain-crt.txt

sublist3r -d $domain -v -o $domain-sublister.txt

cat $domain-crt.txt | ~/go/bin/anew $domain-sublister.txt

cat $domain-sublister.txt | htppx -sc > httpx_domains.txt


