
; encoding: UTF-8 with BOM
; author: Hami Lemon <HamiLemon@aliyun.com>
; 使用BTT做信息提示
; 详见：https://github.com/telppa/BeautifulToolTip
#Include, lib/BTT.ahk
SetWorkingDir, %A_ScriptDir%

; 显示提示信息的小工具
tip(ByRef tip, time:=500){
    btt(tip)
    Sleep, %time%
    ; 清空内容
    btt()
    ; 释放
    tip := ""
    Return
}
; 详见https://wyagd001.github.io/zh-cn/docs/KeyList.htm#IME
SendSuppressedKeyUp(key) {
    DllCall("keybd_event"
        , "char", GetKeyVK(key)
        , "char", GetKeySC(key)
        , "uint", KEYEVENTF_KEYUP := 0x2
        , "uptr", KEY_BLOCK_THIS := 0xFFC3D450)
}
; 判断鼠标是否停留在任务栏
mouse_over_task() {
    WinTitle:="ahk_class Shell_TrayWnd"
    MouseGetPos,,, Win
    return WinExist(WinTitle . " ahk_id " . Win)
}
; 退出程序
exit_app(){
    ExitApp, 0
    Return
}
; 重载程序
reload_app(){
    Reload
    Sleep, 1000
    msgbox 重载失败
}
; 鼠标上移
mouse_up(speed){
    ; 如果同时按住了s键
    if(GetKeyState("s","P")){
        speed:=Ceil(speed*0.7)
        MouseMove, -%speed%, -%speed%, , R
    }else if(GetKeyState("f","P")){
        speed:=Ceil(speed*0.7)
        MouseMove, %speed%, -%speed% ,, R
    }else{
        MouseMove, 0, -%speed% , , R
    }

}
mouse_left(speed){
    if(GetKeyState("e","P")){
        speed:=Ceil(speed*0.7)
        MouseMove, -%speed%, -%speed% , , R
    }else if(GetKeyState("d","P")){
        speed:=Ceil(speed*0.7)
        MouseMove, -%speed%, %speed% ,, R
    }else{
        MouseMove, -%speed%, 0 , , R
    }

}
mouse_right(speed){
    if(GetKeyState("e","P")){
        speed:=Ceil(speed*0.7)
        MouseMove, %speed%, -%speed% , , R
    }else if(GetKeyState("d","P")){
        speed:=Ceil(speed*0.7)
        MouseMove, %speed%, %speed% ,, R
    }else{
        MouseMove, %speed%, 0 , , R
    }

}
mouse_down(speed){
    if(GetKeyState("s","P")){
        speed:=Ceil(speed*0.7)
        MouseMove, -%speed%, %speed% , , R
    }else if(GetKeyState("f","P")){
        speed:=Ceil(speed*0.7)
        MouseMove, %speed%, %speed% ,, R
    }else{
        MouseMove, 0, %speed% , , R
    }

}