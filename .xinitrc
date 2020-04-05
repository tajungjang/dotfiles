simplebar.sh &
default.sh &
source ~.config/bspwm/bspwmrc
wal -R &
sxhkd &
exec dbus-launch --autolaunch=$(cat /var/lib/dbus/machine-id) bspwm
