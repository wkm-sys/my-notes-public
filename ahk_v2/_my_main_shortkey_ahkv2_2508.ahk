#SingleInstance force
#SuspendExempt
Pause::Suspend ; 用Pause鍵來切換脚本内無禁用豁免部分代碼的開關
/*
NumLock::{
		;Numlock狀態切換后 禁用豁免生效 暫停脚本
		SetNumLockState !GetKeyState("NumLock", "T")
		SendInput "{Pause}"
		}
	*/	
;~f & q::^o
;~f & e::Escape
~f & w::^w ; 使用f+w 作爲熱鍵 ctrl+w
~` & 1::#2 ; 切換NX窗口用
~` & 2::#4 ; 切換窗口用
~Tab & q::#5 ; 切換窗口用
!x::!F4 ; Alt+x 等於 Alt+f4 方便單手關閉窗口 提升操作體驗

PrintScreen::{ ;按下f12鍵盤,打開網頁版的谷歌翻譯
			Run "https://translate.google.com/?source=gtx"
			}	
CapsLock::XButton2
!CapsLock::CapsLock

:*:tt::
{	;輸出當前日期 sample=08-03-2024	
	SendInput FormatTime(,"dd-MM-yyyy")
	;SendInput FormatTime(,"HH.mm")
}

!Escape::WinMinimize "A" ; 最小化當前窗口

AppsKey::LWin ; 切換窗口用
RCtrl::^v ; 粘貼
RAlt::^Space ; 切換輸入法

;~`::MouseClick "left", , , 2 ; 這是給Mx Master 3S 準備的側面滾輪下等於雙擊
`::Escape ; 不用伸手去夠到esc鍵了

;:*:fcd::Note:Unspecified Geometry Follow CAD File
;ug_askExpressionValueAsString(p44_z,"%.0f")

;======以下開始禁用豁免============
#SuspendExempt False

$a::
    {
        If KeyWait("a", "T0.2") ; Wait for a to be released, with a 0.2 second timeout
        {
            ; Key was released within 0.2 seconds (short press)
            Send("{a}") ; Send the original keypress
        }
        Else
        {
            ; Key was held longer than 0.2 seconds (long press)
            ;MsgBox("F1 was long-pressed!")
                 send "{Escape}"
		        }
    }

$s::
    {
        If KeyWait("s", "T0.2") ; Wait for F1 to be released, with a 0.2 second timeout
        {
            ; Key was released within 0.2 seconds (short press)
            Send("{s}") ; Send the original keypress
        }
        Else
        {
            ; Key was held longer than 0.2 seconds (long press)
            ;MsgBox("F1 was long-pressed!")
                 send "{AltDown}" "{F1}" "{AltUp}"
		        }
    }
    
   $d::
    {
        If KeyWait("d", "T0.2") ; Wait for F1 to be released, with a 0.2 second timeout
        {
            ; Key was released within 0.2 seconds (short press)
            Send("{d}") ; Send the original F1 keypress
        }
        Else
        {
            ; Key was held longer than 0.2 seconds (long press)
            ;MsgBox("F1 was long-pressed!")
                 send "{LWinDown}" "{3}" "{LWinUp}"
		        }
    }
   
    $f::
    {
        If KeyWait("f", "T0.2") ; Wait for F1 to be released, with a 0.2 second timeout
        {
            ; Key was released within 0.2 seconds (short press)
            Send("{f}") ; Send the original F1 keypress
        }
        Else
        {
            ; Key was held longer than 0.2 seconds (long press)
            ;MsgBox("F1 was long-pressed!")
                 send "{LWinDown}" "{4}" "{LWinUp}"
		        }
    }
    
     $g::
    {
        If KeyWait("g", "T0.2") ; Wait for F1 to be released, with a 0.2 second timeout
        {
            ; Key was released within 0.2 seconds (short press)
            Send("{g}") ; Send the original F1 keypress
        }
        Else
        {
            ; Key was held longer than 0.2 seconds (long press)
            ;MsgBox("F1 was long-pressed!")
                 send "{LWinDown}" "{5}" "{LWinUp}"
        }
    }




;==========請忽略以下代碼======================================

/*
Space::Click 2

LWin::{
    MouseClick "Right",,, 1, 0, "D"  ; 按住鼠标.
    KeyWait "LWin"  ; 等待按键被释放.
    MouseClick "Right",,, 1, 0, "U"  ; 释放鼠标按钮.
}

		
 ^f12::{	; 測試鍵盤層數用
		Run "https://time.is/zh/" ; 打開當前時間網頁
			}
 
^+f::{        ; 在資源管理器中 將所有列調整至合適大小
		SendInput "{AltDown}v{AltUp}"
		SendInput "s"
		SendInput "f"
		ToolTip "已將所有列調整至合適大小`nThis will be displayed for 1 seconds."
		SetTimer () => ToolTip(), -1000
 }	 	

NumpadIns::^v ; 數字鍵盤0

NumpadEnd::^o ; 數字鍵盤1

NumpadPgdn::#3 ; 數字鍵盤3

NumpadLeft::RButton ; 數字鍵盤4

NumpadClear::Click 2 ; 數字鍵盤5	

NumpadRight::XButton2 ; 數字鍵盤6  

NumpadHome::#4 ; 數字鍵盤7

NumpadUp::!f1 ; 數字鍵盤8

NumpadPgUp::F7 ; 數字鍵盤9

NumpadAdd::Volume_Up

NumpadSub::Volume_Down

NumpadDiv::Media_Play_Pause

NumpadMult::^!Tab

NumpadDel::Escape

NumpadDown::{ ; 數字鍵盤2
			    CoordMode "Mouse"
			    Send "{LWinDown}2{LWinUp}"
			    Sleep 100
			    Send "{Click 500, 960}"
			    ;Send "{CtrlDown}v{CtrlUp}"
			               }			             	       
^\::{  
	Run "explorer \\Cadcam-pc\mold"
	}
	
 ;#Hotstring EndChars 热字串设置
 :*:ze::{
		Send "(2501)" ; 熱字串
		}
:*:tt::
{	;輸出當前日期 sample=08-03-2024	
	SendInput FormatTime(,"dd-MM-yyyy")
	;SendInput FormatTime(,"HH.mm")
}

#HotIf WinActive("ahk_class Notepad3")  ;按f5保存并運行當前代碼
f5::
{	Send "^s"
	Send "^r"
	sleep 500
	Send "{Enter}"
}
#HotIf

/*
--==============----==============----==============----==============--
^Escape::
{
    if WinGetMinMax("A") ;如果当前活动窗口为最大化状态
        WinRestore "A" ;则恢复当前窗口
    else
        WinMaximize "A" ;否则最大化当前窗口
}

;#CapsLock::Click 2
;CapsLock::^Space ; 切換中/英輸入法 與Ipad一致的體驗

RCtrl::{
		send "{LAlt}"
		Sleep 300
		send "{Space}"
		Sleep 300
		send "r"
		Sleep 300
		send "{Right}"
		}

;`::Click  2 ; 後面跟數字2就是雙擊

;!`::Escape ; alt 加波浪符 = Escape

;~Escape & 3::#3

;#PgUp::{
	;Run "D:\WORK\2024.04\2403 057 DDM TRANS 4CAV\3dnx 057\_2403 057 DDM Transfer 4cav Mold-Assy.prt"
;	} 

*/