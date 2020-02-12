#include "Headers.h"
#include "resource.h"
#include "DriverDialog.h"
#include "PITONwin.h"
#include "Cdirsnd.h"
#include "Cwave.h"

#pragma comment (lib,"ddraw.lib")
#pragma comment (lib,"dinput.lib")
#pragma comment (lib,"dxguid.lib")


LPDIRECTINPUTDEVICE PITONwin::mouse;

CCriticalSection PITONwin::critsection;
CWinThread* PITONwin::mousethread;
CEvent* PITONwin::mouse_event[2];

int PITONwin::cursor_width;
int PITONwin::cursor_height;
LPDIRECTDRAWSURFACE PITONwin::cursor0;
LPDIRECTDRAWSURFACE PITONwin::cursor1;
LPDIRECTDRAWSURFACE PITONwin::cursor_under;
LPDIRECTDRAWSURFACE PITONwin::cursor_union;

int PITONwin::curx, PITONwin::cury;
int PITONwin::oldcurx, PITONwin::oldcury;
CList<MouseClickData, MouseClickData> PITONwin::mouseclickqueue;

BOOL PITONwin::GameNow;
BOOL PITONwin::loadingFLAG;
BOOL PITONwin::show_cursor;

const int screen_width=800;
const int screen_height=600;


BEGIN_MESSAGE_MAP(PITONwin, DirectDrawWin)
	//{{AFX_MSG_MAP(PITONwin)
	ON_WM_CREATE()
	ON_WM_DESTROY()
	ON_WM_ACTIVATE()
	ON_WM_MOUSEMOVE()
	ON_WM_LBUTTONDBLCLK()
	ON_WM_LBUTTONDOWN()
	ON_WM_LBUTTONUP()
	ON_WM_KEYDOWN()
	ON_WM_TIMER()
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

//------------------------------------------------------- CONSTRUCTOR PITONwin
PITONwin::PITONwin()
{
	dinput=0; mouse=0; mouse_state=0;
	cursor0=0; cursor1=0; 
	curx = int(screen_width/2);
	cury = int(screen_height/2);
	cursor_width=0;	cursor_height=0;
	cursor_under=0;	cursor_union=0;
	loadingFLAG = TRUE;
	show_cursor = FALSE;
	GameNow = FALSE;
}

//------------------------------------------------------- DESTRUCTOR PITONwin
PITONwin::~PITONwin()
{
	;
}

//------------------------------------------------------- PITONwin::CreateCustomSurfaces()
BOOL PITONwin::CreateCustomSurfaces()
{
	ClearSurface( backsurf, 0 );// Loading 
	LPDIRECTDRAWSURFACE tmpsurf = CreateSurface("PICTURES\\pl0.bmp");
	primsurf->BltFast( 275, 260, tmpsurf, 0, DDBLTFAST_WAIT);
//	backsurf->BltFast( 275, 260, tmpsurf, 0, DDBLTFAST_WAIT);
//	primsurf->Flip( 0, DDFLIP_WAIT );
	tmpsurf->Release();

	cursor0=CreateSurface( "PICTURES\\cursor_0.bmp");
	cursor1=CreateSurface( "PICTURES\\cursor_1.bmp");
	GetSurfaceDimensions( cursor0, (DWORD&)cursor_width, (DWORD&)cursor_height );
	cursor_under=CreateSurface( cursor_width, cursor_height );
	cursor_union=CreateSurface( cursor_width*2, cursor_height*2 );
	DDCOLORKEY  colorkey;
	colorkey.dwColorSpaceLowValue = 0xffffff;
	colorkey.dwColorSpaceHighValue = 0xffffff;
	cursor0->SetColorKey( DDCKEY_SRCBLT, &colorkey );
	cursor1->SetColorKey( DDCKEY_SRCBLT, &colorkey );

	return TRUE;
}

