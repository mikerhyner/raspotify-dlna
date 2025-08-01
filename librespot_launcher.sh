#! /bin/bash
export XDG_RUNTIME_DIR="/run/user/$(id -u)"

while ! pidof pulseaudio-dlna > /dev/null; do sleep 1; done
sleep 3
pactl list sinks | grep "Name:" | cut -d ' ' -f 2 | while read device
do
  for running in $(ps -efw | grep "librespot " | sed -e 's:.*--device \(.*\).*:\1:' | grep -v grep);
  do
    if [ "$device" == "$running" ]
    then
      echo "not starting process for $device"
      continue 2
    fi
  done
  name=$(pactl list sinks | grep -A1 "Name: $device" | tail -1 | cut -d " " -f 2-)
  echo "starting process $name"
  librespot --backend pulseaudio --name "$name" --device $device &
done
