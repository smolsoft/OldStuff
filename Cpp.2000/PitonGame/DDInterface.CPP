#include "Headers.h"
#include "DDInterface.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif



///////////////////////////////////////////////////////////////////////
//******************	ddiView			*******************************
///////////////////////////////////////////////////////////////////////
COLORREF ddiView::transparent;
DirectDrawWin* ddiView::ddw;

//------------------------------------------------------- CONSTRUCTOR ddiView
ddiView::ddiView(CPoint p)// : CObject()
{
	coor.x=p.x; coor.y=p.y;
	if (!ddw)
		Fatal("***_ERROR_*** DirectDrawWin* ddiView::ddw NOT initialized.\n");
	size.x=0; size.y=0;// empty rect - default
	options = 0;
	state = sf_Visible;
	command = cm_None; tag=0;
	owner=0;next=0;
	surf=0;
	sel_move.left=0; sel_move.right=0;
	sel_move.up=0; sel_move.down=0;
}

//------------------------------------------------------- DESTRUCTOR ddiView
ddiView::~ddiView()
{
	if (surf) surf->Release();
}

//------------------------------------------------------- ddiView::Do()
ddiEvent ddiView::Do(ddiEvent event)
{
	if (GetState(sf_Disabled))
		return event;// если мы запрещены, то пошли все..

	switch (event.what)
	{
	case ev_Mouse://=============== MOUSE
		if ( (owner->selected) && (owner->selected!=this) )// если в форме-владельце есть выбранный объект
			owner->selected->Do(Message(ms_FocusOff));// и это - не мы, тогда посылаем ему ms_FocusOff
		
		owner->selected=this;// теперь я - пуп земли
			
		if (event.Mouse.buttons)// нажата какая-то кнопка?
			SetState(sf_Active,TRUE);// пока только сделаем себя Active, а вот когда кнопку отпустят...
		else
		{						// просто движение мышью
			SetState(sf_Focused,TRUE);
			if (GetState(sf_Active))
			{// до этого была нажата кнопка!
				SetState(sf_Active,FALSE);// значит, типа, мы нажаты...
				return Command(command);// возвращаем команду
			}
		}
		Clear(event);
		break;// с мышью мы сделали все что могли

	case ev_Keyboard://============== KEYBOARD
		switch (event.Keyboard.keycode)
		{
		case VK_RETURN:// ентеррр
			//SetState(sf_Selected, FALSE);
			return Command(command);// мы, в натуре, нажаты!
			break;

		case VK_UP:// ап
			if (sel_move.up)
			{// если мы можем переместить фокус вверх...
				SetState(sf_Selected, FALSE);// ...посылаем туды ms_FocusOn
				return sel_move.up->Do(Message(ms_FocusOn));
			}
			SetState(sf_Focused, TRUE);
			//Clear(event);
			break;

		case VK_DOWN:// даун
			if (sel_move.down)
			{// если мы можем переместить фокус вниз...
				SetState(sf_Selected, FALSE);// ...посылаем туды ms_FocusOn
				return sel_move.down->Do(Message(ms_FocusOn));
			}
			SetState(sf_Focused, TRUE);
			//Clear(event);
			break;
				
		case VK_LEFT:// лефт
			if (sel_move.left)
			{// если мы можем переместить фокус влево...
				SetState(sf_Selected, FALSE);// ...посылаем туды ms_FocusOn
				return sel_move.left->Do(Message(ms_FocusOn));
			}
			SetState(sf_Focused, TRUE);
			//Clear(event);
			break;

		case VK_RIGHT:// ригхт
			if (sel_move.right)
			{// если мы можем переместить фокус вправо...
				SetState(sf_Selected, FALSE);// ...посылаем туды ms_FocusOn
				return sel_move.right->Do(Message(ms_FocusOn));
			}
			SetState(sf_Focused, TRUE);
			//Clear(event);
			break;// Все! с клавой разделались
		}
		break;

	case ev_Message://=============== MESSAGE
		switch (event.Message.command)
		{
		case ms_FocusOff:// нам сказали, блин, исчезнуть
			SetState(sf_Selected, FALSE);// ...выполняем
			//owner->selected = this;
			Clear(event);
			break;

		case ms_FocusOn:// мы теперь избранно-выбранные
			SetState(sf_Focused, TRUE);// ...выполняем
			owner->selected = this;
			Clear(event);
			break;
		}
	}
	return event;
}

//------------------------------------------------------- ddiView::Clear()
void ddiView::Clear(ddiEvent &event)
{
	ZeroMemory(&event, sizeof(event));
	event.what=ev_Nothing;
	event.Message.iPtr=this;
}

//------------------------------------------------------- ddiView::Command()
ddiEvent ddiView::Command(WORD cm)
{
	ddiEvent event;
	ZeroMemory(&event, sizeof(event));
	if (cm)
	{
		event.what=ev_Command;
		event.Message.command=cm;
	}
	else
		event.what=ev_Nothing;

	event.Message.iPtr=this;
	return event;
}