//------------------------------------------------------- PITONwin::DrawScene()
void PITONwin::DrawScene()
{
	//---------------- Interface
	if ( (!loadingFLAG) && (show_cursor) )
	{
		ClearSurface( backsurf, 0 );

		ddiEvent event;
		PITONinterface->Clear(event);
		event.what = ev_MouseStand;
		event.Mouse.buttons = mouse_state;
		event.Mouse.where.x = curx;
		event.Mouse.where.y = cury;
		PITONinterface->Do(event);

		PITONinterface->Draw( backsurf );
	}

	//------ do synchronized stuff -------------------------------
	critsection.Lock();

	if (loadingFLAG)
	{
		InitInterface();

#ifdef _DEBUG
	DWORD dwTotal,dwFree;
	DDSCAPS ddsCaps;
	ddsCaps.dwCaps = 0;
	long res = ddraw2->GetAvailableVidMem(&ddsCaps, &dwTotal, &dwFree); 
	TRACE("SUMMARY LOADED SURFACE MEMORY: %d Kb\n",DWORD(bytes_for_surf/1024));
	TRACE("VIDEO MEMORY: Total=%d Kb,  Free=%d Kb\n",DWORD(dwTotal/1024),DWORD(dwFree/1024));
#endif
	
		loadingFLAG = FALSE;
		show_cursor = TRUE;
	}


	if (show_cursor)
	{//       save back buffer area under cursor
		RECT src;
		src.left=curx;
		src.top=cury;
		src.right=curx+cursor_width;
		src.bottom=cury+cursor_height;
		cursor_under->BltFast( 0, 0, backsurf, &src, DDBLTFAST_WAIT );
	 //       draw cursor to back buffer
		src.left=0;
		src.top=0;
		src.right=cursor_width;
		src.bottom=cursor_height;
		if ((src.right+curx)>=screen_width)
			src.right=cursor_width-(curx+cursor_width-screen_width)-1;
		if ((src.bottom+cury)>=screen_height)
			src.bottom=cursor_height-(cury+cursor_height-screen_height)-1;

		if (mouse_state)
			backsurf->BltFast( curx, cury, cursor1, &src, DDBLTFAST_SRCCOLORKEY | DDBLTFAST_WAIT );
		else
			backsurf->BltFast( curx, cury, cursor0, &src, DDBLTFAST_SRCCOLORKEY | DDBLTFAST_WAIT );

		primsurf->Flip( 0, DDFLIP_WAIT );
		while (primsurf->GetFlipStatus(DDGFS_ISFLIPDONE)!=DD_OK)
			;  // do nothing (wait for flip to complete)
	}

	critsection.Unlock();
	//------ end of synchronized stuff ---------------------------
}

//------------------------------------------------------- PITONwin::InitKeyboard()
BOOL PITONwin::InitKeyboard()
{
	TRACE("PITONwin::InitKeyboard()\n");

	HRESULT r;
	r = dinput->CreateDevice( GUID_SysKeyboard, &keyboard, 0 ); 
	if (r!=DI_OK)
	{
		TRACE("CreateDevice(keyboard) failed");	
		return FALSE;
	}
	
	r = keyboard->SetDataFormat( &c_dfDIKeyboard );
	if (r!=DI_OK)
	{
		TRACE("keyboard->SetDataFormat() failed\n");
		return FALSE;
	}

	r=keyboard->SetCooperativeLevel( GetSafeHwnd(), 
			DISCL_FOREGROUND | DISCL_NONEXCLUSIVE); // debug, final-FOREGROUND
	if (r!=DI_OK)
	{
		TRACE("keyboard->SetCooperativeLevel() failed\n");
		return FALSE;
	}

	return TRUE;
}

