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
; AutoHotKey v2 macro script collection which provide several useful functions as keyboard shortcuts.
;
; Usage:
; Modify keyboard shortcuts as desired - https://www.autohotkey.com/docs/v1/Hotkeys.htm.
; Compile with AHK into exe and set to start with Windows to have functions available each session.
;
; Included functions:
;  1. Text expansion of several useful abbreviations, including "ttt" for time, "ddd" for date, and "dddd" for date-stamp (use "::abbreviation::TEXT TO EXPAND TO" format to add your own).
;  2. CapsLk -> Triggers PowerShell clipboard image resize script (from UtilityScripts - customize path to launch PowerShell script of choice).
;  3. Shift+CapsLk -> Go up a directory level in Windows Explorer.
;  4. Ctrl+Win+ Up/Down/Left/Right -> PageUp/PageDown/Home/End.
;  5. Ctrl+Win+a -> Launch "Everything" search program.
;  6. Ctrl+Win+s -> Cascade all windows (an option that used to be present in the Windows 10 taskbar right-click menu).
;  7. Ctrl+Win+z -> Move the active window to near the top-left corner of the main screen (especially handy for windows that are lost off the edge of the screen).
;  8. Ctrl+Win+x -> Move the active window to near the top-left corner of the main screen, set the width to 1300, and set the height to 800 (preferred Explorer window size).
;  9. Ctrl+Win+c -> Move the active window to near the top-left corner of the main screen and set width/height to be a bit smaller than the screen.
; 10. Ctrl+Win+v -> Text–only paste from clipboard (better paste as plane text now included in PowerToys - Ctrl+Win+Alt+v).
;
; #macro #script #autohotkey #ahk #utility #shortcut

; Initialize settings.
A_MenuMaskKey := "vkFF"  ; Change the masking key to something unassigned such as vkE8 (vkFF is reserved to mean "no mapping").
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode("Input")  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir(A_ScriptDir)  ; Ensures a consistent starting directory.
; Default state of lock keys
SetCapsLockState("AlwaysOff")
return


; Expand "ddd" text entered to yyyy-MM-dd date.
::ddd::
{
    CurrentDateTime := FormatTime(, "yyyy-MM-dd")
    SendInput(CurrentDateTime)
    return
}

; Expand "dddd" text entered to yyyyMMddhhmm date-stamp.
::dddd::
{
    CurrentDateTime := FormatTime(, "yyyyMMddHHmm")
    SendInput(CurrentDateTime)
    return
}

; Expand "ttt" text entered to HHmm time.
::ttt::
{
    CurrentDateTime := FormatTime(, "HHmm")
    SendInput(CurrentDateTime)
    return
}

; CapsLock triggers PowerShell script that shrinks image in clipboard.
Capslock::Run("PowerShell.exe -ExecutionPolicy Bypass -nologo -File `"C:\Program Files\UtilityScripts\Shrink-ClippedImage.ps1`"")
; Capslock::Run("PowerShell.exe -ExecutionPolicy Bypass -nologo -NoExit -File `"C:\Program Files\UtilityScripts\Shrink-ClippedImage.ps1`"")


; Shift+CapsLock to move up a directory level in Explorer.
#HotIf WinActive("ahk_class CabinetWClass", )
+Capslock::Send("!{Up}")
#HotIf


; Make Ctrl+Win+ Up/Down/Left/Right send PageUp/PageDown/Home/End.
^#Up::Send("{PgUp}")
^#Down::Send("{PgDn}")
^#Left::Send("{Home}")
^#Right::Send("{End}")


; Launch "everything" search when Ctrl+Win+a is pressed.
^#a::
{
    Run("`"C:\Program Files\Everything\Everything.exe`"")
    Return
}


; Cascade all windows when Ctrl+Win+s is pressed.
^#s::
{
    DllCall("CascadeWindows", "uInt", 0, "Int", 4, "Int", 0, "Int", 0, "Int", 0)
    Return
}


; Move active window to 20:20 when Ctrl+Win+z is pressed.
^#z::
{
    WinTitle := WinGetTitle("A")
    WinRestore(WinTitle)
    WinGetPos(, , &Width, &Height, WinTitle)
    WinMove(20, 20, , , WinTitle)
    Return
}


; Move active window to 20:20 and set width to 1300 and height to 800 when Ctrl+Win+x is pressed.
^#x::
{
    WinTitle := WinGetTitle("A")
    WinGetPos(, , &Width, &Height, WinTitle)
    WinMove(20, 20, 1300, 800, WinTitle)
    Return
}


; Move active window to 20:20 and set size to be a bit smaller than the current screen resolution when Ctrl+Win+c is pressed.
^#c::
{
    WinTitle := WinGetTitle("A")
    WinGetPos(, , &Width, &Height, WinTitle)
    WinMove(20, 20, (A_ScreenWidth/1.2), (A_ScreenHeight/1.2), WinTitle)
    Return
}


; Past text-only from Clipboard when Ctrl+Win+v is pressed.
^#v::                            
{
    Clip0 := ClipboardAll()
    A_Clipboard := A_Clipboard       ; Convert to text
    Send("^v")                       ; For best compatibility: SendPlay
    Sleep(50)                      ; Don't change clipboard while it is pasted! (Sleep > 0)
    A_Clipboard := Clip0           ; Restore original ClipBoard
    VarSetStrCapacity(&Clip0, 0)      ; Free memory ; V1toV2: if 'Clip0' is NOT a UTF-16 string, use 'Clip0 := Buffer(0)'
    Return
}


; End