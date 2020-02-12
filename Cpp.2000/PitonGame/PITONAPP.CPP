#include "Headers.h"
#include "resource.h"
#include "PITONapp.h"
#include "PITONwin.h"


BEGIN_MESSAGE_MAP(PITONapp, DirectDrawApp)
	//{{AFX_MSG_MAP(PITONapp)
	//}}AFX_MSG_MAP
END_MESSAGE_MAP()

PITONapp theapp;

BOOL PITONapp::InitInstance()
{
#ifdef _DEBUG
//	afxTraceEnabled=FALSE;
#endif
	PITONwin* win=new PITONwin;
	if (!win->Create( "PITON 2", IDI_ICON ))
		return FALSE;

	m_pMainWnd=win;
	return DirectDrawApp::InitInstance();
}