//------------------------------------------------------- PITONwin::InitMouse()
BOOL PITONwin::InitMouse()
{
	TRACE("PITONwin::InitMouse()\n");

	HRESULT r;
	r = dinput->CreateDevice( GUID_SysMouse, &mouse, 0 ); 
	if (r!=DI_OK)
	{
		TRACE("CreateDevice(mouse) failed\n");	
		return FALSE;
	}

	r = mouse->SetDataFormat( &c_dfDIMouse );
	if (r!=DI_OK)
	{
		TRACE("mouse->SetDataFormat() failed\n");
		return FALSE;
	}

	r = mouse->SetCooperativeLevel( GetSafeHwnd(),
			DISCL_NONEXCLUSIVE | DISCL_FOREGROUND );
	if (r!=DI_OK)
	{
		TRACE("mouse->SetCooperativeLevel() failed\n");
		return FALSE;
	}

	DIPROPDWORD property;
	property.diph.dwSize=sizeof(DIPROPDWORD);
	property.diph.dwHeaderSize=sizeof(DIPROPHEADER);
	property.diph.dwObj=0;
	property.diph.dwHow=DIPH_DEVICE;
	property.dwData=64;

	r = mouse->SetProperty( DIPROP_BUFFERSIZE, &property.diph );
	if (r!=DI_OK)
	{
		TRACE("mouse->SetProperty() failed (buffersize)\n");
		return FALSE;
	}

	mouse_event[mouse_event_index]=new CEvent;
	mouse_event[quit_event_index]=new CEvent;

	r = mouse->SetEventNotification( *mouse_event[mouse_event_index] );
	if (r!=DI_OK)
	{
		TRACE("mouse->SetEventNotification() failed\n");
		return FALSE;
	}

	mousethread=AfxBeginThread( (AFX_THREADPROC)MouseThread, this,
			THREAD_PRIORITY_TIME_CRITICAL, 0, CREATE_SUSPENDED );

	return TRUE;
}

//------------------------------------------------------- PITONwin::MouseThread()
DWORD PITONwin::MouseThread(LPVOID p)
{
	TRACE("starting mouse thread\n" );

	PITONwin* win=(PITONwin*)p;

	while(TRUE)
	{
		CMultiLock mlock( (CSyncObject**)mouse_event, 2 );
		DWORD event=mlock.Lock( INFINITE, FALSE );
		if (event-WAIT_OBJECT_0==quit_event_index)
		{
			TRACE("got quit message: quitting mouse thread\n");
			return 0;
		}

		critsection.Lock();

		oldcurx=curx;
		oldcury=cury;
		BOOL buffer_empty=FALSE;
		while (!buffer_empty)
		{
			DIDEVICEOBJECTDATA data;
			DWORD elements=1;
			if (mouse==0)
			{
				TRACE("mouse pointer invalid: quitting mouse thread\n");
				return 0;
			}
			HRESULT r=mouse->GetDeviceData( sizeof(data), &data, &elements, 0 );
			if (r==DI_OK && elements==1)
			{
				static MouseClickData mc;
				switch(data.dwOfs)
				{
					case DIMOFS_X:
						curx+=data.dwData*2;
						break;
					case DIMOFS_Y: 
						cury+=data.dwData*2;
						break;
					case DIMOFS_BUTTON0:
						if (data.dwData & 0x80)
						{
							mc.x=curx;
							mc.y=cury;
							mc.button=0;
							mouseclickqueue.AddHead( mc );
						}
						break;
					case DIMOFS_BUTTON1:
						if (data.dwData & 0x80)
						{
							mc.x=curx;
							mc.y=cury;
							mc.button=1;
							mouseclickqueue.AddHead( mc );
						}
						break;
				}
			}
			else
				buffer_empty=TRUE;
		}

		if (curx<0)
			curx=0;
		if (cury<0)
			cury=0;
		if (curx>=screen_width)
			curx=screen_width-3;
		if (cury>=screen_height)
			cury=screen_height-3;

		if (!show_cursor)
			goto nevermind;

		if (curx==oldcurx && cury==oldcury)
		//----- no cursor update is necesssary ------
			goto nevermind;
		else if (abs(curx-oldcurx) >= cursor_width || abs(cury-oldcury) >= cursor_height)
		//----- simple case: new and old cursor rects don't overlap -----
			win->UpdateCursorSimpleCase( curx, cury, oldcurx, oldcury );
		else
		//----- complex case: new and old cursor rects overlap -----
			win->UpdateCursorComplexCase( curx, cury, oldcurx, oldcury );
		
		
		nevermind:;
		critsection.Unlock();
	}
	
	TRACE("leaving mouse thread\n");
	return 0;
};

