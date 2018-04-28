
!addincludedir "include"

Var MSG     ;MSG变量必须定义，而且在最前面，否则WndProc::onCallback不工作，插件中需要这个消息变量,用于记录消息信息
Var Dialog  ;Dialog变量也需要定义，他可能是NSIS默认的对话框变量用于保存窗体中控件的信息

Var BGImage  ;背景大图
Var ImageHandle

Var BGImage1  ;背景大图
Var ImageHandle1

Var Txt_Browser
Var btn_Browser

Var btn_in
Var btn_ins
Var btn_back
Var btn_Close
Var btn_instetup
Var btn_instend
Var btn_instend1

Var Ckbox0
Var Ckbox1
Var Ckbox1_State
Var Ckbox4

;---------------------------全局编译脚本预定义的常量-----------------------------------------------------
!define PRODUCT_NAME "票耘"
!define PRODUCT_VERSION "1.1.1"
!define PRODUCT_PUBLISHER "Beijing Deallinker Technology Co., Ltd."
!define PRODUCT_UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"
!define PRODUCT_UNINST_ROOT_KEY "HKLM"


;---------------------------设置软件压缩类型（也可以通过外面编译脚本控制）------------------------------------
SetCompressor lzma
SetCompress force


;应用程序显示名字
Name "${PRODUCT_NAME}"
Caption "InvoiceClouds"
;应用程序输出文件名
OutFile "InvoiceClouds_Setup_1.1.1(0).exe"
;安装路径
!define DIR "$PROGRAMFILES\InvoiceClouds" ;请在这里定义路径
InstallDir "$PROGRAMFILES\InvoiceClouds"
InstallDirRegKey HKLM "${PRODUCT_UNINST_KEY}" "UninstallString"
ShowInstDetails nevershow ;设置是否显示安装详细信息。
ShowUnInstDetails nevershow ;设置是否显示删除详细信息。

;RequestExecutionLevel admin

;安装图标的路径名字
!define MUI_ICON "Icon\fee.ico"
;卸载图标的路径名字
!define MUI_UNICON "Icon\Uninstall.ico"
;使用的UI
!define MUI_UI "UI\mod.exe"

;使用ReserveFile是加快安装包展开速度，具体请看帮助
ReserveFile "images\bg.bmp"
ReserveFile "images\bg2.bmp"
ReserveFile "images\bg3.bmp"
ReserveFile "images\browse.bmp"
ReserveFile "images\close.bmp"
ReserveFile "images\custom.bmp"
ReserveFile "images\empty_bg.bmp"
ReserveFile "images\express.bmp"
ReserveFile "images\finish.bmp"
ReserveFile "images\full_bg.bmp"
ReserveFile "images\onekey.bmp"
ReserveFile "images\strongbtn.bmp"
ReserveFile "images\weakbtn.bmp"
;轮展数据
ReserveFile "images\Slides.dat"
ReserveFile "images\InstallingBG01.png"
ReserveFile "images\InstallingBG02.png"
ReserveFile "images\InstallingBG03.png"
ReserveFile "images\InstallingBG04.png"
;DLL
ReserveFile `${NSISDIR}\Plugins\nsDialogs.dll`
ReserveFile `${NSISDIR}\Plugins\nsWindows.dll`
ReserveFile `${NSISDIR}\Plugins\SkinBtn.dll`
ReserveFile `${NSISDIR}\Plugins\SkinProgress.dll`
ReserveFile `${NSISDIR}\Plugins\System.dll`
ReserveFile `${NSISDIR}\Plugins\WndProc.dll`
ReserveFile `${NSISDIR}\Plugins\nsisSlideshow.dll`
ReserveFile `${NSISDIR}\Plugins\FindProcDLL.dll`

; ------ MUI 现代界面定义 (1.67 版本以上兼容) ------
!include "MUI.nsh"
!include "WinCore.nsh"
!include "nsWindows.nsh"
!include "LogicLib.nsh"
!include "WinMessages.nsh"
!include "FileFunc.nsh"
;!include "LoadRTF.nsh"

!define MUI_CUSTOMFUNCTION_GUIINIT onGUIInit

;自定义页面
Page custom Page.1 Page.1leave

!define MUI_PAGE_CUSTOMFUNCTION_SHOW InstFilesPageShow
!insertmacro MUI_PAGE_INSTFILES
; 安装完成页面
Page custom Page.3
;这个不要删除，否则自动跳转出问题
Page custom Page.4

# UNINSTALL

# UninstPage custom un.ModifyUnConfirm un.ModifyUnConfirmLeave

!define MUI_CUSTOMFUNCTION_UNGUIINIT un.GUIInit
!define MUI_PAGE_CUSTOMFUNCTION_SHOW un.ModifyUnConfirm
!insertmacro MUI_UNPAGE_CONFIRM
!define MUI_PAGE_CUSTOMFUNCTION_SHOW Un.InstFilesPageShow
!insertmacro MUI_UNPAGE_INSTFILES
UninstPage custom un.FinishPage

# INIT

/*!macro RequireAdmin
  UserInfo::GetAccountType
  pop $8
  ${If} $8 != "admin"
    MessageBox MB_ICONSTOP "......"
    setErrorLevel 740 ;ERROR_ELEVATION_REQUIRED
    quit
  ${EndIf}
!macroend

Function RequireAdmin
  ;setShellVarContext all
  !insertmacro RequireAdmin
FunctionEnd*/

; 安装界面包含的语言设置
!insertmacro MUI_LANGUAGE "SimpChinese"

