#clears screen so do first
#xflux -z 95060 > /dev/null < /dev/null
redshift&

xmodmap -e "remove Lock = Caps_Lock"
xmodmap -e "keysym Caps_Lock = Control_L"
xmodmap -e "add Control = Control_L"

xmodmap -e "keycode 49 = Escape asciitilde"
xmodmap -e "keycode 9 = grave asciitilde"

#xkbset m
#xkbset exp =m
#xmodmap -e "keycode 135 = Pointer_Button2"

#xcompmgr -a&

xrdb ~/.Xdefaults

start-pulseaudio-x11&
#nice electricsheep -window-id 0x26f&

eval $(ssh-agent)

export GTK2_RC_FILES="$HOME/.gtkrc-2.0:/usr/share/themes/Zenburn/gtkrc-2.0/gtkrc"

#xinput --set-prop 8 'Device Accel Velocity Scaling' 20
#xinput --set-prop 8 'Device Accel Adaptive Deceleration' 3
#xset mouse 6 6

#nvidia-settings -a '[gpu:0]/GPUPowerMizerMode=1'&
#nvidia-settings -a '[gpu:0]/GPUFanControlState=1' -a '[fan:0]/GPUCurrentFanSpeed=100'&

xmonad