//------------------------------------------------------- PITONwin::OnActivate()
void PITONwin::OnActivate(UINT nState, CWnd* pWndOther, BOOL bMinimized) 
{
	DirectDrawWin::OnActivate(nState, pWndOther, bMinimized);
	
	if (nState!=WA_INACTIVE)
	{
		if (mouse)
		{
			TRACE("mouse->Acquire()\n");
			mouse->Acquire();
		}
		if (keyboard)
		{
			TRACE("keyboard->Acquire()\n");
			keyboard->Acquire();
		}
	}
}

//------------------------------------------------------- PITONwin::OnCreate()
int PITONwin::OnCreate(LPCREATESTRUCT lpCreateStruct) 
{
	HRESULT r=DirectInputCreate( AfxGetInstanceHandle(), 
			DIRECTINPUT_VERSION, &dinput, 0 ); 
	if (r!=DI_OK)
	{
		AfxMessageBox("DirectInputCreate() failed");
		return -1;
	}


	if (InitMouse()==FALSE)
		return -1;

	if (InitKeyboard()==FALSE)
		return -1;
	
	if (DirectDrawWin::OnCreate(lpCreateStruct) == -1)
		return -1;

	mousethread->ResumeThread();
	
/*	sound=new CDirSound;
	sound->CreateDirSound(m_hWnd);
	wave=new CWave("main.wav");

	if (!sound->DirectSoundOK())
		TRACE("****** DirectSound FAILED !!! ******\n");
	if (!wave->WaveOK())
		TRACE("****** Wave Data FAILED ******\n");
	
	buf=sound->CreateSoundBuffer(wave);
	
	if (!sound->CopyWaveToBuffer(wave,buf))
		TRACE("****** CopyWaveToBuffer FAILED !!! ****\n");
	
	sound->SetVolume(buf,0);
	sound->PlaySound(buf);
*/
	return 0;
}

//------------------------------------------------------- PITONwin::OnDestroy()
void PITONwin::OnDestroy() 
{
//	sound->StopSound(buf);
//	delete wave;
//	delete sound;
	
	critsection.Lock();

	InterfaceDone();

	DirectDrawWin::OnDestroy();

	if (mouse)
	{
		TRACE("------------------ DirectDraw DONE ------------------\n");

		TRACE("mouse->Unacquire()\n");
		mouse->Unacquire();

		TRACE("sending mouse quit message...\n");
		mouse_event[quit_event_index]->SetEvent();

		Sleep(100);  // give mouse thread a chance to respond
		TRACE("Releasing mouse pointer...\n");
		mouse->Release(), mouse=0;

		delete mouse_event[mouse_event_index];
		delete mouse_event[quit_event_index];
	}

	if (keyboard)
		keyboard->Release(), keyboard=0;

	if (dinput)
		dinput->Release(), dinput=0;

	critsection.Unlock();
}

//------------------------------------------------------- PITONwin::RestoreSurfaces()
void PITONwin::RestoreSurfaces()
{

}

//------------------------------------------------------- PITONwin::SelectDriver()
int PITONwin::SelectDriver()
{
	return 0;

	int numdrivers=GetNumDrivers();
	if (numdrivers==1)
		return 0;

	CArray<CString, CString> drivers;
	for (int i=0;i<numdrivers;i++)
	{
		LPSTR desc, name;
		GetDriverInfo( i, 0, &desc, &name );
		drivers.Add( desc );
	}

	DriverDialog dialog;
	dialog.SetContents( &drivers );
	if (dialog.DoModal()!=IDOK)
		return -1;

	return dialog.GetSelection();
}