//------------------------------------------------------- ddiView::Message()
ddiEvent ddiView::Message(WORD ms)
{
	ddiEvent event;
	ZeroMemory(&event, sizeof(event));
	event.what=ev_Message;
	event.Message.command=ms;
	event.Message.iPtr=this;
	return event;
}

//------------------------------------------------------- ddiView::SetState()
void ddiView::SetState(BYTE st, BOOL enable)
{
	if (enable)
		state|=st;
	else
		state&=~st;
}

//------------------------------------------------------- ddiView::GetState()
BOOL ddiView::GetState(BYTE st)
{
	return (state & st)==st;
}

//------------------------------------------------------- ddiView::InView()
BOOL ddiView::InView(POINT p)
{
	if (GetState(sf_Disabled))
		return FALSE;

	POINT gc=GetGlobalCoor();
	p.x-=gc.x;
	p.y-=gc.y;
	if ((p.x>0 && p.x<size.x) && (p.y>0 && p.y<size.y))
		return TRUE;
	else
		return FALSE;
}

//------------------------------------------------------- ddiView::GetGlobalCoor()
POINT ddiView::GetGlobalCoor()
{
	POINT p;

	if (owner)
		p = owner->GetGlobalCoor();
	else
	{
		p.x = 0;
		p.y = 0;
	}

	p.x += coor.x;
	p.y += coor.y;

	return p;
}

//------------------------------------------------------- ddiView::GetLocalCoor()
POINT ddiView::GetLocalCoor(POINT p)
{
	POINT p1 = GetGlobalCoor();
	POINT p2;
	
	p2.x=p.x-p1.x;
	p2.y=p.y-p1.y;

	return p2;
}

//------------------------------------------------------- ddiView::SetKeyMove()
void ddiView::SetKeyMove(ddiView *left, ddiView *right, ddiView *up, ddiView *down)
{
	if (left)
		sel_move.left	= left;
	if (right)
		sel_move.right	= right;
	if (up)
		sel_move.up		= up;
	if (down)
		sel_move.down	= down;
}//\\ ddiView class



///////////////////////////////////////////////////////////////////////
//******************	ddiForm			*******************************
///////////////////////////////////////////////////////////////////////

//------------------------------------------------------- CONSTRUCTOR ddiForm
ddiForm::ddiForm(CPoint p)
:ddiView(p)
{
	TraceAll = FALSE;// debug off

	last=0; selected=0; modal=0;
	DWORD w,h,d;
	ddw->GetDisplayModeDimensions(ddw->GetCurDisplayMode(),w,h,d);
	size.x=w-coor.x; size.y=h-coor.y;// full screen - default for ddiForm
	mouse_stand=FALSE;
}

//------------------------------------------------------- DESTRUCTOR ddiForm
ddiForm::~ddiForm()
{
	while (last)
		DeleteFromHeap(last);
}

//------------------------------------------------------- ddiForm::Draw()
void ddiForm::Draw(LPDIRECTDRAWSURFACE s)
{
	ddiView* temp=last;

	if (surf)
	{
		POINT gc = GetGlobalCoor();
		ddw->BltSurface( s, surf, gc.x, gc.y);
	}

	while (temp)
	{
		if (temp->GetState(sf_Visible))
			temp->Draw(s);
		temp=temp->next;
	};

	if (modal)
		modal->Draw(s);
}
	
//------------------------------------------------------- ddiForm::Do()
ddiEvent ddiForm::Do(ddiEvent event)
{
	if (last==0)
		return event;

	if (modal)
	{
		if ( (event.what==ev_Mouse) && (!modal->InView(event.Mouse.where)) )
		{// moving in this form
			if (event.Mouse.buttons)
			{// moving with button down
				SetState(sf_Active, TRUE);
				Clear(event);
			}
			else
			{// simply moving
				if (GetState(sf_Active))
				{// button up?
					SetState(sf_Active, FALSE);
					if (!modal->GetState(sf_ModalFull))
						event = modal->Do(Message(ms_EndModal));
				}
				else
					event = modal->Do(Message(ms_FocusOff));
			}
		}
		else
		{
			if ( (event.what==ev_Keyboard) && (event.Keyboard.keycode==VK_ESCAPE) && (!modal->GetState(sf_ModalFull)) )
				return modal->Do(Message(ms_EndModal));

			event=modal->Do(event);

			if (event.what==ev_Command)
			{
				modal->owner=0;
				modal->next=0;
				modal=0;
			}
		}
		return event;
	}// end modal

	
	ddiView* temp=last;

	switch (event.what)
	{
	case ev_MouseStand://--------- MOUSE STAND
		if (mouse_stand)
			break;		

	case ev_Mouse://-------------- MOUSE
		if (mouse_stand)
		{
			mouse_stand=FALSE;
		}
		event.what=ev_Mouse;

		while( (temp) && (!temp->InView(event.Mouse.where)) )
			temp = temp->next;
		
		if ( (temp) )
		//	moving in some enabled ddiView
			event = temp->Do(event);
		else if (selected)
		// moving in this Form
			selected->Do(Message(ms_FocusOff));

		break;

	case ev_Keyboard://----------- KEYBOARD
		mouse_stand = TRUE;
		if (event.Keyboard.keycode==VK_ESCAPE)
		{// if esc pressed
			while (temp)
			{
				if (temp->options & of_Cancel)
				{// if any object have property 'cancel'...
					event.Keyboard.keycode=VK_RETURN;
					return temp->Do(event);// ...then send enter key
				}
				temp = temp->next;
			}
		}

		if (!selected)
			selected = last;
		
		return selected->Do(event);
		break;

	case ev_Message:
		while (temp)
		{
			temp->Do(event);
			temp = temp->next;
		}
		break;
	};

	return event;
}
										   
