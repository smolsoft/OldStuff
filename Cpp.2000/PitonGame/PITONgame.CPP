#include "Headers.h"
#include "resource.h"
#include "DriverDialog.h"
#include "PITONinterface.h"
#include "PitonGame.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif




///////////////////////////////////////////////////////////////////////
//******************	ddiPITONgame			***********************
///////////////////////////////////////////////////////////////////////


//------------------------------------------------------- CONSTRUCTOR ddiPITONgame
ddiPITONgame::ddiPITONgame()
{//debug
	FrameCount=0;
	TimeAll=0;
	TimeMin=0xffffffff;


//	ReadConfig();

	PlayerPos=new POINT[PlayersNumber];
	PlayerDim=new POINT[PlayersNumber];
	Players=new PITON[PlayersNumber];

	Players[0].Name=Config.Name1;
	if (PlayersNumber==2)
	{
		Players[1].Name=Config.Name2;
	}

	switch(PlayersNumber)
	{
	case 1:
		PlayerPos[0].x=3;
		PlayerPos[0].y=7;
		PlayerDim[0].x=792;
		PlayerDim[0].y=552;
		Players[0].WinHeight=23;
		Players[0].WinWidth=33;
		break;
	case 2:
		PlayerPos[0].x=408;
		PlayerPos[0].y=54;
		PlayerPos[1].x=8;
		PlayerPos[1].y=18;
		for (int i=0;i<PlayersNumber;i++)
		{
			PlayerDim[i].x=384;
			PlayerDim[i].y=528;
			Players[i].WinHeight=22;
			Players[i].WinWidth=16;
		}
		break;
	};


	srand(time(0));
	
	FontName=CreateFont(33,0,0,0,FW_NORMAL,FALSE,FALSE,FALSE,ANSI_CHARSET,
		OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,VARIABLE_PITCH,"Domkrat");
	FontScore=CreateFont(27,0,0,0,FW_NORMAL,FALSE,FALSE,FALSE,ANSI_CHARSET,
		OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,VARIABLE_PITCH,"Domkrat");
	FontNumber=CreateFont(24,0,0,0,FW_NORMAL,FALSE,FALSE,FALSE,ANSI_CHARSET,
		OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,VARIABLE_PITCH,"National Typewriter - Light");
	FontTitle=CreateFont(44,0,0,0,FW_NORMAL,FALSE,FALSE,FALSE,ANSI_CHARSET,
		OUT_DEFAULT_PRECIS,CLIP_DEFAULT_PRECIS,DEFAULT_QUALITY,VARIABLE_PITCH,"Domkrat");

//	FrameState=ST_GAME;

	NewLevel();
	TRACE("CONSTRUCTOR\n");
}

//------------------------------------------------------- DESTRUCTOR ddiPITONgame
ddiPITONgame::~ddiPITONgame()
{
	delete [PlayersNumber] Players;
	delete [PlayersNumber] PlayerDim;
	delete [PlayersNumber] PlayerPos;
}

//------------------------------------------------------- ddiPITONgame::
/*BOOL ddiPITONgame::CreateCustomSurfaces()
{
	TRACE("CREATE CUSTOM START\n");
	HDC hdc ;
	SIZE size;
	DDCOLORKEY ddck;
	ddck.dwColorSpaceHighValue=0xffffffff;
	ddck.dwColorSpaceLowValue=0xffffffff;

	PatternSurf=CreateSurface( "pattern.ptn" );
	WallSurface=CreateSurface( "wall.ptn" );
	WallSurface->SetColorKey(DDCKEY_SRCBLT,&ddck);
	ShadowVertical=CreateSurface( "shvert.ptn" );
	ShadowGorizontal=CreateSurface( "shgor.ptn" );
	ShadowVertical->SetColorKey(DDCKEY_SRCBLT,&ddck);
	ShadowGorizontal->SetColorKey(DDCKEY_SRCBLT,&ddck);
	ddck.dwColorSpaceHighValue=0;
	ddck.dwColorSpaceLowValue=0;
	
	LoadSprites(Sprites, "sprssurf.ptn");

	for (int i=0;i<PlayersNumber;i++)
	{
		// Creating Basic Surface
		Players[i].PitonSurf=CreateSurface(800/PlayersNumber,600);
		//LoadSprites(Players[i].Sprites,"piton.bmp");// DEBUG !!!
		int shiftx=0;
		int shifty=0;
		if (PlayersNumber==1)
			Players[i].PitonInfo=CreateSurface(400,40);
		else
		{
			shiftx=-16;
			shifty=8;
			Players[i].PitonInfo=CreateSurface(384,54);
		}
		ClearSurface(Players[i].PitonInfo,0);
		Players[i].PitonInfo->SetColorKey(DDCKEY_SRCBLT,&ddck);
		// Computing width of one zero and name width
		hdc = ::GetDC(0);
		SelectObject(hdc,FontNumber);
		char *tmp="0";
		GetTextExtentPoint(hdc,tmp,strlen(tmp),&size);
		SelectObject(hdc,FontName);
		GetTextExtentPoint(hdc,Players[i].Name,strlen(Players[i].Name),&size);
		int NWidth=size.cx/2;
		::ReleaseDC(0,hdc);
		// Writing Name, e.t.c On Surface
		//      Name:
		DWORD tm=WriteText(Players[i].Name,FontName,Players[i].PitonInfo,255+shiftx-NWidth,-4,NAME_COLOR);
		//      Score:
		tm=WriteText("SCORE",FontScore,Players[i].PitonInfo,0,15+shifty,SCORE_COLOR);
		//      Lives:
		tm=WriteText("LIVES",FontScore,Players[i].PitonInfo,363+shiftx,15+shifty,SCORE_COLOR);
		//      Score zeroes:
		tm=WriteText("0000000000",FontNumber,Players[i].PitonInfo,42,19+shifty,NUMBER_COLOR);
		//      Lives zeroes:
		tm=WriteText("000",FontNumber,Players[i].PitonInfo,315+shiftx,19+shifty,NUMBER_COLOR);
	}

	TimerOn(TIMER_FRAME_ID,1);
	
TRACE("CREATE CUSTOM END\n");

	DDSCAPS       ddsCaps; 
	ddsCaps.dwCaps = 0;//DDSCAPS_OFFSCREENPLAIN; 
	long res = ddraw2->GetAvailableVidMem(&ddsCaps, &dwTotal, &dwFree); 
	TRACE("======================================\n");
	TRACE("VIDEO MEMORY: Total=%d,  Free=%d\n",dwTotal,dwFree);
	TRACE("======================================\n");

	//PlayerPos=new COOR[PlayersNumber];

	
	return TRUE;
}*/

