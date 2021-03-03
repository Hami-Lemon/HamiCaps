
; encoding: UTF-8 with BOM
; author: Hami Lemon <HamiLemon@aliyun.com>
SetWorkingDir, %A_ScriptDir%

; 显示提示信息的小工具
tip(ByRef tip, time:=-500){
    ToolTip, %tip%
    SetTimer, hide_tip, %time%
    ; 释放
    tip := ""
    Return
}
hide_tip(){
    ToolTip,
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