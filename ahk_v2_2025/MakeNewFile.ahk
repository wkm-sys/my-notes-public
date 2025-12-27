#Requires AutoHotkey v2.0
; ============================================================
; Michael's Universal Anchor
; 快捷鍵 (Hotkey): Ctrl + Alt + N
; 格式 (Format): 2025-12-27_Sat_09h17m31s
; 特點：系統原生音效 + 自動消失彈窗
; ============================================================

#Requires AutoHotkey v2.0

#HotIf WinActive("ahk_class CabinetWClass")
^!n:: {
    try {
        shell := ComObject("Shell.Application")
        for window in shell.Windows {
            if (window.HWND == WinActive("A")) {
                path := window.Document.Folder.Self.Path
                ts := FormatTime(, "yyyy-MM-dd_ddd_HH'h'mm'm'ss's'")
                
                ; 1. 鑄造 (Cast)
                FileOpen(path "\" ts, "w").Close()
                
             ; 2. 最原始的音效 (Primitive Sound)
                SoundPlay "*16"
                
                ; 3. 最簡化的彈窗 (Simplified MsgBox)
                ; 只傳遞一個參數，絕對不會出錯
                MsgBox("Anchor Created:`n" ts)
                
                break
            }
        }
    }
}
#HotIf

/*
#HotIf WinActive("ahk_class CabinetWClass")
^!n:: {
    try {
        ; 1. 獲取當前資源管理器路徑 (Get Current Explorer Path)
        shell := ComObject("Shell.Application")
        for window in shell.Windows {
            if (window.HWND == WinActive("A")) {
                path := window.Document.Folder.Self.Path
                
                ; 2. 依照你的優雅格式生成時間戳 (Generate formatted timestamp)
                ; 'ddd' 會根據系統語言顯示星期 (e.g., Sat 或 週六)
                ts := FormatTime(, "yyyy-MM-dd_ddd_HH'h'mm'm'ss's'")
                
                ; 3. 執行最皮實的「原地創建」 (Execute robust local creation)
                FileOpen(path "\" ts, "w").Close()
                
                break ; 執行完畢，退出循環 (Task done, exit loop)
            }
        }
    }
}
#HotIf

