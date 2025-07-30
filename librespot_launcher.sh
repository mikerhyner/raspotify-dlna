#! /bin/bash
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

while ! pidof pulseaudio-dlna > /dev/null; do sleep 1; done
sleep 3
pactl list sinks | grep "Name:" | cut -d ' ' -f 2 | while read device
do
  name="raspotify_$device"
  for running in $(ps -efw | grep "librespot " | sed -e 's:.*--name \(.*\) --.*:\1:' | grep -v grep);
  do
    if [ "$name" == "$running" ]
    then
      echo "not starting process $name"
      continue 2
    fi
  done
  echo "starting process $name"
  librespot --backend pulseaudio --name $name --device $device &
done