VIProductVersion "0.0.0.0"           ;←↓版本
VIAddVersionKey /LANG=2052 "ProductName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=2052 "Comments" "https://www.invoiceclouds.com" ;修改
VIAddVersionKey /LANG=2052 "CompanyName" "Deallinker"
VIAddVersionKey /LANG=2052 "LegalCopyright" "Deallinker"
VIAddVersionKey /LANG=2052 "LegalTrademarks" "Deallinker"
VIAddVersionKey /LANG=2052 "FileDescription" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=2052 "FileVersion" "${PRODUCT_VERSION}"
VIAddVersionKey /LANG=2052 "InternalName" "${PRODUCT_NAME}"
VIAddVersionKey /LANG=2052 "PrivateBuild" "Deallinker"


RequestExecutionLevel admin

;------------------------------------------------------MUI 现代界面定义以及函数结束------------------------

Function .onInit
    ;Call RequireAdmin
    
    InitPluginsDir ;初始化插件
    
    StrCpy $Ckbox1_State ${BST_CHECKED}
    
    File `/ONAME=$PLUGINSDIR\bg.bmp` `images\bg.bmp` ;第一大背景
    File `/oname=$PLUGINSDIR\bg2.bmp` `images\bg2.bmp` ;第二大背景
    File `/oname=$PLUGINSDIR\bg3.bmp` `images\bg3.bmp` ;完成页背景
    
    File `/oname=$PLUGINSDIR\btn_onekey.bmp` `images\onekey.bmp`  ;快速安装
    File `/oname=$PLUGINSDIR\btn_custom.bmp` `images\custom.bmp`  ;自定义安装
    File `/oname=$PLUGINSDIR\btn_browse.bmp` `images\browse.bmp` ;浏览按钮
    File `/oname=$PLUGINSDIR\btn_strongbtn.bmp` `images\strongbtn.bmp` ;立即安装
    File `/oname=$PLUGINSDIR\btn_finish.bmp` `images\finish.bmp` ;安装完成
    File `/oname=$PLUGINSDIR\btn_weakbtn.bmp` `images\weakbtn.bmp` ;返回
    File `/oname=$PLUGINSDIR\btn_express.bmp` `images\express.bmp` ;立即体验
    File `/oname=$PLUGINSDIR\btn_Close.bmp` `images\Close.bmp` ;关闭
    
		;进度条皮肤
	  File `/oname=$PLUGINSDIR\Progress.bmp` `images\empty_bg.bmp`
  	File `/oname=$PLUGINSDIR\ProgressBar.bmp` `images\full_bg.bmp`
  	
		;初始化
    SkinBtn::Init "$PLUGINSDIR\btn_onekey.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_custom.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_browse.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_strongbtn.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_finish.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_weakbtn.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_express.bmp"
    SkinBtn::Init "$PLUGINSDIR\btn_Close.bmp"
    
    DeleteRegKey /ifempty HKCU "Software\Microsoft\Windows\CurrentVersion\Run\票耘"
    DeleteRegKey /ifempty HKCU "Software\Microsoft\Windows\CurrentVersion\Run\InvoiceClouds" ;删除开机启动
    
FunctionEnd

Function onGUIInit
	;检查重复运行
  System::Call 'kernel32::CreateMutexA(i 0, i 0, t "InvoiceClouds") i .r1 ?e'
  Pop $R1		;;;;$$$$$安装程序已经运行
  StrCmp $R1 0 +3
  MessageBox MB_OK|MB_ICONINFORMATION|MB_TOPMOST "程序已经在运行。"
  Abort

  ;检测是否正在运行
  RETRY:
  FindProcDLL::FindProc "InvoiceClouds.exe" ;检测的运行进程名称
  StrCmp $R0 1 0 +3
  MessageBox MB_RETRYCANCEL|MB_ICONINFORMATION|MB_TOPMOST '检测到 "${PRODUCT_NAME}" 正在运行,请先关闭后重试，或者点击"取消"退出!' IDRETRY RETRY
	Quit
  
    ;消除边框
    System::Call `user32::SetWindowLong(i$HWNDPARENT,i${GWL_STYLE},0x9480084C)i.R0`
    ;隐藏一些既有控件
    GetDlgItem $0 $HWNDPARENT 1034
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1035
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1036
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1037
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1038
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1039
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1256
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1028
    ShowWindow $0 ${SW_HIDE}

    ${NSW_SetWindowSize} $HWNDPARENT 589 439 ;改变主窗体大小
    System::Call User32::GetDesktopWindow()i.R0

    ;圆角
    System::Alloc 16
  	System::Call user32::GetWindowRect(i$HWNDPARENT,isR0)
  	System::Call *$R0(i.R1,i.R2,i.R3,i.R4)
  	IntOp $R3 $R3 - $R1
  	IntOp $R4 $R4 - $R2
  	System::Call gdi32::CreateRoundRectRgn(i0,i0,iR3,iR4,i4,i4)i.r0
  	System::Call user32::SetWindowRgn(i$HWNDPARENT,ir0,i1)
  	System::Free $R0
  	
FunctionEnd

;处理无边框移动
Function onGUICallback
  ${If} $MSG = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd

