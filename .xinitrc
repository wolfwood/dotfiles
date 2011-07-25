xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Control_L"
xmodmap -e "add Control = Control_L"

xrdb ~/.Xdefaults

start-pulseaudio-x11&
nice electricsheep -window-id 0x15a&

xmonad
