; ===============================
; Window Utils
; ===============================

AdjustWindowByPercent(top := 0.1, bottom := 0.1, left := 0.1, right := 0.1) {
    hwnd := WinExist("A")
    if hwnd {
        topMargin := Round(A_ScreenHeight * top)
        bottomMargin := Round(A_ScreenHeight * bottom)
        leftMargin := Round(A_ScreenWidth * left)
        rightMargin := Round(A_ScreenWidth * right)

        WinWidth  := A_ScreenWidth  - leftMargin - rightMargin
        WinHeight := A_ScreenHeight - topMargin  - bottomMargin
        X := leftMargin
        Y := topMargin

        WinMove X, Y, WinWidth, WinHeight, "ahk_id " hwnd
    }
}

; ===============================
; 全局状态（必须在顶层）
; ===============================

global g_LeftRight := 0.20    ; 左右 margin（控制宽度）
global g_OffsetX   := 0.00    ; 水平偏移
global g_OffsetY   := 0.00    ; 垂直偏移

global g_StepSize := 0.02     ; 尺寸变化步长
global g_StepMove := 0.02     ; 平移步长

global g_Min := 0.05
global g_Max := 0.45

; ===============================
; 应用当前窗口状态
; ===============================

ApplyWindow() {
    global g_LeftRight, g_OffsetX, g_OffsetY

    ; 基础上下边距
    baseTop    := 0.17
    baseBottom := 0.06

    ; 垂直平移
    top    := baseTop    + g_OffsetY
    bottom := baseBottom - g_OffsetY

    ; 水平尺寸 + 平移
    left  := g_LeftRight + g_OffsetX
    right := g_LeftRight - g_OffsetX

    ; 防止越界
    top    := Max(0, top)
    bottom := Max(0, bottom)
    left   := Max(0, left)
    right  := Max(0, right)

    AdjustWindowByPercent(top, bottom, left, right)
}

; ===============================
; 快捷键绑定
; ===============================

; --- 改变宽度 ---
^!Left:: {
    global g_LeftRight, g_StepSize, g_Max
    g_LeftRight := Min(g_LeftRight + g_StepSize, g_Max)
    ApplyWindow()
}

^!Right:: {
    global g_LeftRight, g_StepSize, g_Min
    g_LeftRight := Max(g_LeftRight - g_StepSize, g_Min)
    ApplyWindow()
}

; --- 整体左右平移 ---
^!+Left:: {
    global g_OffsetX, g_StepMove
    g_OffsetX -= g_StepMove
    ApplyWindow()
}

^!+Right:: {
    global g_OffsetX, g_StepMove
    g_OffsetX += g_StepMove
    ApplyWindow()
}

; --- 整体上下平移 ---
^!+Up:: {
    global g_OffsetY, g_StepMove
    g_OffsetY -= g_StepMove
    ApplyWindow()
}

^!+Down:: {
    global g_OffsetY, g_StepMove
    g_OffsetY += g_StepMove
    ApplyWindow()
}


#Requires AutoHotkey v2.0

^!Home:: {
    WinSetAlwaysOnTop(-1, "A")
    SoundPlay "*16"
    ExStyle := WinGetExStyle("A") & 0x8
    Tooltip ExStyle ? "置顶 → ON" : "置顶 → OFF"
    SetTimer(() => Tooltip(""), -1000)
}

/*
#Requires AutoHotkey v2.0

^!Home:: {
    WinSetAlwaysOnTop(-1, "A")  ; Toggle 当前活动窗口的置顶状态
    SoundPlay "*16"            ; 播放提示音
}

