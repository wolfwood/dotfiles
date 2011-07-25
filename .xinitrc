xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Control_L"
xmodmap -e "add Control = Control_L"

xrdb ~/.Xdefaults

xsetbg ~/pics/backgrounds/Purple_flower.jpg

xmonad
