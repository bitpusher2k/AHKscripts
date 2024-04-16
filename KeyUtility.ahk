;           Bitpusher
;            \`._,'/
;            (_- -_)
;              \o/
;          The Digital
;              Fox
;          @VinceVulpes
;    https://theTechRelay.com
; https://github.com/bitpusher2k
;
; KeyUtility.ahk - By Bitpusher/The Digital Fox
; v3.3 last updated 2024-04-05
; AutoHotKey v1.1 macro script collection which provide several useful functions as keyboard shortcuts.
;
; Usage:
; Modify keyboard shortcuts as desired - https://www.autohotkey.com/docs/v1/Hotkeys.htm.
; Compile with AHK into exe and set to start with Windows to have functions available each session.
;
; Included functions:
;  1. Text expansion of several useful abbreviations, including "ttt" for time, "ddd" for date, and "dddd" for date-stamp (use "::abbreviation::TEXT TO EXPAND TO" format to add your own).
;  2. CapsLk -> Triggers PowerShell clipboard image resize script (from UtilityScripts).
;  3. Shift+CapsLk -> Go up a directory level in Windows Explorer.
;  4. Ctrl+Win+ Up/Down/Left/Right -> PageUp/PageDown/Home/End.
;  5. Ctrl+Win+a -> Launch "Everything" search program.
;  6. Ctrl+Win+s -> Cascade all windows (an option that used to be present in the Windows 10 taskbar right-click menu).
;  7. Ctrl+Win+z -> Move the active window to near the top-left corner of the main screen (especially handy for windows that are lost off the edge of the screen).
;  8. Ctrl+Win+x -> Move the active window to near the top-left corner of the main screen, set the width to 1300, and set the height to 800 (preferred Explorer window size).
;  9. Ctrl+Win+c -> Move the active window to near the top-left corner of the main screen and set width/height to be a bit smaller than the screen.
; 10. Ctrl+Win+v -> Text–only paste from clipboard.
; 11. Alt+Left Click and drag anywhere on a window to move it.
;
; #macro #script #autohotkey #ahk #utility #shortcut

; Initialize settings.
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#MenuMaskKey vkFF  ; Change the masking key to something unassigned such as vkE8 (vkFF is reserved to mean "no mapping").
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; Default state of lock keys
SetCapsLockState, AlwaysOff
return


; Expand "ddd" text entered to yyyy-MM-dd date.
::ddd::
    FormatTime, CurrentDateTime,, yyyy-MM-dd
    SendInput %CurrentDateTime%
return

; Expand "dddd" text entered to yyyyMMddhhmm date-stamp.
::dddd::
    FormatTime, CurrentDateTime,, yyyyMMddHHmm
    SendInput %CurrentDateTime%
return

; Expand "ttt" text entered to HHmm time.
::ttt::
    FormatTime, CurrentDateTime,, HHmm
    SendInput %CurrentDateTime%
return


; CapsLock triggers PowerShell script that shrinks image in clipboard.
Capslock::Run PowerShell.exe -ExecutionPolicy Bypass -NoExit -File "C:\Program Files\UtilityScripts\Shrink-ClippedImage.ps1


; Shift+CapsLock to move up a directory level in Explorer.
#IfWinActive, ahk_class CabinetWClass
+Capslock::Send !{Up} 
#IfWinActive
return


; Make Ctrl+Win+ Up/Down/Left/Right send PageUp/PageDown/Home/End.
^#Up::Send {PgUp}
^#Down::Send {PgDn}
^#Left::Send {Home}
^#Right::Send {End}


; Launch "everything" search when Ctrl+Win+a is pressed.
^#a::
    Run "C:\Program Files\Everything\Everything.exe"
Return


; Cascade all windows when Ctrl+Win+s is pressed.
^#s::
    DllCall( "CascadeWindows", uInt,0, Int,4, Int,0, Int,0, Int,0 )
Return


; Move active window to 20:20 when Ctrl+Win+z is pressed.
^#z::
    WinGetActiveTitle, WinTitle
    WinRestore, %WinTitle%
    WinGetPos,,, Width, Height, %WinTitle%
    WinMove, %WinTitle%,, 20, 20
Return


; Move active window to 20:20 and set width to 1300 and height to 800 when Ctrl+Win+x is pressed.
^#x::
    WinGetActiveTitle, WinTitle
    WinGetPos,,, Width, Height, %WinTitle%
    WinMove, %WinTitle%,, 20, 20, 1300, 800
Return


; Move active window to 20:20 and set size to be a bit smaller than the current screen resolution when Ctrl+Win+c is pressed.
^#c::
    WinGetActiveTitle, WinTitle
    WinGetPos,,, Width, Height, %WinTitle%
    WinMove, %WinTitle%,, 20, 20, (A_ScreenWidth/1.2), (A_ScreenHeight/1.2)
Return


; Past text–only from Clipboard when Ctrl+Win+v is pressed.
^#v::                            
    Clip0 = %ClipBoardAll%
    ClipBoard = %ClipBoard%       ; Convert to text
    Send ^v                       ; For best compatibility: SendPlay
    Sleep 50                      ; Don't change clipboard while it is pasted! (Sleep > 0)
    ClipBoard = %Clip0%           ; Restore original ClipBoard
    VarSetCapacity(Clip0, 0)      ; Free memory
Return


; End