//------------------------------------------------------- ddiForm::First()
ddiView* ddiForm::First()
{
	ddiView* temp=last;
	ddiView* first=0;
	while (temp)
	{
		first= temp;
		temp = temp->next;
	}
	return first;
}

//------------------------------------------------------- ddiForm::Insert()
BOOL ddiForm::Insert(ddiView* view, DWORD x, DWORD y, BOOL ins_modal)
{
	if (!view)
		return FALSE;

	view->coor.x=x;
	view->coor.y=y;

	if (ins_modal)
	{
		Delete(view);
		modal=view;
		modal->next=0;
		modal->owner=this;
		return TRUE;
	}
	
	ddiView* temp=last;
	last=view;
	view->next=temp;
	view->owner=this;

	return TRUE;
}

//------------------------------------------------------- ddiForm::Delete()
ddiView* ddiForm::Delete(ddiView* view)
{
	if (!view)
		return 0;
	if (!last)
		return 0;
	
	if (view==last)
	{
		last=view->next;
		view->owner=0;
		view->next=0;
	}
	else
	{
		ddiView* prev=last;
		ddiView* counter=prev->next;
		
		while ( (counter) && (counter!=view) )
		{
			prev=counter;
			counter=counter->next;
		}

		if (counter)
		{
			prev->next=counter->next;
			counter->owner=0;
			counter->next=0;
		}
		else
			view = 0;
	}
	return view;
}

//------------------------------------------------------- ddiForm::DeleteFromHeap()
void ddiForm::DeleteFromHeap(ddiView* view)
{
	delete (Delete(view));
}

//------------------------------------------------------- ddiForm::GetObject()
ddiView* ddiForm::GetObject(WORD tag)
{
	if (!tag)
		return 0;
	
	if (this->tag==tag)
		return this;

	if ( (modal) && (modal->tag==tag) )
		return modal;

	ddiView* temp = last;
	while( (temp) && (temp->tag!=tag) )
		temp = temp->next;

	if (temp)
		return temp;
	else
		return 0;
}

//------------------------------------------------------- ddiForm::EventForEach()
BOOL ddiForm::EventForEach(ddiEvent event)
{
	ddiView* temp=last;
	while (temp)
	{
		temp->Do(event);
		temp = temp->next;
	};
	return TRUE;
}//\\ ddiForm class


/*
///////////////////////////////////////////////////////////////////////
//******************	ddiMessageWindow		***********************
///////////////////////////////////////////////////////////////////////
ddiMessageWindow::ddiMessageWindow(CPoint p=0)
: ddiForm(p)
{ 
	tg_Button = 1000; last_tg_b = tg_Button;
	tg_String = 2000; last_tg_s = tg_String;
}


BOOL ddiMessageWindow::InsertButton(CString ttl, HFONT f, WORD cm)
{
	ddiLabelButton* lblButton = new ddiLabelButton;
	last_tg_b--;
	lblButton->tag = last_tg_b;
	lblButton->command = cm;
	Insert(lblButton, 0, 0);
	if (SortButtons())
		lblButton->Init(ttl,f);
	else
		return FALSE;

	return TRUE;
}

BOOL ddiMessageWindow::InsertString(CString ttl)
{
	ddiLabel* lblString = new ddiLabel;
	last_tg_s--;
	lblString->tag = last_tg_s;
	Insert(lblString, 0, 0);
	if (SortButtons())
		lblString->Init(ttl,f);
	else
		return FALSE;

	return TRUE;

}//\\ ddiMessageWindow
*/


///////////////////////////////////////////////////////////////////////
//******************	ddiPicture		*******************************
///////////////////////////////////////////////////////////////////////

//------------------------------------------------------- Constructor ddiPicture
ddiPicture::ddiPicture(CPoint p)
:ddiView(p)
{
	selectsurf=0;pressedsurf=0;masksurf=0;
}

