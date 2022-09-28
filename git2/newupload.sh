#!/bin/bash
#Use : ./newupload.sh "nameoffile"
cred=$(cat credentials)
[ $? != 0 ] && echo error
file=$1
cat $file | curl -F 'f:1=<-' $cred@ix.io
[ $? != 0 ] && echo error
