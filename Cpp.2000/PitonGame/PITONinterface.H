//////////////////////////////////////////////////////////////////////
//
//	PITONinterface.h: interface for the ddiPITONinterface class.
//
//////////////////////////////////////////////////////////////////////
#include "DDInterface.h"
#include "DirectDrawWin.h"

#if !defined(_PITONINTERFACE_H)
#define _PITONINTERFACE_H

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000



// PITON Commands
const WORD cm_Start		=	1000;// frmMenu
const WORD cm_Mode		=	1010;
const WORD cm_Options	=	1030;
const WORD cm_TopTen	=	1050;
const WORD cm_Finish	=	1070;
const WORD cm_Credits	=	1080;
const WORD cm_Help		=	1090;
const WORD cm_TheEnd	=	1100;

const WORD cm_SetTimerEasy	=	1001;// frmStart
const WORD cm_SetTimerMedium=	1002;
const WORD cm_SetTimerPro	=	1003;
const WORD cm_SetTimerHard	=	1004;
const WORD cm_SetTimerNone	=	1005;

const WORD cm_LoadGame		=	1021;// frmMode
const WORD cm_CancelMode	=	1022;
const WORD cm_DoneMode		=	1023;

const WORD cm_Controls		=	1041;// frmOptions
const WORD cm_CancelOptions	=	1042;
const WORD cm_DoneOptions	=	1043;

const WORD cm_DoneTopTen	=	1061;// frmTopTen




///////////////////////////////////////////////////////////////////////
//******************	PITONconfig				***********************
///////////////////////////////////////////////////////////////////////
// GameMode consts
const WORD tg_GAME_MODE		=	2000;
const WORD cm_GM_One		=	2000;
const WORD cm_GM_Friends	=	2001;
const WORD cm_GM_Enemies	=	2002;
const WORD cm_GM_Surround	=	2003;

// Difficult consts
const WORD tg_DIFFICULT		=	2010;
const WORD cm_DF_Easy		=	2010;
const WORD cm_DF_Average	=	2011;
const WORD cm_DF_Pro		=	2012;
const WORD cm_DF_Hardcore	=	2013;

// Grid consts
const WORD tg_GRID			=	2020;
const WORD cm_GR_Off		=	2020;
const WORD cm_GR_Black		=	2021;
const WORD cm_GR_Red		=	2022;

// Locator consts
const WORD tg_LOCATOR		=	2030;
const WORD cm_LC_Always		=	2030;
const WORD cm_LC_Once		=	2031;
const WORD cm_LC_None		=	2032;

// Wrap consts
const WORD tg_WRAP			=	2040;
const WORD cm_WR_Off		=	2040;
const WORD cm_WR_On			=	2041;

// Shuffle constst
const WORD tg_SHUFFLE		=	2050;
const WORD cm_SH_Off		=	2050;
const WORD cm_SH_On			=	2051;

// Sound consts
const WORD tg_SOUND			=	2060;
const WORD cm_SN_Off		=	2060;
const WORD cm_SN_Menu		=	2061;
const WORD cm_SN_On			=	2062;

const WORD tg_SOUND_VOLUME	=	2065;
const WORD cm_SV_25			=	2066;
const WORD cm_SV_50			=	2067;
const WORD cm_SV_75			=	2068;
const WORD cm_SV_100		=	2069;

// Music consts
const WORD tg_MUSIC			=	2070;
const WORD cm_MS_Off		=	2070;
const WORD cm_MS_Menu		=	2071;
const WORD cm_MS_On			=	2072;

const WORD tg_MUSIC_VOLUME	=	2075;
const WORD cm_MV_25			=	2076;
const WORD cm_MV_50			=	2077;
const WORD cm_MV_75			=	2078;
const WORD cm_MV_100		=	2079;

// Fly bonus consts
const WORD tg_FLY_BONUS		=	2080;
const WORD cm_FL_None		=	2080;
const WORD cm_FL_Seldom		=	2081;
const WORD cm_FL_Often		=	2082;
const WORD cm_FL_Always		=	2083;

// Graphic quality 
const WORD tg_GRAPHIC		=	2090;
const WORD cm_GF_None		=	2090;
const WORD cm_GF_Low		=	2091;
const WORD cm_GF_Medium		=	2092;
const WORD cm_GF_High		=	2093;
const WORD cm_GF_Full		=	2094;

// Video mode const
const WORD tg_VIDEOMODE		=	2100;

// Level const
const WORD tg_LEVEL			=	2200;


struct PITONconfig
{
	StringCollection Levels;
	CString CurrentLevel;

	WORD GameMode;
	WORD Shuffle;
	WORD Difficult;
	WORD Grid;
	WORD Wrap;
	WORD Locator;
	WORD FlyBonus;

	WORD Music;
	WORD MusicVol;
	WORD Sound;
	WORD SoundVol;
	WORD VideoMode;
	WORD VideoWidth;
	WORD VideoHeight;
	WORD Graphic;

	CString Name1;
	WORD Keys1[4];
	CString Name2;
	WORD Keys2[4];
};


///////////////////////////////////////////////////////////////////////
//******************	ddiPITONinterface		***********************
///////////////////////////////////////////////////////////////////////
class ddiPITONinterface : public ddiView
{
private:
	HFONT font_main;
	ddiForm* current_form;

	// Forms
	ddiForm* frmMenu;// ---------- frmMain
	ddiForm* frmMode;// ---------- frmMode
	ddiForm* frmOptions;//-------- frmOptions
	ddiForm* frmWindow;//--------- frmWindow

public:
	ddiPITONinterface();
	~ddiPITONinterface();
	void Draw(LPDIRECTDRAWSURFACE surf);
	ddiEvent Do(ddiEvent event);

	HFONT Font (CString name, WORD size);
	BOOL ShowWindow (CString mes, CString but1, WORD com1, CString but2, WORD com2);

	void InitMenu();
	void InitMode();
	void InitOptions();
	void InitWindow();

	BOOL ReadConfig();
//	BOOL SaveConfig();
//	BOOL UpdateConfig();
//	BOOL UpdateMenu();

	PITONconfig config;
};//\\ ddiPITONinterface




#endif // !defined(_PITONINTERFACE_H)
