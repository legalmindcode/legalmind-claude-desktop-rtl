#Requires AutoHotkey v2.0
#SingleInstance Force

; =============================================================================
;  RTL Helper for Claude Desktop - unofficial community tool, not Anthropic
;
;  Makes Hebrew render right-to-left in the Claude Desktop message box by
;  seeding one invisible RIGHT-TO-LEFT EMBEDDING character (U+202B) at the
;  start of the message. The character is built with Chr(0x202B), so this
;  source file intentionally contains no invisible characters - every byte
;  is visible on screen.
;
;  Scope and privacy:
;    - Aims all typing exclusively at Claude's main window (process
;      Claude.exe, top-level Chromium window class), never at its native
;      dialogs, and the automatic paths act only when the active keyboard
;      layout is Hebrew. Every scheduled seed re-checks its conditions at
;      the moment it fires.
;    - No network, no file I/O, no logging, no clipboard access. Exactly
;      two Windows API calls exist in this script (GetWindowThreadProcessId
;      and GetKeyboardLayout), both for keyboard-layout detection.
;    - "KeyHistory 0" and "ListLines 0" below disable AutoHotkey's built-in
;      key-event history and line history, so neither keystrokes nor
;      execution traces are retained, even in memory.
;    - Start it as a normal user. Never elevated.
;
;  Hotkeys:
;    Ctrl+Alt+J        insert the RTL character at the caret (manual
;                      recovery; Claude only; works even when seeding is
;                      toggled off or the layout is English)
;    Ctrl+Alt+Shift+R  toggle automatic seeding on/off (global)
; =============================================================================

KeyHistory 0
ListLines 0

SEED := Chr(0x202B)                  ; U+202B RIGHT-TO-LEFT EMBEDDING
TOGGLE_LABEL := "Claude RTL seeding"

global rtlOn := true
global winSeeded := Map()            ; hwnd, is its current draft seeded?
global winTitle := Map()             ; hwnd, last seen window title
global claudeGone := 0               ; watcher ticks with no Claude present
global seedDeadline := 0             ; latest tick a deferred seed may wait for
global prevActive := 0               ; last Claude window seen as active
global lastSeedAt := 0               ; tick of the last activation seed

A_IconTip := "Claude RTL: on"
A_TrayMenu.Add(TOGGLE_LABEL, (*) => ToggleRtl())
A_TrayMenu.Check(TOGGLE_LABEL)
SetTimer(WatchClaude, 300)

; ---- state checks -----------------------------------------------------------

IsHebrewLayout() {
    hwnd := WinActive("A")
    if !hwnd
        return false
    tid := DllCall("GetWindowThreadProcessId", "ptr", hwnd, "ptr", 0, "uint")
    return (DllCall("GetKeyboardLayout", "uint", tid, "ptr") & 0xFFFF) = 0x040D  ; he-IL
}

; The hwnd of Claude's active MAIN window, or 0. Native dialogs (class
; #32770, e.g. the file picker) are excluded, so a seed is never typed
; into a file-name field.
ClaudeMainActive() {
    hwnd := WinActive("ahk_exe Claude.exe")
    if !hwnd
        return 0
    try cls := WinGetClass(hwnd)
    catch
        return 0
    return (cls = "Chrome_WidgetWin_1") ? hwnd : 0
}

; ---- seeding ----------------------------------------------------------------

; Seed at the start of the message, waiting out any typing burst first
; (so the Ctrl+Home / Ctrl+End dance never interleaves with keystrokes).
SeedLineStart() {
    global winSeeded
    if !rtlOn
        return
    hwnd := ClaudeMainActive()
    if !hwnd
        return                       ; the watcher re-arms on the next visit
    if winSeeded.Get(hwnd, false)
        return                       ; whichever window is active now is
                                     ; already seeded - never double up
    if !IsHebrewLayout()
        return                       ; the watcher re-arms on layout switch
    ; Wait for a gap in typing so the Home/End navigation cannot interleave
    ; with real keystrokes - but never wait forever. Someone who types a
    ; whole message without a 250ms pause would otherwise send it unseeded.
    if (A_TimeIdlePhysical < 250 && A_TickCount < seedDeadline) {
        SetTimer(SeedLineStart, -200)
        return
    }
    Send("^{Home}")
    SendText(SEED)
    Send("^{End}")
    winSeeded[hwnd] := true
}

; Seed the fresh line created by Shift+Enter. Every line break starts a new
; bidi paragraph, so without this the second line and onward render LTR
; again - the single most visible failure of the one-seed-per-message
; approach. Each key press schedules its own one-shot timer, so a rapid
; second Shift+Enter is never dropped and the hotkey thread never blocks.
; {Home} and {End} bracket the new line, keeping the mark at its start.
ArmNewLineSeed() {
    SetTimer(() => SeedNewLine(), -60)  ; a fresh timer per press, on purpose
}

SeedNewLine() {
    if (!rtlOn || !ClaudeMainActive() || !IsHebrewLayout())
        return
    Send("{Home}")
    SendText(SEED)
    Send("{End}")
}

