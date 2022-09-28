#!/bin/bash
cred=$(cat credentials)
[ $? != 0 ] && echo error
data=$(cat uploadData)
[ $? != 0 ] && echo error

function abs(){
    x=$1
    [ "$x" -lt 0 ] && x=$(( x * -1 ))
    echo $x
}
IFS=$'\n'
for line in $data
do
    file=$(awk '{print $1}' <<< $line)
    id=$(awk '{print $2}' <<< $line)

    #echo downloading old file
    oldfile=".tmpoldfile"
    curl "http://ix.io/$id" 2>/dev/null > $oldfile

    #echo getting the difference of old and new
    diff=$(( $(cat $file | wc -c) -  $(cat $oldfile | wc -c) ))

    printf "$file $id - "
    diff $file $oldfile > /dev/null 2>&1 && echo "No changes" && echo && continue

    printf "%d bytes " "$(abs $diff)"
    [ $diff -ge 0 ] && echo "added"
    [ $diff -lt 0 ] && echo "removed"

    #echo uploading file to ix.io
    while true
    do
        cat $file | curl -F 'f:1=<-' -F "id:1=$id" $cred@ix.io > /dev/null 2>&1
        result=$?
        [ "$result" != "0" ] && echo error, trying again
        [ "$result" = "0" ] && break
    done
    echo

done
