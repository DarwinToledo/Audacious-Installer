#===========================================================
# Audacious Installer - v2.0
#===========================================================
; Copyright 2016 Darwin Toledo
; Based on audaciois.nsi - Copyright 2013-2016 Carlo Bramini and John Lindgren
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions are met:
;
; 1. Redistributions of source code must retain the above copyright notice,
;    this list of conditions, and the following disclaimer.
;
; 2. Redistributions in binary form must reproduce the above copyright notice,
;    this list of conditions, and the following disclaimer in the documentation
;    provided with the distribution.
;
; This software is provided "as is" and without any warranty, express or
; implied. In no event shall the authors be liable for any damages arising from
; the use of this software.
#===========================================================
# INCLUDES
#===========================================================


      !include "MUI2.nsh"
      ;!include "LogicLib.nsh"
      

#===========================================================
#DEFINES
#===========================================================

      ;!define DEV
      ;!define DEV2

      !define PRODUCT_NAME    "Audacious"
      !define PRODUCT_WEBSITE "http://audacious-media-player.org/"
      !define BUILDDIR        "C:\aud-win32" ; Location of local build
      
      !define /date DATE "%Y%b%d-%H%M%S" ;this define a hour, minute, second, year, mont and year


         !define PRODUCT_VERSION_FULL "3.8.0.0"
      !ifdef DEV2
         #Version
         !define VERSION "@PACKAGE_VERSION@"
      !else
         !define VERSION "3.8-beta2"
      !endif
      
#===========================================================
# INSTALLER ATTRIBUTES
#===========================================================

          Name             "${PRODUCT_NAME}"
          Caption          "${PRODUCT_NAME} v${VERSION}"
          Brandingtext     "${PRODUCT_NAME} v${VERSION}"
          OutFile          "${PRODUCT_NAME}-${VERSION}-win32-${DATE}.exe"
          RequestExecutionLevel admin

          SetCompressor    /FINAL /SOLID lzma
          CRCCheck         On
          XPStyle          On

          InstallDir       "$PROGRAMFILES\${PRODUCT_NAME}"


          VIProductVersion "${PRODUCT_VERSION_FULL}"
          VIAddVersionKey  ProductName     "Audacious"
          VIAddVersionKey  ProductVersion  "${VERSION}"
          VIAddVersionKey  CompanyName     "${PRODUCT_WEBSITE}"
          VIAddVersionKey  LegalCopyright  "©2016  Audacious. All rights reserved."
          VIAddVersionKey  FileVersion     "${PRODUCT_VERSION_FULL}"
          VIAddVersionKey  FileDescription "Audacious audio player"
          VIAddVersionKey  Comment         "${PRODUCT_NAME}-${VERSION}-${DATE}-win32"


#===========================================================
# INSTALLER MUI ATTRIBUTES
#===========================================================

      !define MUI_COMPONENTSPAGE_SMALLDESC
         !define MUI_HEADERIMAGE
         !define MUI_ABORTWARNING
      ; Installer icon
      !ifdef DEV
         !define MUI_WELCOMEFINISHPAGE_BITMAP "..\images\Wizard.bmp"
         !define MUI_HEADERIMAGE_BITMAP       "..\images\header.bmp"
         !define MUI_ICON                     "..\images\audacious.ico"
         !define MUI_UNICON                   "..\images\audacious.ico"
      !else
         !define MUI_WELCOMEFINISHPAGE_BITMAP "images\Wizard.bmp"
         !define MUI_HEADERIMAGE_BITMAP       "images\header.bmp"
         !define MUI_ICON                     "images\audacious.ico"
         !define MUI_UNICON                   "images\audacious.ico"
      !endif
      ; Registry uninstall key
      !define UNINST_KEY "Software\Microsoft\Windows\CurrentVersion\Uninstall\Audacious"
      ; Path to uninstaller
      !define UNINSTALLER "$INSTDIR\uninstall.exe"


