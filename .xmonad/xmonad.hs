import XMonad
import XMonad.Actions.SpawnOn
import XMonad.Hooks.ManageHelpers
import qualified XMonad.StackSet as W
import qualified Data.Map as M

import XMonad.Layout.NoBorders
import XMonad.Layout.Tabbed
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spiral
import XMonad.Layout.Fullscreen
import XMonad.Layout.IM
import XMonad.Layout.Reflect
import Data.Ratio ((%))


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

-- don't border me brah
import Data.Monoid

-- stop accidentailly quiting
import System.Exit

-- WS ordering
import Data.List
import Data.Ord
import Data.Maybe
import Data.Function

-- spawnOnce startup hack
import System.Environment (getArgs)
import Control.Monad (when)

-- spawn Control
import XMonad.Actions.SpawnOn

workspaces = ["web", "irc", "build", "code", "c0de", "misc", "tex", "tools", "admin", "audio", "video", "hidden"
             ,"Straife", "Swizzle","Frak","Rakins", "ts+map","pyfa","launcher", "sensors"]

term :: String
term = "term" -- this is a script that launches urxvt in client-daemon mode

--Use a colourscheme with dmenu
addColor = " -- -nb '#3F3F3F' -nf '#DCDCCC' -sb '#7F9F7F' -sf '#DCDCCC'"

makeLauncher yargs run exec close = concat
  ["exe=`yeganesh ", yargs, "` && ", run, " ", exec, "$exe", close]
launcher sid     = makeLauncher addColor "eval" "\"exec " "\""
--launcher sid     = makeLauncher (addColor++" -m "++ (sid)++" ") "eval" "\"exec " "\""
termLauncher sid = makeLauncher ("-p withterm"++addColor) ("exec "++term++" -e") "" ""
--termLauncher sid = makeLauncher ("-p withterm"++addColor ++ " -m "++ (sid) ++ " ") ("exec "++term++" -e") "" ""

myTheme = defaultTheme { fontName = "xft:inconsolata:bold:pixelsize=9:antialias=true"
                       , decoHeight = 13
                       , activeColor =  "#202020"
                       , activeBorderColor = "#93e0e3"
                       , activeTextColor = "#93e0e3"

                       , inactiveColor = "#202020"
                       , inactiveBorderColor = "#404040" --"#709080"
}

main = do
  xmproc <- spawnPipe "bash -c \"tee >(xmobar -x0) | xmobar -x1\""
  --xmproc <- spawnPipe "xmobar"

  xmonad $ withUrgencyHook NoUrgencyHook
       $ defaultConfig
       { borderWidth = 1
       , modMask = mod4Mask
       --, startupHook = spawn "xmodmap -e \"add Mod4 = Menu\""
       --, startupHook = spawn "xmodmap -e \"keysym Menu = Super_L\""
       --, startupHook = startup
       , keys = myKeys
       , terminal = term
       , XMonad.workspaces = Main.workspaces
       -- Don't put borders on fullFloatWindows (OtherIndicated)
       , layoutHook = onWorkspace "ts+map" (avoidStruts (reflectHoriz (withIM (1%6) (Title "TeamSpeak 3") (noBorders ( reflectHoriz (tabbedBottom shrinkText myTheme))))))
                      $ onWorkspaces["Straife", "Swizzle","Frak", "Rakins"] (avoidStruts (noBorders  Full))
                      $ lessBorders (Screen) $ (avoidStruts ((onWorkspace "web" (tabbedBottom shrinkText myTheme ||| spiral (6/7)) (layoutHook defaultConfig) ))) ||| Full
       , logHook = dynamicLogWithPP xmobarPP
                   { ppOutput = hPutStrLn xmproc
                   , ppCurrent = xmobarColor "#f0dfaf" "" . wrap "|" "|"
                   , ppUrgent =  xmobarColor "#dfaf8f" "" . wrap ">" "<"
                   , ppVisible = wrap "|" "|"
                   , ppHidden =  wrap " " " "
                   , ppWsSep = ""
                   , ppTitle = xmobarColor "#93e0e3" "" . shorten 165
                   , ppSort = mkWsSort myXineramaWsCompare
                   }
       , manageHook = manageSpawn <+> manageDocks <+> myManageHooks
       --, handleEventHook = fullscreenEventHook <+> removeBordersEventHook
       }

startup :: X ()
startup = do
  as <- io getArgs
  when (null as) $ do
            spawnOn "irc" $term++" -name irc -e ssh ca"
            spawnOn "admin" $term++" -name admin -e \"bash -c tmux attach || tmux\""
            spawnOn "audio" "pavucontrol --class=audio"
            spawnOn "audio" "qmpdclient --class=audio"
            spawnOn "hidden" $term++" -name hidden  -e watch -n 3600 python repos/evelink/thang.py"
            spawnOn "pyfa" "mypyfa"
            spawnOn "launcher" "eve"
            spawnOn "sensors" $term++" -name sensors -e watch sensors"
            spawnOn "sensors" "nvidia-settings --class=sensors"


