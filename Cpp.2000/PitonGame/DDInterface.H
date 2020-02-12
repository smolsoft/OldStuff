#include "DirectDrawWin.h"
#include "Collection.h"

#if !defined(ddi_interface)
#define ddi_interface

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


///////////////////////////////////////////////////////////////////////
//				classes tree
///////////////////////////////////////////////////////////////////////
struct ddiEvent;//					- Main struct for event handling
struct ddiKeyMove;//				- Struct for keyboard cursor moving


class  ddiView;//					- Abstract
	class ddiLabel;//				- Static Label
		class ddiLabelButton;//		- Button (text)
			class ddiLabelList;//	- Button with PopUp List of Values

	class ddiPicture;//				- Button (picture)

	class ddiForm;//				- Semiabstract class (using with other ddiView objects only)
		
	class ddiList;//				- List of Labels for ddiLabelList
		class ddiListShadow;//		- List with semitransparent shadow



///////////////////////////////////////////////////////////////////////
//				ddinterface commands
///////////////////////////////////////////////////////////////////////
const WORD cm_None		=	0;

const WORD cm_Cancel	=	1;
const WORD cm_OK		=	2;



///////////////////////////////////////////////////////////////////////
//				ddinterface messages
///////////////////////////////////////////////////////////////////////
const WORD ms_FocusOff	=	0;
const WORD ms_FocusOn	=	1;
const WORD ms_EndModal	=	2;
const WORD ms_ListOK	=	3;// for ddiLabelList
const WORD ms_ListCancel=	4;// for ddiLabelList



///////////////////////////////////////////////////////////////////////
//				state flags
///////////////////////////////////////////////////////////////////////
const BYTE sf_Visible	=	1;
const BYTE sf_Focused	=	2;
const BYTE sf_Active	=	4;
const BYTE sf_ModalFull	=	8;
const BYTE sf_Disabled	=	16;
const BYTE sf_Selected	=	sf_Focused+sf_Active;



///////////////////////////////////////////////////////////////////////
//				options flags
///////////////////////////////////////////////////////////////////////
const BYTE of_NonFirstClick	=	1;
const BYTE of_AlignLeft		=	2;
const BYTE of_AlignRight	=	4;
const BYTE of_Cancel		=	8;



///////////////////////////////////////////////////////////////////////
//				palette entries consts
///////////////////////////////////////////////////////////////////////
const BYTE MAX_COLORS		=	6;

typedef DWORD	DDI_PALETTE [MAX_COLORS];

const BYTE COLOR_BACK		=	0;
const BYTE COLOR_NORMAL		=	1;
const BYTE COLOR_FOCUSED	=	2;
const BYTE COLOR_SELECTED	=	3;
const BYTE COLOR_DISABLED	=	4;
const BYTE COLOR_ERROR		=	5;


///////////////////////////////////////////////////////////////////////
//				mouse buttons consts
///////////////////////////////////////////////////////////////////////
const BYTE ev_MouseBNone	=	0;
const BYTE ev_MouseBLeft	=	1;
const BYTE ev_MouseBRight	=	2;
const BYTE ev_MouseBDouble	=	4;


///////////////////////////////////////////////////////////////////////
//						ddiEvent
///////////////////////////////////////////////////////////////////////
const BYTE ev_Nothing		=	0;
const BYTE ev_Mouse			=	1;
const BYTE ev_MouseStand	=	2;
const BYTE ev_Keyboard		=	4;
const BYTE ev_Command		=	8;
const BYTE ev_Message		=	16;

struct ddiEvent
{
	BYTE what;
	union
	{
		struct __mouse
		{
			BYTE buttons;
			POINT where;
		} Mouse;
		
		struct __keyboard
		{
			WORD keycode;
		} Keyboard;

		struct __message
		{
			WORD command;
			union
			{
				ddiView* iPtr;
				DWORD iDword;
				long  iLong;
				WORD  iWord;
				int   iInt;
				BYTE  iByte;
				char  iChar;
			};
		} Message;
	};
};//\\ struct ddiEvent



///////////////////////////////////////////////////////////////////////
//						ddiKeyMove
///////////////////////////////////////////////////////////////////////
struct ddiKeyMove
{
	ddiView* left;
	ddiView* right;
	ddiView* up;
	ddiView* down;
};//\\ struct ddiKeyMove



///////////////////////////////////////////////////////////////////////
//******************	ddiView		***********************************
///////////////////////////////////////////////////////////////////////
class ddiView// : public CObject
{
protected:
	BYTE state;
	static COLORREF transparent;
	static DirectDrawWin* ddw;

public:
	POINT coor;
	POINT size;

	LPDIRECTDRAWSURFACE surf;

	ddiForm* owner;
	ddiView* next;
	ddiKeyMove sel_move;
	BYTE options;
	WORD command;
	WORD tag;

	CString title;

	static void SetDirectDrawWin(DirectDrawWin *w) { ddw=w; };
	static void SetTransparentColor(COLORREF c) { transparent=c; };
	
	ddiView(CPoint p=0);
    virtual ~ddiView();

	virtual void Draw(LPDIRECTDRAWSURFACE surf)	{;};
	virtual ddiEvent Do(ddiEvent event);

	virtual BOOL InView(POINT p);
	POINT GetGlobalCoor();
	POINT GetLocalCoor(POINT p);
	void Clear(ddiEvent &event);
	ddiEvent Command(WORD comm);
	ddiEvent Message(WORD ms);
	BOOL GetState(BYTE st);
	void SetState(BYTE st, BOOL enable);
	void SetKeyMove(ddiView* left, ddiView* right, ddiView* up, ddiView* down);	
};//\\ ddiView



