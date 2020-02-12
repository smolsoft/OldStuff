#define VC_EXTRALEAN

#include <AfxWin.h>
#include <AfxExt.h>
#include <AfxTempl.h>
#include <AfxMt.h>
#include <fstream.h>
#include <math.h>
#include <ddraw.h>
#include <dinput.h>
//#include <cdirsnd.h>
//#include "cwave.h"
#include <stdafx.h>
#include <afx.h>

#ifdef _DEBUG

#define TWICE_TRACING
#ifdef TRACE
#undef TRACE
#endif// TRACE
#define TRACE	FileTRACE

#endif//_DEBUG