//------------------------------------------------------- ddiPITONgame::Draw()
void ddiPITONgame::Draw(LPDIRECTDRAWSURFACE s)
{
	//if (CloseFLAG) PostMessage( WM_CLOSE );

//	DWORD time=timeGetTime();

		for (int i=0;i<PlayersNumber;i++)
		{
			
			PrepareSurface(i);
			ddw->BltSurface(s,Players[i].PitonSurf ,(PlayersNumber==1)?(0):(400*(1-i)),0);
		}
		ShowShadow();
		ShowGrid();
//		primsurf->Flip( 0, DDFLIP_WAIT );//DEBUG: must be at start
		FrameCount++;

//	if ((timeGetTime()-time) < TimeMin) TimeMin=timeGetTime()-time;
//	TimeAll+=timeGetTime()-time;		




/*		Frame=FALSE;
		MoveResult* mr=new MoveResult[PlayersNumber];
		for (i=0;i<PlayersNumber;i++)
			mr[i]=Move(i);
		if (PlayersNumber==1)
		switch (mr[0])
		{
			case MP_WRAP:
				break;
			case MP_BOTTLE:
				break;
		};
//////////////////////////////// FUCK !!!!!!!!!!!!!!!!!!!!!!!!!				

		if (mr[0]==mr[PlayersNumber-1])
			switch (mr[0])
			{
				case MP_WRAP:

					break;
				case MP_WALL:
					for (i=0;i<PlayersNumber;i++)
						if (Players[i].Lives>0) Players[i].Lives--;
					if (Players[i].Lives==0 && Players[PlayersNumber-1].Lives==0)
//						NextFrame=NT_GAMEOVER;
					case MP_THIS



		


*/	
}

/*void ddiPITONgame::OnKeyDown(UINT nChar, UINT nRepCnt, UINT nFlags)
{
	switch (FrameState)
	{
	case ST_GAME:
		TRACE("game\n");
		switch (nChar)
		{
		
		case VK_ESCAPE:
			{
				TRACE( "DrawScene min time=%d\n",TimeMin);
				TimerOff();
				FILE* fp=fopen( "fps_test.txt", "wt" );
				fprintf( fp, "\n             PITON PERFOMANCE TEST\n\n");
				fprintf( fp, "=============================================\n");
				fprintf( fp, "VIDEO MEMORY:       Total=%d bytes\n",dwTotal);
				fprintf( fp, "                     Free=%d bytes\n",dwFree);
				fprintf( fp, "=============================================\n");
				fprintf( fp, "FRAMES PER SECOND:   Time=%f seconds\n",TimeAll/1000.0);
				fprintf( fp, "                   Frames=%d pieces\n\n",FrameCount);
				fprintf( fp, "                      FPS=%f\n",float(FrameCount)/(TimeAll/1000.0));
				fprintf( fp, "=============================================\n");
				fprintf( fp, "ONE FRAME        Min Time=%f seconds\n",TimeMin/1000.0);
				fprintf( fp, "             Average Time=%f seconds\n",(TimeAll/1000.0)/FrameCount);
				fprintf( fp, "=============================================\n\n");
				fprintf( fp, "   Place for your system info:\n");
				fprintf( fp, "---------------------------------------------\n\n");
				fclose(fp);
				PostMessage( WM_CLOSE );
			}
			//PostMessage( WM_CLOSE );// DEBUG ! (Show Window must be)
			break;

		default:
			CheckKey(nChar);
		}
		break;
	
	case ST_WINDOW:
		TRACE("window\n");
/*		switch (nChar)
		{
		case VK_LEFT:
			if (MenuWin.CurButton>0)
				MenuWin.CurButton--;
			break;
		case VK_RIGHT:
			if (MenuWin.CurButton<MenuWin.NumButtons)
				MenuWin.CurButton++;
			break;
		case VK_RETURN:
			MenuDone(TRUE);
			break;
		case VK_ESCAPE:
			MenuDone(FALSE);
			break;
		}
*//*		break;
	case ST_OTHER:
		TRACE("other\n");
		break;
	}

	DirectDrawWin::OnKeyDown(nChar, nRepCnt, nFlags);
}*/

