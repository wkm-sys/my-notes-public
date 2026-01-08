#SingleInstance Force
#Requires AutoHotkey v2.0

MyMenu := Menu()
MyMenu.Add("WinAlwaysOnTop", MenuHandler)
MyMenu.Add()  ; Add a separator line.
MyMenu.Add("UseEveryThing", MenuHandler)
MyMenu.Add()  ; Add a separator line.
MyMenu.Add("Open WorkPath", MenuHandler)
MyMenu.Add("Edit WorkPath", MenuHandler)
MyMenu.Add("Hotstrings Date", MenuHandler)
MyMenu.Add()  ; Add a separator line.
; Create another menu destined to become a submenu of the above menu.
Submenu1 := Menu()
Submenu1.Add("Item A", MenuHandler)
Submenu1.Add("Item B", MenuHandler)

; Create a submenu in the first menu (a right-arrow indicator). When the user selects it, the second menu is displayed.
MyMenu.Add("My Submenu", Submenu1)

MenuHandler(Item, *) {
    if (Item = "WinAlwaysOnTop") {
        ;MsgBox("快捷键Ctrl+Alt+Home:切换窗口置顶`n执行逻辑: WinSetAlwaysOnTop")
        WinSetAlwaysOnTop(-1, "A")
        SoundPlay "*16"
        ExStyle := WinGetExStyle("A") & 0x8
        Tooltip ExStyle ? "置顶 → ON" : "置顶 → OFF"
        SetTimer(() => Tooltip(""), -1000)
    }
    else if (Item = "Hotstrings Date") {
        ;MsgBox("热子串tt`n功能: 显示日期`n执行逻辑: FormatTime")
        SendInput FormatTime(, "yyyy-MM-dd")
    }
    else if (Item = "Open WorkPath") {
        ;MsgBox("快捷键^\:: 文件夹`n执行逻辑: Run Path")
        Run "explorer " WorkPath
    }
        else if (Item = "Edit WorkPath") {
        ;MsgBox("快捷键^]:: 文件夹`n执行逻辑: Run Path")
        ;Run "explorer D:\UserW\Scripts\Ahk_v2" 
        Run 'edit "D:\UserW\Scripts\Ahk_v2\WorkPath.ahk"'
    }
    else if (Item = "UseEveryThing") {
        ;MsgBox("Here is MsgBox Test Item")
         Send "#5"
    }
    else if (Item = "Item A") {
        MsgBox("Here is MsgBox Item A")
    }
      else if (Item = "Item B") {
        MsgBox("Here is MsgBox Item B")
    }
}

^End::
^!a::MyMenu.Show()