//------------------------------------------------------- PITONwin::SelectInitialDisplayMode()
int PITONwin::SelectInitialDisplayMode()
{
	DWORD curdepth=GetDisplayDepth();
	int i, nummodes=GetNumDisplayModes();
	DWORD w,h,d;

	//--- Some ddraw configurations fail if the initial
	//--- call to SetDisplayMode() tries to change the
	//--- current display depth. To get around this
	//--- we activate a mode that has the same depth as
	//--- the desktop, and then choose our display mode.
//	if (curdepth!=8)
//		ddraw2->SetDisplayMode( 640, 480, curdepth, 0, 0 );

	for (i=0;i<nummodes;i++)
	{
		GetDisplayModeDimensions( i, w, h, d );
		if (w==screen_width && h==screen_height && d==24)
			return i;
	}

	for (i=0;i<nummodes;i++)
	{
		GetDisplayModeDimensions( i, w, h, d );
		if (w==screen_width && h==screen_height && d==16)
			return i;
	}

	AfxMessageBox("Desired display mode not supported");
	return -1;
}

//------------------------------------------------------- PITONwin::UpdateCursorComplexCase()
BOOL PITONwin::UpdateCursorComplexCase(int curx, int cury, int oldcurx, int oldcury)
{
	RECT src;
	HRESULT r;

	int unionx=min(curx, oldcurx);
	int uniony=min(cury, oldcury);
	int unionw=max(curx, oldcurx)-unionx+cursor_width;
	int unionh=max(cury, oldcury)-uniony+cursor_height;

	//----- Blt 1: copy the rect union to the scratch buffer --------
	src.left=unionx;
	src.top=uniony;
	src.right=unionx+unionw;
	src.bottom=uniony+unionh;
	if (src.right>=screen_width) src.right=screen_width-1;
	if (src.bottom>=screen_height) src.bottom=screen_height-1;

	r=cursor_union->BltFast( 0, 0, primsurf, &src, DDBLTFAST_WAIT );
	if (r!=DD_OK)
	{
		TRACE("Blt 1 failed (complex)\n");
		CheckResult(r);
	}

	//------ Blt 2: erase old cursor from scratch buffer ---------
	r=cursor_union->BltFast( oldcurx-unionx, oldcury-uniony, cursor_under, 0, DDBLTFAST_WAIT );
	if (r!=DD_OK)
	{
		TRACE("Blt 2 failed (complex)\n");
		CheckResult(r);
	}

	//------ Blt 3: save area under new cursor ---------
	src.left=curx-unionx;
	src.top=cury-uniony;
	src.right=src.left+cursor_width;
	src.bottom=src.top+cursor_height;

	r=cursor_under->BltFast( 0, 0, cursor_union, &src, DDBLTFAST_WAIT );
	if (r!=DD_OK)
	{
		TRACE("Blt 3 failed (complex)\n");
		CheckResult(r);
	}

	//------ Blt 4: draw new cursor into scratch buffer ---------
	if (mouse_state)
		r=cursor_union->BltFast( curx-unionx, cury-uniony, cursor1, 0, DDBLTFAST_SRCCOLORKEY | DDBLTFAST_WAIT );
	else
		r=cursor_union->BltFast( curx-unionx, cury-uniony, cursor0, 0, DDBLTFAST_SRCCOLORKEY | DDBLTFAST_WAIT );
		
	if (r!=DD_OK)
	{
		TRACE("Blt 4 failed (complex)\n");
		CheckResult(r);
	}

	//------- Blt 5: blt scratch buffer back to primary buffer --------
	src.left=0;
	src.top=0;
	src.right=unionw;
	src.bottom=unionh;
	if ((src.right+unionx)>=screen_width)
		src.right=screen_width-unionx-1;
	if ((src.bottom+uniony)>=screen_height)
		src.bottom=screen_height-uniony-1;

	r=primsurf->BltFast( unionx, uniony, cursor_union, &src, DDBLTFAST_WAIT );
	if (r!=DD_OK)
	{
		TRACE("Blt 5 failed (complex)\n");
		CheckResult(r);
	}

	return TRUE;
}

