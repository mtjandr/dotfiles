--
-- File         : xmonad.hs
-- Author       : Miles Tjandrawidjaja
-- Last Updated : 10/28/2012 
-- My xmonad configurations, uses dzen2 and conky
-- Also uses the contrib version
--

--Imports--
import XMonad
import XMonad.Actions.CycleWindows -- Classic alt-tab
import XMonad.Actions.CycleWS      -- Using to toggle back and forth from last used workspace
import XMonad.Hooks.DynamicLog     -- To use stats bar/ dzen with pretty printing
import XMonad.Hooks.EwmhDesktops   -- FullscreenEventHook fixes chrome fullscreen, not currently working
import XMonad.Hooks.ManageDocks    -- Hide/Show status bar
import XMonad.Hooks.UrgencyHook    -- Window alert bells 
import XMonad.Hooks.SetWMName	   -- Java fix
import XMonad.Layout.Named         -- Custom layout names
import XMonad.Layout.NoBorders     -- Smart borders on solo clients
import XMonad.Layout.ResizableTile -- Resizable windows in all directions
import XMonad.Hooks.FadeInactive   -- Fade out inactive windows
import XMonad.Util.EZConfig        -- Append key/mouse bindings
import XMonad.Util.Run(spawnPipe)  -- SpawnPipe and hPutStrLn
import System.IO                   -- System calls (hPutStrLn scope)
import qualified XMonad.StackSet as W   -- manageHook rules
import XMonad.Hooks.ManageHelpers

main = do
    conky      <- spawnPipe myDzenConky                                             --Conky stats on the right
    statuspipe <- spawnPipe myDzenMain                                              --Dzen2 status to the left
    xmonad $ withUrgencyHook NoUrgencyHook $ defaultConfig{ 
        modMask              = mod4Mask                                             --Use Windows logo as mod key
	    , terminal 		     = "urxvt"                                              --Set terminal to urxvt
        , borderWidth        = 2                                                    --Set border width to 2 
        , normalBorderColor  = "#dddddd"                                            --Set unfocused border colour
        , focusedBorderColor = "#0000ff"                                            --Set focused border colour
        , handleEventHook    = fullscreenEventHook                                  --For fullscreen chromium
        , layoutHook = myLayoutHook                                                 --Modify layout
	    , manageHook = (isFullscreen --> doFullFloat) <+> (fmap not isDialog --> doF avoidMaster)            	        --Make new window not be master winodw
	    , startupHook= setWMName "LG3D"                                             --Java fix
	    ,   logHook = logHook' statuspipe >> (fadeLogHook)                          --Xmonad output, for status bar info, fade inactive windows
	} `additionalKeysP` myKeys                                                      --Key bindings


--Log hook
--
logHook' ::  Handle -> X ()
logHook' statuspipe = dynamicLogWithPP $ defaultPP                                  --Xmonad output, for status bar info,
        {                                                                           --Info must be piped via spawnPipe or .xsession, etc, use default config with some modifications
            ppCurrent = dzenColor "#3399ff" "#000000" . pad                         --Current workspace (fore/back)ground colour
            , ppVisible = dzenColor "#888888" "#000000" . pad 
            , ppHidden = dzenColor "#dddddd" "#000000" . pad                        --Unused workspace (fore/back)ground colour with apps on it
            , ppHiddenNoWindows = dzenColor "#888888"  "#000000" . pad              --Unused workspace (fore/back)ground colour with no apps on it
            , ppUrgent  = dzenColor "#171717" "#fee100" . wrap "[" "]"
            , ppTitle           = dzenColor "#FF00FF" "". shorten 700 . dzenEscape  --Colour and max lenght of title of window on current workspace
            , ppOutput = hPutStrLn statuspipe                                       --Pipe pretty output to dzen     
        }   


avoidMaster :: W.StackSet i l a s sd -> W.StackSet i l a s sd
avoidMaster = W.modify' $ \c -> case c of
     W.Stack t [] (r:rs) ->  W.Stack t [r] rs
     otherwise           -> c

