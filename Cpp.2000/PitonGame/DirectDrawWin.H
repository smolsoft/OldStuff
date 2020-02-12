#ifndef DIRECTDRAWWIN_H
#define DIRECTDRAWWIN_H


const int MAXDRIVERS = 10;
const int MAXDISPLAYMODES = 100;

const BYTE MOUSE_LEFT =1;
const BYTE MOUSE_RIGHT=2;


class DirectDrawWin : public CWnd
{
	struct DriverInfo
	{
		LPGUID guid;
		LPSTR desc, name;
	};

	struct DisplayModeInfo
	{
		DWORD width, height, depth;
	};

public:
	DirectDrawWin();
	BOOL Create(const CString& sTitle,int icon);
	virtual void DrawScene() = 0;
	void CheckResult( HRESULT result );
	LPDIRECTDRAW2 GetDDraw()  { return ddraw2; }

	//------- driver functions ---------
	int GetNumDrivers() { return totaldrivers; }
	BOOL GetDriverInfo( int index, LPGUID* guid, LPSTR* desc, LPSTR* name );
	virtual int SelectDriver() { return 0; }

	//------- display mode functions ---------
	int GetNumDisplayModes() { return totaldisplaymodes; }
	BOOL GetDisplayModeDimensions( int mode, DWORD& width, DWORD& height, DWORD& depth );
	int GetDisplayModeIndex( DWORD w, DWORD h, DWORD d );
	int GetCurDisplayMode()  { return curdisplaymode; }
	int GetCurDisplayDepth()  { return displaydepth; }
	void RestoreDisplayMode();
	BOOL ActivateDisplayMode( int mode );
	BOOL ActivateDisplayMode( int mode, DWORD rate );
	virtual int SelectInitialDisplayMode() = 0;

	//------- surface functions ---------
	virtual BOOL CreateCustomSurfaces() = 0;
	BOOL ClearSurface( LPDIRECTDRAWSURFACE surf, DWORD clr, RECT* rect=0 );
	BOOL ClearSurface( LPDIRECTDRAWSURFACE surf, DWORD r, DWORD g, DWORD b, RECT* rect=0 );
	LPDIRECTDRAWSURFACE CreateSurface(DWORD w, DWORD h );
	LPDIRECTDRAWSURFACE CreateSurface(LPCTSTR filename, BOOL installpalette=FALSE);
	BOOL LoadSurface(LPDIRECTDRAWSURFACE surf, LPCTSTR filename);
	BOOL SaveSurface(LPDIRECTDRAWSURFACE surf, LPCTSTR filename);
	BOOL GetSurfaceDimensions( LPDIRECTDRAWSURFACE surf, DWORD& w, DWORD& h );
	BOOL GetSurfaceRect( LPDIRECTDRAWSURFACE surf, RECT& rect);
	virtual void RestoreSurfaces() = 0;
	BOOL BltSurface( LPDIRECTDRAWSURFACE destsurf, LPDIRECTDRAWSURFACE srcsurf, int x, int y, BOOL srccolorkey=FALSE );
	DWORD RGBtoPixel(DWORD r, DWORD g, DWORD b);	
	void PrintSurfaceInfo(LPDIRECTDRAWSURFACE surf, LPCTSTR name);

	//------- SMOLsoft finctions -----
	BOOL Line( LPDIRECTDRAWSURFACE surf, WORD x1, WORD y1, WORD x2, WORD y2, BYTE red, BYTE green, BYTE blue);
	BOOL PointAlpha( LPDIRECTDRAWSURFACE surf, WORD x, WORD y, DWORD color, BYTE alpha);

