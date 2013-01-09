import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import qualified Data.Map as M

import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spiral
import XMonad.Util.Themes

-- Xmobar
import System.IO
import XMonad.Hooks.DynamicLog
import XMonad.Util.WorkspaceCompare
import XMonad.Hooks.ManageDocks
import XMonad.Util.Run(spawnPipe)

--import XMonad.Prompt
--import XMonad.Prompt.Ssh

-- figuring out when ppl talk in irc
import XMonad.Hooks.UrgencyHook

-- volume display
import XMonad.Actions.Volume
import XMonad.Util.Dzen


workspaces = ["web", "irc", "build", "code", "c0de", "misc", "tex", "tools", "admin"]

term :: String
term = "term" -- this is a script that launches urxvt in client-daemon mode

--Use a colourscheme with dmenu
addColor = " -- -nb '#3F3F3F' -nf '#DCDCCC' -sb '#7F9F7F' -sf '#DCDCCC'"

makeLauncher yargs run exec close = concat
  ["exe=`yeganesh ", yargs, "` && ", run, " ", exec, "$exe", close]
launcher     = makeLauncher (addColor++"") "eval" "\"exec " "\""
termLauncher = makeLauncher ("-p withterm"++addColor) ("exec "++term++" -e") "" ""

myTheme = defaultTheme { fontName = "xft:inconsolata:bold:pixelsize=9:antialias=true", decoHeight = 13
                       , activeColor =  "#202020"
                       , activeBorderColor = "#93e0e3"
                       , activeTextColor = "#93e0e3"

                       , inactiveColor = "#202020"
                       , inactiveBorderColor = "#404040" --"#709080"
}

main = do
  xmproc <- spawnPipe "bash -c \"tee >(xmobar -x0) | xmobar -x1\""
  xmonad $ withUrgencyHook NoUrgencyHook
       $ defaultConfig
       { borderWidth = 1
       , modMask = mod4Mask
       --, startupHook = spawn "xmodmap -e \"add Mod4 = Menu\""
       --, startupHook = spawn "xmodmap -e \"keysym Menu = Super_L\""
       , keys = myKeys
       , terminal = term
       , XMonad.workspaces = Main.workspaces
       -- Don't put borders on fullFloatWindows (OtherIndicated)
       , layoutHook = lessBorders (Screen)  $ (avoidStruts ((onWorkspace "web" (tabbedBottom shrinkText myTheme ||| spiral (6/7)) (layoutHook defaultConfig) ))) ||| Full
       , logHook = dynamicLogWithPP xmobarPP
                   { ppOutput = hPutStrLn xmproc
                   , ppCurrent = xmobarColor "#f0dfaf" "" . wrap "|" "| "
                   , ppUrgent =  xmobarColor "#dfaf8f" "" . wrap ">" "<"
                     , ppVisible = wrap "|" "|"
                   , ppHidden =  wrap " " " "
                   , ppWsSep = ""
                   , ppTitle = xmobarColor "#93e0e3" "" . shorten 165
                   , ppSort = getSortByXineramaRule
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
    , className =? "Uzbl-core" --> doShift "web"
    ]

-- Union default and new key bindings
myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

--{{{ Keybindings
--    Add new and/or redefine key bindings
newKeys conf@(XConfig {XMonad.modMask = modm}) = [
 ((modm, xK_p), spawn launcher ),
 ((modm, xK_u), spawn "uzbl-browser" ),
 ((modm .|. shiftMask  , xK_p), spawn termLauncher),
 -- XF86AudioMute
 ((modm, xK_F9), toggleMute    >> return ()),
 -- XF86AudioLowerVolume
 ((modm, xK_F10), lowerVolume 2 >>= audioAlert),
 -- XF86AudioRaiseVolume
 ((modm, xK_F11), setMute False >> raiseVolume 4 >>= audioAlert)
  ]
--}}}

audioAlert = dzenConfig centered . show . round
centered = onCurr (center 150 66)
      >=> timeout 0.5
      >=> font "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*"
      >=> addArgs ["-fg", "#80c0ff"]
      >=> addArgs ["-bg", "#000040"]