//------------------------------------------------------- PITONwin::UpdateCursorSimpleCase()
BOOL PITONwin::UpdateCursorSimpleCase(int curx, int cury, int oldcurx, int oldcury)
{
	RECT src;
	HRESULT r;

	src.left=0;
	src.top=0;
	src.right=cursor_width;
	src.bottom=cursor_height;
	if ((src.right+oldcurx)>=screen_width)
		src.right=cursor_width-(oldcurx+cursor_width-screen_width)-1;
	if ((src.bottom+oldcury)>=screen_height)
		src.bottom=cursor_height-(oldcury+cursor_height-screen_height)-1;

	//------ Blt 1: erase old cursor ----------
	r=primsurf->BltFast( oldcurx, oldcury, cursor_under, &src, DDBLTFAST_WAIT );
	if (r!=DD_OK)
	{
		TRACE("Blt 1 failed (simple)\n");
		CheckResult(r);
	}

	//------ Blt 2: save area under new cursor -----------
	src.left=curx;
	src.top=cury;
	src.right=curx+cursor_width;
	src.bottom=cury+cursor_height;
	if (src.right>=screen_width)
		src.right=screen_width-1;
	if (src.bottom>=screen_height)
		src.bottom=screen_height-1;

	r=cursor_under->BltFast( 0, 0, primsurf, &src, DDBLTFAST_WAIT );
	if (r!=DD_OK)
	{
		TRACE("Blt 2 failed (simple)\n");
		CheckResult(r);
	}

	//------ Blt 3: draw new cursor ----------
	src.left=0;
	src.top=0;
	src.right=cursor_width;
	src.bottom=cursor_height;
	if ((src.right+curx)>=screen_width)
		src.right=cursor_width-(curx+cursor_width-screen_width)-1;
	if ((src.bottom+cury)>=screen_height)
		src.bottom=cursor_height-(cury+cursor_height-screen_height)-1;


	if (mouse_state)
		r=primsurf->BltFast( curx, cury, cursor1, &src, DDBLTFAST_SRCCOLORKEY | DDBLTFAST_WAIT );
	else
		r=primsurf->BltFast( curx, cury, cursor0, &src, DDBLTFAST_SRCCOLORKEY | DDBLTFAST_WAIT );
	
	if (r!=DD_OK)
	{
		TRACE("Blt 3 failed (simple)\n");
		CheckResult(r);
	}

	return TRUE;
}


//------------------------------------------------------- PITONwin::InitInterface()
BOOL PITONwin::InitInterface()
{
	TRACE("------------------- Interface INIT ------------------\n");

	CreateScalableFontResource(0, "FONTS\\font0.fot", "FONTS\\font0.ttf", 0);
	CreateScalableFontResource(0, "FONTS\\font1.fot", "FONTS\\font1.ttf", 0);
	
	if (!AddFontResource("FONTS\\font0.fot"))
		Fatal("Can't add Piton's FONTS\\font0.ttf!\nPlease remove not used fonts from Control Panel\\Fonts.");
	if (!AddFontResource("FONTS\\font1.fot"))
		Fatal("Can't add Piton's FONTS\\font1.ttf!\nPlease remove not used fonts from Control Panel\\Fonts.");
	
	SendMessage(WM_FONTCHANGE, 0, 0);

	// Init static variable
	ddiView::SetTransparentColor(RGB(127,127,127));
	ddiView::SetDirectDrawWin(GetDDWin());

	PITONinterface = new ddiPITONinterface;

	return TRUE;
}