--Fade amount
--
fadeLogHook :: X ()
fadeLogHook = fadeInactiveLogHook fadeAmount
    where fadeAmount = 1.0                                                          --The lower the number the higher the transparency of the nonactive windows

-- Layouts
--
myLayoutHook = avoidStruts $ smartBorders ( mtiled ||| full  ||| tiled )            --Avoid strust allows hiding status bar
  where                                                                             --Smart border removes border when only one window is opened
    rt = ResizableTall 1 (5/100) (2/(1+(toRational(sqrt(5)::Double)))) []           --Set to use golden ratio and resizable in all directions
    full    = named "X" $ Full                                                      --Set full tiling mode as X
    mtiled  = named "M" $ Mirror rt                                                 --Set wide tiling made as M
    tiled   = named "T" $ rt                                                        --Set tall tiling mode as T


-- Statusbar 
--
myDzenMain = "dzen2 -bg black -fg white -ta l -w 900" ++ myDzenStyle                             --Status bar for dzen
myDzenConky  = "conky -c ~/.conkyrc | dzen2 -bg black -x '810' -w '1110' -ta 'r'" ++ myDzenStyle --Conky bar for dzen
myDzenStyle  = " -h '20' -fg '#777777' -bg 'black' -fn 'arial:bold:size=11'"                     --Dzen style

-- Key bindings
--
myKeys = [ ("M1-<Tab>"      , cycleRecentWindows [xK_Alt_L] xK_Tab xK_Tab )         -- classic alt-tab behaviour
       	 , ("M-b"	        , sendMessage ToggleStruts	 	              )         -- toggle the status bar gap
         , ("M-<Tab>"       , toggleWS                                    )         -- toggle last workspace (super-tab)
         , ("M-C-<Right>"   , nextWS                                      )         -- go to next workspace
         , ("M-C-<Left>"    , prevWS                                      )         -- go to prev workspace
         , ("M-S-<Right>"   , shiftToNext                                 )         -- move client to next workspace
         , ("M-S-<Left>"    , shiftToPrev                                 )         -- move client to prev workspace
    	 , ("M-<Left>"	    , spawn "mpc prev"			                  )         -- play previous song
    	 , ("M-<Right>"	    , spawn "mpc next"			                  )         -- play next song
    	 , ("M-<Up>"	    , spawn "mpc play"			                  )         -- start song
    	 , ("M-<Down>"  	, spawn "mpc pause"			                  )         -- pause song
         , ("M-r"           , spawn "xmonad --restart"                    )         -- restart xmonad w/o recompiling
         , ("M-x"           , spawn "chromium"                            )         -- launch browser
         , ("M-S-x"         , spawn "chromium --incognito"                )         -- launch private browser
         , ("C-M1-<Delete>" , spawn "sudo shutdown -r now"                )         -- reboot
         , ("C-M1-<End>"    , spawn "sudo shutdown -h now"                )         -- poweroff
         , ("M-n", sendMessage MirrorShrink                               )         -- resize height/width in T/M
         , ("M-i", sendMessage MirrorExpand                               )         -- resize height/width in T/M 
    	 , ("M-<F9>" , spawn "amixer -c 1 -q sset Master toggle"              ) -- Toggle Volume
    	 , ("M-<F12>" , spawn "amixer -c 1 -q sset Headphone toggle"              ) -- Toggle Volume
    	 , ("M-<F10>", spawn "amixer -c 1 -q sset Master 2- unmute"     ) -- lower volume
    	 , ("M-<F11>", spawn "amixer -c 1 -q sset Master 2+ unmute"     ) -- raise volume
    	 , ("<Print>"	 , spawn "~/pictures/snapshot.py") --Take a Screenshot
    	 --, ("<Print>"	 , spawn "import -window root `date '+%Y%m%d-%H%M%S'`.png") --Take a Screenshot
         ]
