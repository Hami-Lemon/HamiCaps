
; encoding: UTF-8 with BOM
; author: Hami Lemon <HamiLemon@aliyun.com>

#NoEnv
#SingleInstance, force
#NoTrayIcon
#Persistent
;@Ahk2Exe-IgnoreBegin
#Warn All,StdOut
;@Ahk2Exe-IgnoreEnd
#Include, lib/util.ahk
#InstallKeybdHook
SendMode Input 
SetWorkingDir %A_ScriptDir% 

; 是否显示托盘图标
tray_icon:=1
; CapsLock是否被按下
caps_lock_down:=0

; capsLock模式是否可用
caps_mode_enable:=1
; 鼠标单次移动距离（Caps+e,s,d,f)
mouse_move_speed:=30
; 是否开机自启
start_poweron:=0

; 显示或隐藏托盘图标
show_hide_icon(){
    global tray_icon
    tray_icon := not tray_icon
    if(tray_icon){
        tip("显示托盘图标")
        Menu, Tray, Icon
        Menu, Tray, Rename, 显示图标, 隐藏图标
    }else{
        tip("隐藏托盘图标")
        Menu, Tray, NoIcon
        Menu, Tray, Rename, 隐藏图标, 显示图标
    }
}
; 临时禁用
suspend_toggle(){
    Suspend, Toggle
    if(A_IsSuspended){
        tip("脚本挂起")
        Menu, tray, Check, 临时禁用〔Win+Caps〕
    }else{
        tip("取消挂起")
        Menu, tray, UnCheck, 临时禁用〔Win+Caps〕
    }
}
; 改变CapsLock模式是否可用
enable_disable_caps_mode(){
    global caps_mode_enable
    caps_mode_enable:= not caps_mode_enable
    if(caps_mode_enable){
        Menu, status, UnCheck, 1&
    }else{
        Menu, status, Check, 1&
        ; 关闭数字锁，以免影响使用
        num_lock := 0
    }
    Return
}

; 检查是否开机自启
check_start_poweron(){
    RegRead, out, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, HamiCaps
    global start_poweron
    if(out = A_ScriptFullPath){
        start_poweron:= 1
        Menu , Tray, Check, 5&
    }else{
        start_poweron:=0
    }
}
; 开机自启
start_app_when_poweron(){
    global start_poweron
    start_poweron:= not start_poweron
    if(start_poweron){
        RegWrite REG_SZ, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, HamiCaps, %A_ScriptFullPath%
        Menu, Tray, Check, 5&
        tip("设置开机自启")
    }else{
        RegDelete, HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run, HamiCaps
        Menu, Tray, UnCheck, 5&
        tip("取消开机自启")
    }
}
;;;;;;;;;;;;托盘菜单;;;;;;;;;;;;;;;;
Menu, Tray, NoDefault
Menu, Tray, NoStandard
Menu, Tray, NoMainWindow
Menu, Tray, Tip, HamiCaps正在运行
; 功能启用子菜单
Menu, status, add, 禁用Caps模式, enable_disable_caps_mode, +Radio

Menu, Tray, add, 功能启用, :status
Menu, Tray, add, 显示图标, show_hide_icon
Menu, Tray, add, 临时禁用〔Win+Caps〕, suspend_toggle
Menu, Tray, add ; 分隔线
Menu, Tray, add, 开机自启, start_app_when_poweron
Menu, Tray, add, 重载程序〔Caps+`` 〕, reload_app
Menu, Tray, add, 退出〔Caps+Q〕, exit_app

; 初始化托盘图标
if(tray_icon){
    Menu, Tray, Icon
    Menu, Tray, Rename, 显示图标, 隐藏图标
}else{
    Menu, Tray, Rename, 隐藏图标, 显示图标
}

check_start_poweron()
;Win+capsLock 控制托盘图标显示
#CapsLock::
    Suspend, Toggle
    if(A_IsSuspended){
        tip("脚本挂起")
        Menu, tray, Check, 临时禁用〔Win+Caps〕
    }else{
        tip("取消挂起")
        Menu, tray, UnCheck, 临时禁用〔Win+Caps〕
    }
Return
;;;;;;;;;;;;CapsLock模式;;;;;;;;;;;;;;
; 单击CapsLock无效果
CapsLock::
    caps_lock_down:=1
    ; CapsLock模式不可用时，启用大写锁定
    if not caps_mode_enable{
        caps_lock_down := 0
        SetCapsLockState % !GetKeyState("CapsLock", "T")
        Return
    }
    ;等待CapsLock被释放
    KeyWait, CapsLock
    caps_lock_down:=0