//------------------------------------------------------- Destructor ddiPicture
ddiPicture::~ddiPicture()
{
	if (selectsurf) selectsurf->Release();
	if (pressedsurf) pressedsurf->Release();
	if (masksurf) masksurf->Release();
}

//------------------------------------------------------- ddiPicture::Draw()
void ddiPicture::Draw(LPDIRECTDRAWSURFACE s)
{
	POINT gc = GetGlobalCoor();

	if (GetState(sf_Active))
	{
		if (!GetState(sf_Disabled))
			if (pressedsurf)
				ddw->BltSurface(s, pressedsurf, gc.x, gc.y);
			else
				ddw->BltSurface(s, selectsurf, gc.x, gc.y);
	}
	else if (GetState(sf_Focused))
	{
		if (!GetState(sf_Disabled))
			ddw->BltSurface(s, selectsurf, gc.x, gc.y);
	}
	else if (surf)
		ddw->BltSurface(s, surf, gc.x, gc.y);

}

//------------------------------------------------------- ddiPicture::Do()
ddiEvent ddiPicture::Do(ddiEvent event)
{
	return ddiView::Do(event);
}

//------------------------------------------------------- ddiPicture::Init()
BOOL ddiPicture::Init(CString nonselect, CString select, CString press, CString mask)
{
	if (nonselect!="")
	{
		if (surf)
		{
			surf->Release();
			surf=0;
		};
		surf=ddw->CreateSurface(nonselect);
		if (!surf) return FALSE;
	};
	if (select!="")
	{
		if (selectsurf)
		{
			selectsurf->Release();
			selectsurf=0;
		};
		selectsurf=ddw->CreateSurface(select);
		if (!selectsurf) return FALSE;
	};
	if (press!="")
	{
		if (pressedsurf)
		{
			pressedsurf->Release();
			pressedsurf=0;
		};
		pressedsurf=ddw->CreateSurface(press);
		if (!pressedsurf) return FALSE;
	};
	if (mask!="")
	{
		if (masksurf)
		{
			masksurf->Release();
			masksurf=0;
		};
		masksurf=ddw->CreateSurface(mask);
		if (!masksurf) return FALSE;
	};

	if (selectsurf)
	{
		DWORD w,h;
		if (ddw->GetSurfaceDimensions(selectsurf, w, h))
			size.x=w; size.y=h;
	};
	return TRUE;
}//\\ ddiPicture::Init()

//------------------------------------------------------- ddiPicture::InView()
BOOL ddiPicture::InView(POINT p)
{
	return (ddiView::InView(p) && InMask(p));
}

//------------------------------------------------------- ddiPicture::InMask()
BOOL ddiPicture::InMask(POINT p)
{
	if (masksurf==0)
		return TRUE;

	p.x-=coor.x;
	p.y-=coor.y;
	
	DDSURFACEDESC desc;
	ZeroMemory( &desc, sizeof(desc) );
	desc.dwSize = sizeof(desc);
	masksurf->GetSurfaceDesc( &desc );
	HRESULT res=masksurf->Lock( 0, &desc, DDLOCK_WAIT, 0 );
 	if (res!=DD_OK)
 	{
 		TRACE("ddiPicture::InMask - Lock() FAILED !!!\n");
 		return FALSE;
 	}

	BYTE* pixelbyte=(BYTE*)desc.lpSurface;

	long color=0;
	if (ddw->GetDisplayDepth()==16)
	{
 		USHORT* pixel=(unsigned short*)(pixelbyte+(p.y*desc.lPitch+p.x*2));
		color = (long)(*pixel);
	}
	else if (ddw->GetDisplayDepth()==24)
	{
		RGBTRIPLE* pixel=(RGBTRIPLE*)(pixelbyte+(p.y*desc.lPitch+p.x*3));
		color = (pixel->rgbtRed | pixel->rgbtGreen | pixel->rgbtBlue);
	}
	else
		return TRUE;


	BOOL r;
	if (color)
		r=TRUE;
	else
		r=FALSE;
 	
	masksurf->Unlock( 0 );
	
	return r;
}//\\ ddiPicture class



///////////////////////////////////////////////////////////////////////
//******************	ddiLabel		*******************************
///////////////////////////////////////////////////////////////////////

//------------------------------------------------------- Constructor ddiLabel
ddiLabel::ddiLabel(CPoint p)
:ddiView(p)
{
	options=of_AlignLeft;
	palette[COLOR_BACKGROUND]	= RGB(  0,  0,  0);// Standart Palette
	palette[COLOR_NORMAL]		= RGB(  0,  0,255);
	palette[COLOR_FOCUSED]		= RGB(255,255,255);
	palette[COLOR_SELECTED]		= RGB(255,255,  0);
	palette[COLOR_DISABLED]		= RGB(127,127,127);
	palette[COLOR_ERROR]		= RGB(255,  0,  0);
}

