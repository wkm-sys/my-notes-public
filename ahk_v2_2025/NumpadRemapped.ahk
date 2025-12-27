#Requires AutoHotkey v2.0

; 小鍵盤 0-9 直接重映射到主鍵盤 0-9
; Numpad 0-9 directly remapped to Main Keyboard 0-9

CapsLock::{
	Send "#{Space} "
}
  
; 使用逗号分隔多个热键标签，共用同一行指令
^Numpad0::
!Numpad0::Send("^v")

^Numpad1::
!Numpad1::Send("#1")

^Numpad2::
!Numpad2::Send("#2")

^Numpad3::
!Numpad3::Send("#3")

^Numpad4::
!Numpad4::Send("#4")

^Numpad5::
!Numpad5::Send("#5")

^Numpad6::
!Numpad6::Send("#6")

^Numpad7::
!Numpad7::Send("#7")

^Numpad8::
!Numpad8::Send("#8")

^Numpad9::
!Numpad9::Send("#9")


;^Numpad0::#0
;^Numpad1::#1
;^Numpad2::#2
;^Numpad3::#3
;^Numpad4::#4
;^Numpad5::#5
;^Numpad6::#6
;^Numpad7::#7
;^Numpad8::#8
;^Numpad9::#9

;NumpadEnd::Send("#1")    ; 对应 Numpad1
;NumpadDown::Send("#2")   ; 对应 Numpad2
;NumpadPgDn::Send("#3")   ; 对应 Numpad3
;NumpadLeft::Send("#4")   ; 对应 Numpad4
;NumpadClear::Send("#5")  ; 对应 Numpad5
;NumpadRight::Send("#6")  ; 对应 Numpad6
;NumpadHome::Send("#7")   ; 对应 Numpad7
;NumpadUp::Send("#8")     ; 对应 Numpad8
;NumpadPgUp::Send("#9")   ; 对应 Numpad9
;NumpadIns::Send("#0")    ; 对应 Numpad0  

;test

/*NumLock:: {
    t0 := A_TickCount
    KeyWait "NumLock"
    elapsed := A_TickCount - t0

    if (elapsed < 500) {
        ; 短按 → 输入等于号
        Send "="
    } else {
        ; 長按 → 切換 NumLock 狀態
        SetNumLockState !GetKeyState("NumLock", "T")
         ; 長按 → 發送時間   ;SendInput getFormattedTime("timestamp")
    }
}
*/

/*; AutoHotkey v2
; NumLock 短按 -> return FormatTime(, "yyyy-MM-dd_hh-mm-ss_tt")
; NumLock 長按 (>=0.5秒) -> 切換NumLock狀態
NumLock::{
		 t0 := A_TickCount
    KeyWait "NumLock"  ; 等待放開
    elapsed := A_TickCount - t0

    if (elapsed < 500) {
        ; 短按 → SendInput getFormattedTime("timestamp")
        SendInput getFormattedTime("timestamp")
    } else {
        ; 長按 → 切換NumLock 狀態
        SetNumLockState !GetKeyState("NumLock", "T")
    }
		}
*/