#Requires AutoHotkey v2.0
#SingleInstance Force

; $Esc - 逻辑分界标记

DetectHiddenWindows(true)

; --- 常量定义 ---
RIM_TYPEMOUSE := 0
RIM_TYPEKEYBOARD := 1
RIM_TYPEHID := 2
RIDI_DEVICENAME := 0x20000007
RIDI_DEVICEINFO := 0x2000000b
RIDEV_INPUTSINK := 0x00000100
RID_INPUT := 0x10000003

Global DoCapture := false
Global SizeofRawInputDeviceList := A_PtrSize * 2
Global SizeofRawInputDevice := 8 + A_PtrSize

; --- GUI 界面构建 ---
MyGui := Gui("+Resize", "Michael的设备检测器 (v2)")
MyGui.SetFont("s9", "Consolas")

; 注意：V2 中 GUI 控件现在是对象，我们直接存入变量
InfoOut := MyGui.Add("Edit", "r15 w600 HScroll -Wrap ReadOnly")
EditOut := MyGui.Add("Edit", "r15 w600 HScroll -Wrap ReadOnly")
BtnCapture := MyGui.Add("Button", "Default w150", "&Capture")

BtnCapture.OnEvent("Click", ToggleCapture)
MyGui.OnEvent("Close", (*) => ExitApp())
MyGui.Show()

; 注册消息回调
OnMessage(0x00FF, InputMessage)

; --- 获取设备列表逻辑 ---
Count := 0
DllCall("GetRawInputDeviceList", "Ptr", 0, "UInt*", &Count, "UInt", SizeofRawInputDeviceList)

InfoOutput("检测到 " . Count . " 个原始输入设备`r`n")

RawInputListData := Buffer(SizeofRawInputDeviceList * Count)
DllCall("GetRawInputDeviceList", "Ptr", RawInputListData, "UInt*", &Count, "UInt", SizeofRawInputDeviceList)

MouseRegistered := 0
KeyboardRegistered := 0

Loop Count {
    Offset := (A_Index - 1) * SizeofRawInputDeviceList
    Handle := NumGet(RawInputListData, Offset, "UPtr")
    
    ; --- 关键修正点：将 Type 改为 DevType，避免与内置函数冲突 ---
    DevType := NumGet(RawInputListData, Offset + A_PtrSize, "UInt")
    
    TypeName := (DevType == RIM_TYPEMOUSE) ? "鼠标" : (DevType == RIM_TYPEKEYBOARD) ? "键盘" : "HID设备"
    
    InfoOutput("设备 " . A_Index . ": 句柄 " . Handle . " [" . TypeName . "]`r`n")
    
    ; 获取设备名
    nLength := 0
    DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICENAME, "Ptr", 0, "UInt*", &nLength)
    NameBuf := Buffer((nLength + 1) * 2)
    DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICENAME, "Ptr", NameBuf, "UInt*", &nLength)
    InfoOutput("`t路径: " . StrGet(NameBuf) . "`r`n")
    
    ; 注册监听
    RawDevice := Buffer(SizeofRawInputDevice, 0)
    NumPut("UInt", RIDEV_INPUTSINK, RawDevice, 4)
    NumPut("UPtr", MyGui.Hwnd, RawDevice, 8)
    
    DoRegister := false
    if (DevType == RIM_TYPEMOUSE && !MouseRegistered) {
        NumPut("UShort", 1, RawDevice, 0), NumPut("UShort", 2, RawDevice, 2)
        MouseRegistered := true, DoRegister := true
    } else if (DevType == RIM_TYPEKEYBOARD && !KeyboardRegistered) {
        NumPut("UShort", 1, RawDevice, 0), NumPut("UShort", 6, RawDevice, 2)
        KeyboardRegistered := true, DoRegister := true
    } else if (DevType == RIM_TYPEHID) {
        iLength := 0
        DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICEINFO, "Ptr", 0, "UInt*", &iLength)
        if (iLength > 0) {
            InfoBuf := Buffer(iLength)
            NumPut("UInt", iLength, InfoBuf)
            DllCall("GetRawInputDeviceInfo", "Ptr", Handle, "UInt", RIDI_DEVICEINFO, "Ptr", InfoBuf, "UInt*", &iLength)
            uPage := NumGet(InfoBuf, 20, "UShort")
            uID := NumGet(InfoBuf, 22, "UShort")
            NumPut("UShort", uPage, RawDevice, 0), NumPut("UShort", uID, RawDevice, 2)
            DoRegister := true
        }
    }

    if (DoRegister) {
        DllCall("RegisterRawInputDevices", "Ptr", RawDevice, "UInt", 1, "UInt", SizeofRawInputDevice)
    }
}

; --- 功能函数 ---

ToggleCapture(*) {
    Global DoCapture
    DoCapture := !DoCapture
    BtnCapture.Text := DoCapture ? "Stop &Capture" : "&Capture"
}

InputMessage(wParam, lParam, msg, hwnd) {
    if (!DoCapture)
        return
    
    Size := 0
    HeaderSize := 8 + A_PtrSize * 2
    DllCall("GetRawInputData", "Ptr", lParam, "UInt", RID_INPUT, "Ptr", 0, "UInt*", &Size, "UInt", HeaderSize)
    
    if (Size <= 0) {
        return
    }
    
    InputBuf := Buffer(Size)
    if (DllCall("GetRawInputData", "Ptr", lParam, "UInt", RID_INPUT, "Ptr", InputBuf, "UInt*", &Size, "UInt", HeaderSize) != -1) {
        InpType := NumGet(InputBuf, 0, "UInt")
        InpHandle := NumGet(InputBuf, 8, "UPtr")
        
        if (InpType == RIM_TYPEKEYBOARD) {
            VKey := NumGet(InputBuf, HeaderSize + 6, "UShort")
            AppendOutput("键盘 [" . InpHandle . "] 按键码: " . VKey . "`r`n")
        } else if (InpType == RIM_TYPEMOUSE) {
            AppendOutput("鼠标 [" . InpHandle . "] 动作`r`n")
        }
    }
}

InfoOutput(Text) {
    InfoOut.Value .= Text
    SendMessage(0x0115, 7, 0, InfoOut.Hwnd, "ahk_id " . MyGui.Hwnd)
}

AppendOutput(Text) {
    EditOut.Value .= Text
    SendMessage(0x0115, 7, 0, EditOut.Hwnd, "ahk_id " . MyGui.Hwnd)
}