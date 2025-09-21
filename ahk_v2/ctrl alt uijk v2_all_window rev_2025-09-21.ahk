#SingleInstance force

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


:*:tt::
{
    SendInput FormatTime(, "yyyy-MM-dd")
}


:*:sss::
{
 SendInput FormatTime(, "hh:mm:ss_tt")
	}

!x:: {
    Send "^c"
}

!c:: {
    Send "^v"
}

^\::{  
	Run "explorer \\Cadcam-pc\mold"
	}


NumLock:: {
    t0 := A_TickCount
    KeyWait "NumLock"
    elapsed := A_TickCount - t0

    if (elapsed < 500) {
        ; 短按 → 切換 NumLock 狀態
        SetNumLockState !GetKeyState("NumLock", "T")
    } else {
        ; 長按 → 發送時間
        SendInput getFormattedTime("timestamp")
    }
}


/*; AutoHotkey v2
; NumLock 短按 -> return FormatTime(, "yyyy-MM-dd_hh-mm-ss_tt")
; NumLock 長按 (>=0.5秒) -> 真正切換NumLock狀態
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

; AutoHotkey v2
; CapsLock 短按 -> Win+Space
; CapsLock 長按 (>=1秒) -> 真正切換 CapsLock 狀態

CapsLock::
{
    t0 := A_TickCount
    KeyWait "CapsLock"  ; 等待放開
    elapsed := A_TickCount - t0

    if (elapsed < 500) {
        ; 短按 → Win+Space
        Send "# "
    } else {
        ; 長按 → 切換 CapsLock 狀態
        SetCapsLockState !GetKeyState("CapsLock", "T")
    }
}



#HotIf WinActive("ahk_exe explorer.exe")  ; 只在文件资源管理器中激活
#HotIf
F12::
{
    ; 右键单击以弹出菜单
    Click "Right"
    Sleep 200  ; 等待菜单出现，这很重要
    
    ; 模拟按下向上箭头键，选择菜单中的某个选项
    Send "{Up}"
    Sleep 200  ; 等待菜单出现，这很重要
    
    ; 模拟按下 Enter 键确认选择
    Send "{Enter}"
    Sleep 200  ; 等待菜单出现，这很重要
    
    ; 模拟按下 'n' 键
    Send "n"
}

^!UP:: {
    hwnd := WinExist("A") ; 获取活动窗口
    if hwnd {
        WinWidth := Round(A_ScreenWidth * 0.75)
        WinHeight := Round(A_ScreenHeight * 0.75)
        X := (A_ScreenWidth - WinWidth) / 2
        Y := (A_ScreenHeight - WinHeight) / 2
        WinMove X, Y, WinWidth, WinHeight, "ahk_id " hwnd
    }
}

^!Down:: {
    hwnd := WinExist("A") ; 获取活动窗口
    if hwnd {
        WinWidth := Round(A_ScreenWidth * 0.5)
        WinHeight := Round(A_ScreenHeight * 0.5)
        X := (A_ScreenWidth - WinWidth) / 2
        Y := (A_ScreenHeight - WinHeight) / 2
        WinMove X, Y, WinWidth, WinHeight, "ahk_id " hwnd
    }
}

/*
^!UP:: {
    hwnd := WinExist("A") ; 获取活动窗口
    if hwnd {
        WinMove 0, 0, A_ScreenWidth, Floor(A_ScreenHeight/2), "ahk_id " hwnd
    }
}

; Ctrl+Alt+Down → 下半屏
^!Down:: {
    hwnd := WinExist("A")
    if hwnd {
        WinMove 0, Floor(A_ScreenHeight/2), A_ScreenWidth, Floor(A_ScreenHeight/2), "ahk_id " hwnd
    }
}
*/

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

/*  ^!Up:: { ; Ctrl + Alt + ↑
    WinMove 0, 0, A_ScreenWidth, Floor(A_ScreenHeight/2), "A"
}

^!Down:: { ; Ctrl + Alt + ↓
    WinMove 0, Floor(A_ScreenHeight/2), A_ScreenWidth, Floor(A_ScreenHeight/2), "A"
}
