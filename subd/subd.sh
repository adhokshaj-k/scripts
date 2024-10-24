#!/bin/bash

#need input
domain=$1
cd recon
mkdir $domain

curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > $domain/$domain-crt.txt

sublist3r -d $domain -v -o $domain/$domain-sublister.txt

cat $domain/$domain-crt.txt | ~/go/bin/anew $domain/$domain-sublister.txt

cat $domain/$domain-sublister.txt | httpx -sc > $domain/$domain-httpx.txt