//------------------------------------------------------- ddiLabel::Init()
BOOL ddiLabel::Init(CString ttl, HFONT f)
{
	if (!owner)
		Fatal("ddiLabel: You must insert object in form last!");

	title = ttl;// на всякий случай... (например для ddiList)

	DWORD w,h;
	WidthText(ttl,f,w,h);

	size.x=w;size.y=h;
	
	if ( (options & of_AlignLeft) && (options & of_AlignRight) )
	{
		options -= (of_AlignLeft + of_AlignRight);
		coor.x-=int(size.x/2);
	}
	else if (options & of_AlignRight)
	{
		options -= of_AlignRight;
		coor.x-=size.x;
	}

	if (surf)
	{
		surf->Release();
		surf=0;
	}
	
	surf=ddw->CreateSurface(w,h);
	ddw->ClearSurface(surf,palette[COLOR_BACKGROUND]);
	if (owner->surf)
	{
		CRect r;
		r.left=coor.x;
		r.top=coor.y;
		r.right=r.left+size.x;
		r.bottom=r.top+size.y;
		HRESULT rs=surf->BltFast(0, 0, owner->surf, &r, DDBLTFAST_WAIT);
		if (rs!=DD_OK)
		{
			TRACE("*_ERROR_*  ddiLabel::Init blit failed\n");
			ddw->CheckResult(rs);
		}
	}

	WriteText(ttl, f, surf, 0, 0, palette[COLOR_NORMAL]);

	return TRUE;
}

//------------------------------------------------------- ddiLabel::Draw()
void ddiLabel::Draw(LPDIRECTDRAWSURFACE s)
{
	POINT gc = GetGlobalCoor();
	ddw->BltSurface( s, surf, gc.x, gc.y);
}

//------------------------------------------------------- ddiLabel::Do()
ddiEvent ddiLabel::Do(ddiEvent event)
{
	Clear(event);
	return event;
}

//------------------------------------------------------- ddiLabel::WriteText()
BOOL ddiLabel::WriteText(CString text, HFONT font, LPDIRECTDRAWSURFACE s, WORD x, WORD y, DWORD color)
{
	if (!s)
		return FALSE;

	DWORD w,h;
	WidthText(text, font, w, h);
	y -= int(h*0.2);// для сокращения расстояния сверху до надписи

	HDC hdc;
	s->GetDC(&hdc);
	const char* txt=LPCTSTR(text);
	SelectObject ( hdc, font);
	SetBkMode( hdc, TRANSPARENT);
	SetTextColor( hdc, color);
	TextOut( hdc, x, y, txt, strlen(txt));
	DeleteObject(font);
	s->ReleaseDC(hdc);

	return TRUE;
}

//------------------------------------------------------- ddiLabel::WidthText()
void ddiLabel::WidthText(CString text, HFONT font, DWORD &w, DWORD &h)
{
	HDC	hdc = ::GetDC(0);
	SelectObject( hdc, font);
	SIZE size;
	const char* txt=LPCTSTR(text);
	GetTextExtentPoint(hdc,txt,strlen(txt),&size);
	w=size.cx;
	
	if (text.FindOneOf("gjpqy")==-1)// для сокращения промежутка снизу надписи
		h=int(size.cy*0.8);// not found
	else
		h=int(size.cy*0.9);// found
	
	DeleteObject(font);
	::ReleaseDC(0,hdc);
}

//------------------------------------------------------- ddiLabel::SetColor()
BOOL ddiLabel::SetColor(BYTE color, DWORD value)
{
	if (color>MAX_COLORS-1)
		return FALSE;

	palette[color] = value;
	return TRUE;
}

//------------------------------------------------------- ddiLabel::SetPalette()
BOOL ddiLabel::SetPalette(DWORD c1, DWORD c2, DWORD c3, DWORD c4, DWORD c5, DWORD c6)
{
	if (MAX_COLORS<6)
		return FALSE;

	palette[0] = c1;
	palette[1] = c2;
	palette[2] = c3;
	palette[3] = c4;
	palette[4] = c5;
	palette[5] = c6;

	return TRUE;
}//\\ ddiLabel class



///////////////////////////////////////////////////////////////////////
//******************	ddiLabelButton		***************************
///////////////////////////////////////////////////////////////////////

//------------------------------------------------------- CONSTRUCTOR ddiLabelButton
ddiLabelButton::ddiLabelButton(CPoint p)
:ddiLabel(p)
{
	options=of_AlignLeft;
	selectsurf=0;
}

//------------------------------------------------------- DESTRUCTOR ddiLabelButton
ddiLabelButton::~ddiLabelButton()
{;}

