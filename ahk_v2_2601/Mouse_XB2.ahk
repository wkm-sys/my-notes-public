#Requires AutoHotkey v2.0

; --- 全局状态 ---
global IsLeftieMode := false

; --- 核心触发逻辑：鼠标自己切换自己 ---
XButton2:: {
	static lastTime := 0
    currentTime := A_TickCount
    
    ; 如果两次点击间隔小于 350 毫秒，判定为双击
    if (currentTime - lastTime < 350) {
        global IsLeftieMode := !IsLeftieMode  
        lastTime := 0 ; 重置时间防止连击触发三次
        ;MsgBox "鼠标已就绪"
        TrayTip "模式切换", IsLeftieMode ? "当前：左手镜像" : "当前：标准模式", 1
        /* ToolTip(IsLeftieMode ? "左手模式：已就绪" : "标准模式：已还原")
        SetTimer () => ToolTip(), -2000  ; 负数代表只运行一次，1000ms 后清空 ToolTip
        lastTime := 0 */
    } else {
        lastTime := currentTime
        ; 短按一次依然保留原有的前进功能（延迟发送，确保不是双击的一部分）
        SetTimer () => (lastTime != 0 ? Send("{XButton2}") : ""), -350
    }
}

; --- 逻辑映射 ---
#HotIf IsLeftieMode 
LButton::RButton
RButton::LButton
#HotIf