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
Var NWNMINVERSION

; Modern interface settings
!include "MUI.nsh"

!define MUI_ABORTWARNING
!define MUI_FINISHPAGE_TEXT "The PRC Pack is now installed.  You can now run the PRC installer to add the PRC pack to modules."
!define MUI_FINISHPAGE_SHOWREADME "$NWNPRCPATH\PRCPack\prc_consortium.htm"
!define MUI_FINISHPAGE_RUN_TEXT "Install the PRC pack in modules now"
!define MUI_FINISHPAGE_RUN "$NWNPRCPATH\PRCPack\PRCModuleUpdater.exe"

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
	File "..\CompiledResources\PRCModuleUpdater.exe"
	File "..\prc_consortium.htm"
	SetOutPath "$NWNPATH\erf\"
	File "..\CompiledResources\prc_consortium.erf"
	CreateShortCut "$DESKTOP\PRC Module Updater.lnk" "$NWNPRCPATH\PRCPack\PRCModuleUpdater.exe"
	CreateDirectory "$SMPROGRAMS\PRC Pack"
	CreateShortCut "$SMPROGRAMS\PRC Pack\PRC Module Updater.lnk" "$NWNPRCPATH\PRCPack\PRCModuleUpdater.exe"
	CreateShortCut "$SMPROGRAMS\PRC Pack\Uninstall.lnk" "$NWNPRCPATH\PRCPack\uninstall.exe"
	CreateShortCut "$SMPROGRAMS\PRC Pack\Read Me.lnk" "$NWNPRCPATH\PRCPack\prc_consortium.htm"

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
	Delete "$DESKTOP\PRC Module Updater.lnk"
	Delete "$SMPROGRAMS\PRC Pack\PRC Module Updater.lnk"
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
	Delete "$NWNPRCPATH\PRCPack\PRCModuleUpdater.exe"
	Delete "$NWNPRCPATH\PRCPack\prc_consortium.htm"

	; Remove remaining directories
	RMDir "$SMPROGRAMS\PRC Pack"
	RMDir "$NWNPRCPATH\PRCPack\"

SectionEnd

; This function loads the NWN installed version and path from the registry
; aborting the install if they are not there.
Function .onInit
	; Minimum version of NWN that the installer requires, just set
	; the string to the part after the 1., i.e. for 1.62 set the
	; string to "62"
	StrCpy $NWNMINVERSION "62"

	; Read the NWN intall path and installed version from the registry.  If we get any
	; errors assume NWN is not installed correctly.
	ReadRegStr $NWNVERSION HKEY_LOCAL_MACHINE "SOFTWARE\BioWare\NWN\Neverwinter" "Version"
	ReadRegStr $NWNPATH HKEY_LOCAL_MACHINE "SOFTWARE\BioWare\NWN\Neverwinter" "Location"
	IfErrors noNWN
		
	; Validate that NWNMINVERSION or later of NWN is installed.
	Push $0
	StrCpy $0 $NWNVERSION 2 2
	IntCmp $0 $NWNMINVERSION okNWN badNWN
	Pop $0
	
	okNWN:
	; Get the parent directory of the $NWNPATH to use for the prc pack, since
	; the NWN install path always has the nwn\ folder which contains the game,
	; we want the PRC installer EXE and readme's to be parallel to that.
	Push $NWNPATH
	Call GetParent
	Pop $NWNPRCPATH
	
	; Make sure that 1.1 or later of the .NET framework is installed.
	Call IsDotNETInstalled
	Pop $0
	StrCmp $0 1 foundNETFramework noNETFramework

	foundNETFramework:
	Return
	
	noNETFramework:
	MessageBox MB_OK|MB_ICONEXCLAMATION "The .NET Framework 1.1 is not installed on your PC.  The PRC pack cannot be installed until the .NET Framwwork 1.1 is installed.  Use Windows Update to install the .NET Framework 1.1 or later, or download it from the following web page."
	ExecShell open "http://www.microsoft.com/downloads/details.aspx?FamilyID=262d25e3-f589-4842-8157-034d1e7cf3a3&DisplayLang=en"
	Abort
	
	badNWN:
	MessageBox MB_OK|MB_ICONEXCLAMATION "The PRC pack requires at least version 1.62 of NWN.  You must upgrade NWN before installing the PRC pack."
	Abort
	
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
 
 ; IsDotNETInstalled
 ;
 ; Usage:
 ;   Call IsDotNETInstalled
 ;   Pop $0
 ;   StrCmp $0 1 found.NETFramework no.NETFramework

 Function IsDotNETInstalled
   Push $0
   Push $1
   Push $2
   Push $3
   Push $4

   ReadRegStr $4 HKEY_LOCAL_MACHINE \
     "Software\Microsoft\.NETFramework" "InstallRoot"
   # remove trailing back slash
   Push $4
   Exch $EXEDIR
   Exch $EXEDIR
   Pop $4
   # if the root directory doesn't exist .NET is not installed
   IfFileExists $4 0 noDotNET

   StrCpy $0 0

   EnumStart:

     EnumRegKey $2 HKEY_LOCAL_MACHINE \
       "Software\Microsoft\.NETFramework\Policy"  $0
     IntOp $0 $0 + 1
     StrCmp $2 "" noDotNET
		 StrCmp $2 "v1.0" EnumStart

     StrCpy $1 0

     EnumPolicy:

       EnumRegValue $3 HKEY_LOCAL_MACHINE \
         "Software\Microsoft\.NETFramework\Policy\$2" $1
       IntOp $1 $1 + 1
        StrCmp $3 "" EnumStart
         IfFileExists "$4\$2.$3" foundDotNET EnumPolicy

   noDotNET:
     StrCpy $0 0
     Goto done

   foundDotNET:
     StrCpy $0 1

   done:
     Pop $4
     Pop $3
     Pop $2
     Pop $1
     Exch $0
 FunctionEnd
 
; eof