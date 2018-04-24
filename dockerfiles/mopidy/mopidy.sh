#!/bin/bash

cp /root/.config/mopidy/mopidy.conf.default /root/.config/mopidy/mopidy.conf

args=( )
for i in "$@" ; do
    if [[ $i == "--snapcast" ]] ; then
        echo "" >> /root/.config/mopidy/mopidy.conf
        echo "[audio]" >> /root/.config/mopidy/mopidy.conf
        echo "output = audioresample ! audioconvert ! audio/x-raw,rate=48000,channels=2,format=S16LE ! wavenc ! filesink location=/tmp/snapfifo" >> /root/.config/mopidy/mopidy.conf
    else
        args += $i
    fi
done

exec mopidy ${args[@]}
