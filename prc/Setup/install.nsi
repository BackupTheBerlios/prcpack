; Script generated with the Venis Install Wizard

; Define your application name
!define APPNAME "PRC Pack"
!define APPNAMEANDVERSION "PRC Pack 2.0"

; Enable LZMA compression for the smallest EXE.
SetCompressor lzma

; Main Install settings
Name "${APPNAMEANDVERSION}"
InstallDir "$PROGRAMFILES\PRC Pack"
InstallDirRegKey HKLM "Software\${APPNAME}" ""
OutFile "..\CompiledResources\Setup.exe"
Var NWNVERSION
Var NWNPATH
Var NWNPRCPATH

; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_TEXT "The PRC Pack is now installed.  You can now run the PRC installer to add the PRC pack to modules."
!define MUI_FINISHPAGE_SHOWREADME "$NWNPRCPATH\PRCPack\prc_consortium.txt"
!define MUI_FINISHPAGE_RUN_TEXT "Install the PRC pack in modules now"
!define MUI_FINISHPAGE_RUN "$NWNPRCPATH\PRCPack\PRCInstaller.exe"

!define MUI_WELCOMEPAGE_TEXT "The PRC pack will now be installed into your installation of Neverwinter Nights.\r\n\r\n\r\nNeverwinter Nights version $NWNVERSION is currently installed at $NWNPATH."

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH

!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES

; Set languages (first is default language)
!insertmacro MUI_LANGUAGE "English"
!insertmacro MUI_RESERVEFILE_LANGDLL

Section "PRC Pack" Section1

	; Set Section properties
	SetOverwrite on

	; Set Section Files and Shortcuts
	SetOutPath "$NWNPATH\hak\"
	File "..\CompiledResources\PRC Pack.hif"
	File "..\CompiledResources\prc_2das.hak"
	File "..\CompiledResources\prc_craft2das.hak"
	File "..\CompiledResources\prc_misc.hak"
	File "..\CompiledResources\prc_scripts.hak"
	File "..\CompiledResources\prc_textures.hak"
	SetOutPath "$NWNPATH\tlk\"
	File "..\tlk\prc_consortium.tlk"
	SetOutPath "$NWNPRCPATH\PRCPack\"
	File "..\CompiledResources\PRCInstaller.exe"
	File "..\prc_consortium.htm"
	File "..\prc_consortium.txt"
	SetOutPath "$NWNPATH\erf\"
	File "..\CompiledResources\prc_consortium.erf"
	CreateShortCut "$DESKTOP\PRC Installer.lnk" "$NWNPRCPATH\PRCPack\PRCInstaller.exe"
	CreateDirectory "$SMPROGRAMS\PRC Pack"
	CreateShortCut "$SMPROGRAMS\PRC Pack\PRC Installer.lnk" "$NWNPRCPATH\PRCPack\PRCInstaller.exe"
	CreateShortCut "$SMPROGRAMS\PRC Pack\Uninstall.lnk" "$NWNPRCPATH\PRCPack\uninstall.exe"
	CreateShortCut "$SMPROGRAMS\PRC Pack\Read Me.lnk" "$NWNPRCPATH\PRCPack\prc_consortium.txt"

SectionEnd

Section -FinishSection

	WriteRegStr HKLM "Software\${APPNAME}" "" "$NWNPRCPATH\PRCPack"
	WriteRegStr HKLM "Software\${APPNAME}" "PRCPath" "$NWNPRCPATH"
	WriteRegStr HKLM "Software\${APPNAME}" "NWNPath" "$NWNPATH"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "DisplayName" "${APPNAME}"
	WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}" "UninstallString" "$NWNPRCPATH\PRCPack\uninstall.exe"
	WriteUninstaller "$NWNPRCPATH\PRCPack\uninstall.exe"

SectionEnd

; Modern install component descriptions
!insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
	!insertmacro MUI_DESCRIPTION_TEXT ${Section1} ""
