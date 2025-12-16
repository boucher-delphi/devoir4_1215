#!/bin/bash

: > notesMinFinaux.txt
a=$( cat $1)

OLDIFS=$IFS
IFS=$'\n'
for i in $a
do
    IFS=' '
    set -- $i
    total=$(echo "scale=2; $2+$3" | bc )
    moy=$(echo "scale=2; $total*($4/100)" | bc )
    cont=$(echo "scale=2; $2*($5/100)" | bc )
    reste=$(echo "scale=2; $moy-$cont" | bc )
    final=$(echo "scale=2; ($reste/$3)*100" | bc)
    let final=${final%.*}
    echo $1 $final >> notesMinFinaux.txt
done
IFS=$OLDIFS