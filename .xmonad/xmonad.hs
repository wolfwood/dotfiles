import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import XMonad.Layout.NoBorders
 
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
       , layoutHook = smartBorders $ layoutHook defaultConfig -- Don't put borders on fullFloatWindows
       , manageHook =  myManageHooks
       }

myManageHooks = composeAll
    -- Allows focusing other monitors without killing the fullscreen
    [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
    -- Single monitor setups, or if the previous hook doesn't work
    -- [ isFullscreen --> doFullFloat
    -- skipped
    ]

-- Union default and new key bindings
myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

--{{{ Keybindings 
--    Add new and/or redefine key bindings
newKeys conf@(XConfig {XMonad.modMask = modm}) = [
 ((modm, xK_p), spawn launcher ),
 ((modm .|. shiftMask  , xK_p), spawn termLauncher),
 ((modm, xK_F9), spawn "amixer -c 0 set Master 2dB-"),
 ((modm, xK_F12), spawn "amixer -c 0 set Master 2dB+"),
 ((modm, xK_F11), spawn "amixer -c 0 set Master toggle")
  ]
--}}}