//------------------------------------------------------- ddiPITONgame::PrepareSurface()
BOOL ddiPITONgame::PrepareSurface(BYTE PlayerN)
{
	// Show Back Picture (pattern)
	ddw->ClearSurface(Players[PlayerN].PitonSurf, 0, 0, 130 );
	for( int y=0 ; y<(AREA_HEIGHT*SPRITE_SIZE)/PATTERN_SIZE ; y++)
		for(int x=0 ; x<(AREA_WIDTH*SPRITE_SIZE)/PATTERN_SIZE ; x++)
			ddw->BltSurface( Players[PlayerN].PitonSurf, PatternSurf,
					x*PATTERN_SIZE-(Players[PlayerN].WinPosition.x-1)*SPRITE_SIZE+PlayerPos[PlayersNumber-1].x,
					y*PATTERN_SIZE-(Players[PlayerN].WinPosition.y-1)*SPRITE_SIZE+PlayerPos[PlayerN].y);

	// Show Static Sprites (wall e.t.c.)
	BOOL bottle=FALSE;
	for ( y=-3 ; y<Players[PlayerN].WinHeight+3 ; y++)
		for (int x=-1 ; x<Players[PlayerN].WinWidth+1 ; x++)
		{
			if ((Players[PlayerN].WinPosition.x+x<1) || (Players[PlayerN].WinPosition.x+x>AREA_WIDTH) 
				|| (Players[PlayerN].WinPosition.y+y<1) || (Players[PlayerN].WinPosition.y+y>AREA_WIDTH))
				continue;
			switch (GameArea[Players[PlayerN].WinPosition.x+x][Players[PlayerN].WinPosition.y+y])
			{
			case GA_WALL:
				ddw->BltSurface(Players[PlayerN].PitonSurf,WallSurface,
							PlayerPos[PlayersNumber-1].x+x*24+1,
							PlayerPos[PlayerN].y+y*24+1,TRUE);
//				ShowSprite(Players[PlayerN].PitonSurf,
//					PlayerPos[PlayersNumber-1].x+x*24+1, PlayerPos[PlayerN].y+y*24+1,
//					Sprites,0,FALSE);
				break;
			case GA_BOTTLE:
				ShowSprite(Players[PlayerN].PitonSurf,
					PlayerPos[PlayersNumber-1].x+x*24+1, PlayerPos[PlayerN].y+y*24+1,
					Sprites,Players[PlayerN].Bottle);
				bottle=TRUE;
				break;
			case GA_LIFE:
				ShowSprite(Players[PlayerN].PitonSurf,
					PlayerPos[PlayersNumber-1].x+x*24+1, PlayerPos[PlayerN].y+y*24+1,
					Sprites,11);
				break;
			case GA_FLY:
				ShowSprite(Players[PlayerN].PitonSurf,
					PlayerPos[PlayersNumber-1].x+x*24+1, PlayerPos[PlayerN].y+y*24+1,
					Sprites,12);
				break;
		}
		}


		// Show PITON
//		for (int i=1;i<=Players[PlayerN].PitonLen;i++)
//			if (Players[PlayerN].Piton[i].x>=Players[PitonN].WinPosition.x


		// Show Locator
		if ((!bottle) && Config.Locator)
		{
			POINT tmp;
			tmp=Locator(PlayerN);
			//tmp.x=100;tmp.y=100;
			ShowSprite(Players[PlayerN].PitonSurf,tmp.x+1,tmp.y+1,Sprites,10);
		}

	return TRUE;
}

//------------------------------------------------------- ddiPITONgame::LoadLevel
BOOL ddiPITONgame::LoadLevel (CString filename)
{
	
	filename.MakeUpper();
	if (filename.Right(3)=="PSL")
		return LoadStandartLevel (filename);
	else
		return LoadCustomLevel (filename);
}