myManageHooks = composeAll
    -- Allows focusing other monitors without killing the fullscreen
    [ isFullscreen  --> (doF W.focusDown <+> doFullFloat) -- <&&> className /=? "Wine"
    -- Single monitor setups, or if the previous hook doesn't work
    -- [ isFullscreen --> doFullFloat

    -- browser has to stay in its box
    , className =? "Firefox" --> doShift "web"
    , className =? "Uzbl-core" --> doShift "web"
    , className =? "irc" --> doShift "irc"
    , className =? "pavucontrol" --> doShift "audio"
    , className =? "qmpdclient" --> doShift "audio"
    , className =? "QMPDClient" --> doShift "audio"
    , className =? "audio" --> doShift "audio"
    , className =? "admin" --> doShift "admin"
    , className =? "plugin-container" --> doShift "video"
    , className =? "hidden" --> doShift "hidden"

    , className =? "Ts3client" --> doShift "ts+map"
    , className =? "Gamez" --> doShift "ts+map"
    , className =? "launcher.exe" --> doShift "launcher"
    , className =? "sensors" --> doShift "sensors"
    --, className =? "Wine" --> doFloat
    ]

-- Union default and new key bindings
myKeys x  = M.union (M.fromList (newKeys x)) (keys defaultConfig x)

--{{{ Keybindings
--    Add new and/or redefine key bindings
newKeys conf@(XConfig {XMonad.modMask = modm}) =
    [ ((modm, xK_p), spawn (launcher "0")) --gets ((\(S n) -> n) .  W.screen . W.current . windowset) >>= spawn. launcher . show),
    , ((modm, xK_u), spawn "uzbl-browser" )
    , ((modm .|. shiftMask, xK_u), spawn "uzbl-browser --class=Gamez" )
    , ((modm .|. shiftMask, xK_p), gets ((\(S n) -> n) .  W.screen . W.current . windowset) >>= spawn . termLauncher . show)
    -- XF86AudioMute
    , ((modm, xK_F9), toggleMute    >> return ())
    -- XF86AudioLowerVolume
    , ((modm, xK_F10), lowerVolume 2 >>= audioAlert)
    -- XF86AudioRaiseVolume
    , ((modm, xK_F11), setMute False >> raiseVolume 2 >>= audioAlert)
    -- stop accidentally quiting
    , ((modm .|. shiftMask, xK_q), return ())
    , ((modm .|. shiftMask, xK_Delete), io (exitWith ExitSuccess))
    ]
    ++
    -- mod-[1..9] %! Switch to workspace N
    -- mod-shift-[1..9] %! Move client to workspace N
    [((m .|. modm, k), windows $ f i)
         | (i, k) <- zip (XMonad.workspaces conf) $[xK_1 .. xK_9]++[xK_0, xK_minus, xK_equal]++[xK_F1..xK_F8]
    , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
--}}}

audioAlert = dzenConfig centered . show . round
centered = onCurr (center 150 66)
      >=> timeout 0.5
      >=> font "-*-helvetica-*-r-*-*-64-*-*-*-*-*-*-*"
      >=> addArgs ["-fg", "#80c0ff"]
      >=> addArgs ["-bg", "#000040"]



-- my own workspase ordering, visible wworkspaces first, others is index order
myXineramaWsCompare :: X WorkspaceCompare
myXineramaWsCompare = do
    w <- gets windowset
    wsIndex <- getWsIndex
    return $ \ a b -> case (isOnScreen a w, isOnScreen b w) of
        (True, True)   -> cmpPosition w a b
        (False, False) -> (compare `on` wsIndex) a b
        (True, False)  -> LT
        (False, True)  -> GT
  where
    onScreen w =  W.current w : W.visible w
    isOnScreen a w  = a `elem` map (W.tag . W.workspace) (onScreen w)
    tagToSid s x = W.screen $ fromJust $ find ((== x) . W.tag . W.workspace) s
    cmpPosition w a b = comparing (tagToSid $ onScreen w) a b


-- | Remove borders from every mpv window as soon as possible in an event
-- hook, because otherwise dimensions are messed and the fullscreen mpv is
-- stretched by a couple pixels.
--
-- Basically the effect is the same as with
-- "XMonad.Layout.NoBorders.lessBorders OnlyFloat", except that OnlyFloat
-- messes up the dimensions when used together with fullscreenEventHook
-- (e.g. NET_WM_STATE). Well at least in mplayer/mpv.
--
-- I have no idea how often/where the border is re-applied, but resetting
-- it to 0 whenever possible just works :)
--removeBordersEventHook :: Event -> X All
--removeBordersEventHook ev = do
--    whenX (className =? "Wine" `runQuery` w) $ withDisplay $ \d ->
--        io $ setWindowBorderWidth d w 0
--    return (All True)
--    where
--        w = ev_window ev