Function Page.1

    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1990
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1991
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1992
    ShowWindow $0 ${SW_HIDE}
    
    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;背景设成透明

    ${NSW_SetWindowSize} $0 588 438 ;改变Page大小
    
    ;自定义安装按钮
    ${NSD_CreateButton} 310u 263u 98 17 ""
    Pop $btn_ins
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_custom.bmp $btn_ins
    GetFunctionAddress $3 onClickint
    SkinBtn::onClick $btn_ins $3
    
    ;快速安装
    ${NSD_CreateButton} 116u 204u 252 64 ""
    Pop $btn_in
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_onekey.bmp $btn_in
    GetFunctionAddress $3 onClickins
    SkinBtn::onClick $btn_in $3

    ;关闭按钮
    ${NSD_CreateButton} 372u 8u 24 20 ""
    Pop $btn_Close
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_Close.bmp $btn_Close
    GetFunctionAddress $3 ABORT
    SkinBtn::onClick $btn_Close $3

    ;立即安装
    ${NSD_CreateButton} 274u 250u 82 26 "立即安装"
    Pop $btn_instetup
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_strongbtn.bmp $btn_instetup
    GetFunctionAddress $3 onClickins
    SkinBtn::onClick $btn_instetup $3
    SetCtlColors $btn_instetup FFFFFF transparent
    ShowWindow $btn_instetup ${SW_HIDE}

    ;返回
    ${NSD_CreateButton} 334u 250u 56 26 "返回"
    Pop $btn_back
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_weakbtn.bmp $btn_back
    GetFunctionAddress $3 onClickBack
    SkinBtn::onClick $btn_back $3
    SetCtlColors $btn_back 7F7F7F transparent
    ShowWindow $btn_back ${SW_HIDE}
    
#------------------------------------------
#许可协议
#------------------------------------------
    ${NSD_CreateLink} 17u 265u 63u 12u ""
    Pop $Ckbox0
    SetCtlColors $Ckbox0 0178ff FFFFFF
    ${NSD_OnClick} $Ckbox0 textClick

#------------------------------------------
#可选项1
#------------------------------------------
    ${NSD_CreateCheckbox} 21u 226u 80u 12u "创建桌面图标"
    Pop $Ckbox1
    SetCtlColors $Ckbox1 ""  FFFFFF ;前景色,背景设成透明
		ShowWindow $Ckbox1 ${SW_HIDE}
		${NSD_Check} $Ckbox1
		
#------------------------------------------
#可选项2
#------------------------------------------

#------------------------------------------
#可选项3
#------------------------------------------


		;创建安装目录输入文本框
  	${NSD_CreateText} 21u 183u 290u 17.5u "${DIR}"
		Pop $Txt_Browser
		SetCtlColors $Txt_Browser ""  FFFFFF ;背景设成透明
		;${NSD_AddExStyle} $Txt_Browser ${WS_EX_WINDOWEDGE}
    CreateFont $1 "tahoma" "10" "500"
    SendMessage $Txt_Browser ${WM_SETFONT} $1 1
		ShowWindow $Txt_Browser ${SW_HIDE}


    ;创建更改路径文件夹按钮
    ${NSD_CreateButton} 312u 273U 76 28  "浏览..."
		Pop $btn_Browser
		SkinBtn::Set /IMGID=$PLUGINSDIR\btn_browse.bmp $btn_Browser
		GetFunctionAddress $3 onClickSelectPath
    SkinBtn::onClick $btn_Browser $3
    SetCtlColors $btn_Browser 7F7F7F transparent ;前景色,背景设成透明
    ShowWindow $btn_Browser ${SW_HIDE}


    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage1
    ${NSD_SetImage} $BGImage1 $PLUGINSDIR\bg2.bmp $ImageHandle1
    ShowWindow $BGImage1 ${SW_HIDE}

    ;贴背景大图
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\bg.bmp $ImageHandle

    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ;处理无边框窗体移动
    WndProc::onCallback $BGImage1 $0 ;处理无边框窗体移动

    nsDialogs::Show
    ${NSD_FreeImage} $ImageHandle
    ${NSD_FreeImage} $ImageHandle1
FunctionEnd

Function Page.1leave
${NSD_GetState} $Ckbox1 $Ckbox1_State
FunctionEnd

;Function InstFilesPagePRO
;    GetDlgItem $0 $HWNDPARENT 1
;    ShowWindow $0 ${SW_HIDE}
;    GetDlgItem $0 $HWNDPARENT 2
;    ShowWindow $0 ${SW_HIDE}
;    GetDlgItem $0 $HWNDPARENT 3
;FunctionEnd

Function  InstFilesPageShow
    FindWindow $R2 "#32770" "" $HWNDPARENT

    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $1 $R2 1027
    ShowWindow $1 ${SW_HIDE}

		;存入轮展图片
    File '/oname=$PLUGINSDIR\Slides.dat' 'images\Slides.dat'
    File '/oname=$PLUGINSDIR\InstallingBG01.png' 'images\InstallingBG01.png'
    File '/oname=$PLUGINSDIR\InstallingBG02.png' 'images\InstallingBG02.png'
    File '/oname=$PLUGINSDIR\InstallingBG03.png' 'images\InstallingBG03.png'
    File '/oname=$PLUGINSDIR\InstallingBG04.png' 'images\InstallingBG04.png'
  
    StrCpy $R0 $R2 ;改变页面大小,不然贴图不能全页
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 588, i 438) i r2"
    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $R0 $0 ;处理无边框窗体移动
    
    GetDlgItem $R0 $R2 1004  ;设置进度条位置
    System::Call "user32::MoveWindow(i R0, i 30, i 302, i 537, i 12) i r2"

    GetDlgItem $R1 $R2 1006  ;进度条上面的标签
    SetCtlColors $R1 ""  FFFFFF ;背景设成F6F6F6,注意颜色不能设为透明，否则重叠
    System::Call "user32::MoveWindow(i R1, i 30, i 275, i 290, i 12) i r2"

    GetDlgItem $R8 $R2 1016
    ;SetCtlColors $R8 ""  F6F6F6 ;背景设成F6F6F6,注意颜色不能设为透明，否则重叠
    System::Call "user32::MoveWindow(i R8, i 0, i 0, i 588, i 216) i r2"
    
    FindWindow $R2 "#32770" "" $HWNDPARENT  ;获取1995并设置图片
    GetDlgItem $R0 $R2 1995
    System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
    ${NSD_SetImage} $R0 $PLUGINSDIR\bg2.bmp $ImageHandle

		;这里是给进度条贴图
    FindWindow $R2 "#32770" "" $HWNDPARENT
    GetDlgItem $5 $R2 1004
	  SkinProgress::Set $5 "$PLUGINSDIR\ProgressBar.bmp" "$PLUGINSDIR\Progress.bmp"