//------------------------------------------------------- ddiPITONgame::LoadStandartLevel()
BOOL ddiPITONgame::LoadStandartLevel (CString filename)
{
	const char* lns=LPCTSTR( filename.Mid(filename.GetLength()-6, 2));
	int ln=atoi(lns);

	ifstream level( filename, ios::binary | ios::nocreate );
	if (!level.is_open())
	{
		TRACE ("LoadStandartLevel: CANNOT OPEN LEVEL FILE\n");
		return FALSE;
	}
	
	DWORD signature=0;
	level.read( (char*)&signature, sizeof(DWORD));
	
	if (signature!=0x4c507453)
	{
		TRACE ("LoadStandartLevel: INVALID SIGNATURE (%d)\n",signature);
		return FALSE;
	}
	
	BYTE* databuf=new BYTE[(AREA_WIDTH*AREA_HEIGHT)/8];
	level.read( databuf, (AREA_WIDTH*AREA_HEIGHT)/8 );
	BYTE code1=0;
	BYTE code2=0;
	level.read( (char*)&code1, sizeof(BYTE) );
	level.read( (char*)&code2, sizeof(BYTE) );
	
	if ( code1!=80 )
	{
		TRACE ("LoadStandartLevel: INVALID CODE_1 (%d)\n",code1);
		return FALSE;
	}
	if ( code2-ln!=76 )
	{
		TRACE ("LoadStandartLevel: INVALID SIGNATURE (%d)\n",signature);
		return FALSE;
	}
	DWORD CRC=0;
	level.read( (char*)&CRC, sizeof(DWORD) );
	BYTE* ptr=databuf;
	WORD x=0,y=1;
	DWORD CRCthis=0;
	
	for (int i=0 ; i<(AREA_WIDTH*AREA_HEIGHT)/8 ; i++)
	{
		BYTE byte=*ptr;
		CRCthis+=byte;
		for (int j=0 ; j<8 ; j++)
		{
			if ( x<AREA_WIDTH )
				x++;
			else
			{
				x=1;
				y++;
			}
			if ((byte & ((BYTE)1<<(7-j)))>>(7-j))
				GameArea[x][y]=GA_WALL;
			else
				GameArea[x][y]=GA_EMPTY;
		}
		ptr++;
	}
	CRCthis += code1 + code2;
	if ( CRC!=CRCthis )
	{
		TRACE("LoadStandartLevel: INVALID FILE CRC\n");
		return FALSE;
	}
	
	delete [] databuf;
	return TRUE;
}

//------------------------------------------------------- ddiPITONgame::LoadCustomLevel()
BOOL ddiPITONgame::LoadCustomLevel (CString filename)
{
	for(int y=1;y<=AREA_HEIGHT;y++)
		for(int x=1;x<=AREA_WIDTH;x++)
			GameArea[x][y]=GA_EMPTY;
	return TRUE;
}

//------------------------------------------------------- ddiPITONgame::NewBottle()
BOOL ddiPITONgame::NewBottle()
{
/*	DWORD debug=0;
	WORD x,y;
	do
	{
		debug++;
		x=(abs(rand())%AREA_WIDTH)+1;
		y=(abs(rand())%AREA_HEIGHT)+1;
	}
	while (GameArea[x][y]!=GA_EMPTY);
	TRACE("NewBottle(): tryed %d times.\n",debug);
	GameArea[x][y]=GA_BOTTLE;
	cBottle.x=x;
	cBottle.y=y;
*/	GameArea[90][83]=GA_BOTTLE;
	cBottle.x=90;
	cBottle.y=83;

	return TRUE;
}

//------------------------------------------------------- ddiPITONgame::NewLife()
BOOL ddiPITONgame::NewLife()
{
//	DWORD debug=0;
//	WORD x,y;
//	do
//	{
//		debug++;
//		x=(abs(rand())%AREA_WIDTH)+1;
//		y=(abs(rand())%AREA_HEIGHT)+1;
//	}
//	while (GameArea[x][y]!=GA_EMPTY);
//	TRACE("NewLife(): tryed %d times.\n",debug);
//	GameArea[x][y]=GA_LIFE;
//	cLife.x=x;
//	cLife.y=y;
	GameArea[10][15]=GA_LIFE;
	cLife.x=10;
	cLife.y=15;

	return TRUE;
}

//------------------------------------------------------- ddiPITONgame::NewFly()
BOOL ddiPITONgame::NewFly()
{
	DWORD debug=0;
	WORD x,y;
	do
	{
		debug++;
		x=(abs(rand())%AREA_WIDTH)+1;
		y=(abs(rand())%AREA_HEIGHT)+1;
	}
	while (GameArea[x][y]!=GA_EMPTY);
	TRACE("NewFly(): tryed %d times.\n",debug);
	GameArea[x][y]=GA_FLY;
	cFly.x=x;
	cFly.y=y;
	return TRUE;
}

