
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
