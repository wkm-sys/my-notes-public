#requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; 路径转 Obsidian 链接工具
; 功能：复制路径 -> 自动清洗 -> 自动补全 file:/// -> 写回剪贴板
; ==============================================================================

^+c::
{
    ; 1. 获取内容
    A_Clipboard := "" 
    Send "^c"
    if !ClipWait(0.5) {
        return
    }

    rawPath := A_Clipboard

    ; 2. 核心清洗逻辑
    ; 统一转为正斜杠，解决 Windows 路径符号问题
    cleanPath := StrReplace(rawPath, "\", "/")
    
    cleanPath := RegExReplace(cleanPath, "i)^D:/work", "Z:")
    
    ; 处理空格（Obsidian 链接必须处理空格，否则会断开）
    webPath := StrReplace(cleanPath, " ", "%20")
    
    ; 3. 拼接协议头
    finalLink := "file:///" . webPath
    
    ; 4. 写回剪贴板并给个“响动”
    A_Clipboard := finalLink
    
    ; 气泡提示（ 1.5 秒）
    TrayTip "链接转换成功", finalLink, "Iconi Mute"
    SetTimer () => TrayTip(), -1500
}