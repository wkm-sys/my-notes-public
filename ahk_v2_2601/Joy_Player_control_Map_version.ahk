;MD 映射 SDK (已适配 8BitDo 2dc8:0651)
;(Final Version)
#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; 0. 硬件心跳检测 (核心保险)
; ==============================================================================
CheckController() {
    ; 探测是否连接了任何游戏控制器
    Loop 16 {
        if GetKeyState(A_Index "JoyName") {
            return true ; 只要有一个手柄在线，就返回正常
        }
    }
    return false ; 没找到任何手柄
}

if !CheckController() {
    MsgBox("未探测到手柄连接。`n请插好手柄后重新运行脚本。", "SDK 安全警告", "Icon!")
    ExitApp()
}

; ==============================================================================
; 1. 核心硬件映射 (Data: 记录手柄的真实物理编号)
; ==============================================================================
MD_Map := Map(
    "X", 4, "Y", 5, "Z", 7,
    "A", 1, "B", 2, "C", 8,
    "L", 9, "R", 10,
    "Start", 12, "Select", 11, "Home", 3
)

; ==============================================================================
; 2. 逻辑分发区 (Logic: 填空题开始)
; ==============================================================================

; --- [ 第一排：XYZ ] ---
Hotkey "Joy" MD_Map["X"], (*) => MsgBox("X 键已接通")  ; 待填空
Hotkey "Joy" MD_Map["Y"], (*) => MsgBox("Y 键已接通")  ; 待填空
Hotkey "Joy" MD_Map["Z"], (*) => SendEvent("f")       ; Z 键：全屏

; --- [ 第二排：ABC ] ---
Hotkey "Joy" MD_Map["A"], (*) => SendEvent("j")       ; A 键：快退
Hotkey "Joy" MD_Map["B"], (*) => SendEvent("{Space}") ; B 键：暂停/播放
Hotkey "Joy" MD_Map["C"], (*) => SendEvent("l")       ; C 键：快进

; --- [ 第三排：L ( ) R ] ---
Hotkey "Joy" MD_Map["L"], (*) => Send("{Volume_Down 8}") ; L 键：音量减
Hotkey "Joy" MD_Map["R"], (*) => Send("{Volume_Up 8}")   ; R 键：音量加

; --- [ 第四排：控制键 ] ---
Hotkey "Joy" MD_Map["Select"], (*) => SendEvent("!{Left}") ; Select：后退
Hotkey "Joy" MD_Map["Start"],  (*) => MsgBox("Start 键已接通") ; 待填空
Hotkey "Joy" MD_Map["Home"],   (*) => Send("{Volume_Mute}")    ; Home：静音

; ==============================================================================
; 3. 十摇杆字区
; ==============================================================================
Global LastX := 50

; --- 调整这里：数值越小，反应越快 ---
; 50ms 意味着每秒检测 20 次，手感会非常丝滑
DelayTime := 50 
SetTimer WatchJoystick, DelayTime

WatchJoystick() {
    Global LastX
    
    currX := Round(GetKeyState("JoyX"))
    currY := Round(GetKeyState("JoyY"))

    ; --- X轴：左右 (YouTube 快进退) ---
    ; 依然保持“推一下动一下”，防止定位太难
    if (currX < 20 && LastX >= 20) {
        SendEvent("j")
    }
    else if (currX > 80 && LastX <= 80) {
        SendEvent("l")
    }
    LastX := currX

    ; --- Y轴：上下 (音量调节 - 极速模式) ---
    if (currY < 20) {
        ; 这里发两次，速度翻倍！
        Send("{Volume_Up 2}") 
    }
    else if (currY > 80) {
        ; 这里发两次，速度翻倍！
        Send("{Volume_Down 2}") 
    }
}

; ==============================================================================
; 4. 运行提示
; ==============================================================================
ToolTip("SDK 已就绪！")
SetTimer () => ToolTip(), -2000

/*

; ==============================================================================
; 3. 可视化监测 GUI
; ==============================================================================
MyGui := Gui("+AlwaysOnTop", "Michael's MD-SDK (Active)")
MyGui.SetFont("s10", "Consolas")

Grid := [["X","Y","Z"], ["A","B","C"], ["L"," ","R"], ["Start","Select","Home"]]

for r_idx, r_data in Grid {
    for c_idx, k_name in r_data {
        x := (c_idx-1) * 70 + 15, y := (r_idx-1) * 50 + 15
        MyGui.Add("Text", "x" x " y" y " w60 Center", k_name)
        num := MD_Map.Has(k_name) ? MD_Map[k_name] : ""
        if num != ""
            MyGui.Add("Text", "x" x " y" y+20 " w60 Center cBlue", "[" num "]")jjjjjj l
    }
}

MyGui.Show("w230 h210 NoActivate")
ToolTip("D-Input 映射加载成功！")
SetTimer () => ToolTip(), -2000