#===========================================================
# INSTALLER/UNISNATLLER PAGES
#===========================================================
      ; Installer pages
      !insertmacro MUI_PAGE_WELCOME
      !insertmacro MUI_PAGE_LICENSE "${BUILDDIR}\README.txt"
      !insertmacro MUI_PAGE_COMPONENTS
      !insertmacro MUI_PAGE_DIRECTORY
      !insertmacro MUI_PAGE_INSTFILES
      !insertmacro MUI_PAGE_FINISH

      ; Uninstaller pages
      !insertmacro MUI_UNPAGE_CONFIRM
      !insertmacro MUI_UNPAGE_INSTFILES

#===========================================================
# LANGUAGES
#===========================================================

      #ADD LANGUAGES
      !insertmacro MUI_LANGUAGE "English"
      !insertmacro MUI_LANGUAGE "SpanishInternational"

      !include "scripts\Audacious_lang-es.nsh"
      !include "scripts\Audacious_lang-en.nsh"

#===========================================================
# INSTALLER SECTIONS
#===========================================================
Insttype "$(INSTTYPE_FULL)"
Insttype "$(INSTTYPE_LITE)"

       Section "!$(SEC_MAIN)" InstallSection
               SectionIn 1 2 RO

               !ifndef TEST_WITHOUTFILES
               SetOutPath "$INSTDIR"
               File /r "${BUILDDIR}\*"
               !endif

               ; create uninstaller
               WriteRegStr HKLM "${UNINST_KEY}" "DisplayName" "${PRODUCT_NAME}"
               WriteRegStr HKLM "${UNINST_KEY}" "DisplayVersion" "${VERSION}"
               WriteRegStr HKLM "${UNINST_KEY}" "Publisher" "${PRODUCT_NAME} developers"
               WriteRegStr HKLM "${UNINST_KEY}" "DisplayIcon" "${UNINSTALLER}"
               WriteRegStr HKLM "${UNINST_KEY}" "UninstallString" "${UNINSTALLER}"
               WriteRegDWORD HKLM "${UNINST_KEY}" "NoModify" 1
               WriteRegDWORD HKLM "${UNINST_KEY}" "NoRepair" 1

               ; estimate installed size
               SectionGetSize ${InstallSection} $0
               WriteRegDWORD HKLM "${UNINST_KEY}" "EstimatedSize" $0

               WriteUninstaller ${UNINSTALLER}

               SetShellVarContext all

        SectionEnd

        ; Optional sections
        Section "$(SEC_ADD_TO_START)" StartMenuSection
                SectionIn 1

                SetOutPath "$INSTDIR\bin" ; sets the shortcut's working directory
                CreateShortCut "$SMPROGRAMS\${PRODUCT_NAME}.lnk" "$INSTDIR\bin\audacious.exe"

        SectionEnd

        Section "$(SEC_ADD_TO_DESKT)" DesktopSection
                SectionIn 1

                SetOutPath "$INSTDIR\bin" ; sets the shortcut's working directory
                CreateShortCut "$DESKTOP\${PRODUCT_NAME}.lnk" "$INSTDIR\bin\audacious.exe"

        SectionEnd

#===========================================================
# Assign language strings to sections
#===========================================================

      !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
            !insertmacro MUI_DESCRIPTION_TEXT ${InstallSection}   $(DESC_InstallSection)
            !insertmacro MUI_DESCRIPTION_TEXT ${StartMenuSection} $(DESC_StartMenuSection)
            !insertmacro MUI_DESCRIPTION_TEXT ${DesktopSection}   $(DESC_DesktopSection)
      !insertmacro MUI_FUNCTION_DESCRIPTION_END

#===========================================================
# UNINSTALLER SECTIONS
#===========================================================

        Section "Uninstall" UninstallSection

                RMDir /r "$INSTDIR"

                SetShellVarContext all
                Delete "$SMPROGRAMS\${PRODUCT_NAME}.lnk"
                Delete "$DESKTOP\${PRODUCT_NAME}.lnk"

                DeleteRegKey HKLM "${UNINST_KEY}"

        SectionEnd

