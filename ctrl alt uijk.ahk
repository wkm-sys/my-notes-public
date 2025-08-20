^!u:: { ; 左上角
    WinMove 0, 0, Floor(A_ScreenWidth/2), Floor(A_ScreenHeight/2), "A"
}

^!i:: { ; 右上角
    WinMove Floor(A_ScreenWidth/2), 0, Floor(A_ScreenWidth/2), Floor(A_ScreenHeight/2), "A"
}

^!j:: { ; 左下角
    WinMove 0, Floor(A_ScreenHeight/2), Floor(A_ScreenWidth/2), Floor(A_ScreenHeight/2), "A"
}

^!k:: { ; 右下角
    WinMove Floor(A_ScreenWidth/2), Floor(A_ScreenHeight/2), Floor(A_ScreenWidth/2), Floor(A_ScreenHeight/2), "A"
}

^!Up:: { ; Ctrl + Alt + ↑
    WinMove 0, 0, A_ScreenWidth, Floor(A_ScreenHeight/2), "A"
}

^!Down:: { ; Ctrl + Alt + ↓
    WinMove 0, Floor(A_ScreenHeight/2), A_ScreenWidth, Floor(A_ScreenHeight/2), "A"
}
