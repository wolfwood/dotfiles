import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import qualified Data.Map as M

import XMonad.Layout.NoBorders

-- Xmobar
import System.IO
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)

--import XMonad.Prompt
--import XMonad.Prompt.Ssh
 
import XMonad.Hooks.UrgencyHook


workspaces = ["web", "irc", "build", "code", "c0de", "6", "tex", "tools", "admin"]

term :: String
term = "term"

--Use a colourscheme with dmenu
addColor = " -- -nb '#3F3F3F' -nf '#DCDCCC' -sb '#7F9F7F' -sf '#DCDCCC'"  

makeLauncher yargs run exec close = concat
  ["exe=`yeganesh ", yargs, "` && ", run, " ", exec, "$exe", close]
launcher     = makeLauncher (addColor++"") "eval" "\"exec " "\""
termLauncher = makeLauncher ("-p withterm"++addColor) ("exec "++term++" -e") "" ""

main = do
  xmproc <- spawnPipe "/usr/bin/xmobar /home/wolfwood/.xmobarrc"
  xmonad $ withUrgencyHook NoUrgencyHook
       $ defaultConfig
       { borderWidth = 1
       , keys = myKeys 
       , terminal = term
       , XMonad.workspaces = Main.workspaces
       -- Don't put borders on fullFloatWindows (OtherIndicated)
       , layoutHook = lessBorders (Screen)  $ (avoidStruts (layoutHook defaultConfig)) ||| Full 
       , logHook = dynamicLogWithPP xmobarPP
                   { ppOutput = hPutStrLn xmproc 
                   , ppCurrent = xmobarColor "#f0dfaf" "" . wrap "[" "]"
                   , ppUrgent =  xmobarColor "#dfaf8f" "" . wrap ">" "<" . xmobarStrip
                   , ppTitle = xmobarColor "#93e0e3" "" . shorten 50 
                   }
       , manageHook = manageDocks <+> myManageHooks
       }

myManageHooks = composeAll
    -- Allows focusing other monitors without killing the fullscreen
    [ isFullscreen --> (doF W.focusDown <+> doFullFloat)
    -- Single monitor setups, or if the previous hook doesn't work
    -- [ isFullscreen --> doFullFloat
    
    -- browser has to stay in its box
    , className =? "Firefox" --> doShift "web"
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
-- , ((modm .|. controlMask, xK_s), sshPrompt defaultXPConfig)
  ]
--}}}
