#Requires AutoHotkey v2.0

; ==========================================
; 常用路径配置表 (Michael 的导航中心)
; ==========================================
PathMap := Map(
    "1", "D:\Projects",
    "2", "D:\MoldLib",
    "3", "D:\Temp",
    "4", "D:\Clients",
    "5", "D:\Archive"
)

; ==========================================
; 前缀键：Ctrl + E (语义：Explore/Enter)
; ==========================================
^e:: {
    ; 1. 修正后的 ToolTip：显示数字对应的路径名
    ; 这样即便偶尔忘了 2 是什么，瞄一眼提示就知道了
    ToolTip(GetPathHint(PathMap))

    ih := InputHook("L1 T1.5") ; 稍微给一点余量
    ih.Visible := false
    ih.KeyOpt("{All}", "E")

    ih.Start()
    ih.Wait()

    ToolTip() ; 清除提示

    key := ih.Input
    if (key = "" || !PathMap.Has(key))
        return

    SwitchToPath(PathMap[key])
}

; ==========================================
; 路径切换动作 (增加“已打开则激活”的逻辑)
; ==========================================
SwitchToPath(path) {
    if !DirExist(path) {
        MsgBox("路径不存在: " . path)
        return
    }

    ; 检查文件夹是否已经打开，如果打开了就激活它，不再新开窗口
    if WinExist("ahk_class CabinetWClass") { ; Explorer 的类名
        ; 获取所有资源管理器窗口的路径进行比对（这步略高级，但为了好用很值得）
        for window in ComObject("Shell.Application").Windows {
            if (window.Document.Folder.Self.Path = path) {
                WinActivate("ahk_id " . window.hwnd)
                return
            }
        }
    }
    
    ; 如果没找到已打开的窗口，直接运行
    Run(path)
}

; ==========================================
; 工具函数：生成提示信息
; ==========================================
GetPathHint(mapObj) {
    out := ""
    ; v2 遍历 Map 需要用 k, v
    for k, v in mapObj {
        SplitPath(v, &name) ; 提取文件夹名字，比如 "D:\Projects" 提取出 "Projects"
        out .= "[" k "]" name "  "
    }
    return Trim(out)
}