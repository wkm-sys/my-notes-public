#Requires AutoHotkey v2.0

^!s:: {
    recentDir := A_AppData "\Microsoft\Windows\Recent"
    recentList := []
    seenPaths := Map() 

    ; 1. 全量扫描：不设限制，遍历 149+ 个文件
    Loop Files recentDir "\*.lnk" {
        try {
            FileGetShortcut(A_LoopFileFullPath, &targetPath)
            
            if (targetPath == "")
                continue

            lowerPath := StrLower(targetPath)
            mTime := A_LoopFileTimeModified
            
            ; 智能去重逻辑
            if seenPaths.Has(lowerPath) {
                if (mTime > seenPaths[lowerPath].time) {
                    seenPaths[lowerPath].time := mTime
                    seenPaths[lowerPath].name := StrReplace(A_LoopFileName, ".lnk")
                }
                continue
            }
            
            ; 初次记录入库
            obj := {
                name: StrReplace(A_LoopFileName, ".lnk"),
                path: targetPath,
                time: mTime
            }
            recentList.Push(obj)
            seenPaths[lowerPath] := obj
        }
    }

    ; 2. 排序逻辑：按修改时间从大到小（最新的在前）
    if (recentList.Length > 1) {
        Loop recentList.Length - 1 {
            i := A_Index
            Loop recentList.Length - i {
                j := A_Index + i
                if (recentList[j].time > recentList[i].time) {
                    temp := recentList[i]
                    recentList[i] := recentList[j]
                    recentList[j] := temp
                }
            }
        }
    }

    ; 3. 构建菜单
    m := Menu()
    m.Add("扫描: " . recentList.Length . " | 刷新: " . A_Hour . ":" . A_Min . ":" . A_Sec, (*) => 0)
    m.Disable("1&")
    m.Add()

    count := 0
    for item in recentList {
        ; 检查是否为物理文件夹
        if DirExist(item.path) {
            cleanName := RegExReplace(item.name, "\s\(\d+\)$")
            m.Add(cleanName, RunPath.Bind(item.path))
            count++
            ; 内部控制，达到 15 个即跳出循环
            if (count >= 15) {
                break
            }
        }
    }

    ; 展示结果
    if (count > 0) {
        m.Show()
    } else {
        ToolTip("未发现有效的文件夹记录")
        SetTimer(() => Tooltip(), -2000)
    }
}

; 独立函数定义
RunPath(path, *) {
    try {
        Run(path)
    }
}