	//------- misc functions ---------
	static int GetMouseX()    { return mousex; }
	static int GetMouseY()    { return mousey; }
	static BOOL GetBmpDimensions( LPCTSTR filename, int& w, int& h );
	int GetDisplayDepth()  { return displaydepth; }
	const CRect& GetDisplayRect() { return displayrect; }

#ifdef _DEBUG
	DWORD bytes_for_surf;
#endif

protected:
	//{{AFX_MSG(DirectDrawWin)
	afx_msg int OnCreate(LPCREATESTRUCT lpCreateStruct);
	afx_msg void OnDestroy();
	afx_msg void OnActivateApp(BOOL bActive, HTASK hTask);
	afx_msg BOOL OnEraseBkgnd(CDC* pDC);
	afx_msg void OnMouseMove(UINT nFlags, CPoint point);
	//}}AFX_MSG
	DECLARE_MESSAGE_MAP()
private:
	//------- SMOLsoft finctions -----
	BOOL PointAlpha16( LPDIRECTDRAWSURFACE surf, WORD x, WORD y, DWORD color, BYTE alpha);
	BOOL PointAlpha24( LPDIRECTDRAWSURFACE surf, WORD x, WORD y, DWORD color, BYTE alpha);

	static BOOL WINAPI DriverAvailable(LPGUID guid, LPSTR desc, LPSTR name, LPVOID p );
	static HRESULT WINAPI DisplayModeAvailable(LPDDSURFACEDESC, LPVOID);
	static int CompareModes( const void *arg1, const void *arg2 );
	virtual BOOL CreateFlippingSurfaces();
	BOOL StorePixelFormatData();
	BOOL PreDrawScene();
	BOOL Copy_Bmp_Surface(LPDIRECTDRAWSURFACE surf, BITMAPINFOHEADER* bmphdr, BYTE* buf);
	BOOL Copy_Bmp08_Surface08(LPDIRECTDRAWSURFACE surf, BYTE* bmpbuf, int w, int h);
	BOOL Copy_Bmp24_Surface16(LPDIRECTDRAWSURFACE surf, BYTE* bmpbuf, int w, int h);
	BOOL Copy_Bmp24_Surface24(LPDIRECTDRAWSURFACE surf, BYTE* bmpbuf, int w, int h);
	BOOL Copy_Bmp24_Surface32(LPDIRECTDRAWSURFACE surf, BYTE* bmpbuf, int w, int h);
	BOOL SaveSurface08(LPDIRECTDRAWSURFACE surf, FILE* fp, DWORD w, DWORD h);
	BOOL SaveSurface16(LPDIRECTDRAWSURFACE surf, FILE* fp, DWORD w, DWORD h);
	BOOL SaveSurface24(LPDIRECTDRAWSURFACE surf, FILE* fp, DWORD w, DWORD h);
	BOOL SaveSurface32(LPDIRECTDRAWSURFACE surf, FILE* fp, DWORD w, DWORD h);
	WORD LowBitPos(DWORD);
	WORD HighBitPos(DWORD);
	BOOL CreatePalette(RGBQUAD* quad, int ncolors);

protected:
	LPDIRECTDRAW2 ddraw2;
	LPDIRECTDRAWSURFACE primsurf, backsurf;
	LPDIRECTDRAWPALETTE palette;

	WORD loREDbit, numREDbits;
	WORD loGREENbit, numGREENbits;
	WORD loBLUEbit, numBLUEbits;

private:
	DriverInfo driver[MAXDRIVERS];
	int totaldrivers;

	DisplayModeInfo displaymode[MAXDISPLAYMODES];
	int curdisplaymode;
	int totaldisplaymodes;
	CRect displayrect;
	int displaydepth;

	static long mousex;
	static long mousey;
	static UINT mousestate;

	BOOL window_active;
	static DirectDrawWin* thisptr;

	friend class DirectDrawApp;
	friend DirectDrawWin* GetDDWin();
};

inline DirectDrawWin* GetDDWin()
{
	return DirectDrawWin::thisptr;
}


void Fatal(LPCTSTR msg);
void FileTRACE (LPCTSTR lpszFormat, ...);


#ifdef _DEBUG

#undef ASSERT
#define ASSERT(c) \
	if (!(c)) \
	{ \
		if (GetDDWin()) \
		{ \
			GetDDWin()->GetDDraw()->RestoreDisplayMode(); \
			GetDDWin()->GetDDraw()->Release(); \
		} \
		AfxAssertFailedLine(THIS_FILE, __LINE__); \
		AfxDebugBreak(); \
	}

#endif _DEBUG

#endif