//------------------------------------------------------- ddiPITONgame::NewLevel()
BOOL ddiPITONgame::NewLevel()//================================================
{
	BOOL result=LoadLevel("LEVELS\\level00.psl");// DEBUG level name
	if (!result)
		Fatal ("Can't load Piton's level 'level00.psl'");


	for (int i=0;i<PlayersNumber;i++)
	{
		for (int j=0;j<=MAX_PITON_LENGHT;j++)
		{
			Players[i].Piton[j].x=0;
			Players[i].Piton[j].y=0;
		}
		Players[i].Bottle=1;
		Players[i].Fly=0;
		Players[i].Lives=5;
		Players[i].PitonExtension=15;
		Players[i].PitonLen=1;
		Players[i].Score=0;
	};

	Players[0].WinPosition.x=AREA_WIDTH-Players[0].WinWidth+1;
	Players[0].WinPosition.y=AREA_HEIGHT-Players[0].WinHeight+1;
	Players[0].Piton[1].x=AREA_WIDTH;
	Players[0].Piton[1].y=AREA_HEIGHT-2;
	if (PlayersNumber==2)
	{
		Players[1].WinPosition.x=1;
		Players[1].WinPosition.y=1;
		Players[1].Piton[1].x=1;
		Players[1].Piton[1].y=3;
	}
	NewBottle();
	if (rand()%10==0)
		NewLife();
	if (rand()%10==0)
		NewFly();

	return TRUE;
}

//------------------------------------------------------- ddiPITONgame::Move()
BYTE ddiPITONgame::Move(BYTE PitonN)
{
	if (Players[PitonN].PitonExtension!=0)
	{
		Players[PitonN].PitonLen = Players[PitonN].PitonLen + 1;
		Players[PitonN].PitonExtension = Players[PitonN].PitonExtension - 1;
		Players[PitonN].Piton[Players[PitonN].PitonLen] = Players[PitonN].Piton[Players[PitonN].PitonLen-1];
	}

	BYTE mr;
	switch (Players[PitonN].PitonDirection)
	{
	case DIR_UP:
		mr=MoveUp(PitonN);
	case DIR_DOWN:
		mr=MoveDown(PitonN);
	case DIR_LEFT:
		mr=MoveLeft(PitonN);
	case DIR_RIGHT:
		mr=MoveRight(PitonN);
	default:
		Fatal("FATAL ERROR in MovePiton/switch");
		mr=MP_WALL;
	};

	if (mr==MP_WALL)
		return mr;

	switch (GameArea[Players[PitonN].Piton[1].x][Players[PitonN].Piton[1].y])
	{
	case GA_EMPTY:
		return MP_OK;
	case GA_BOTTLE:
		return MP_BOTTLE;
	case GA_LIFE:
		return MP_LIFE;
	case GA_FLY:
		return MP_FLY;
	case GA_WALL:
		return MP_WALL;
	default:
		Fatal("FATAL ERROR in MovePiton");
		return MP_OK;
	}
}

//------------------------------------------------------- ddiPITONgame::MoveUp()
BYTE ddiPITONgame::MoveUp(BYTE PitonN)
{
    if (Players[PitonN].Piton[1].y > 1)
	{
        Players[PitonN].Piton[Players[PitonN].PitonLen] = Players[PitonN].Piton[Players[PitonN].PitonLen - 1];
        for (int i=Players[PitonN].PitonLen - 1;i>=2;i--)
            Players[PitonN].Piton[i] = Players[PitonN].Piton[i - 1];
        Players[PitonN].Piton[1].y = Players[PitonN].Piton[1].y - 1;
	}
    else
        if (Config.Wrap == FALSE)
            return MP_WALL;
        else
		{
            Players[PitonN].Piton[1].y = AREA_HEIGHT;
            if (Players[PitonN].Piton[2].y != 1)
			{
                for (int i=Players[PitonN].PitonLen;i>=3;i--)
                    Players[PitonN].Piton[i] = Players[PitonN].Piton[i - 1];
                Players[PitonN].Piton[2].y = Players[PitonN].Piton[2].y - 1;
            }
        };

	return MP_OK;
}

//------------------------------------------------------- ddiPITONgame::MoveDown()
BYTE ddiPITONgame::MoveDown(BYTE PitonN)
{
    if (Players[PitonN].Piton[1].y < AREA_HEIGHT)
	{
        Players[PitonN].Piton[Players[PitonN].PitonLen] = Players[PitonN].Piton[Players[PitonN].PitonLen - 1];
        for (int i=Players[PitonN].PitonLen - 1;i>=2;i--)
            Players[PitonN].Piton[i] = Players[PitonN].Piton[i - 1];
        Players[PitonN].Piton[1].y = Players[PitonN].Piton[1].y + 1;
	}
    else
        if (Config.Wrap == FALSE)
            return MP_WALL;
        else
		{
            Players[PitonN].Piton[1].y = 1;
            if (Players[PitonN].Piton[2].y != AREA_HEIGHT)
			{
                for (int i=Players[PitonN].PitonLen;i>=3;i--)
                    Players[PitonN].Piton[i] = Players[PitonN].Piton[i - 1];
                Players[PitonN].Piton[2].y = Players[PitonN].Piton[2].y + 1;
				return MP_WRAP;
            };
        };

	return MP_OK;
}

