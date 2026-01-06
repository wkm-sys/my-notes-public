#SingleInstance force ; 再次运行脚本时自动替换旧进程，方便调试
#Include WindowHistory.ahk
#Include WindowUtils.ahk
#Include NumpadRemapped.ahk
#Include WorkPath.ahk
#Include MakeNewFile.ahk

getFormattedTime(type := "datetime") {
    if (type = "date")
        return FormatTime(, "yyyy-MM-dd")
    else if (type = "time")
        return FormatTime(, "hh:mm:ss tt")       ; 注意 tt 用空格分 AM/PM
    else if (type = "timestamp")
        return FormatTime(, "yyyy-MM-dd_hh-mm-ss_tt")
    else
        return FormatTime(, "yyyy-MM-dd_hh:mm:ss tt")
}

:*:ftt:: {
    SendInput getFormattedTime("date")
}

:*:fss:: {
    SendInput getFormattedTime("time")
}

:*:noww:: {
    SendInput getFormattedTime("timestamp")
}

Pause::
:*:tt::
{
    SendInput FormatTime(, "yyyy-MM-dd")
}


:*:sss::
{
 SendInput FormatTime(, "hh:mm:ss_tt")
	}


;!z::Send "^c"
;!x::Send "^v"
;!z::Send("^c"), SoundPlay("*16")
;!x::Send("^v"), SoundPlay("*16")
;!z::SoundPlay("*-1"), Send("^c")
;!z::Send("^c"), ToolTip("Copied"), SetTimer(() => ToolTip(), -600)
!z::Send("^c"), Hint("Copied")
!x::Send "^v"
!c::Send "#2"

~^c::Hint("Copied")  ; ~ 符号表示保留原功能，仅叠加 Hint

^F::#5 ; 打开搜索Everything
^!D::#6 ; 打开Google翻译
^!+\::Run "explorer " ME ; 理解环境变量 字符串拼接 函数赋值 三个知识点
;^!\::SendText OpenPath
^!\::
{
    if (A_PriorHotkey = "^!\" && A_TimeSincePriorHotkey < 300) {
        Send "{Enter}"
    } else {
        SendText OpenPath
    }
}



^\::{  
	Run "explorer \\Cadcam-pc\mold"
	}

*^]::{  
	Run "explorer D:\UserW\Scripts\Ahk_v2" 
	}
	
*^[::{  
	;Run "explorer D:\Work"
	Run "explorer " WorkPath
	}	

;Ctrl & AppsKey::{
 ;   Send "^v"
  ;  Send "{Enter}"
;}

;^AppsKey::SendText(A_Clipboard "`n")
;AppsKey::Send "^v{Enter}"
;AppsKey::Send("^v"), Sleep(300), Send("{Enter}")

; 这一行设置了：每次按键后自动停 300ms，按住按键的时长也是 50ms
AppsKey::SetKeyDelay(300, 50), SendEvent("^v{Enter}")


Alt & ,::{
    Send "^+{Tab}"   ; 上一个标签
}

Alt & .::{
    Send "^{Tab}"    ; 下一个标签
}

*!/::
*!'::{
    Send "^w"        ; 关闭当前标签
}

*!;::
{
    Send "^t"   ; 新建标签
}



#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_exe explorer.exe")  ; 只在文件资源管理器中启用 F12
F12::
{
    Click "Right"    ; 右键单击以弹出菜单
    Sleep 200        ; 等待菜单出现

    Send "{Up}"      ; 向上箭头
    Sleep 200

    Send "{Enter}"   ; 回车
    Sleep 200

    Send "nn"         ; 输入 n
    
    Send "{Right}"      ; 向右箭头
    
}
#HotIf  ; 关闭条件，使后续热键不受影响



; ✅ 再定義熱鍵，呼叫函數 "D:\UserW\Scripts\Ahk_v2\WindowUtils.ahk"

^!Up:: {
    AdjustWindowByPercent(top := 0.15, bottom := 0.06, left := 0.22, right := 0.22)
}

^!Down:: {
     WinMinimize "A" ;  窗口最小化
    ;AdjustWindowByPercent(top := 0.20, bottom := 0.05, left := 0.25, right := 0.25)
}

^!u:: { ; 左上角
	hwnd := WinExist("A")	
    WinMove 0, 0, Floor(A_ScreenWidth/2), Floor(A_ScreenHeight/2), "A"
}

^!i:: { ; 右上角
	hwnd := WinExist("A")
    WinMove Floor(A_ScreenWidth/2), 0, Floor(A_ScreenWidth/2), Floor(A_ScreenHeight/2), "A"
}

^!j:: { ; 左下角
	hwnd := WinExist("A")
    WinMove 0, Floor(A_ScreenHeight/2), Floor(A_ScreenWidth/2), Floor(A_ScreenHeight/2), "A"
}

^!k:: { ; 右下角
	hwnd := WinExist("A")
    WinMove Floor(A_ScreenWidth/2), Floor(A_ScreenHeight/2), Floor(A_ScreenWidth/2), Floor(A_ScreenHeight/2), "A"
}

;  长短区分功能 只适合低频场景 很卡手 且Alt+CapsLock可以穿透无需添加长按逻辑
; AutoHotkey v2
; CapsLock 短按 -> Win+Space
; CapsLock 長按 (>=1秒) -> 真正切換 CapsLock 狀態
/*
{
    t0 := A_TickCount
    KeyWait "CapsLock"  ; 等待放開
    elapsed := A_TickCount - t0

    if (elapsed < 500) {
        ; 短按 → Win+Space
        Send "{NumLock} "
    } else {
        ; 長按 → 切換 CapsLock 狀態
        SetCapsLockState !GetKeyState("CapsLock", "T")
    }
}
*/