//------------------------------------------------------- ddiLabelButton::Init()
BOOL ddiLabelButton::Init(CString ttl, HFONT f)
{
	ddiLabel::Init(ttl, f);

	if (selectsurf)
	{
		selectsurf->Release();
		selectsurf=0;
	}
	
	DWORD w,h;
	ddw->GetSurfaceDimensions(surf, w, h);
	selectsurf=ddw->CreateSurface(w,h);
	ddw->ClearSurface(selectsurf,palette[COLOR_BACKGROUND]);
	if (owner->surf)
	{
		CRect r;
		r.left=coor.x;
		r.top=coor.y;
		r.right=r.left+size.x;
		r.bottom=r.top+size.y;
		HRESULT rs=selectsurf->BltFast(0, 0, owner->surf, &r, DDBLTFAST_WAIT);
		if (rs!=DD_OK)
		{
			TRACE("*_ERROR_*  ddiLabelButton::Init() blit failed\n");
			ddw->CheckResult(rs);
		}
	}

	WriteText(ttl, f, selectsurf, 0, 0, palette[COLOR_FOCUSED]);

	if (owner->TraceAll)
		TRACE("ddiLabelButton(%d)::Init('%s')\n",command,ttl);

	return TRUE;
}

//------------------------------------------------------- ddiLabelButton::Draw()
void ddiLabelButton::Draw(LPDIRECTDRAWSURFACE s)
{
	POINT gc = GetGlobalCoor();
	if ( GetState(sf_Focused) )
		ddw->BltSurface(s, selectsurf, gc.x, gc.y);
	else
		ddw->BltSurface(s, surf, gc.x, gc.y);
}

//------------------------------------------------------- ddiLabelButton::Do()
ddiEvent ddiLabelButton::Do(ddiEvent event)
{
	return ddiView::Do(event);
}//\\ ddiLabelButton class



///////////////////////////////////////////////////////////////////////
//******************	ddiLabelList		***************************
///////////////////////////////////////////////////////////////////////

//------------------------------------------------------- CONSTRUCTOR ddiLabelList
ddiLabelList::ddiLabelList(CPoint p)
:ddiLabelButton(p)
{
	lshList=new ddiList(this);
	main_width=0;
	title = "";
}

//------------------------------------------------------- DESTRUCTOR ddiLabelList
ddiLabelList::~ddiLabelList()
{
	offset=0;
}

//------------------------------------------------------- ddiLabelList::Init()
BOOL ddiLabelList::Init(CString ttl, HFONT f)
{
	value = ttl+" > ";
	font = f;
	ddiLabelButton::Init(value, f);
	
	DWORD w,h;
	ddw->GetSurfaceDimensions(surf, w, h);
	main_width=(WORD)w;

	owner->Insert(lshList,coor.x+main_width-offset,coor.y);
	lshList->SetState(sf_Disabled, TRUE);
	lshList->SetState(sf_Visible, FALSE);
	lshList->Init(font, palette);

	return TRUE;
}

//------------------------------------------------------- ddiLabelList::Draw()
void ddiLabelList::Draw(LPDIRECTDRAWSURFACE s)
{
	ddiLabelButton::Draw(s);
}

//------------------------------------------------------- ddiLabelList::Do()
ddiEvent ddiLabelList::Do(ddiEvent event)
{
	POINT p={0,0};
	if (event.what==ev_Mouse)
		p=GetLocalCoor(event.Mouse.where);

	event = ddiView::Do(event);

	switch (event.what)
	{
	case ev_Keyboard:
		switch (event.Keyboard.keycode)
		{
		case VK_LEFT:
		case VK_RIGHT:
			ddiLabelButton::Init(title, font);
			lshList->Do(Message(ms_FocusOff));
			lshList->First()->Do(Message(ms_FocusOn));
			lshList->SetState(sf_Disabled, FALSE);
			lshList->SetState(sf_Visible, TRUE);
			owner->Insert(lshList,coor.x+main_width-offset,coor.y,TRUE);
			Clear(event);
			break;
		}
		break;

	case ev_Message:
		switch (event.Message.command)
		{
		case ms_ListCancel:
			owner->modal=0;
			lshList->SetState(sf_Disabled, TRUE);
			lshList->SetState(sf_Visible, FALSE);
			owner->Insert(lshList,coor.x+main_width-offset,coor.y);
			
			SetCurrentValue(command);
			Clear(event);
			break;

		case ms_ListOK:
			owner->modal=0;
			lshList->SetState(sf_Disabled, TRUE);
			lshList->SetState(sf_Visible, FALSE);
			owner->Insert(lshList,coor.x+main_width-offset,coor.y);

			SetCurrentValue(lshList->SelectedCommand());
			Clear(event);
			break;
		}
		break;

	case ev_Command:
		if (p.x<main_width)
			NextValue();
		else
		{
			ddiLabelButton::Init(title, font);
			lshList->Do(Message(ms_FocusOff));
			lshList->SetState(sf_Disabled, FALSE);
			lshList->SetState(sf_Visible, TRUE);
			owner->Insert(lshList,coor.x+main_width-offset,coor.y,TRUE);
		}
		Clear(event);
		break;
	}
	return event;
}