//------------------------------------------------------- ddiPITONgame::MoveLeft()
BYTE ddiPITONgame::MoveLeft(BYTE PitonN)
{
    if (Players[PitonN].Piton[1].x > 1)
	{
        Players[PitonN].Piton[Players[PitonN].PitonLen] = Players[PitonN].Piton[Players[PitonN].PitonLen - 1];
        for (int i=Players[PitonN].PitonLen - 1;i>=2;i--)
            Players[PitonN].Piton[i] = Players[PitonN].Piton[i - 1];
        Players[PitonN].Piton[1].x = Players[PitonN].Piton[1].x - 1;
	}
    else
        if (Config.Wrap == FALSE)
            return MP_WALL;
        else
		{
            Players[PitonN].Piton[1].x = AREA_WIDTH;
            if (Players[PitonN].Piton[2].x != 1)
			{
                for (int i=Players[PitonN].PitonLen;i>=3;i--)
                    Players[PitonN].Piton[i] = Players[PitonN].Piton[i - 1];
                Players[PitonN].Piton[2].x = Players[PitonN].Piton[2].x - 1;
            };
        };

	return MP_OK;
}

//------------------------------------------------------- ddiPITONgame::MoveRight()
BYTE ddiPITONgame::MoveRight(BYTE PitonN)
{
    if (Players[PitonN].Piton[1].x < AREA_WIDTH)
	{
        Players[PitonN].Piton[Players[PitonN].PitonLen] = Players[PitonN].Piton[Players[PitonN].PitonLen - 1];
        for (int i=Players[PitonN].PitonLen - 1;i>=2;i--)
            Players[PitonN].Piton[i] = Players[PitonN].Piton[i - 1];
        Players[PitonN].Piton[1].x = Players[PitonN].Piton[1].x + 1;
	}
    else
        if (Config.Wrap == FALSE)
            return MP_WALL;
        else
		{
            Players[PitonN].Piton[1].x = 1;
            if (Players[PitonN].Piton[2].x != AREA_WIDTH)
			{
                for (int i=Players[PitonN].PitonLen;i>=3;i--)
                    Players[PitonN].Piton[i] = Players[PitonN].Piton[i - 1];
                Players[PitonN].Piton[2].x = Players[PitonN].Piton[2].x + 1;
            };
        };

	return MP_OK;
}

//------------------------------------------------------- ddiPITONgame::Locator()
POINT ddiPITONgame::Locator(BYTE PitonN)
{
	POINT w[5],Loc;
	Loc.x=0; Loc.y=0;
	w[1].x=(Players[PitonN].WinPosition.x+Players[PitonN].WinWidth)*SPRITE_SIZE;
	w[1].y=Players[PitonN].WinPosition.y*SPRITE_SIZE;
	w[2].x=Players[PitonN].WinPosition.x*SPRITE_SIZE;
	w[2].y=Players[PitonN].WinPosition.y*SPRITE_SIZE;
	w[3].x=Players[PitonN].WinPosition.x*SPRITE_SIZE;
	w[3].y=(Players[PitonN].WinPosition.y+Players[PitonN].WinHeight)*SPRITE_SIZE;
	w[4].x=(Players[PitonN].WinPosition.x+Players[PitonN].WinWidth)*SPRITE_SIZE;
	w[4].y=(Players[PitonN].WinPosition.y+Players[PitonN].WinHeight)*SPRITE_SIZE;
	POINT Head;
		 Head.x=Players[PitonN].Piton[1].x*SPRITE_SIZE;
		 Head.y=Players[PitonN].Piton[1].y*SPRITE_SIZE;
	POINT Bottle=cBottle;
		 Bottle.x*=SPRITE_SIZE;
		 Bottle.y*=SPRITE_SIZE;
	int n=0;
	for (int i=1;i<5;i++)
		if (Angle(Head,Bottle)<=Angle(Head,w[i]))
		{
			n=i;
			break;
		};

	switch (n)
	{
	case 0:
	case 1:
		Loc.x=PlayerDim[PitonN].x+PlayerPos[PlayersNumber-1].x-SPRITE_SIZE/2;
		Loc.y=(w[1].x-Head.x)*(Bottle.y-Head.y)/(Bottle.x-Head.x)+Head.y-w[1].y+PlayerPos[PitonN].y-SPRITE_SIZE/2;
		return Loc;

	case 2:
		Loc.y=PlayerPos[PitonN].y-SPRITE_SIZE/2;
		Loc.x=(Head.y-w[2].y)*(Bottle.x-Head.x)/(Head.y-Bottle.y)+Head.x-w[2].x+PlayerPos[PlayersNumber-1].x-SPRITE_SIZE/2;
		return Loc;
	
	case 3:
		Loc.x=PlayerPos[PlayersNumber-1].x-SPRITE_SIZE/2;
		Loc.y=(Head.x-w[2].x)*(Bottle.y-Head.y)/(Head.x-Bottle.x)+Head.y-w[2].y+PlayerPos[PitonN].y-SPRITE_SIZE/2;
		return Loc;
	
	case 4:
		Loc.y=PlayerDim[PitonN].y+PlayerPos[PitonN].y-SPRITE_SIZE/2;
		Loc.x=(w[3].y-Head.y)*(Bottle.x-Head.x)/(Bottle.y-Head.y)+Head.x-w[3].x+PlayerPos[PlayersNumber-1].x-SPRITE_SIZE/2;
		return Loc;
	default:
		Fatal("FATAL ERROR in Locator() - switch() default.\nPlease call PITON's developer.");
		return Loc;
	}
}