//------------------------------------------------------- PITONwin::InterfaceDone()
BOOL PITONwin::InterfaceDone()
{
	TRACE("------------------- Interface DONE. ------------------\n");

	RemoveFontResource("FONTS\\font0.fot");
	RemoveFontResource("FONTS\\font1.fot");

	SendMessage(WM_FONTCHANGE, 0, 0);

	delete PITONinterface;
	return TRUE;
}

//------------------------------------------------------- PITONwin::CheckEvent()
void PITONwin::CheckEvent(ddiEvent event)
{
	if (event.what==ev_Command)
		switch (event.Message.command)
		{
		case cm_TheEnd:
			PostMessage( WM_CLOSE );
			break;

		case cm_SetTimerEasy:
			TimerOn(850);// time for EASY difficult
			break;

		case cm_SetTimerMedium:
			TimerOn(600);// time for MEDIUM difficult
			break;

		case cm_SetTimerPro:
			TimerOn(400);// time for PRO difficult
			break;

		case cm_SetTimerHard:
			TimerOn(150);// time for HARD difficult
			break;

		case cm_SetTimerNone:
			TimerOff();
			break;

		default:
			mouse_state=0;
		}
}

//------------------------------------------------------- PITONwin::OnMouseMove()
void PITONwin::OnMouseMove(UINT nFlags, CPoint point) 
{
	if (loadingFLAG)
		return;

	ddiEvent event;
	PITONinterface->Clear(event);
	event.what = ev_Mouse;
	event.Mouse.buttons = mouse_state;
	event.Mouse.where.x = curx;
	event.Mouse.where.y = cury;

	PITONinterface->Do(event);
}

//------------------------------------------------------- PITONwin::OnLButtonDblClk()
void PITONwin::OnLButtonDblClk(UINT nFlags, CPoint point) 
{
	if (loadingFLAG)
		return;

	mouse_state = 0;
	ddiEvent event;
	PITONinterface->Clear(event);
	event.what = ev_Mouse;
	event.Mouse.buttons = ev_MouseBDouble;
	event.Mouse.where.x = curx;
	event.Mouse.where.y = cury;

	CheckEvent(PITONinterface->Do(event));
}

//------------------------------------------------------- PITONwin::OnLButtonDown()
void PITONwin::OnLButtonDown(UINT nFlags, CPoint point) 
{
	if (loadingFLAG)
		return;

	mouse_state=ev_MouseBLeft;
	ddiEvent event;
	PITONinterface->Clear(event);
	event.what = ev_Mouse;
	event.Mouse.buttons = mouse_state;
	event.Mouse.where.x = curx;
	event.Mouse.where.y = cury;

	CheckEvent(PITONinterface->Do(event));
}

//------------------------------------------------------- PITONwin::OnLButtonUp()
void PITONwin::OnLButtonUp(UINT nFlags, CPoint point) 
{
	if (loadingFLAG)
		return;

	mouse_state=ev_MouseBNone;
	ddiEvent event;
	PITONinterface->Clear(event);
	event.what = ev_Mouse;
	event.Mouse.buttons = mouse_state;
	event.Mouse.where.x = curx;
	event.Mouse.where.y = cury;

	CheckEvent(PITONinterface->Do(event));
}

//------------------------------------------------------- PITONwin::OnKeyDown()
void PITONwin::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags) 
{
	if (loadingFLAG)
		return;

	ddiEvent event;
	PITONinterface->Clear(event);
	event.what = ev_Keyboard;
	event.Keyboard.keycode = nChar;

	CheckEvent(PITONinterface->Do(event));
}

//------------------------------------------------------- PITONwin::OnTimer()
void PITONwin::OnTimer(UINT nIDEvent) 
{
//  	CheckEvent(PITONinterface->Do(event));
}

//------------------------------------------------------- PITONwin::TimerOn()
void PITONwin::TimerOn(int interval)
{
	SetTimer(713,interval,NULL);
}

//------------------------------------------------------- PITONwin::TimerOff()
void PITONwin::TimerOff()
{
	KillTimer(713);
}

