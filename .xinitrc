#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

if [ -f "/usr/bin/dpass" ] ; then
	export SUDO_ASKPASS="/usr/bin/dpass"
fi

xmodmap -e "remove mod4 = Super_L"
xmodmap -e "add mod1 = Super_L"

~/.statusbar.sh
xrdb -merge ~/.Xresources
xscreensaver -no-splash &
xset +fp ~/.fonts
xset +fp /usr/share/fonts/local &
fc-cache -fv
xset fp rehash &

# PC dependant
# xinput set-prop "SynPS/2 Synaptics TouchPad" "libinput Tapping Enabled" 1

sh ~/.fehbg &

exec /usr/local/bin/dwm

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice
