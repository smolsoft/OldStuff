//////////////////////////////////////////////////////////////////////
//
//	PITONinterface.cpp: implementation of the ddiPITONinterface class.
//
//////////////////////////////////////////////////////////////////////
#include "headers.h"
#include "DDInterface.h"
#include "PITONinterface.h"
#include "PITONgame.h"


#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif



// PITON colors palette
const COLORREF P_colr1=RGB(  0,   0,   0);// back color
const COLORREF P_colr2=RGB( 20,  20,  20);// normal color
const COLORREF P_colr3=RGB(255, 255, 255);// focused color
const COLORREF P_colr4=RGB(255,   0,   0);// selected color
const COLORREF P_colr5=RGB(150, 150, 150);// disabled color
const COLORREF P_colr6=RGB(150,   0,   0);// error color



///////////////////////////////////////////////////////////////////////
//******************	ddiPITONinterface		***********************
///////////////////////////////////////////////////////////////////////

//------------------------------------------------------- CONSTRUCTOR ddiPITONinterface
ddiPITONinterface::ddiPITONinterface()
{
	font_main = Font("Bedrock", 31);

	ReadConfig();

	InitMenu();
	InitMode();
	InitOptions();
	
	InitWindow();

	
	// DEBUG
	/*lstDebug = new ddiList(font, nrm_color, foc_color);
	lstDebug->Init(50,10);
	lstDebug->AddItem("TYUIOP",777);
	lstDebug->AddItem("QWERTY",555);
	frmMenu->Insert(lstDebug);*/

	current_form=frmMenu;
}

//------------------------------------------------------- DESTRUCTOR ddiPITONinterface
ddiPITONinterface::~ddiPITONinterface()
{
	delete frmMenu;//------	frmMenu
	delete frmMode;//------	frmMode
	delete frmOptions;//---	frmOptions
	delete frmWindow;//---- frmWindow

	//delete lstDebug;
}

//------------------------------------------------------- ddiPITONinterface::Draw()
void ddiPITONinterface::Draw(LPDIRECTDRAWSURFACE s)
{
	current_form->Draw(s);
}

//------------------------------------------------------- ddiPITONinterface::Do()
ddiEvent ddiPITONinterface::Do(ddiEvent event)
{
	event = current_form->Do(event);

	if (event.what==ev_Command)
	{
		switch (event.Message.command)
		{
		case cm_Start:
			TRACE("INTERFACE - Start The Game !\n");
			break;

		case cm_Mode:
			TRACE("INTERFACE - Go To MODE Form.\n");
			current_form=frmMode;
			break;

		case cm_Options:
			TRACE("INTERFACE - Go To OPTIONS Form.\n");
			current_form=frmOptions;
			break;

		case cm_TopTen:
			TRACE("INTERFACE - Go To TOP TEN Form.\n");
			//current_form=frmTopTen;
			break;

		case cm_Finish:
			TRACE("INTERFACE - Show Question Window...\n");
			event.Message.command = cm_TheEnd;
//			ShowWindow("YOU REALLY WANT QUIT?", "YES",cm_TheEnd, "NO",cm_Cancel);
			break;

		case cm_Credits:
			TRACE("INTERFACE - Show CREDITS Presentation...\n");
			//current_form=frmCredits;
			break;

		case cm_Help:
			TRACE("INTERFACE - Show HELP Presentation...\n");
			//current_form=frmHelp;
			break;

		case cm_DoneMode:
			TRACE("INTERFACE - Exit from MODE Form with saving changes.\n");
			current_form=frmMenu;
			break;

		case cm_CancelMode:
			TRACE("INTERFACE - Exit from MODE Form without saving changes.\n");
			current_form=frmMenu;
			break;

		case cm_DoneOptions:
			TRACE("INTERFACE - Exit from OPTIONS Form with saving changes.\n");
			current_form=frmMenu;
			break;

		case cm_CancelOptions:
			TRACE("INTERFACE - Exit from OPTIONS Form without saving changes.\n");
			current_form=frmMenu;
			break;

		case cm_DoneTopTen:
			TRACE("INTERFACE - Exit from TOP TEN Form.\n");
			current_form=frmMenu;
			break;

		case cm_TheEnd:
			TRACE("INTERFACE - Getted cm_TheEnd.\n");
			//return event;
			break;
		}
		//Clear(event);
	}
	return event;
}

//------------------------------------------------------- ddiPITONinterface::ShowWindow()
BOOL ddiPITONinterface::ShowWindow(CString mes, CString but1, WORD com1, CString but2, WORD com2)
{/*
	DWORD w,w1,h;
//	lblMessage->WidthText(mes, font, w, h);
//	if (w>(unsigned)frmWindow->size.x)
//		mes="*_ERROR_* TOO LONG";
//	lblMessage->options = of_AlignLeft + of_AlignRight;
//	lblMessage->Init(mes, frmWindow->coor.x+size.x/2, frmWindow->coor.y+50);

//debug
	lblMes1->options = of_AlignLeft + of_AlignRight;
	lblMes2->options = of_AlignLeft + of_AlignRight;
	lblMes3->options = of_AlignLeft + of_AlignRight;
	lblMes4->options = of_AlignLeft + of_AlignRight;
	frmWindow->norm_color=nrm_color;
	lblMes1->Init(" YOU REALLY WANT QUIT?", frmWindow->coor.x+size.x/2, frmWindow->coor.y+30);
	frmWindow->norm_color=foc_color;
	lblMes2->Init(" YOU REALLY WANT QUIT?", frmWindow->coor.x+size.x/2, frmWindow->coor.y+60);
	frmWindow->norm_color=not_color;
	lblMes3->Init(" YOU REALLY WANT QUIT?", frmWindow->coor.x+size.x/2, frmWindow->coor.y+90);
	frmWindow->norm_color=sel_color;
	lblMes4->Init(" YOU REALLY WANT QUIT?", frmWindow->coor.x+size.x/2, frmWindow->coor.y+120);
	frmWindow->norm_color=nrm_color;
//debug end

	lblMessage->WidthText(but1, font, w, h);
	lblMessage->WidthText(but2, font, w1, h);
	w1+=w;
	DWORD x=DWORD((frmWindow->size.x - w1)/3);
//	lbtWinButtons[0].Init(but1, frmWindow->coor.x+WORD(x), frmWindow->coor.y+150);
//	lbtWinButtons[1].Init(but2, frmWindow->coor.x+WORD(w+x*2), frmWindow->coor.y+150);
	lbtWinButtons[0].command=com1;
	lbtWinButtons[1].command=com2;

	frmWindow->SetState(sf_ModalFull, TRUE);
	current_form->Insert(frmWindow, TRUE);
*/	
	return TRUE;
}

//------------------------------------------------------- ddiPITONinterface::Font()
HFONT ddiPITONinterface::Font(CString name, WORD size)
{
	return CreateFont( size, 0, 0, 0,	FW_NORMAL, FALSE, FALSE, FALSE, ANSI_CHARSET,
		OUT_DEFAULT_PRECIS, CLIP_DEFAULT_PRECIS, ANTIALIASED_QUALITY, VARIABLE_PITCH, name );
}

//------------------------------------------------------- ddiPITONinterface::InitMenu()
void ddiPITONinterface::InitMenu()
{
	frmMenu = new ddiForm(0);
	frmMenu->surf = ddw->CreateSurface("PICTURES\\mn0.bmp");
	if (!frmMenu->surf)
		Fatal("ERROR: Cannot load image files for menu back picture.");

	ddiPicture* temp1=new ddiPicture;// START picture
	frmMenu->Insert(temp1, 34,306);
	temp1->command = cm_Start;
	if (!temp1->Init("","PICTURES\\ms0.bmp","PICTURES\\mp0.bmp","PICTURES\\mm0.bmp"))
		Fatal("ERROR: Cannot load image files for start picture.");
	ddiPicture* temp2=new ddiPicture;// MODE picture
	frmMenu->Insert(temp2,  6,132);
	temp2->command = cm_Mode;
	if (!temp2->Init("","PICTURES\\ms1.bmp","PICTURES\\mp1.bmp","PICTURES\\mm0.bmp"))
		Fatal("ERROR: Cannot load image files for mode picture.");
	ddiPicture* temp3=new ddiPicture;// OPTIONS picture
	frmMenu->Insert(temp3,251,  2);
	temp3->command = cm_Options;
	if (!temp3->Init("","PICTURES\\ms2.bmp","PICTURES\\mp2.bmp","PICTURES\\mm0.bmp"))
		Fatal("ERROR: Cannot load image files for options picture.");
	ddiPicture* temp4=new ddiPicture;// TOPTEN picture
	frmMenu->Insert(temp4,501,128);
	temp4->command = cm_TopTen;
	if (!temp4->Init("","PICTURES\\ms3.bmp","PICTURES\\mp3.bmp","PICTURES\\mm0.bmp"))
		Fatal("ERROR: Cannot load image files for topten picture.");
	ddiPicture* temp5=new ddiPicture;// FINISH picture
	frmMenu->Insert(temp5,478,308);
	temp5->command = cm_Finish;
	temp5->options |= of_Cancel;
	if (!temp5->Init("","PICTURES\\ms4.bmp","PICTURES\\mp4.bmp","PICTURES\\mm0.bmp"))
		Fatal("ERROR: Cannot load image files for finish picture.");
	ddiPicture* temp6=new ddiPicture;// LOGO picture
	frmMenu->Insert(temp6,290,180);
	temp6->command = cm_Credits;
	if (!temp6->Init("","PICTURES\\ms5.bmp","PICTURES\\mp5.bmp","PICTURES\\mm5.bmp"))
		Fatal("ERROR: Cannot load image files for logo picture.");
	ddiPicture* temp7=new ddiPicture;// PITON picture
	frmMenu->Insert(temp7,206,454);
	temp7->command = cm_Help;
	if (!temp7->Init("","PICTURES\\ms6.bmp","PICTURES\\mp6.bmp",""))
		Fatal("ERROR: Cannot load image files for piton picture.");

	// Setting Keys Move
	temp1->SetKeyMove( temp2, temp5, temp2, temp7);
	temp2->SetKeyMove( temp3, temp6, temp3, temp1);
	temp4->SetKeyMove( temp6, temp3, temp3, temp5);
	temp5->SetKeyMove( temp1, temp4, temp4, temp7);
	temp3->SetKeyMove( temp2, temp4, 0, temp6);
	temp7->SetKeyMove( temp1, temp5, temp6, 0);
	temp6->SetKeyMove( temp2, temp4, temp3, temp7);
	
	
		
	/*	pctMainItems = new ddiPicture[7];
	char filename1[20];
	for (int i=0; i<7; i++)
	{
		sprintf( filename1, "PICTURES\\ms%d.bmp", i);
		if (!pctMainItems[i].Init("",filename1,filename2,""))
			Fatal("str+=filename1");
	}*/
}

//------------------------------------------------------- ddiPITONinterface::InitMode()
void ddiPITONinterface::InitMode()
{
	frmMode = new ddiForm;
	frmMode->surf = ddw->CreateSurface("PICTURES\\mn1.bmp");
	if (!frmMode->surf)
		Fatal("ERROR: Cannot load image files for mode back picture.");

	ddiPicture* temp=new ddiPicture;// MODE static picture
	frmMode->Insert(temp,159, 92);
	if (!temp->Init("PICTURES\\mt0.bmp","","",""))
		Fatal("ERROR: Cannot load image files for mode label.");
	ddiPicture* temp1=new ddiPicture;// DONE picture
	frmMode->Insert(temp1,580,455);
	temp1->command = cm_DoneMode;
	if (!temp1->Init("","PICTURES\\mb0.bmp","",""))
		Fatal("ERROR: Cannot load image files for done button.");
	ddiPicture* temp2=new ddiPicture;// CANCEL picture
	frmMode->Insert(temp2,555,490);
	temp2->command = cm_CancelMode;
	temp2->options |= of_Cancel;
	if (!temp2->Init("","PICTURES\\mb1.bmp","",""))
		Fatal("ERROR: Cannot load image files for cancel button.");
	//...
	ddiLabelList* temp4=new ddiLabelList;// DIFFICULT list
	frmMode->Insert(temp4,400,180);
	temp4->options = of_AlignRight;
	temp4->SetBack(TRUE, 0, 60, FALSE, 0);
	temp4->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp4->Init("difficult", font_main);
	temp4->tag = tg_DIFFICULT;
	temp4->AddItem("EASY",		cm_DF_Easy);
	temp4->AddItem("AVERAGE",	cm_DF_Average);
	temp4->AddItem("PRO",		cm_DF_Pro);
	temp4->AddItem("HARDCORE",	cm_DF_Hardcore);	
	temp4->SetCurrentValue(config.Difficult);

	ddiLabelList* temp5=new ddiLabelList;// WRAP list
	frmMode->Insert(temp5,400,230);
	temp5->options = of_AlignRight;
	temp5->SetBack(TRUE, 0, 60, FALSE, 0);
	temp5->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp5->Init("wrap", font_main);
	temp5->tag = tg_WRAP;
	temp5->AddItem("ON",	cm_WR_On);
	temp5->AddItem("OFF",	cm_WR_Off);
	temp5->SetCurrentValue(config.Wrap);

	ddiLabelList* temp6=new ddiLabelList;// GRID list
	frmMode->Insert(temp6,400,270);
	temp6->options = of_AlignRight;
	temp6->SetBack(TRUE, 0, 60, FALSE, 0);
	temp6->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp6->Init("grid", font_main);
	temp6->tag = tg_GRID;
	temp6->AddItem("RED",	cm_GR_Red);
	temp6->AddItem("BLACK",	cm_GR_Black);
	temp6->AddItem("OFF",	cm_GR_Off);
	temp6->SetCurrentValue(config.Grid);

	ddiLabelList* temp7=new ddiLabelList;// LOCATOR list
	frmMode->Insert(temp7,400,310);
	temp7->options = of_AlignRight;
	temp7->SetBack(TRUE, 0, 60, FALSE, 0);
	temp7->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp7->Init("locator", font_main);
	temp7->tag = tg_LOCATOR;
	temp7->AddItem("ALWAYS",	cm_LC_Always);
	temp7->AddItem("ONCE",		cm_LC_Once);
	temp7->AddItem("NEVER",		cm_LC_None);
	temp7->SetCurrentValue(config.Locator);

	ddiLabelList* temp8=new ddiLabelList;// LEVELS list
	frmMode->Insert(temp8,400,360);
	temp8->options = of_AlignRight;
	temp8->SetBack(TRUE, 0, 60, FALSE, 0);
	temp8->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp8->Init("current level", font_main);
	temp8->tag = tg_LEVEL;
	temp8->AddItem("LEVEL 1",	tg_LEVEL+1);
	temp8->AddItem("LEVEL 2",	tg_LEVEL+2);
	temp8->AddItem("LEVEL 3",	tg_LEVEL+3);
	temp8->AddItem("LEVEL 4",	tg_LEVEL+4);
	temp8->SetCurrentValue(tg_LEVEL+1);//debug

	ddiLabelList* temp9=new ddiLabelList;// SHUFFLE list
	frmMode->Insert(temp9,400,400);
	temp9->options = of_AlignRight;
	temp9->SetBack(TRUE, 0, 60, FALSE, 0);
	temp9->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp9->Init("shuffle", font_main);
	temp9->tag = tg_SHUFFLE;
	temp9->AddItem("ON",	cm_SH_On);
	temp9->AddItem("OFF",	cm_SH_Off);
	temp9->SetCurrentValue(config.Shuffle);

	ddiLabelButton* temp10=new ddiLabelButton;// LOAD GAME button
	frmMode->Insert(temp10,400,450);
	temp10->options = of_AlignRight;
	temp10->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp10->Init("load game", font_main);
	temp10->command = cm_LoadGame;

	ddiLabelList* temp3=new ddiLabelList;// GAME MODE list
	frmMode->Insert(temp3,400,140);
	temp3->options = of_AlignRight;
	temp3->SetBack(TRUE, 0, 60, FALSE, 0);
	temp3->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp3->Init("game mode", font_main);
	temp3->tag = tg_GAME_MODE;
	temp3->AddItem("ONE PLAYER",cm_GM_One);
	temp3->AddItem("FRIENDS",	cm_GM_Friends);
	temp3->AddItem("ENEMIES",	cm_GM_Enemies);
	temp3->AddItem("SURROUND",	cm_GM_Surround);
	temp3->SetCurrentValue(config.GameMode);

	// Set Key Moves
	temp3->SetKeyMove( 0, 0, 0, temp4);
	temp4->SetKeyMove( 0, 0, temp3, temp5);
	temp5->SetKeyMove( 0, 0, temp4, temp6);
	temp6->SetKeyMove( 0, 0, temp5, temp7);
	temp7->SetKeyMove( 0, 0, temp6, temp8);
	temp8->SetKeyMove( 0, 0, temp7, temp9);
	temp9->SetKeyMove( 0, 0, temp8, temp10);
	temp10->SetKeyMove(0, temp1, temp9, temp1);
	temp1->SetKeyMove( temp10, 0,temp10, temp2);
	temp2->SetKeyMove( temp10, 0, temp1, 0);

}

//------------------------------------------------------- ddiPITONinterface::InitOptions()
void ddiPITONinterface::InitOptions()
{
	frmOptions = new ddiForm;
	ddw->GetDDraw()->DuplicateSurface(frmMode->surf, &frmOptions->surf);

	ddiPicture* temp=new ddiPicture;// OPTIONS static picture
	frmOptions->Insert(temp,159, 92);
	temp->command=7777;
	if (!temp->Init("PICTURES\\mt1.bmp","","",""))
		Fatal("ERROR: Cannot load image files for options label.");
	ddiPicture* temp1=new ddiPicture;// DONE picture
	frmOptions->Insert(temp1,580,455);
	temp1->command = cm_DoneOptions;
	if (!temp1->Init("","PICTURES\\mb0.bmp","",""))
		Fatal("ERROR: Cannot load image files for done button.");
	ddiPicture* temp2=new ddiPicture;// CANCEL picture
	frmOptions->Insert(temp2,555,490);
	temp2->command = cm_CancelOptions;
	temp2->options |= of_Cancel;
	if (!temp2->Init("","PICTURES\\mb1.bmp","",""))
		Fatal("ERROR: Cannot load image files for cancel button.");


	ddiLabelList* temp4=new ddiLabelList;// VIDEO MODE list
	frmOptions->Insert(temp4,400,200);
	temp4->options = of_AlignRight;
	temp4->SetBack(TRUE, 0, 60, FALSE, 0);
	temp4->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp4->Init("video mode", font_main);
	temp4->tag = tg_VIDEOMODE;
	int last_mode=0; int count=0;
	for (int i=0; i<ddw->GetNumDisplayModes(); i++)
	{
		DWORD w,h,d;
		ddw->GetDisplayModeDimensions(i,w,h,d);
		if ( (d==16) && ( (w*h) >= (640*480) ) )
		{
			last_mode=i;
			char mode[11];	
			sprintf( mode, "%d x %d", w, h);
			temp4->AddItem(mode, tg_VIDEOMODE+i);
		}
		if (count==10)
			break;
	}
	if (last_mode)
		temp4->SetCurrentValue(tg_VIDEOMODE+last_mode);
	else
		Fatal("You have f..king videocard!\nPITON can't get necessary video mode");

	ddiLabelList* temp5=new ddiLabelList;// MUSIC list
	frmOptions->Insert(temp5,400,250);
	temp5->options = of_AlignRight;
	temp5->SetBack(TRUE, 0, 60, FALSE, 0);
	temp5->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp5->Init("music", font_main);
	temp5->tag = tg_MUSIC;
	temp5->AddItem("ON",		cm_MS_On);
	temp5->AddItem("MENU ONLY",	cm_MS_Menu);
	temp5->AddItem("OFF",		cm_MS_Off);
	temp5->SetCurrentValue(config.Music);

	ddiLabelList* temp6=new ddiLabelList;// MUSIC VOLUME list
	frmOptions->Insert(temp6,400,290);
	temp6->options = of_AlignRight;
	temp6->SetBack(TRUE, 0, 60, FALSE, 0);
	temp6->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp6->Init("music volume", font_main);
	temp6->tag = tg_MUSIC_VOLUME;
	temp6->AddItem("MAX",	cm_MV_100);
	temp6->AddItem("75%",	cm_MV_75);
	temp6->AddItem("50%",	cm_MV_50);
	temp6->AddItem("25%",	cm_MV_25);
	temp6->SetCurrentValue(config.MusicVol);

	ddiLabelList* temp7=new ddiLabelList;// SOUND list
	frmOptions->Insert(temp7,400,340);
	temp7->options = of_AlignRight;
	temp7->SetBack(TRUE, 0, 60, FALSE, 0);
	temp7->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp7->Init("sound", font_main);
	temp7->tag = tg_SOUND;
	temp7->AddItem("ON",		cm_SN_On);
	temp7->AddItem("MENU ONLY",	cm_SN_Menu);
	temp7->AddItem("OFF",		cm_SN_Off);
	temp7->SetCurrentValue(config.Sound);

	ddiLabelList* temp8=new ddiLabelList;// SOUND VOLUME list
	frmOptions->Insert(temp8,400,380);
	temp8->options = of_AlignRight;
	temp8->SetBack(TRUE, 0, 60, FALSE, 0);
	temp8->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp8->Init("sound volume", font_main);
	temp8->tag = tg_SOUND_VOLUME;
	temp8->AddItem("MAX",	cm_SV_100);
	temp8->AddItem("75%",	cm_SV_75);
	temp8->AddItem("50%",	cm_SV_50);
	temp8->AddItem("25%",	cm_SV_25);
	temp8->SetCurrentValue(config.SoundVol);

	ddiLabelButton* temp9=new ddiLabelButton;
	frmOptions->Insert(temp9,395,430);
	temp9->options = of_AlignRight;
	temp9->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp9->Init("controls", font_main);
	temp9->command = cm_Controls;

	ddiLabelList* temp3=new ddiLabelList;// GRAPHIC list
	frmOptions->Insert(temp3,400,160);
	temp3->options = of_AlignRight;
	temp3->SetBack(TRUE, 0, 60, FALSE, 0);
	temp3->SetPalette(P_colr1, P_colr2, P_colr3, P_colr4, P_colr5, P_colr6);
	temp3->Init("graphic", font_main);
	temp3->tag = tg_GRAPHIC;
	temp3->AddItem("FULL",		cm_GF_Full);
	temp3->AddItem("HIGH",		cm_GF_High);
	temp3->AddItem("MEDIUM",	cm_GF_Medium);
	temp3->AddItem("LOW",		cm_GF_Low);
	temp3->AddItem("NONE",		cm_GF_None);
	temp3->SetCurrentValue(config.Graphic);

	// set keys moves
	temp3->SetKeyMove( 0, 0, 0, temp4);
	temp4->SetKeyMove( 0, 0, temp3, temp5);
	temp5->SetKeyMove( 0, 0, temp4, temp6);
	temp6->SetKeyMove( 0, 0, temp5, temp7);
	temp7->SetKeyMove( 0, 0, temp6, temp8);
	temp8->SetKeyMove( 0, 0, temp7, temp9);
	temp9->SetKeyMove( 0, temp1, temp8, temp1);
	temp1->SetKeyMove( temp9, 0, temp9, temp2);
	temp2->SetKeyMove( temp9, 0, temp1, 0);

}

//------------------------------------------------------- ddiPITONinterface::InitWindow()
void ddiPITONinterface::InitWindow()
{
	frmWindow = new ddiForm(0);
	frmWindow->surf = ddw->CreateSurface("PICTURES\\mw0.bmp");
	if (!frmMenu->surf)
		Fatal("ERROR: Cannot load image files for window back picture.");

	frmWindow->size.x=336; frmWindow->size.y=192;
	frmWindow->coor.x=232; frmWindow->coor.y=204;
}

//------------------------------------------------------- ddiPITONinterface::ReadConfig()
BOOL ddiPITONinterface::ReadConfig()
{
	// DEBUG START --- Read Configuration
	
	//VideoMode;
	//VideoWidth;
	//VideoHeight;
	config.Graphic		= cm_GF_High;
	config.GameMode		= cm_GM_One;
	config.Shuffle		= cm_SH_Off;
	config.Difficult	= cm_DF_Average;
	config.Grid			= cm_GR_Black;
	config.Wrap			= cm_WR_Off;
	config.Locator		= cm_LC_Always;
	config.FlyBonus		= cm_FL_None;
	
	config.Music		= cm_MS_On;
	config.MusicVol		= cm_MV_75;
	config.Sound		= cm_SN_On;
	config.SoundVol		= cm_SV_25;
	//StringCollection Levels;
	//CString CurrentLevel;
	config.Name1 = "POMAH";
	//WORD Keys1[4];
	config.Name2 = "TYUIOP";
	//WORD Keys2[4];

	// DEBUG END ----- Read Configuration

	return TRUE;
}
