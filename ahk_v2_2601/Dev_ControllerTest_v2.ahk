; $Esc - 控制器测试及日志记录脚本 (AHK v2)
#Requires AutoHotkey v2.0
#SingleInstance Force

; ==============================================================================
; 配置与初始化
; 0001 | 1 | 2026-01-21 18:30:03
; 0002 | 2 | 2026-01-21 18:30:04
; 0003 | 3 | 2026-01-21 18:30:06
; 0004 | 4 | 2026-01-21 18:30:07
; 0005 | 6 | 2026-01-21 18:30:08
; 0006 | 5 | 2026-01-21 18:30:09
; 0007 | 8 | 2026-01-21 18:30:11
; 0008 | 7 | 2026-01-21 18:30:12
; ==============================================================================
ControllerNumber := 0
LogCounter := 1
LastButtonsState := "" ; 用于记录上一次的按键状态，防止重复记录
LogFileName := A_ScriptName ".log" ; 生成同名日志文件 (例如 Dev_ControllerTest_Logger.ahk.log)

; 确保日志文件开始是干净的（如果想追加记录，可以删掉下面这行）
if FileExist(LogFileName)
    FileDelete(LogFileName)

MyGui := Gui("+AlwaysOnTop", "控制器测试及日志系统")
MyGui.SetFont("s10", "Microsoft YaHei")
MyGui.Add("Text", "w350", "日志已开启：正在将按键动作写入 " LogFileName)
Display := MyGui.Add("Edit", "r15 w350 +ReadOnly")
MyGui.OnEvent("Close", (*) => ExitApp())
MyGui.Show()

; 自动检测
if (ControllerNumber <= 0) {
    Loop 16 {
        if GetKeyState(A_Index "JoyName") {
            ControllerNumber := A_Index
            break
        }
    }
}

if (ControllerNumber <= 0 || !GetKeyState(ControllerNumber "JoyName")) {
    Display.Value := "未检测到控制器。"
    return
}

cont_buttons := GetKeyState(ControllerNumber "JoyButtons")
cont_name    := GetKeyState(ControllerNumber "JoyName")

; ==============================================================================
; 主循环
; ==============================================================================
Loop {
    current_buttons := ""
    Loop cont_buttons {
        if GetKeyState(ControllerNumber "Joy" A_Index)
            current_buttons .= A_Index " "
    }

    ; --- 日志写入逻辑 ---
    ; 只有当按键状态发生变化，且当前有按键按下时才记录
    if (current_buttons != LastButtonsState && current_buttons != "") {
        ; 格式化序号为 4 位数 (0001)
        formatted_count := Format("{:04}", LogCounter)
        ; 获取当前时间
        time_stamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        
        ; 构建日志行
        log_line := formatted_count " | " Trim(current_buttons) " | " time_stamp "`n"
        
        ; 写入文件
        FileAppend(log_line, LogFileName, "UTF-8")
        
        LogCounter++
        LastButtonsState := current_buttons
    } else if (current_buttons == "") {
        LastButtonsState := "" ; 重置状态，方便下次按下同一个键时记录
    }

    ; --- 界面更新 ---
    axis_info := "X: " Round(GetKeyState(ControllerNumber "JoyX")) " | Y: " Round(GetKeyState(ControllerNumber "JoyY"))
    try {
        Display.Value := "设备: " cont_name "`n"
                      . "日志序号: " (LogCounter - 1) "`n"
                      . "------------------------------------`n"
                      . axis_info "`n"
                      . "------------------------------------`n"
                      . "当前按下: " (current_buttons == "" ? "无" : current_buttons)
    } catch {
        break
    }
    
    Sleep 50
}