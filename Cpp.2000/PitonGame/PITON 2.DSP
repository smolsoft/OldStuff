# Microsoft Developer Studio Project File - Name="PITON 2" - Package Owner=<4>
# Microsoft Developer Studio Generated Build File, Format Version 6.00
# ** DO NOT EDIT **

# TARGTYPE "Win32 (x86) Application" 0x0101

CFG=PITON 2 - Win32 Debug
!MESSAGE This is not a valid makefile. To build this project using NMAKE,
!MESSAGE use the Export Makefile command and run
!MESSAGE 
!MESSAGE NMAKE /f "PITON 2.mak".
!MESSAGE 
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "PITON 2.mak" CFG="PITON 2 - Win32 Debug"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "PITON 2 - Win32 Release" (based on "Win32 (x86) Application")
!MESSAGE "PITON 2 - Win32 Debug" (based on "Win32 (x86) Application")
!MESSAGE 

# Begin Project
# PROP AllowPerConfigDependencies 0
# PROP Scc_ProjName ""
# PROP Scc_LocalPath ""
CPP=cl.exe
MTL=midl.exe
RSC=rc.exe

!IF  "$(CFG)" == "PITON 2 - Win32 Release"

# PROP BASE Use_MFC 2
# PROP BASE Use_Debug_Libraries 0
# PROP BASE Output_Dir "Release"
# PROP BASE Intermediate_Dir "Release"
# PROP BASE Target_Dir ""
# PROP Use_MFC 2
# PROP Use_Debug_Libraries 0
# PROP Output_Dir "Release"
# PROP Intermediate_Dir "Release"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /YX /FD /c
# ADD CPP /nologo /G6 /MD /W3 /GX /O2 /D "WIN32" /D "NDEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /Yu"headers.h" /FD /c
# ADD BASE MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "NDEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x419 /d "NDEBUG" /d "_AFXDLL"
# ADD RSC /l 0x419 /d "NDEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /machine:I386
# ADD LINK32 /nologo /subsystem:windows /machine:I386

!ELSEIF  "$(CFG)" == "PITON 2 - Win32 Debug"

# PROP BASE Use_MFC 2
# PROP BASE Use_Debug_Libraries 1
# PROP BASE Output_Dir "Debug"
# PROP BASE Intermediate_Dir "Debug"
# PROP BASE Target_Dir ""
# PROP Use_MFC 2
# PROP Use_Debug_Libraries 1
# PROP Output_Dir "Debug"
# PROP Intermediate_Dir "Debug"
# PROP Target_Dir ""
# ADD BASE CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /YX /FD /GZ /c
# ADD CPP /nologo /MDd /W3 /Gm /GX /ZI /Od /D "WIN32" /D "_DEBUG" /D "_WINDOWS" /D "_AFXDLL" /D "_MBCS" /FR /Yu"headers.h" /FD /GZ /c
# ADD BASE MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD MTL /nologo /D "_DEBUG" /mktyplib203 /win32
# ADD BASE RSC /l 0x419 /d "_DEBUG" /d "_AFXDLL"
# ADD RSC /l 0x419 /d "_DEBUG" /d "_AFXDLL"
BSC32=bscmake.exe
# ADD BASE BSC32 /nologo
# ADD BSC32 /nologo
LINK32=link.exe
# ADD BASE LINK32 /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept
# ADD LINK32 /nologo /subsystem:windows /debug /machine:I386 /pdbtype:sept

!ENDIF 

# Begin Target

# Name "PITON 2 - Win32 Release"
# Name "PITON 2 - Win32 Debug"
# Begin Group "Source Files"

# PROP Default_Filter "cpp;c;cxx;rc;def;r;odl;idl;hpj;bat"
# Begin Source File

SOURCE=.\Cdirsnd.cpp
# End Source File
# Begin Source File

SOURCE=.\Coder.cpp
# End Source File
# Begin Source File

SOURCE=.\Collection.cpp
# End Source File
# Begin Source File

SOURCE=.\Cwave.cpp
# End Source File
# Begin Source File

SOURCE=.\DDInterface.cpp
# End Source File
# Begin Source File

SOURCE=.\DirectDrawApp.cpp
# End Source File
# Begin Source File

SOURCE=.\DirectDrawWin.cpp
# End Source File
# Begin Source File

SOURCE=.\DriverDialog.cpp
# End Source File
# Begin Source File

SOURCE=.\Headers.cpp
# ADD CPP /Yc"headers.h"
# End Source File
# Begin Source File

SOURCE=".\PITON 2.rc"
# End Source File
# Begin Source File

SOURCE=.\PITONapp.cpp
# End Source File
# Begin Source File

SOURCE=.\PitonGame.cpp
# End Source File
# Begin Source File

SOURCE=.\PITONinterface.cpp
# End Source File
# Begin Source File

SOURCE=.\PITONwin.cpp
# End Source File
# End Group
# Begin Group "Header Files"

# PROP Default_Filter "h;hpp;hxx;hm;inl"
# Begin Source File

SOURCE=.\Cdirsnd.h
# End Source File
# Begin Source File

SOURCE=.\Coder.h
# End Source File
# Begin Source File

SOURCE=.\Collection.h
# End Source File
# Begin Source File

SOURCE=.\Cwave.h
# End Source File
# Begin Source File

SOURCE=.\DDInterface.h
# End Source File
# Begin Source File

SOURCE=.\DirectDrawApp.h
# End Source File
# Begin Source File

SOURCE=.\DirectDrawWin.h
# End Source File
# Begin Source File

SOURCE=.\DriverDialog.h
# End Source File
# Begin Source File

SOURCE=.\Headers.h
# End Source File
# Begin Source File

SOURCE=.\PITONapp.h
# End Source File
# Begin Source File

SOURCE=.\PitonGame.h
# End Source File
# Begin Source File

SOURCE=.\PITONinterface.h
# End Source File
# Begin Source File

SOURCE=.\PITONwin.h
# End Source File
# Begin Source File

SOURCE=.\resource.h
# End Source File
# End Group
# Begin Group "Resource Files"

# PROP Default_Filter "ico;cur;bmp;dlg;rc2;rct;bin;rgs;gif;jpg;jpeg;jpe"
# Begin Source File

SOURCE=.\Sprites\ec.cur
# End Source File
# Begin Source File

SOURCE=.\icon.ico
# End Source File
# End Group
# End Target
# End Project