FunctionEnd


Function Page.3
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}


    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == error
        Abort
    ${EndIf}
    SetCtlColors $0 ""  transparent ;背景设成透明

    ${NSW_SetWindowSize} $0 588 438 ;改变Page大小
    
    
    ${NSD_CreateCheckbox} 20u 160u 66u 10u "开机自动启动"
    Pop $Ckbox4
    SetCtlColors $Ckbox4 "" FFFFFF
		;ShowWindow $Ckbox4 ${SW_HIDE} ;如果不需要可以使用这行隐藏
		${NSD_Check} $Ckbox4 ;默认勾选

    ;立即体验
    ${NSD_CreateButton} 76u 206u 160 54 ""
    Pop $btn_instend
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_express.bmp $btn_instend
    GetFunctionAddress $3 onClickexpress
    SkinBtn::onClick $btn_instend $3

    ;安装完成
    ${NSD_CreateButton} 210u 206u 160 54 ""
    Pop $btn_instend1
    SkinBtn::Set /IMGID=$PLUGINSDIR\btn_finish.bmp $btn_instend1
    GetFunctionAddress $3 onClickend
    SkinBtn::onClick $btn_instend1 $3

    ;贴背景大图
    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $BGImage
    ${NSD_SetImage} $BGImage $PLUGINSDIR\bg3.bmp $ImageHandle

    GetFunctionAddress $0 onGUICallback
    WndProc::onCallback $BGImage $0 ;处理无边框窗体移动
    nsDialogs::Show

    ${NSD_FreeImage} $ImageHandle

FunctionEnd


Function Page.4

FunctionEnd

Section MainSetup
DetailPrint "正在安装..."
Sleep 1000
SetDetailsPrint None ;不显示信息
nsisSlideshow::Show /NOUNLOAD /auto=$PLUGINSDIR\Slides.dat
Sleep 500 ;在安装程序里暂停执行 "休眠时间(单位为:ms)" 毫秒。"休眠时间(单位为:ms)" 可以是一个变量， 例如 "$0" 或一个数字，例如 "666"。
SetOutPath "$INSTDIR\InvoiceClouds"
File /r "py"
File /r "autostart\*.*"
File /r "project\*.*"
Sleep 50
Sleep 50
Sleep 50
Sleep 500
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 500
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 500
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 500
      ${If} $Ckbox1_State == 1
            CreateShortCut "$DESKTOP\票耘.lnk" "$INSTDIR\InvoiceClouds\InvoiceClouds.exe"
      ${EndIf}
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
Sleep 50
    CreateShortCut "$SMPROGRAMS\票耘.lnk" "$INSTDIR\InvoiceClouds\InvoiceClouds.exe"
nsisSlideshow::Stop
SetAutoClose true
SectionEnd

Section -Post
  WriteUninstaller "$INSTDIR\InvoiceClouds\uninst.exe" ;生成卸载文件
  ;WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\InvoiceClouds.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\InvoiceClouds\uninst.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\InvoiceClouds\InvoiceClouds.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLInfoAbout" "https://www.invoiceclouds.com" ;这些信息需要自己修改
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "URLUpdateInfo" "https://www.invoiceclouds.com" ;这些信息需要自己修改
SectionEnd

#----------------------------------------------
#创建控制面板卸载程序信息
#----------------------------------------------

Section -Post
  WriteUninstaller "$INSTDIR\InvoiceClouds\uninst.exe" ;这个是生成卸载程序,对于迅雷，我们可以使用原版的卸载程序，所以不要这个了
  ;WriteRegStr HKLM "${PRODUCT_DIR_REGKEY}" "" "$INSTDIR\Program\Thunder.exe"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayName" "$(^Name)"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "UninstallString" "$INSTDIR\InvoiceClouds\uninst.exe" ;这里建议自己修改.这里是卸载程序的路径和文件名。
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayIcon" "$INSTDIR\InvoiceClouds\InvoiceClouds.exe" ;显示在你的应用程序名称旁边的图标的路径，文件名和索引。
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "DisplayVersion" "${PRODUCT_VERSION}"
  WriteRegStr ${PRODUCT_UNINST_ROOT_KEY} "${PRODUCT_UNINST_KEY}" "Publisher" "${PRODUCT_PUBLISHER}"
SectionEnd

Function ABORT
MessageBox MB_ICONQUESTION|MB_YESNO|MB_ICONSTOP '您确定要退出"票耘${PRODUCT_VERSION}"安装程序？' IDNO CANCEL
SendMessage $hwndparent ${WM_CLOSE} 0 0
CANCEL:
Abort
FunctionEnd

