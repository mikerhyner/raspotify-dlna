# raspotify
Spotify-To-DLNA Gateway

The idea of this procect was, to have a small device (e.g. a rasspberry pi 4), that acts as a gateway for Spotify to DLNA cabable devices, which have not Spotify functionality built in.

As the OS, install Raspberry Pi OS (previously called Raspbian), to be found on https://www.raspberrypi.com/software/operating-systems/. Choose "Raspberry Pi OS with desktop" bcause we use PulseAudio.

This requires installation of several Debian packages. To install them, do as root:
  echo "deb [signed-by=/usr/share/keyrings/raspotify_key.asc] https://dtcooper.github.io/raspotify raspotify main" > /etc/apt/sources.list.d/raspotify.list
  apt install raspotify pulseaudio-dlna pulseaudio-utils

Also as root, put the two files librespot_launcher and librespot_terminator to /usr/local/bin/:
  cp librespot_launcher.sh rasspi:/usr/local/bin/
  cp librespot_terminator.sh /usr/local/bin/

Put the file pulseaudio-dlna.service to systemd directory:
 cp pulseaudio-dlna.service /usr/lib/systemd/system/pulseaudio-dlna.service 

Add this to /etc/rc.local (to avoid pulseaudio-dlna was started too early):
 cat << EOF >> /etc/rc.local
sleep 5
systemctl restart pulseaudio-dlna
exit 0
EOF

Now, change to user pi and copy the two .desktop files to users autostart directory:
 cp *.desktop ~/.config/autostart/

Add the following cronjob for user pi using cronjob -e:
 * * * * *       /usr/local/bin/librespot_terminator.sh; /usr/local/bin/librespot_launcher.sh

Finally reboot the Raspberry PI to start everything.