; Seed at the caret without moving it. Used when returning to Claude, where
; the input is usually empty and the caret is already at position 0. If a
; draft is open instead, the mark lands mid-text: invisible, and inert,
; because the message is already inside an embedding at that point. The
; cost of one spare character buys back the case the script cannot detect -
; a chat opened, switched, or sent with the mouse, which fires no hotkey
; and does not change the window title.
SeedAtCaret() {
    global lastSeedAt
    if (!rtlOn || !ClaudeMainActive() || !IsHebrewLayout())
        return
    SendText(SEED)
    lastSeedAt := A_TickCount
}

; ---- window / layout watcher ------------------------------------------------

; Ticks every 300ms. Arms a seed whenever the active main Claude window's
; draft is not seeded yet - which covers a newly opened window, a return
; after a missed seed, and an English-to-Hebrew layout switch. A window
; whose draft is already seeded is never re-seeded, so alt-tab round-trips
; and Alt+Shift toggles cannot accumulate characters.
WatchClaude() {
    global winSeeded, winTitle, claudeGone
    DetectHiddenWindows True         ; Claude minimized to the tray is alive
    if !WinExist("ahk_exe Claude.exe") {
        if (++claudeGone = 10) {     ; ~3s with no Claude: forget old windows
            winSeeded.Clear()        ; (also guards against hwnd reuse)
            winTitle.Clear()
        }
        return
    }
    claudeGone := 0
    dead := []                       ; drop entries whose window is gone, so
    for h, seen in winSeeded         ; a recycled hwnd can't inherit state
        if !WinExist("ahk_exe Claude.exe ahk_id " h)
            dead.Push(h)
    for h in dead {
        winSeeded.Delete(h)
        if winTitle.Has(h)              ; Delete throws on a missing key, and
            winTitle.Delete(h)          ; a window can be seeded before the
    }                                   ; watcher ever recorded its title
    if !rtlOn
        return
    hwnd := ClaudeMainActive()
    if !hwnd {
        global prevActive := 0       ; focus left Claude - arm the next return
        return
    }
    ; A title change suggests a different conversation is on screen - a
    ; fresh, empty input. This is a best-effort catch for switching chats
    ; with the mouse, which fires no hotkey at all. Note that Claude
    ; Desktop currently keeps the title constant, so in practice this
    ; branch rarely fires; Ctrl+Alt+J remains the reliable recovery.
    try title := WinGetTitle(hwnd)
    catch
        return
    if (winTitle.Get(hwnd, "") != title) {
        winTitle[hwnd] := title
        winSeeded[hwnd] := false
    }
    ; Returning to Claude from elsewhere: the input was very likely replaced
    ; by a mouse action the script cannot see. Drop a mark at the caret,
    ; rate limited, so coming back to a chat does not require the hotkey.
    global prevActive
    if (hwnd != prevActive) {
        prevActive := hwnd
        if (A_TickCount - lastSeedAt > 5000)
            SetTimer(SeedAtCaret, -350)
    }
    if (!winSeeded.Get(hwnd, false) && IsHebrewLayout()) {
        global seedDeadline := A_TickCount + 1500
        SetTimer(SeedLineStart, -250)
    }
}

; ---- toggle -----------------------------------------------------------------

ToggleRtl() {
    global rtlOn := !rtlOn
    A_IconTip := "Claude RTL: " (rtlOn ? "on" : "off")
    if rtlOn {
        A_TrayMenu.Check(TOGGLE_LABEL)
    } else {
        A_TrayMenu.Uncheck(TOGGLE_LABEL)
        SetTimer(SeedLineStart, 0)   ; cancel anything pending
    }
    ToolTip("Claude RTL " (rtlOn ? "ON" : "OFF"))
    SetTimer(ClearToolTip, -1200)    ; named, so rapid toggles reset one timer
}

ClearToolTip() {
    ToolTip()
}

^!+r::ToggleRtl()                    ; global on purpose - usable anywhere

; ---- Claude-scoped hotkeys --------------------------------------------------
; All Enter hotkeys use ~ (pass-through): the real keystroke always reaches
; Claude first, so a script fault can never block sending a message.

#HotIf WinActive("ahk_exe Claude.exe")

~Enter::        AfterSend()
~NumpadEnter::  AfterSend()
~+Enter::       ArmNewLineSeed()
~+NumpadEnter:: ArmNewLineSeed()
~^n::           AfterNewChat()
^!j::           ManualSeed()

#HotIf

; Message sent: the input is empty again, so mark this window unseeded and
; schedule a fresh seed. Does nothing when focus is in a dialog.
AfterSend() {
    global winSeeded, seedDeadline
    hwnd := ClaudeMainActive()
    if !hwnd
        return
    winSeeded[hwnd] := false
    seedDeadline := A_TickCount + 1500
    SetTimer(SeedLineStart, -250)
}

AfterNewChat() {
    global winSeeded, seedDeadline
    hwnd := ClaudeMainActive()
    if !hwnd
        return
    winSeeded[hwnd] := false
    seedDeadline := A_TickCount + 2000
    SetTimer(SeedLineStart, -500)    ; give the new chat's input time to mount
}

ManualSeed() {
    global winSeeded
    hwnd := ClaudeMainActive()
    if !hwnd
        return                       ; never type into dialogs, even manually
    SendText(SEED)
    winSeeded[hwnd] := true          ; user handled it - no automatic follow-up
}
