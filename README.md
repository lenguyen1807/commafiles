### Bspwm

<img src="img/327898468_1400218020514239_4879097187421492755_n.jpg">

### Hyprland

<img src="img/1677083250.png">

### Set up hyprland

#### Dependencies
```
yay --needed -S polkit-kde-agent dunst grim rofi-lbonn-wayland-git rofi-emoji \
wl-clipboard wf-recorder hyprpicker-git hyprpaper-git \
xdg-desktop-portal-hyprland-git ffmpegthumbnailer tumbler  \
swaylock-effects qt5-wayland qt6-wayland ripgrep  \
thunar thunar-archive-plugin file-roller wtype colord \
waybar-hyprland-git
```

#### Fonts
```
yay --needed -S ttf-jetbrains-mono ttf-jetbrains-mono-nerd noto-fonts-emoji noto-fonts-cjk ttf-fira-code otf-san-francisco 
```

#### Drivers
https://github.com/lutris/docs/blob/master/InstallingDrivers.md#arch--manjaro--other-arch-linux-derivatives

https://github.com/lutris/docs/blob/master/WineDependencies.md#archantergosmanjaroother-arch-derivatives

```
sudo pacman -S gamemode lib32-gamemode
```

```
sudo pacman -S cmake make gcc gdb nodejs git r python python-pip llvm clang
```

#### Bluetooth
```
sudo pacman -S bluez-utils
modprobe btusb
systemctl start bluetooth.service
systemctl enable bluetooth.service
```

#### Keyboard
```
sudo pacman -S fcitx5-im fcitx5-unikey
```

edit environment:
```
GTK_IM_MODULE=fcitx
QT_IM_MODULE=fcitx
XMODIFIERS=@im=fcitx
SDL_IM_MODULE=fcitx
```

#### Wayland
```
sudo pacman -S qt5-wayland qt6-wayland
```

edit environment:
```
QT_QPA_PLATFORM="wayland;xcb"
SDL_VIDEODRIVER="wayland,x11"
```
https://wiki.archlinux.org/title/wayland#GUI_libraries

#### Texlive
```
sudo pacman -S texlive texlive-lang
```

#### Tools
```
yay -S visual-studio-code-bin github-desktop-bin rstudio-bin 
```

gnome specific:
```
yay -S extension-manager
sudo pacman -S power-profiles-daemon
```
