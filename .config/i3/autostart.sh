# killall if already
killall -9 picom xfce4-power-manager sxhkd fcitx5 

# Notifications
/usr/bin/dunst &

# Polkit
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &

# Wallpaper
nitrogen --restore &

# Dex
dex -a -s /etc/xdg/autostart/:~/.config/autostart/  &

# Network Applet
nm-applet --indicator &

# Cursor
xsetroot -cursor_name left_ptr &

# picom
while pgrep -u $UID -x picom >/dev/null; do sleep 1; done
picom --experimental-backends --config $HOME/.config/i3/picom.conf &

# powermanager
xfce4-power-manager &

# key
fcitx5 -d &

# start redshift
redshift -c ~/.config/redshift/redshift.conf &