!insertmacro MUI_FUNCTION_DESCRIPTION_END

;Uninstall section
Section Uninstall
	; Read the install paths from the registry.  Then delete them.
	ReadRegStr $NWNPRCPATH HKLM "Software\${APPNAME}" "PRCPath"
	ReadRegStr $NWNPATH HKLM "Software\${APPNAME}" "NWNPath"

	;Remove from registry...
	DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${APPNAME}"
	DeleteRegKey HKLM "SOFTWARE\${APPNAME}"

	; Delete self
	Delete "$NWNPRCPATH\PRCPack\uninstall.exe"

	; Delete Shortcuts
	Delete "$DESKTOP\PRC Installer.lnk"
	Delete "$SMPROGRAMS\PRC Pack\PRC Installer.lnk"
	Delete "$SMPROGRAMS\PRC Pack\Uninstall.lnk"
	Delete "$SMPROGRAMS\PRC Pack\Read Me.lnk"

	; Clean up PRC Pack
	Delete "$NWNPATH\hak\PRC Pack.hif"
	Delete "$NWNPATH\hak\prc_2das.hak"
	Delete "$NWNPATH\hak\prc_craft2das.hak"
	Delete "$NWNPATH\hak\prc_misc.hak"
	Delete "$NWNPATH\hak\prc_scripts.hak"
	Delete "$NWNPATH\hak\prc_textures.hak"
	Delete "$NWNPATH\tlk\prc_consortium.tlk"
	Delete "$NWNPATH\erf\prc_consortium.erf"
	Delete "$NWNPRCPATH\PRCPack\PRCInstaller.exe"
	Delete "$NWNPRCPATH\PRCPack\prc_consortium.htm"
	Delete "$NWNPRCPATH\PRCPack\prc_consortium.txt"

	; Remove remaining directories
	RMDir "$SMPROGRAMS\PRC Pack"
	RMDir "$NWNPRCPATH\PRCPack\"

SectionEnd

; This function loads the NWN installed version and path from the registry
; aborting the install if they are not there.
Function .onInit
	ReadRegStr $NWNVERSION HKEY_LOCAL_MACHINE "SOFTWARE\BioWare\NWN\Neverwinter" "Version"
	ReadRegStr $NWNPATH HKEY_LOCAL_MACHINE "SOFTWARE\BioWare\NWN\Neverwinter" "Location"
	IfErrors noNWN
	
	; Get the parent directory of the $NWNPATH to use for the prc pack, since
	; the NWN install path always has the nwn\ folder which contains the game,
	; we want the PRC installer EXE and readme's to be parallel to that.
	Push $NWNPATH
	Call GetParent
	Pop $NWNPRCPATH
	
	Return
	
	noNWN:
	MessageBox MB_OK|MB_ICONEXCLAMATION "Neverwinter Nights is not installed on your PC.  The PRC pack cannot be installed until Neverwinter Nights is installed."
	Abort
FunctionEnd

 ; GetParent
 ; input, top of stack  (e.g. C:\Program Files\Poop)
 ; output, top of stack (replaces, with e.g. C:\Program Files)
 ; modifies no other variables.
 ;
 ; Usage:
 ;   Push "C:\Program Files\Directory\Whatever"
 ;   Call GetParent
 ;   Pop $R0
 ;   ; at this point $R0 will equal "C:\Program Files\Directory"

 Function GetParent
 
   Exch $R0
   Push $R1
   Push $R2
   Push $R3
   
   StrCpy $R1 0
   StrLen $R2 $R0
   
   loop:
     IntOp $R1 $R1 + 1
     IntCmp $R1 $R2 get 0 get
     StrCpy $R3 $R0 1 -$R1
     StrCmp $R3 "\" get
     Goto loop
   
   get:
     StrCpy $R0 $R0 -$R1
     
     Pop $R3
     Pop $R2
     Pop $R1
     Exch $R0
     
 FunctionEnd
 
; eof