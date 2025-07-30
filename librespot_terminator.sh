#! /bin/bash
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

ps -efw | grep "librespot " | sed -e 's:.*--name \(.*\) --.*:\1:' | grep -v grep | while read running
do
  flag=0
  for device in $(pactl list sinks | grep "Name:" | cut -d ' ' -f 2)
  do
    name="raspotify_$device"
    if [ "$running" == "$name" ]
    then
      echo "not terminating process $running"
      continue 2
    fi
  done
  echo "terminating process $running"
  kill -9 $(ps -efw | grep $running | grep -v grep | tr -s ' ' | cut -d ' ' -f 2)
done
