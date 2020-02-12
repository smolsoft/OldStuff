; CLW file contains information for the MFC ClassWizard

[General Info]
Version=1
LastClass=DirectDrawWin
LastTemplate=CDialog
NewFileInclude1=#include "stdafx.h"
NewFileInclude2=#include "piton 2.h"
LastPage=0

ClassCount=5
Class1=DirectDrawApp
Class2=DirectDrawWin
Class3=DriverDialog
Class4=PITONapp
Class5=PITONwin

ResourceCount=3
Resource1=IDR_MAINMENU (English (U.S.))
Resource2=IDD_DRIVERDIALOG (English (U.S.))
Resource3=IDD_DIALOG1

[CLS:DirectDrawApp]
Type=0
BaseClass=CWinApp
HeaderFile=DirectDrawApp.h
ImplementationFile=DirectDrawApp.cpp
Filter=N
LastObject=DirectDrawApp

[CLS:DirectDrawWin]
Type=0
BaseClass=CWnd
HeaderFile=DirectDrawWin.h
ImplementationFile=DirectDrawWin.cpp
LastObject=DirectDrawWin
Filter=W
VirtualFilter=WC

[CLS:DriverDialog]
Type=0
BaseClass=CDialog
HeaderFile=DriverDialog.h
ImplementationFile=DriverDialog.cpp

[CLS:PITONapp]
Type=0
BaseClass=DirectDrawApp
HeaderFile=PITONapp.h
ImplementationFile=PITONapp.cpp
LastObject=PITONapp

[CLS:PITONwin]
Type=0
BaseClass=DirectDrawWin
HeaderFile=PITONwin.h
ImplementationFile=PITONwin.cpp
Filter=W
LastObject=ID_APP_EXIT

[DLG:IDD_DRIVERDIALOG]
Type=1
Class=DriverDialog

[MNU:IDR_MAINMENU (English (U.S.))]
Type=1
Class=?
Command1=ID_APP_EXIT
CommandCount=1

[DLG:IDD_DRIVERDIALOG (English (U.S.))]
Type=1
Class=?
ControlCount=3
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816
Control3=IDC_DRIVERLIST,listbox,1352728835

[DLG:IDD_DIALOG1]
Type=1
Class=?
ControlCount=2
Control1=IDOK,button,1342242817
Control2=IDCANCEL,button,1342242816

