#Requires AutoHotkey v2.0

; ==== ACTIVE ====
WorkPath := "D:\Work\Q4"

; ==== HISTORY ====
; 2025-12-26  D:\UserW\Scripts\Ahk_v2
; 2025-12-26  D:\OldProject
; 2025-12-26  D:\AnotherProject
; 2025-12-26  D:\Prototype


$Esc:: {
    ; 长按 Esc 超过 0.3 秒触发
    if !KeyWait("Esc", "T0.3") { 
        ; 发送 Ctrl + Alt + Tab
        ; 这个组合键在 Windows 中会呼出“固定住”的任务切换菜单
        Send "^!{Tab}" 
        
        ; 等待物理 Esc 键松开，防止松开时的动作干扰系统
        KeyWait "Esc"
    } else {
        ; 短按：依然是原本的 Esc 功能
        Send "{Esc}"
    }
}