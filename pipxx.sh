#!bin/bash
list=$1
no=$2

i=0
while read line 
do
        arr[$i]="$line"
        i=$((i+1))
        # echo "${arr[@($i)]}"
done < $list

for b in "${arr[@]}"
do
   pipx install $b
   pipx ensurepath
done
