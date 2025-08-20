; Ctrl+Alt+Up → 上半屏
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