Return

#IF caps_lock_down and caps_mode_enable

; j,l,k,i 移动光标
; 同时按下alt时，移动距离为2
; $j::
;     Send, {Left}
; Return
$j::Left
$!j::
    SendSuppressedKeyUp("Alt")
    Send, {Left 2}
return
; $l::
;     Send, {right}
; Return
$l::Right
$!l::
    SendSuppressedKeyUp("Alt")
    Send, {right 2}
return
; $i::
;     Send, {up}
; Return
$i::Up
$!i::
    SendSuppressedKeyUp("Alt")
    Send, {up 2}
return
; $k::
;     Send, {down}
; Return
$k::Down
$!k::
    SendSuppressedKeyUp("Alt")
    Send, {down 2}
return
; 删除光标右侧内容
$`;::
Send, +{End}{Delete}
Return
; 删除光标左侧内容
$h::
    Send, +{Home}{BackSpace}
Return
; 删除当前行内容
$y::
    Send, {Home}+{End}{Delete}{BackSpace}
Return
; pageup
; $[::
;     Send, {PgUP}
; Return
$[::PgUp
; pagedown
; $]::
;     Send, {PgDn}
; Return
$]::PgDn
; home
; $,::
;     Send, {Home}
; Return
$,::Home
; end
; $.::
;     Send, {End}
; Return
$.::End
; ctrl + home
$!,::
    SendSuppressedKeyUp("Alt")
    Send, ^{Home}
Return
; ctrl + end
$!.::
    SendSuppressedKeyUp("Alt")
    Send, ^{End}
Return
; insert
; $\::
;     Send, {Insert}
; Return
$\::Insert
; 不影响当前行回车
$Enter::
    send, {End}{Enter}
Return

; 清空所有内容
$r::
    Send, ^a{Delete}
Return
; delete
; $v::
;     Send, {Delete}
; Return
$v::Delete
; backspace
; $n::
;     Send, {BackSpace}
; Return
$n::BackSpace
; 显示程序菜单
$g::
    Menu,Tray,Show
Return
; 鼠标左键
; $u::
;     Click Left D
;     KeyWait, u
;     Click Left U
;Return
$u::LButton
; 鼠标右键
; $p::
;     Click Right D
;     KeyWait, p
;     Click Right U
; Return
$p::RButton
; 鼠标中键
; $'::
;     Click Middle D
;     KeyWait, '
;     Click Middle U
; Return
$'::MButton
; 鼠标滚轮向上
$w::
    Click WheelUp
Return
; 鼠标滚轮向下
$o::
    Click WheelDown
Return
; 鼠标移动
$e::
    mouse_up(mouse_move_speed)
Return
$d::
    mouse_down(mouse_move_speed)
Return
$s::
    mouse_left(mouse_move_speed)
Return
$f::
    mouse_right(mouse_move_speed)
Return
$!e::
    mouse_up(mouse_move_speed*4)
Return
$!d::
    mouse_down(mouse_move_speed*4)
Return
$!s::
    mouse_left(mouse_move_speed*4)
Return
$!f::
    mouse_right(mouse_move_speed*4)
Return
; 退出程序
$q::
    exit_app()
Return
;重载程序
$`::
    reload_app()
return
#IF

;;;;;;;; / 快捷命令 ;;;;;;;;;
; / 是否按下
i_click_down:=0
$/::
    i_click_down:=1
    KeyWait, /
    i_click_down:=0
    if(A_ThisHotkey = "$/" and A_TimeSinceThisHotkey <= 300){
        Send, {/}
    }
Return
#IF i_click_down

$c::Run CMD
$e::Run explorer
$b:: Run https://www.baidu.com
$n:: Run notepad
$m:: Run mspaint
#IF

;;;;;;;分号引导快捷符号;;;;;;;;
semi_click_down:=0
$;::
semi_click_down:=1
KeyWait, `;
semi_click_down:=0
if(A_ThisHotkey = "$;" and A_TimeSinceThisHotkey <= 300){
Send, {;}
}
Return

#IF semi_click_down

$a::Send {!}
$s::Send {^}
$d::Send {\}
$f::Send {Text}``````
$e::Send {(}
$r::Send {)}
#IF
    ;;;;;;;;鼠标停留在任务栏时，可使用滚轮调节音量;;;;;;;;;;
#IF mouse_over_task()
    $WheelUp::Volume_Up
$WheelDown::Volume_Down
#IF