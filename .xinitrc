xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Control_L"
xmodmap -e "add Control = Control_L"

xmodmap -e "keycode 49 = Escape asciitilde"
xmodmap -e "keycode 9 = grave asciitilde"

xkbset m
xkbset exp =m
xmodmap -e "keycode 135 = Pointer_Button2"

xrdb ~/.Xdefaults

start-pulseaudio-x11&
nice electricsheep -window-id 0x263&

xflux -z 95060

eval $(ssh-agent)

export GTK2_RC_FILES="$HOME/.gtkrc-2.0:/usr/share/themes/Zenburn/gtkrc-2.0/gtkrc"

xmonad