///////////////////////////////////////////////////////////////////////
//******************	ddiForm		***********************************
///////////////////////////////////////////////////////////////////////
class ddiForm : public ddiView
{
public:
	ddiView* GetObject(WORD tag);
	BOOL TraceAll;// debug flag
	ddiView* last;
	ddiView* selected;
	ddiView* modal;

	ddiForm(CPoint p=0);
	~ddiForm();
	void Draw(LPDIRECTDRAWSURFACE surf);
	ddiEvent Do(ddiEvent event);

	ddiView* First();
	BOOL Insert(ddiView* view, DWORD x, DWORD y, BOOL ins_modal=FALSE);
	ddiView* Delete(ddiView* view);
	void DeleteFromHeap(ddiView* view);

	BOOL EventForEach(ddiEvent event);

protected:
	BOOL mouse_stand;
};//\\ ddiForm


/*
///////////////////////////////////////////////////////////////////////
//******************	ddiMessageWindow		***********************
///////////////////////////////////////////////////////////////////////
class ddiMessageWindow : public ddiForm
{
public:
	ddiMessageWindow(CPoint p=0);
	~ddiMessageWindow() {;};

	BOOL InsertButton(CString ttl,WORD cm);
	BOOL InsertString(CString ttl);

private:
	DDI_PALETTE palette;

	WORD tg_Button;
	WORD last_tg_b;
	WORD tg_String;
	WORD last_tg_s;

	BOOL SortButtons();
	BOOL SortStrings();
};//\\ ddiMessageWindow
*/


///////////////////////////////////////////////////////////////////////
//******************	ddiPicture		*******************************
///////////////////////////////////////////////////////////////////////
class ddiPicture : public ddiView
{
public:
	LPDIRECTDRAWSURFACE selectsurf;
	LPDIRECTDRAWSURFACE pressedsurf;
	LPDIRECTDRAWSURFACE masksurf;

	ddiPicture(CPoint p=0);
	~ddiPicture();
	BOOL Init(CString nonselect, CString select, CString press, CString mask);
	void Draw(LPDIRECTDRAWSURFACE surf);
	ddiEvent Do(ddiEvent event);

	BOOL InView(POINT p);

protected:
	BOOL InMask(POINT p);
};//\\ ddiPicture



///////////////////////////////////////////////////////////////////////
//******************	ddiLabel		*******************************
///////////////////////////////////////////////////////////////////////
class ddiLabel : public ddiView
{
public:
	DDI_PALETTE palette;

	ddiLabel(CPoint p=0);
	~ddiLabel() { ; };

	BOOL Init(CString ttl, HFONT f);
	void Draw(LPDIRECTDRAWSURFACE surf);
	ddiEvent Do(ddiEvent event);

	BOOL WriteText(CString text, HFONT font, LPDIRECTDRAWSURFACE surf, WORD x, WORD y, DWORD color);
	void WidthText(CString text, HFONT font, DWORD &w, DWORD &h);

	BOOL SetPalette(DWORD c1, DWORD c2, DWORD c3, DWORD c4, DWORD c5, DWORD c6);
	BOOL SetColor(BYTE color, DWORD value);
};//\\ ddiLabelButton



///////////////////////////////////////////////////////////////////////
//******************	ddiLabelButton		***************************
///////////////////////////////////////////////////////////////////////
class ddiLabelButton : public ddiLabel
{
public:
	LPDIRECTDRAWSURFACE selectsurf;

	ddiLabelButton(CPoint p=0);
	~ddiLabelButton();
	BOOL Init(CString ttl, HFONT f);
	void Draw(LPDIRECTDRAWSURFACE surf);
	ddiEvent Do(ddiEvent event);
};//\\ ddiLabelButton



///////////////////////////////////////////////////////////////////////
//******************	ddiLabelList		***************************
///////////////////////////////////////////////////////////////////////
class ddiLabelList : public ddiLabelButton
{
public:
	ddiList* lshList;
	CString value;

	ddiLabelList(CPoint p=0);
	~ddiLabelList();
	BOOL Init(CString ttl, HFONT f);
	void Draw(LPDIRECTDRAWSURFACE surf);
	ddiEvent Do(ddiEvent event);

	void SetBack(BOOL sh, COLORREF sh_c, BYTE sh_t, BOOL fr, COLORREF fr_c);
	BOOL AddItem(CString ttl, WORD cmd);

	BOOL SetCurrentValue(WORD cm);
	WORD GetCurrentValue();

protected:
	HFONT font;
	WORD main_width;
	WORD offset;
	void NextValue();
};//\\ ddiLabelList



///////////////////////////////////////////////////////////////////////
//******************	ddiList		***********************************
///////////////////////////////////////////////////////////////////////
class ddiList : public ddiForm
{
public:
	ddiView* _owner;
	
	HFONT font;
	DDI_PALETTE palette;

	ddiList(ddiView* ow, CPoint p=0);
	~ddiList() {;};
	BOOL Init(HFONT f, DDI_PALETTE pal);
	void Draw(LPDIRECTDRAWSURFACE surf);
	ddiEvent Do(ddiEvent event);

	BOOL AddItem(CString ttl, WORD cmd);
	WORD SelectedCommand();
	WORD NextCommand(WORD cm);
	CString GetString(WORD cm);

	void SetBackOptions(BOOL sh, COLORREF sh_c, BYTE sh_t, BOOL fr, COLORREF fr_c);

protected:
	WORD offset_x, offset_y;
	BOOL shadow; COLORREF shadow_color; BYTE shadow_transparent;
	BOOL frame; COLORREF frame_color;

	BOOL CreateShadow ();
	BOOL CreateFrame ();
};//\\ ddiList







#endif // !defined(ddi_interface)