//------------------------------------------------------- ddiPITONgame::Angle()
DOUBLE ddiPITONgame::Angle(POINT a,POINT b)
{
	DOUBLE dist=sqrt(pow((a.x-b.x),2)+pow((a.y-b.y),2));
	if ((b.x>a.x) && (b.y<=a.y))
		return (a.y-b.y)/dist;
	if ((b.x<=a.x) && (b.y<a.y))
		return 1+(a.x-b.x)/dist;
	if ((b.x<a.x) && (b.y>=a.y))
		return 2+(b.y-a.y)/dist;
	if ((b.x>=a.x) && (b.y>a.y))
		return 3+(b.x-a.x)/dist;
	Fatal("FATAL ERROR in Angle!");
	return -1;
}

//------------------------------------------------------- ddiPITONgame::ShowSprite()
BOOL ddiPITONgame::ShowSprite(LPDIRECTDRAWSURFACE surf, WORD x, WORD y, SPRITES spr, BYTE SpriteN)
{
	if (surf==0)
		return FALSE;

	DDSURFACEDESC surfdesc;
	ZeroMemory( &surfdesc, sizeof(surfdesc) );
	surfdesc.dwSize = sizeof(surfdesc);
	surf->GetSurfaceDesc( &surfdesc );
//	if (surfdesc.dwWidth<x || surfdesc.dwHeight<y)
//	{
//		TRACE ("ShowSprite: I DON'T CLIPPING!\n");
//		return FALSE;
//	}

	for (int y0=0;y0<24;y0++)
		for (int x0=0;x0<24;x0++)
		{
			BYTE eq=0;
			if ( GetRValue(spr[SpriteN][x0][y0]) == GetGValue(spr[SpriteN][x0][y0]) )
				eq = GetRValue(spr[SpriteN][x0][y0]);
			else if ( GetGValue(spr[SpriteN][x0][y0]) == GetBValue(spr[SpriteN][x0][y0]) )
				eq = GetGValue(spr[SpriteN][x0][y0]);
			else if ( GetRValue(spr[SpriteN][x0][y0]) == GetBValue(spr[SpriteN][x0][y0]) )
				eq = GetBValue(spr[SpriteN][x0][y0]);

				ddw->PointAlpha(surf, x+x0, y+y0, spr[SpriteN][x0][y0], 255-eq);
		};

	return TRUE;
}

//------------------------------------------------------- ddiPITONgame::ShowShadow()
void ddiPITONgame::ShowShadow()
{
	if (PlayersNumber==1)
	{
		// Show Shadow
/*		CRect r;
		r.left=0;
		r.right=3;
		r.top=0;
		r.bottom=599;
		RectAlpha( backsurf, r, 110, 0, 0, 0);
		r.left=795;
		r.right=799;
		r.top=0;
		r.bottom=599;
		RectAlpha( backsurf, r, 110, 0, 0, 0);
		r.left=4;
		r.right=794;
		r.top=0;
		r.bottom=7;
		RectAlpha( backsurf, r, 110, 0, 0, 0);
		r.left=4;
		r.right=794;
		r.top=559;
		r.bottom=599;
		RectAlpha( backsurf, r, 110, 0, 0, 0);
*/		// Show Player's Info
//		ddw->BltSurface( s, Players[0].PitonInfo,200,560,TRUE);
	}
	else // PlayersNumber=2 (or more - SMOLL BUG!)
	{
		// Show Shadow
/*		BltSurface( backsurf, ShadowVertical,  -8, 0, TRUE);
		BltSurface( backsurf, ShadowVertical, 792, 0, TRUE);
		BltSurface( backsurf, ShadowVertical, 392, 0, TRUE);
		BltSurface( backsurf, ShadowGorizontal,   8, -42, TRUE);
		BltSurface( backsurf, ShadowGorizontal, 408,  -6, TRUE);
		BltSurface( backsurf, ShadowGorizontal, 408, 582, TRUE);
		BltSurface( backsurf, ShadowGorizontal,   8, 546, TRUE);
		// Show Player's Info
		BltSurface( backsurf, Players[0].PitonInfo,407,4,TRUE);
		BltSurface( backsurf, Players[1].PitonInfo,9,550,TRUE);*/
	}
}

