# raspotify-dlna
Spotify-To-DLNA Gateway

## Introduction ##
The idea of this procect was, to have a small device (e.g. a rasspberry pi 4), that acts as a gateway for Spotify to DLNA caabble devices, which have not Spotify functionality built in.

## OS Installation ##
As the OS, install Raspberry Pi OS (previously called Raspbian), to be found on https://www.raspberrypi.com/software/operating-systems/. Choose "Raspberry Pi OS with desktop" bcause we use PulseAudio.

## Package Installation ##
This requires installation of several Debian packages. To install them, do as root:

```
echo "deb [signed-by=/usr/share/keyrings/raspotify_key.asc] https://dtcooper.github.io/raspotify raspotify main" > /etc/apt/sources.list.d/raspotify.list
apt install raspotify pulseaudio-dlna pulseaudio-utils
```

By default, pipewire-pulse is installed. But we want pulseaudio-module-gsettings, as we need this. To install this package, thus removing pipewire-pulse, and avoid pipewire-pulse to be installed later by mistale, e.g. with an update, run:
```
apt install pulseaudio-module-gsettings
apt-mark hold pipewire-pulse
```

## Configuration ##
Then copy the required files from this repository to Raspberry PI:
`scp *.desktop *.sh pi@rasspi`

Again as root, put the two files librespot_launcher and librespot_terminator to /usr/local/bin/:
```
cp ~pi/librespot_launcher.sh rasspi:/usr/local/bin/
cp ~pilibrespot_terminator.sh /usr/local/bin/
```

Put the file pulseaudio-dlna.service to systemd directory:
```
cp ~pi/pulseaudio-dlna.service /usr/lib/systemd/system/pulseaudio-dlna.service 
```

Add this to /etc/rc.local (to avoid pulseaudio-dlna was started too early):

```
cat << EOF >> /etc/rc.local
`
sleep 5
systemctl restart pulseaudio-dlna
exit 0
EOF
```

Now, change to user pi and copy the two .desktop files to users autostart directory:

```
cp *.desktop ~/.config/autostart/
```

Add the following cronjob for user pi using cronjob -e:
```
* * * * *       /usr/local/bin/librespot_terminator.sh; /usr/local/bin/librespot_launcher.sh
```
This is to scan the network every minute so new (recently turned on) devices will be seen.

Finally reboot the Raspberry PI to start everything.

## Usage ##
In the Spotify app, you should see some new devices beginning with "raspotify_{devicename}_dlna".

There are also some special, internal devices like "raspotify_alsa_output.platform-...", that one is the local audio output of your Raspberry Pi. The others are some default Pulseaudio sinks like raspotify_upnp, raspotify_rtp and raspotify_combined, which may be used from other applications, when streaming to them.

## Troubleshooting ##

If librespot suddenly stops playing songs, add the following to the local hosts file:
```
cat << EOF >> /etc/hosts
# spotify_player workaround, see https://github.com/librespot-org/librespot/issues/972#issuecomment-2320943137
0.0.0.0         apresolve.spotify.com
EOF
```
This overrides the apresolve mechanism, which sometimes direct to spotify access point not working with librespot.