;处理页面跳转的命令
Function RelGotoPage
  IntCmp $R9 0 0 Move Move
    StrCmp $R9 "X" 0 Move
      StrCpy $R9 "120"
  Move:
  SendMessage $HWNDPARENT "0x408" "$R9" ""
FunctionEnd

Function onClickins

	${NSD_GetText} $Txt_Browser  $R0  ;获得设置的安装路径

   ;判断目录是否正确
	ClearErrors
	CreateDirectory "$R0"
	IfErrors 0 +3
  MessageBox MB_ICONINFORMATION|MB_OK "'$R0' 安装目录不存在，请重新设置。"
  Return

	StrCpy $INSTDIR  $R0  ;保存安装路径

  StrCpy $R9 1 ;Goto the next page
  Call RelGotoPage
  Abort
FunctionEnd

;当单击自定义安装后隐藏和显示一部分控件
Function onClickint
ShowWindow $BGImage ${SW_HIDE}
ShowWindow $Ckbox0 ${SW_HIDE}


ShowWindow $btn_in ${SW_HIDE}
ShowWindow $btn_ins ${SW_HIDE}


ShowWindow $BGImage1 ${SW_SHOW}
ShowWindow $btn_instetup ${SW_SHOW}
ShowWindow $btn_back ${SW_SHOW}
ShowWindow $Ckbox1 ${SW_SHOW}
ShowWindow $btn_Browser ${SW_SHOW}
ShowWindow $Txt_Browser ${SW_SHOW}

FunctionEnd

;点击返回时隐藏显示部分控件
Function onClickBack
ShowWindow $BGImage1 ${SW_HIDE}

ShowWindow $BGImage ${SW_SHOW}

ShowWindow $Ckbox0 ${SW_SHOW}
ShowWindow $btn_in ${SW_HIDE}
ShowWindow $btn_ins ${SW_HIDE}
ShowWindow $btn_in ${SW_SHOW}
ShowWindow $btn_ins ${SW_SHOW}


ShowWindow $BGImage1 ${SW_HIDE}
ShowWindow $btn_instetup ${SW_HIDE}
ShowWindow $btn_back ${SW_HIDE}
ShowWindow $Ckbox1 ${SW_HIDE}
ShowWindow $btn_Browser ${SW_HIDE}
ShowWindow $Txt_Browser ${SW_HIDE}
FunctionEnd


Function textClick
   ExecShell "open" "https://www.invoiceclouds.com/upload"
FunctionEnd

#--------------------------------------------------------
# 路径选择按钮事件，打开Windows系统自带的目录选择对话框
#--------------------------------------------------------
Function onClickSelectPath


	 ${NSD_GetText} $Txt_Browser  $0
   nsDialogs::SelectFolderDialog  "请选择 ${PRODUCT_NAME} 安装目录："  "$0"
   Pop $0
   ${IfNot} $0 == error
			${NSD_SetText} $Txt_Browser  $0
	${EndIf}

FunctionEnd

;立即体验检测
Function onClickexpress
${NSD_GetState} $Ckbox4 $0
    ${If} $0 == 1
    ;SetShellVarContext all
      
  	;CreateShortCut "$SMSTARTUP\票耘.lnk" "$INSTDIR\InvoiceClouds\InvoiceClouds.exe" ;'选中：开机自动启动'
  	;SetRegView 32
      WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "InvoiceClouds" "$INSTDIR\InvoiceClouds\invoice.exe"
      ;WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\InvoiceClouds\InvoiceClouds.exe" "RUNASADMIN"
    ${EndIf}
Exec "$INSTDIR\InvoiceClouds\InvoiceClouds.exe" ;这个不需要选中也操作
SendMessage $hwndparent ${WM_CLOSE} 0 0
FunctionEnd

;完成页面完成按钮
Function onClickend
${NSD_GetState} $Ckbox4 $0
    ${If} $0 == 1
    ;SetShellVarContext all
  	;CreateShortCut "$SMSTARTUP\票耘.lnk" "$INSTDIR\InvoiceClouds\InvoiceClouds.exe" ;'选中：开机自动启动'
  	;SetRegView 32
      WriteRegStr HKCU "Software\Microsoft\Windows\CurrentVersion\Run" "InvoiceClouds" "$INSTDIR\InvoiceClouds\invoice.exe"
      ;WriteRegStr HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\InvoiceClouds\InvoiceClouds.exe" "RUNASADMIN"
  ${EndIf}
SendMessage $hwndparent ${WM_CLOSE} 0 0
FunctionEnd


# ................. UNINSTALL  卸载区域 ....................

var /global Un.MSG

