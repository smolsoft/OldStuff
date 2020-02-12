//////////////////////////////////////////////////////////////////////
//
//	PITONgame.h: interface for the ddiPITONinterface class.
//
//////////////////////////////////////////////////////////////////////

#include "PITONinterface.h"
#include "DDInterface.h"
#include "DirectDrawWin.h"

#if !defined(_PITONGAME_H)
#define _PITONGAME_H

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000





// PITON consts
const BYTE AREA_WIDTH=100;//  width of level map
const BYTE AREA_HEIGHT=100;// height of level map
const WORD MAX_PITON_LENGHT=AREA_HEIGHT*AREA_WIDTH+1;// maximum piton body lenght
const BYTE SPRITE_SIZE=24;// size of square sprite
const WORD PATTERN_SIZE=400;// size of gamearea pattern

// PITON directions consts
const BYTE DIR_LEFT=0;
const BYTE DIR_UP=1;
const BYTE DIR_RIGHT=2;
const BYTE DIR_DOWN=3;

// PITON colors
const COLORREF NAME_COLOR=RGB(150,20,20);
const COLORREF SCORE_COLOR=RGB(180,180,180);
const COLORREF NUMBER_COLOR=RGB(190,190,190);

//const TIMER_FRAME_ID=13666;
//const TIMER_EFFECT_ID=7666;
//const TIMER_VIDEO_ID=10101;

//const MENU_NEXT_LEVEL=0;
//const MENU_GAME_OVER=1;
//const MENU_PAUSE=2;

//enum STAT
//{
//	ST_GAME,
//	ST_WINDOW,
//	ST_OTHER,
//};


// GameArea consts
const BYTE GA_EMPTY	=	0;
const BYTE GA_PITON1=	1;
const BYTE GA_PITON2=	2;
const BYTE GA_BOTTLE=	252;
const BYTE GA_LIFE	=	253;
const BYTE GA_FLY	=	254;
const BYTE GA_WALL	=	255;


// MoveResult consts
const MP_OK			=	0;
const MP_WRAP		=	1;
const MP_WALL		=	2;
const MP_BOTTLE		=	3;
const MP_LIFE		=	4;
const MP_FLY		=	5;




///////////////////////////////////////////////////////////////////////
//******************	PITONplayer				***********************
///////////////////////////////////////////////////////////////////////
typedef COLORREF SPRITES[13][24][24];

struct PITON
{
	CString Name;
	WORD Keys[3];
	POINT WinPosition;
	BYTE WinWidth;
	BYTE WinHeight;
	POINT Piton[MAX_PITON_LENGHT];
	WORD PitonLen;
	WORD PitonExtension;
	BYTE PitonDirection;
	WORD Lives;
	BYTE Fly;
	BYTE Bottle;
	DWORD Score;
	LPDIRECTDRAWSURFACE PitonSurf;
	LPDIRECTDRAWSURFACE PitonInfo;
	SPRITES Sprites;
};



///////////////////////////////////////////////////////////////////////
//******************	ddiPITONgame			***********************
///////////////////////////////////////////////////////////////////////
class ddiPITONgame : public ddiView
{
public:
	ddiPITONgame();
	~ddiPITONgame();
	void Draw(LPDIRECTDRAWSURFACE surf);
	ddiEvent Do(ddiEvent event);

private:
	BOOL NewLevel();
	BOOL LoadLevel (CString LevelName);
	BOOL LoadStandartLevel (CString LevelName);
	BOOL LoadCustomLevel (CString LevelName);

	BOOL NewBottle();
	BOOL NewLife();
	BOOL NewFly();

	BYTE Move(BYTE PitonN);
	BYTE MoveRight(BYTE PitonN);
	BYTE MoveLeft(BYTE PitonN);
	BYTE MoveDown(BYTE PitonN);
	BYTE MoveUp(BYTE PitonN);

	BOOL PrepareSurface(BYTE PlayerN);


	POINT Locator(BYTE PitonN);
	DOUBLE Angle(POINT a,POINT b);
	void ShowGrid();
	void ShowShadow();
	BOOL ShowSprite(LPDIRECTDRAWSURFACE surf, WORD x, WORD y, SPRITES spr, BYTE SpriteN);
	BOOL LoadSprites(SPRITES spr,LPCTSTR filename);
	
	BOOL CheckKey(int nChar);


private:
	LPDIRECTDRAWSURFACE PatternSurf, WallSurface;
	LPDIRECTDRAWSURFACE ShadowGorizontal, ShadowVertical;
	
	SPRITES Sprites;
	
	PITONconfig Config;
	BYTE GameArea [AREA_WIDTH+1][AREA_HEIGHT+1];
	POINT cBottle;
	POINT cLife;
	POINT cFly;
	BYTE PlayersNumber;
	POINT* PlayerPos;
	POINT* PlayerDim;
	PITON* Players;

	HFONT FontName,FontScore,FontNumber,FontTitle;
	int timer,timerID;

//debug
DWORD FrameCount,TimeAll,TimeMin;
DWORD dwTotal,dwFree;
BOOL CloseFLAG;
//end debug

};//\\ ddiPITONgame




#endif // !defined(_PITONGAME_H)