//------------------------------------------------------- ddiLabelList::SetBack()
void ddiLabelList::SetBack(BOOL sh, COLORREF sh_c, BYTE sh_t, BOOL fr, COLORREF fr_c)
{
	if (sh)
		offset=2;
	lshList->SetBackOptions(sh,sh_c,sh_t,fr,fr_c);
}

//------------------------------------------------------- ddiLabelList::AddItem()
BOOL ddiLabelList::AddItem(CString ttl, WORD cm)
{
	return lshList->AddItem(ttl, cm);
}

//------------------------------------------------------- ddiLabelList::SetCurrentValue()
BOOL ddiLabelList::SetCurrentValue(WORD cm)
{
	CString temp = lshList->GetString(cm);

	if (temp!="*_ERROR_*")
	{
		ddiLabelButton::Init(value+temp, font);
		command=cm;
		lshList->command=cm;
		return TRUE;
	}
	else
	{
		TRACE("ddiLabelList::SetCurrentValue() *_ERROR_*\n");
		return FALSE;
	}
}

//------------------------------------------------------- ddiLabelList::GetCurrentValue()
WORD ddiLabelList::GetCurrentValue()
{
	return command;
}

//------------------------------------------------------- ddiLabelList::NextValue()
void ddiLabelList::NextValue()
{
	SetCurrentValue(lshList->NextCommand(GetCurrentValue()));
}//\\ ddiLabelList



///////////////////////////////////////////////////////////////////////
//******************	ddiList		***********************************
///////////////////////////////////////////////////////////////////////

//------------------------------------------------------- CONSTRUCTOR ddiList
ddiList::ddiList(ddiView* ow, CPoint p)
:ddiForm(p)
{
	_owner = ow;
	offset_x=0; offset_y=0;
	shadow = FALSE;
	frame = FALSE;
}

//------------------------------------------------------- ddiList::Init()
BOOL ddiList::Init(HFONT f, DDI_PALETTE pal)
{
	font=f;
	for (int i=0; i<MAX_COLORS; i++)
		palette[i]=pal[i];
	size.x=0; size.y=0;

	return TRUE;
}

//------------------------------------------------------- ddiList::Draw()
void ddiList::Draw(LPDIRECTDRAWSURFACE s)
{
	ddiForm::Draw(s);
}

//------------------------------------------------------- ddiList::Do()
ddiEvent ddiList::Do(ddiEvent event)
{
	if ( (event.what==ev_Keyboard) && ( (event.Keyboard.keycode==VK_LEFT) || (event.Keyboard.keycode==VK_RIGHT) ) )
		event=Message(ms_EndModal);

	if ( (event.what==ev_Message) && (event.Message.command==ms_EndModal) )
		return _owner->Do(Message(ms_ListCancel));

	event = ddiForm::Do(event);

	if (event.what==ev_Command)
	{
		//selected=0;
		command=event.Message.command;
		return _owner->Do(Message(ms_ListOK));
	}

	return event;
}

//------------------------------------------------------- ddiList::AddItem()
BOOL ddiList::AddItem(CString ttl, WORD cmd)
{
	//TRACE("ddiList::AddItem() - START --------------------\n");
	ddiLabelButton *tmpView = new ddiLabelButton;
	if (last)
		last->SetKeyMove(0, 0, 0, tmpView);
	tmpView->SetKeyMove(0, 0, last, 0);
	for (int i=0; i<MAX_COLORS; i++)
		tmpView->SetColor(i,palette[i]);
	tmpView->command=cmd;

	//TRACE("ddiList::AddItem() - insert label (x=%d, y=%d)\n", offset_x, size.y+
	Insert(tmpView, offset_x, size.y);
	
	DWORD w,h;
	tmpView->WidthText(ttl, font, w, h);
	size.y+=h;
	int s=size.x-offset_x*2;
	if (s<0) s=0;
	if (w > (unsigned)s)
		size.x = w+offset_x*2;
	
	if (surf)// Creating surface
	{
		surf->Release();
		surf=0;
	}
	surf=ddw->CreateSurface(size.x, size.y);
	ddw->ClearSurface(surf, RGB(127,127,127));

	if (owner->surf)// back blitting
	{
		CRect r;
		r.left=coor.x-owner->coor.x;
		r.top=coor.y-owner->coor.y;
		r.right=r.left+size.x;
		r.bottom=r.top+size.y;

		HRESULT rs=surf->BltFast(0, 0, owner->surf, &r, DDBLTFAST_WAIT);
		if (rs!=DD_OK)
		{
			TRACE("*_ERROR_*  ddiList::AddItem() blit failed\n");
			ddw->CheckResult(rs);
		}
		if (shadow)
			CreateShadow();
		if (frame)
			CreateFrame();
	}

	tmpView->Init(ttl, font);
	
	ddiView* tmp = last;
	while (tmp)
	{
		tmp->size.x = size.x-offset_x*2;
		tmp = tmp->next;
	}

	return TRUE;
}