Function 'un.onInit'
	;SetShellVarContext all
	;IfSilent 0 +3
	;  MessageBox MB_ICONQUESTION|MB_YESNO|MB_TOPMOST "$(NSIS.Msg.Uninstall)" IDYES next IDNO +2
	   ;Abort
	;HideWindow
      ;!insertmacro RequireAdmin

      /*System::Call 'kernel32::CreateMutexA(i 0, i 0, t "InvoiceClouds") i .r1 ?e'
        Pop $R1		;;;;$$$$$安装程序已经运行
        StrCmp $R1 0 +3
        MessageBox MB_ICONSTOP|MB_ICONINFORMATION|MB_TOPMOST "卸载程序检测到 ${PRODUCT_NAME} 正在运行，请关闭之后再卸载！"
        Quit
        ;Abort*/

      /*FindProcDLL::FindProc "InvoiceClouds.exe"
      Pop $R0
      IntCmp $R0 1 0 no_run
            MessageBox MB_ICONSTOP "卸载程序检测到 ${PRODUCT_NAME} 正在运行，请关闭之后再卸载！"
      Quit
      no_run:*/

	InitPluginsDir

	File `/ONAME=$PLUGINSDIR\uninstall_btn_chancel.bmp` `Images\uninstall_btn_chancel.bmp`
	File `/ONAME=$PLUGINSDIR\uninstall_btn_finish.bmp` `Images\uninstall_btn_finish.bmp`
	File `/ONAME=$PLUGINSDIR\uninstall_btn_ok.bmp` `Images\uninstall_btn_ok.bmp`
	File `/ONAME=$PLUGINSDIR\uninstall_finish.bmp` `Images\uninstall_finish.bmp`
	File `/ONAME=$PLUGINSDIR\uninstall_ing.bmp` `Images\uninstall_ing.bmp`
	File `/ONAME=$PLUGINSDIR\uninstall_start.bmp` `Images\uninstall_start.bmp`
	File `/ONAME=$PLUGINSDIR\loading1.bmp` `Images\loading1.bmp`
	File `/ONAME=$PLUGINSDIR\loading2.bmp` `Images\loading2.bmp`
 	File `/oname=$PLUGINSDIR\quit.bmp` "images\quit.bmp"

 	File `/oname=$PLUGINSDIR\btn_ok.bmp` "images\btn_ok.bmp"
 	File `/oname=$PLUGINSDIR\btn_cancel.bmp` "images\btn_cancel.bmp"

        SkinBtn::Init "$PLUGINSDIR\check_savedata.bmp"
        SkinBtn::Init "$PLUGINSDIR\check_savedata_ok.bmp"
        SkinBtn::Init "$PLUGINSDIR\uninstall_btn_chancel.bmp"
        SkinBtn::Init "$PLUGINSDIR\uninstall_btn_finish.bmp"
        SkinBtn::Init "$PLUGINSDIR\uninstall_btn_ok.bmp"
        SkinBtn::Init "$PLUGINSDIR\btn_ok.bmp"
        SkinBtn::Init "$PLUGINSDIR\btn_cancel.bmp"

	# FONT

	InitPluginsDir
	File '/oname=$PLUGINSDIR\BAARS.ttf' 'Fonts\BAARS.ttf'

	IfFileExists "$FONTS\BAARS.ttf" "Un.Continue" "Un.InstallFont"
	StrCmp $0 1 "Un.Continue" "Un.InstallFont"
	${If} "$0" == "1"
	  Un.Continue:

	${ElseIf} $0 == "0"
 	  Un.InstallFont:

	  ;setShellVarContext all

 	  SetOutPath "$FONTS"

	  CopyFiles /SILENT /FILESONLY "$PLUGINSDIR\BAARS.ttf" "$FONTS\BAARS.ttf"

 	  Push "$FONTS\BAARS.ttf"
 	  System::Call 'GDI32::AddFontResourceEx(t"$PLUGINSDIR\BAARS.ttf",i 0x30,i0)'
 	  System::Call "Gdi32::AddFontResource(t s) i .s"
 	  Pop $0
 	  IntCmp $0 0 0 +2 +2
 	  SendMessage ${HWND_BROADcast} ${WM_FONTCHANGE} 0 0
	${EndIf}
FunctionEnd

Function un.GUIInit

    GetDlgItem $0 $HWNDPARENT 1037
    SetCtlColors $0 "" 0xFFFFFF
    GetDlgItem $0 $HWNDPARENT 1038
    SetCtlColors $0 "" 0xFFFFFF
    GetDlgItem $0 $HWNDPARENT 1034
    SetCtlColors $0 "" 0xFFFFFF
    GetDlgItem $0 $HWNDPARENT 1039
    SetCtlColors $0 "" 0xFFFFFF
    GetDlgItem $0 $HWNDPARENT 1028
    SetCtlColors $0 /BRANDING ""
    GetDlgItem $0 $HWNDPARENT 1256
    SetCtlColors $0 /BRANDING ""

    System::Call user32::GetWindowLong(i$HWNDPARENT,i-16)i.R0
    IntOp $1 0x00C00000 ~    ; ^ 0xFFFFFFFF
    IntOp $0 $R0 & $1
    System::Call user32::SetWindowLong(i$HWNDPARENT,i-16,$0)i.R0
    System::Call user32::GetWindowLong(i$HWNDPARENT,i-20)i.R0
    IntOp $1 0x00000100 ~    ; ^ 0xFFFFFFFF
    IntOp $0 $R0 & $1
    System::Call user32::SetWindowLong(i$HWNDPARENT,i-20,$0)i.R0
    GetDlgItem $0 $HWNDPARENT 1034
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1035
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1036
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1037
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1038
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1039
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1256
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1028
    ShowWindow $0 ${SW_HIDE}
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
FunctionEnd

# Welcome Uninstall Page

var Un.BGImage
var Un.IMAGE

;var Un.Btn_CkSaveData
;var Un_Bool_CkSaveData

;var Un_Btn_Close
var Un_Btn_UninstallOk
var Un_Btn_Chancel

