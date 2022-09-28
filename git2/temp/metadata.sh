#!/bin/bash

function gettimestamp(){
    file=$1
    git log --format=%ci $file | head -n 1 | perl -pe 's/^(.*) .*/$1/' | perl -pe 's/[- :+]//g'
}
function gentimestamp(){
    [ -f ".gitmetadata" ] && rm .gitmetadata
    lastedit=0
    filetype="file"
    for file in $(ls);do
        if [ -f "$file" ];then
            time=$(gettimestamp $file)
            filetype="file"
        fi
        if [ -d "$file" ];then
            cd $file
            time=$(gentimestamp)
            filetype="folder"
            cd ..
        fi
        [ -z "$time" ] && time=0
        if [ "$time" -ge "$lastedit" ];then
            lastedit=$time
        fi
        echo $filetype $file $time >> .gitmetadata
    done
    echo $lastedit
}

git add .
git commit -m "-"

gentimestamp

git add .
git commit -m "-"
git push