//------------------------------------------------------- ddiList::SelectedCommand()
WORD ddiList::SelectedCommand()
{
	if (selected)
		return selected->command;
	else
		return command;
}

//------------------------------------------------------- ddiList::NextCommand()
WORD ddiList::NextCommand(WORD cm)
{
	if (last->command==cm)
	{
		ddiView* tmp=last;
		while(tmp->next)
			tmp=tmp->next;
		return tmp->command;
	}

	ddiView* prev=last;
	ddiView* counter=prev->next;
	
	while ( (counter) && (counter->command != cm) )
	{
		prev=counter;
		counter=counter->next;
	}

	if (counter)
		return prev->command;
	else
		return 0;

}

//------------------------------------------------------- ddiList::GetString()
CString ddiList::GetString(WORD cm)
{
	ddiView* tmp = last;
	while ( (tmp) && (tmp->command != cm) )
		tmp = tmp->next;
	
	if (tmp)
		return tmp->title;
	else
		return "*_ERROR_*";
}

//------------------------------------------------------- ddiList::SetBackOptions()
void ddiList::SetBackOptions(BOOL sh, COLORREF sh_c, BYTE sh_t, BOOL fr, COLORREF fr_c)
{
	shadow = sh;
	if (shadow)
	{
		offset_x=11; offset_y=11;
		//coor.y -= offset_y;
		size.x += offset_x*2;
		size.y += offset_y*2;

		shadow_color = sh_c;
		shadow_transparent = sh_t;
	}

	frame = fr;
	if (frame)
		frame_color = fr_c;
}

//------------------------------------------------------- ddiList::CreateShadow()
BOOL ddiList::CreateShadow()
{
	int x,y;

	if (TRUE)
	{
		double m[10][10]=
		{ 0.00, 0.01, 0.02, 0.03, 0.05, 0.10, 0.30, 0.50, 0.60, 0.70,

		  0.01, 0.03, 0.05, 0.10, 0.20, 0.40, 0.70, 1.00, 1.00, 1.00,

		  0.02, 0.05, 0.12, 0.30, 0.70, 1.00, 1.00, 1.00, 1.00, 1.00,

		  0.03, 0.10, 0.30, 0.75, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00,

		  0.05, 0.20, 0.70, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00,

		  0.10, 0.40, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00,

		  0.30, 0.70, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00,

		  0.50, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00,

		  0.60, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00,

		  0.70, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00, 1.00 };


		for (y = 0; y < 10; y++)// левый верхний угол
			for (x = 0; x < 10; x++)
				ddw->PointAlpha(surf, x, y, shadow_color, 
				int(shadow_transparent*m[x][y]+0.5));

		for (y = 0; y < 10; y++)// верхняя полоса
			for (x = 10; x < size.x-10; x++)
				ddw->PointAlpha(surf, x, y, shadow_color, shadow_transparent);

		for (y = 0; y < 10; y++)// правый верхний угол
			for (x = size.x-11; x < size.x; x++)
				ddw->PointAlpha(surf, x, y, shadow_color,
				int(shadow_transparent*m[size.x-(x+1)][y]+0.5));

		for (y = 10; y < size.y-10; y++)// центр
			for (x = 0; x < size.x; x++)
				ddw->PointAlpha(surf, x, y, shadow_color, shadow_transparent);

		for (y = size.y-10; y < size.y; y++)// левый нижний угол
			for (x = 0; x < 10; x++)
				ddw->PointAlpha(surf, x, y, shadow_color,
				int(shadow_transparent*m[x][size.y-(y+1)]+0.5));

		for (y = size.y-10; y < size.y; y++)// нижняя полоса
			for (x = 10; x < size.x-10; x++)
				ddw->PointAlpha(surf, x, y, shadow_color, shadow_transparent);

		for (y = size.y-10; y < size.y; y++)// правый нижний угол
			for (x = size.x-11; x < size.x; x++)
				ddw->PointAlpha(surf, x, y, shadow_color, 
				int(shadow_transparent*m[size.x-(x+1)][size.y-(y+1)]+0.5));
	}
	else
		for (int y=0; y<size.y; y++)
			for (int x=0; x<size.x; x++)
				ddw->PointAlpha(surf, x, y, shadow_color, shadow_transparent);

	return TRUE;
}

//------------------------------------------------------- ddiList::CreateFrame()
BOOL ddiList::CreateFrame()
{
//	for (int y=0; y<size.y; y++)
//		for (int x=0; x<size.x; x++)
//			ddw->PointAlpha(surf, x, y, sh_c, 100);

	return TRUE;
}//\\ ddiList class
