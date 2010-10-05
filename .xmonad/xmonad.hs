import XMonad
import XMonad.Actions.SpawnOn

import qualified Data.Map as M

--Use a colourscheme with dmenu
addColor = " -- -nb '#3F3F3F' -nf '#DCDCCC' -sb '#7F9F7F' -sf '#DCDCCC'"  

makeLauncher yargs run exec close = concat
  ["exe=`yeganesh ", yargs, "` && ", run, " ", exec, "$exe", close]
launcher     = makeLauncher (addColor++"") "eval" "\"exec " "\""
termLauncher = makeLauncher ("-p withterm"++addColor) "exec xterm -e" "" ""

main = xmonad $ defaultConfig
       { borderWidth = 1
       , keys = myKeys 
       }

-- Union default and new key bindings
myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

--{{{ Keybindings 
--    Add new and/or redefine key bindings
newKeys conf@(XConfig {XMonad.modMask = modm}) = [
 ((modm, xK_p), spawn launcher ),
 ((modm .|. shiftMask  , xK_p), spawn termLauncher),
 ((modm, xK_F9), spawn "amixer set Master 2dB-"),
 ((modm, xK_F12), spawn "amixer set Master 2dB+"),
 ((modm, xK_F11), spawn "amixer set Master toggle")
  ]
--}}}