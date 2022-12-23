# kill if already running
killall -9 picom xfce4-power-manager dunst

# launch xfce4
xfce4-power-manager &

# launch picom
while pgrep -u $UID -x picom >/dev/null; do sleep 1; done
picom --experimental-backends --config $HOME/.config/i3/picom.conf &

# launch dunst
dunst -config $HOME/.config/dunst/dunstrc &

# launch polybar
sh $HOME/.config/polybar/launch.sh &

# launch nitrogen
nitrogen --restore &

# launch fcitx5
fcitx5 -d &

# launch geoclue
/usr/lib/geoclue-2.0/demos/agent &
