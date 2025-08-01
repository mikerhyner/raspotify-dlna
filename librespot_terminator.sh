#! /bin/bash
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

ps -efw | grep "librespot " | sed -e 's:.*--device \(.*\).*:\1:' | grep -v grep | while read running
do
  flag=0
  for device in $(pactl list sinks | grep "Name:" | cut -d ' ' -f 2)
  do
    if [ "$running" == "$device" ]
    then
      echo "not terminating process for present device $running"
      continue 2
    fi
  done
  echo "terminating process for disappeared device $running"
  kill -9 $(ps -efw | egrep librespot.*$running | grep -v grep | tr -s ' ' | cut -d ' ' -f 2)
done