Function un.ModifyUnConfirm

    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1990
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1991
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1992
    ShowWindow $0 ${SW_HIDE}

    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == 'error'
   	Abort
    ${EndIf}
    SetCtlColors $0 "" 'transparent'

    System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i552,i333,i0x0002)
    System::Call user32::SetWindowPos(i$0,i0,i0,i0,i552,i333,i0x0002)

    nsDialogs::CreateControl BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 341 282 90 35 ""
    Pop $Un_Btn_UninstallOk
    SkinBtn::Set /IMGID=$PLUGINSDIR\uninstall_btn_ok.bmp $Un_Btn_UninstallOk
    GetFunctionAddress $3 "un.on.Click.Uninstall"
    SkinBtn::onClick $Un_Btn_UninstallOk $3

    SetCtlColors $Un_Btn_UninstallOk "" "transparent"

    nsDialogs::CreateControl BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 441 282 90 35 ""
    Pop $Un_Btn_Chancel
    SkinBtn::Set /IMGID=$PLUGINSDIR\uninstall_btn_chancel.bmp $Un_Btn_Chancel
    GetFunctionAddress $3 "un.On_Click_Chancel.App"
    SkinBtn::onClick $Un_Btn_Chancel $3

    SetCtlColors $Un_Btn_Chancel "" "transparent"

    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $Un.BGImage
    ${NSD_SetImage} $Un.BGImage "$PLUGINSDIR\uninstall_start.bmp" $Un.IMAGE

    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $Un.BGImage $0

    nsDialogs::Show

    ${NSD_FreeIcon} $R0
    ${NSD_FreeImage} $Un.IMAGE
    System::Call "user32::DestroyIcon(iR0)"
    System::Call 'user32::DestroyImage(iR0)'
    System::Call "gdi32::DeleteObject(i$Un.IMAGE)"
FunctionEnd

Function un.on.Click.Uninstall
   /*System::Call 'kernel32::CreateMutexA(i 0, i 0, t "InvoiceClouds") i .r1 ?e'
        Pop $R1		;;;;$$$$$安装程序已经运行
        StrCmp $R1 0 +3
        MessageBox MB_ICONSTOP|MB_ICONINFORMATION|MB_TOPMOST "卸载程序检测到 ${PRODUCT_NAME} 正在运行，请关闭之后再卸载！"
        Quit*/
        ;Abort
   SendMessage $HWNDPARENT 0x408 1 0
FunctionEnd

# Uninstall Warning

;var /global Un.Dialog
;var /global Un.Btn_Cancel
;var /global Un.Btn_OkClose

Function un.On_Click_Chancel.App
	SendMessage $hwndparent ${WM_CLOSE} 0 0
FunctionEnd

# Section Uninstall

Section "Uninstall"

   SetDetailsPrint textonly
   ;DetailPrint `Uninstall Files...`
   SetDetailsPrint listonly
   SetDetailsView hide

   Sleep 50
   Sleep 50

   ;SetShellVarContext all

   Delete "$INSTDIR\InvoiceClouds\scratch\*.*"
   Delete "$INSTDIR\InvoiceClouds\py\main\*.*"
   Delete "$INSTDIR\InvoiceClouds\py\update\*.*"
   Delete "$INSTDIR\InvoiceClouds\db\*.*"
   Delete "$INSTDIR\InvoiceClouds\logs\*.*"
   Delete "$INSTDIR\InvoiceClouds\resources\*.*"
   Delete "$INSTDIR\InvoiceClouds\locales\*.*"

   Sleep 50
   Sleep 50

   Delete "$INSTDIR\InvoiceClouds\uninst.exe"
   Delete "$DESKTOP\票耘.lnk"
   Delete "$SMPROGRAMS\票耘.lnk"
   delete "$SMSTARTUP\票耘.lnk"

   RMDir /r "$INSTDIR\InvoiceClouds\scratch"
   RMDir /r "$INSTDIR\InvoiceClouds\py\main"
   RMDir /r "$INSTDIR\InvoiceClouds\py\update"
   RMDir /r "$INSTDIR\InvoiceClouds\py"
   RMDir /r "$INSTDIR\InvoiceClouds\db"
   RMDir /r "$INSTDIR\InvoiceClouds\logs"
   RMDir /r "$INSTDIR\InvoiceClouds\locales"
   RMDir /r "$INSTDIR\InvoiceClouds\resources"
   
   RMDir /r "$SMPROGRAMS\InvoiceClouds\InvoiceClouds"
   RMDir /r "$SMPROGRAMS\InvoiceClouds"
   


   Delete "$INSTDIR\*.*"

   Sleep 50
   Sleep 50
   
   DeleteRegValue HKCU "Software\Microsoft\Windows NT\CurrentVersion\AppCompatFlags\Layers" "$INSTDIR\InvoiceClouds\InvoiceClouds.exe"
   DeleteRegKey /ifempty HKCU "Software\Microsoft\Windows\CurrentVersion\Run\票耘"
   DeleteRegKey /ifempty HKCU "Software\Microsoft\Windows\CurrentVersion\Run\InvoiceClouds"
   
   RMDir "$INSTDIR\InvoiceClouds"
   RMDir "$PROGRAMFILES\InvoiceClouds\InvoiceClouds"
   RMDir /r "$INSTDIR"
   RMDir /r "$INSTDIR"
   RMDir "$PROGRAMFILES\InvoiceClouds"
   RMDir "$INSTDIR"

   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 1500
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50

   DeleteRegKey /ifempty HKLM "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${PRODUCT_NAME}"

   Sleep 50
   Sleep 50
   
   SetDetailsPrint textonly
   ;DetailPrint `卸载成功...`
   SetDetailsPrint listonly
   SetDetailsView hide

   System::Call /NOUNLOAD "shell32::SHChangeNotify(i, i, i, i) v (0x08000000, 0, 0, 0)"

   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 1500
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 1500
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 500
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 500
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 500
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50
   Sleep 50

   Quit
   SetAutoClose true
SectionEnd

# Uninstall Files

