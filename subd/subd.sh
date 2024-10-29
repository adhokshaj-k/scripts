#!/bin/bash

#need input
domain=$1
mkdir recon
cd recon
mkdir $domain-subdout

curl -s https://crt.sh/\?q\=\%.$domain\&output\=json | jq -r '.[].name_value' | sed 's/\*\.//g' | sort -u > $domain-subdout/$domain-crt.txt

sublist3r -d $domain -v -o $domain-subdout/$domain-sublister.txt

cat $domain-subdout/$domain-crt.txt | ~/go/bin/anew $domain-subdout/$domain-sublister.txt

cat $domain-subdout/$domain-sublister.txt | httpx -sc > $domain-subdout/$domain-httpx.txt

grep "200" $domain-subdout/$domain-httpx.txt > $domain-subdout/alive.txt 
grep "403" $domain-subdout/$domain-httpx.txt > $domain-subdout/forbidden.txt 
grep "302" $domain-subdout/$domain-httpx.txt > $domain-subdout/redirect.txt 



