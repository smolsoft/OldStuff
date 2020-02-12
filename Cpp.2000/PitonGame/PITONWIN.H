#ifndef PITONwin_H
#define PITONwin_H


#include "DirectDrawWin.h"
#include "CDirSnd.h"
#include "CWave.h"
#include "PITONinterface.h"

const int mouse_event_index = 0;
const int quit_event_index = 1;


struct MouseClickData
{
	int x, y;
	int button;
};

class PITONwin : public DirectDrawWin
{
public:
	PITONwin();
	~PITONwin();

protected:
	//{{AFX_MSG(PITONwin)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	afx_msg void OnActivate(UINT nState, CWnd* pWndOther, BOOL bMinimized);
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	afx_msg void OnLButtonDblClk(UINT nFlags, CPoint point);
	afx_msg void OnLButtonDown(UINT nFlags, CPoint point);
	afx_msg void OnLButtonUp(UINT nFlags, CPoint point);
	afx_msg void OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags);
	afx_msg void OnTimer(UINT nIDEvent);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	int SelectDriver();
	int SelectInitialDisplayMode();
	BOOL CreateCustomSurfaces();
	void DrawScene();
	void RestoreSurfaces();
	//------- init mouse&keyboard ---------
	BOOL InitMouse();
	BOOL InitKeyboard();
	//------- mouse thread functions ------
	static DWORD MouseThread(LPVOID);
	BOOL UpdateCursorSimpleCase(int curx, int cury, int oldcurx, int oldcury);
	BOOL UpdateCursorComplexCase(int curx, int cury, int oldcurx, int oldcury);
	//------- mouse stuff -----------------
 	static LPDIRECTINPUTDEVICE mouse;

	static CCriticalSection critsection;
	static CWinThread* mousethread;
	static CEvent* mouse_event[2];

	static int cursor_width;
	static int cursor_height;
	static LPDIRECTDRAWSURFACE cursor0;
	static LPDIRECTDRAWSURFACE cursor1;
	static LPDIRECTDRAWSURFACE cursor_under;
	static LPDIRECTDRAWSURFACE cursor_union;


	static int curx, cury;
	static int oldcurx, oldcury;
	static CList<MouseClickData, MouseClickData> mouseclickqueue;
	//------- app stuff -------
	LPDIRECTINPUT dinput;
	LPDIRECTINPUTDEVICE keyboard;

private:
	static BOOL GameNow;
	static BOOL loadingFLAG;
	static BOOL show_cursor;

	ddiPITONinterface* PITONinterface;
	BOOL InitInterface();
	BOOL InterfaceDone();

	void CheckEvent(ddiEvent event);
	void TimerOn(int interval);
	void TimerOff();


	BYTE mouse_state;
	

	//CDirSound* sound;
	//CWave* wave;
	//UINT buf;
};


#endif