Function Un.InstFilesPageShow
  FindWindow $R2 "#32770" "" $HWNDPARENT

  ShowWindow $0 ${SW_HIDE}
  GetDlgItem $1 $R2 1027
  ShowWindow $1 ${SW_HIDE}

  StrCpy $R0 $R2
  System::Call "user32::MoveWindow(i R0, i 0, i 0, i 552, i 333) i r2"
  GetFunctionAddress $0 un.onGUICallback
  WndProc::onCallback $R0 $0

  GetDlgItem $R0 $R2 1004
  SetCtlColors $R2 "0x4A766E" "transparent"
  System::Call "user32::MoveWindow(i R0, i 0, i 244, i 552, i 6) i r2"

  GetDlgItem $R1 $R2 1006
  SetCtlColors $R1 "0x4A766E" "transparent"
  System::Call "user32::MoveWindow(i R1, i 10, i 210, i 540, i 15) i r2"
  CreateFont $1 "Baar Sophia" "12" "400"
  SendMessage $R1 ${WM_SETFONT} $1 0

  GetDlgItem $R8 $R2 1016
  SetCtlColors $R8 "0x4A766E" "transparent"
  System::Call "user32::MoveWindow(i R8, i 0, i 0, i 588, i 216) i r2"

  FindWindow $R2 "#32770" "" $HWNDPARENT
  GetDlgItem $R0 $R2 1995
  System::Call "user32::MoveWindow(i R0, i 0, i 0, i 498, i 373) i r2"
  ${NSD_SetImage} $R0 $PLUGINSDIR\uninstall_ing.bmp $ImageHandle
  ;${NSD_SetImage} $R0 $PLUGINSDIR\uninstall_ing.bmp $IMAGE
  
  FindWindow $R2 "#32770" "" $HWNDPARENT
  GetDlgItem $5 $R2 1004
  SkinProgress::Set $5 "$PLUGINSDIR\loading2.bmp" "$PLUGINSDIR\loading1.bmp"
  ;w7tbp::Start
FunctionEnd

# Finish Page Uninstall

var Un_Btn_Finish

Function un.FinishPage

    GetDlgItem $0 $HWNDPARENT 1
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 2
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 3
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1990
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1991
    ShowWindow $0 ${SW_HIDE}
    GetDlgItem $0 $HWNDPARENT 1992
    ShowWindow $0 ${SW_HIDE}

    nsDialogs::Create 1044
    Pop $0
    ${If} $0 == 'error'
   	Abort
    ${EndIf}
    SetCtlColors $0 "" 'transparent'

    System::Call user32::SetWindowPos(i$HWNDPARENT,i0,i0,i0,i552,i333,i0x0002)
    System::Call user32::SetWindowPos(i$0,i0,i0,i0,i552,i333,i0x0002)

    nsDialogs::CreateControl BUTTON 0x40000000|0x10000000|0x04000000|0x00010000 0 441 275 90 35 ""
    Pop $Un_Btn_Finish
    SkinBtn::Set /IMGID=$PLUGINSDIR\uninstall_btn_finish.bmp $Un_Btn_Finish
    GetFunctionAddress $3 "un.On_Click_Finish_Uninstaller"
    SkinBtn::onClick $Un_Btn_Finish $3

    SetCtlColors $Un_Btn_Finish "" "transparent"

    ${NSD_CreateBitmap} 0 0 100% 100% ""
    Pop $Un.BGImage
    ${NSD_SetImage} $Un.BGImage "$PLUGINSDIR\uninstall_finish.bmp" $Un.IMAGE

    GetFunctionAddress $0 un.onGUICallback
    WndProc::onCallback $Un.BGImage $0

    nsDialogs::Show

    ${NSD_FreeIcon} $R0
    ${NSD_FreeImage} $Un.IMAGE
    System::Call "user32::DestroyIcon(iR0)"
    System::Call 'user32::DestroyImage(iR0)'
    System::Call "gdi32::DeleteObject(i$Un.IMAGE)"
FunctionEnd

Function un.On_Click_Finish_Uninstaller
   SendMessage $hwndparent ${WM_CLOSE} 0 0
   /*Push "$FONTS\BAARS.ttf"
   System::Call 'Gdi32::RemoveFontResourceEx(t"$PLUGINSDIR\BAARS.ttf",i 0x30,i0)'
   System::Call "Gdi32::RemoveFontResource(t s) i .s"
   Pop $0
   IntCmp $0 0 0 +2 +2
   SendMessage ${HWND_BROADcast} ${WM_FONTCHANGE} 0 0

   Delete "$PLUGINSDIR\BAARS.ttf"
   Sleep 150

   SendMessage $HWNDPARENT ${WM_CLOSE} 0 0*/
   ;SendMessage $HWNDPARENT 0x408 1 0
FunctionEnd

# Uninstall Call Back

Function un.onGUICallback
    Strcpy $Un.MSG '0'
    ${If} $Un.MSG = ${WM_LBUTTONDOWN}
    	SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
    ${EndIf}
FunctionEnd

/*Function Un.onWarningGUICallback
    Strcpy $Un.MSG '0'
    ${If} $Un.MSG = ${WM_LBUTTONDOWN}
    SendMessage $HWNDPARENT ${WM_NCLBUTTONDOWN} ${HTCAPTION} $0
  ${EndIf}
FunctionEnd*/

/*Function Un.onGUIEnd
  System::Call `gdi32:DeleteObject(i s)` ;$IMAGE
  System::Call "user32::DestroyIcon(iR0)"
  System::Call 'user32::DestroyImage(iR0)'
FunctionEnd*/






