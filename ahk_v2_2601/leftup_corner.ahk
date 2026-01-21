; ########################################################
; Project: Operation Skuld - Hot Corners
; Function: 鼠标停在左上角 0.1秒 触发 Win+Tab (::#tab)
; ########################################################

#Requires AutoHotkey v2.0
Persistent(true)

; 核心修正：确保坐标判定基于整个屏幕
CoordMode "Mouse", "Screen"

; 每 50 毫秒观测一次世界线
SetTimer(CheckHotCorner, 50)

CheckHotCorner() {
    MouseGetPos(&mouseX, &mouseY)
    static hoverStartTime := 0
    
    ; 逻辑判断：在左上角 (10x10范围内) 且 必须按住 Ctrl 键 (Control)
    ;if (mouseX <= 10 && mouseY <= 10 && GetKeyState("Control", "P"))
    if (mouseX <= 10 && mouseY <= 10 && GetKeyState("Alt", "P")) {
        if (hoverStartTime = 0) {
            hoverStartTime := A_TickCount
        }
        else if (A_TickCount - hoverStartTime >= 100) {
            ; 触发 Win+Tab
            Send("#`t")
            
            ; 锁定状态，直到鼠标离开或松开 Ctrl
            hoverStartTime := 2147483647
        }
    } 
    else {
        ; 只要鼠标移开或者松开了 Ctrl，就重置计时器
        hoverStartTime := 0
    }
}