//------------------------------------------------------- ddiPITONgame::ShowGrid()
void ddiPITONgame::ShowGrid()
{
	if (Config.Grid)
		for (int i=0;i<PlayersNumber;i++)
		{
			for (int y=PlayerPos[i].y;y<=PlayerPos[i].y+PlayerDim[i].y-SPRITE_SIZE;y+=SPRITE_SIZE)
;//				ddw->Line(backsurf,PlayerPos[i].x,y,PlayerPos[i].x+PlayerDim[i].x-1,y,0,0,0);
			for (int x=PlayerPos[i].x;x<=PlayerPos[i].x+PlayerDim[i].x-SPRITE_SIZE;x+=SPRITE_SIZE)
;//				ddw->Line(backsurf,x,PlayerPos[i].y,x,PlayerPos[i].y+PlayerDim[i].y-1,0,0,0);
		}
}

//------------------------------------------------------- ddiPITONgame::LoadSprites()
BOOL ddiPITONgame::LoadSprites(SPRITES spr, LPCTSTR filename)
{
	ifstream bmp( filename, ios::binary | ios::nocreate );
	if (!bmp.is_open())
	{
		TRACE("LoadSprites: cannot open Bmp file\n");
		return FALSE;
	}

	BITMAPFILEHEADER bmpfilehdr;
	bmp.read( (char*)&bmpfilehdr, sizeof(bmpfilehdr) );

	char* ptr=(char*)&bmpfilehdr.bfType;
	if (*ptr!='B' || *++ptr!='M')
	{
//		TRACE("LoadSprites: invalid bitmap\n");
//		return FALSE;
	}
	
	BITMAPINFOHEADER bmpinfohdr;
	bmp.read( (char*)&bmpinfohdr, sizeof(bmpinfohdr) );
	bmp.seekg( sizeof(bmpfilehdr)+bmpinfohdr.biSize, ios::beg );

	int imagew=bmpinfohdr.biWidth;
	int imageh=bmpinfohdr.biHeight;
	int imagebitdepth=bmpinfohdr.biBitCount;

	int imagesize=bmpinfohdr.biSizeImage;
	if (imagesize==0)
		imagesize=((imagew*(imagebitdepth/8)+3) & ~3)*imageh;

	if (bmpinfohdr.biCompression!=BI_RGB)
	{
		TRACE("compressed BMP format\n");
		return 0;
	}

	TRACE("Load %d sprites from file'%s': \n",imagew/SPRITE_SIZE, filename);

	BYTE* buf=new BYTE[imagesize];
	bmp.read( buf, imagesize );

	int bytesrequired=imagew*3;
	int bytesgiven=(bytesrequired+3) & ~3;
	BYTE* imagebits = (BYTE*)(&buf[(imageh-1)*bytesgiven]);

	for(int y=0; y<24; y++ )
	{
		RGBTRIPLE* image=(RGBTRIPLE*)imagebits;
		for (int i=0,p=0;p<imagew;p++)// 312=13*SPRITE_SIZE
		{
			if (p%24==0) i=p/24;
//			BYTE r=image->rgbtRed;  // << loREDbit;
//			BYTE g=image->rgbtGreen;// << loGREENbit;
//			BYTE b=image->rgbtBlue; // << loBLUEbit;
			spr[i][p-i*24][y] = RGB(image->rgbtRed, image->rgbtGreen, image->rgbtBlue);
			image++;
		}
		imagebits -= bytesgiven;
	}


	delete [] buf;
	return TRUE;
}

//void __stdcall TimerCallBack(HWND, UINT, UINT, DWORD)
//{
//	TRACE("TIMER CALLBACK -----------------------------------\n");
//}

//------------------------------------------------------- ddiPITONgame::Locator()
/*void ddiPITONgame::OnTimer(UINT nIDEvent) 
{
	if (PreDrawScene())
		switch (nIDEvent)
		{
		case TIMER_FRAME_ID:
			Frame=TRUE;
			DrawScene();
			break;

		case TIMER_EFFECT_ID:
/*			{
			BltSurface(backsurf,Effect.surf,0,0);
			CRect r;
			r.left=0;r.top=0;r.right=799;r.bottom=599;
			TRACE("EFFECT NEXT FRAME: Alpha=%d\n",255-Effect.steps);
			RectAlpha(backsurf,r,255-Effect.steps,0,0,0);//255*(1-Effect.step/Effect.steps));
			if (Effect.steps+Effect.step>0 && Effect.steps+Effect.step<255)
				Effect.steps+=Effect.step;
			else
				TimerOn(TIMER_FRAME_ID,TimerInterval);
			primsurf->Flip( 0, DDFLIP_WAIT );
			}
*//*			break;
		
		case TIMER_VIDEO_ID:
			TRACE("TIMER VIDEO\n");
			break;

		default:
			DirectDrawWin::OnTimer(nIDEvent);
		}
}*/


BOOL ddiPITONgame::CheckKey(int nChar)
{

	return TRUE;
}

ddiEvent ddiPITONgame::Do(ddiEvent event)
{
	return event;
}
