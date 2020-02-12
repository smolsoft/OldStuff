// Machine generated IDispatch wrapper class(es) created with ClassWizard

#include "stdafx.h"
#include "ctauto.h"

#ifdef _DEBUG
#define new DEBUG_NEW
#undef THIS_FILE
static char THIS_FILE[] = __FILE__;
#endif



/////////////////////////////////////////////////////////////////////////////
// ICTCD properties

LPDISPATCH ICTCD::GetApplication()
{
	LPDISPATCH result;
	GetProperty(0x1, VT_DISPATCH, (void*)&result);
	return result;
}

void ICTCD::SetApplication(LPDISPATCH propVal)
{
	SetProperty(0x1, VT_DISPATCH, propVal);
}

CString ICTCD::GetFullName()
{
	CString result;
	GetProperty(0x2, VT_BSTR, (void*)&result);
	return result;
}

void ICTCD::SetFullName(LPCTSTR propVal)
{
	SetProperty(0x2, VT_BSTR, propVal);
}

CString ICTCD::GetName()
{
	CString result;
	GetProperty(0x3, VT_BSTR, (void*)&result);
	return result;
}

void ICTCD::SetName(LPCTSTR propVal)
{
	SetProperty(0x3, VT_BSTR, propVal);
}

LPDISPATCH ICTCD::GetParent()
{
	LPDISPATCH result;
	GetProperty(0x4, VT_DISPATCH, (void*)&result);
	return result;
}

void ICTCD::SetParent(LPDISPATCH propVal)
{
	SetProperty(0x4, VT_DISPATCH, propVal);
}

BOOL ICTCD::GetVisible()
{
	BOOL result;
	GetProperty(0x5, VT_BOOL, (void*)&result);
	return result;
}

void ICTCD::SetVisible(BOOL propVal)
{
	SetProperty(0x5, VT_BOOL, propVal);
}

short ICTCD::GetTrackCount()
{
	short result;
	GetProperty(0x6, VT_I2, (void*)&result);
	return result;
}

void ICTCD::SetTrackCount(short propVal)
{
	SetProperty(0x6, VT_I2, propVal);
}

short ICTCD::GetTrackNumber()
{
	short result;
	GetProperty(0x7, VT_I2, (void*)&result);
	return result;
}

void ICTCD::SetTrackNumber(short propVal)
{
	SetProperty(0x7, VT_I2, propVal);
}

CString ICTCD::GetTrackName()
{
	CString result;
	GetProperty(0x8, VT_BSTR, (void*)&result);
	return result;
}

void ICTCD::SetTrackName(LPCTSTR propVal)
{
	SetProperty(0x8, VT_BSTR, propVal);
}

CString ICTCD::GetCollection()
{
	CString result;
	GetProperty(0x9, VT_BSTR, (void*)&result);
	return result;
}

void ICTCD::SetCollection(LPCTSTR propVal)
{
	SetProperty(0x9, VT_BSTR, propVal);
}

CString ICTCD::GetArtiste()
{
	CString result;
	GetProperty(0xa, VT_BSTR, (void*)&result);
	return result;
}

void ICTCD::SetArtiste(LPCTSTR propVal)
{
	SetProperty(0xa, VT_BSTR, propVal);
}

BOOL ICTCD::GetPlaying()
{
	BOOL result;
	GetProperty(0xb, VT_BOOL, (void*)&result);
	return result;
}

void ICTCD::SetPlaying(BOOL propVal)
{
	SetProperty(0xb, VT_BOOL, propVal);
}

BOOL ICTCD::GetStopped()
{
	BOOL result;
	GetProperty(0xc, VT_BOOL, (void*)&result);
	return result;
}

void ICTCD::SetStopped(BOOL propVal)
{
	SetProperty(0xc, VT_BOOL, propVal);
}

BOOL ICTCD::GetPaused()
{
	BOOL result;
	GetProperty(0xd, VT_BOOL, (void*)&result);
	return result;
}

void ICTCD::SetPaused(BOOL propVal)
{
	SetProperty(0xd, VT_BOOL, propVal);
}

BOOL ICTCD::GetPlaylist()
{
	BOOL result;
	GetProperty(0xe, VT_BOOL, (void*)&result);
	return result;
}

void ICTCD::SetPlaylist(BOOL propVal)
{
	SetProperty(0xe, VT_BOOL, propVal);
}

/////////////////////////////////////////////////////////////////////////////
// ICTCD operations

void ICTCD::Quit()
{
	InvokeHelper(0xf, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTCD::Play()
{
	InvokeHelper(0x10, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTCD::PlayTrack(short nTrackNumber)
{
	static BYTE parms[] =
		VTS_I2;
	InvokeHelper(0x11, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 nTrackNumber);
}

void ICTCD::Stop()
{
	InvokeHelper(0x12, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTCD::Pause()
{
	InvokeHelper(0x13, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTCD::SkipForward()
{
	InvokeHelper(0x14, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTCD::SkipBackward()
{
	InvokeHelper(0x15, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTCD::ShowPlaylist()
{
	InvokeHelper(0x16, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

BOOL ICTCD::AddTrack(LPCTSTR lpcstrTrack)
{
	BOOL result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x17, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		lpcstrTrack);
	return result;
}

BOOL ICTCD::RemoveCurrentTrack()
{
	BOOL result;
	InvokeHelper(0x18, DISPATCH_METHOD, VT_BOOL, (void*)&result, NULL);
	return result;
}

void ICTCD::Eject()
{
	InvokeHelper(0x19, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}


/////////////////////////////////////////////////////////////////////////////
// ICTMIDI properties

LPDISPATCH ICTMIDI::GetApplication()
{
	LPDISPATCH result;
	GetProperty(0x1, VT_DISPATCH, (void*)&result);
	return result;
}

void ICTMIDI::SetApplication(LPDISPATCH propVal)
{
	SetProperty(0x1, VT_DISPATCH, propVal);
}

CString ICTMIDI::GetFullName()
{
	CString result;
	GetProperty(0x2, VT_BSTR, (void*)&result);
	return result;
}

void ICTMIDI::SetFullName(LPCTSTR propVal)
{
	SetProperty(0x2, VT_BSTR, propVal);
}

CString ICTMIDI::GetName()
{
	CString result;
	GetProperty(0x3, VT_BSTR, (void*)&result);
	return result;
}

void ICTMIDI::SetName(LPCTSTR propVal)
{
	SetProperty(0x3, VT_BSTR, propVal);
}

LPDISPATCH ICTMIDI::GetParent()
{
	LPDISPATCH result;
	GetProperty(0x4, VT_DISPATCH, (void*)&result);
	return result;
}

void ICTMIDI::SetParent(LPDISPATCH propVal)
{
	SetProperty(0x4, VT_DISPATCH, propVal);
}

BOOL ICTMIDI::GetVisible()
{
	BOOL result;
	GetProperty(0x5, VT_BOOL, (void*)&result);
	return result;
}

void ICTMIDI::SetVisible(BOOL propVal)
{
	SetProperty(0x5, VT_BOOL, propVal);
}

short ICTMIDI::GetTrackCount()
{
	short result;
	GetProperty(0x6, VT_I2, (void*)&result);
	return result;
}

void ICTMIDI::SetTrackCount(short propVal)
{
	SetProperty(0x6, VT_I2, propVal);
}

short ICTMIDI::GetTrackNumber()
{
	short result;
	GetProperty(0x7, VT_I2, (void*)&result);
	return result;
}

void ICTMIDI::SetTrackNumber(short propVal)
{
	SetProperty(0x7, VT_I2, propVal);
}

CString ICTMIDI::GetTrackName()
{
	CString result;
	GetProperty(0x8, VT_BSTR, (void*)&result);
	return result;
}

void ICTMIDI::SetTrackName(LPCTSTR propVal)
{
	SetProperty(0x8, VT_BSTR, propVal);
}

CString ICTMIDI::GetCollection()
{
	CString result;
	GetProperty(0x9, VT_BSTR, (void*)&result);
	return result;
}

void ICTMIDI::SetCollection(LPCTSTR propVal)
{
	SetProperty(0x9, VT_BSTR, propVal);
}

CString ICTMIDI::GetArtiste()
{
	CString result;
	GetProperty(0xa, VT_BSTR, (void*)&result);
	return result;
}

void ICTMIDI::SetArtiste(LPCTSTR propVal)
{
	SetProperty(0xa, VT_BSTR, propVal);
}

BOOL ICTMIDI::GetPlaying()
{
	BOOL result;
	GetProperty(0xb, VT_BOOL, (void*)&result);
	return result;
}

void ICTMIDI::SetPlaying(BOOL propVal)
{
	SetProperty(0xb, VT_BOOL, propVal);
}

BOOL ICTMIDI::GetStopped()
{
	BOOL result;
	GetProperty(0xc, VT_BOOL, (void*)&result);
	return result;
}

void ICTMIDI::SetStopped(BOOL propVal)
{
	SetProperty(0xc, VT_BOOL, propVal);
}

BOOL ICTMIDI::GetPaused()
{
	BOOL result;
	GetProperty(0xd, VT_BOOL, (void*)&result);
	return result;
}

void ICTMIDI::SetPaused(BOOL propVal)
{
	SetProperty(0xd, VT_BOOL, propVal);
}

BOOL ICTMIDI::GetPlaylist()
{
	BOOL result;
	GetProperty(0xe, VT_BOOL, (void*)&result);
	return result;
}

void ICTMIDI::SetPlaylist(BOOL propVal)
{
	SetProperty(0xe, VT_BOOL, propVal);
}

/////////////////////////////////////////////////////////////////////////////
// ICTMIDI operations

void ICTMIDI::Quit()
{
	InvokeHelper(0xf, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTMIDI::Play()
{
	InvokeHelper(0x10, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTMIDI::PlayTrack(short nTrackNumber)
{
	static BYTE parms[] =
		VTS_I2;
	InvokeHelper(0x11, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 nTrackNumber);
}

void ICTMIDI::Stop()
{
	InvokeHelper(0x12, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTMIDI::Pause()
{
	InvokeHelper(0x13, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTMIDI::SkipForward()
{
	InvokeHelper(0x14, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTMIDI::SkipBackward()
{
	InvokeHelper(0x15, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTMIDI::ShowPlaylist()
{
	InvokeHelper(0x16, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

BOOL ICTMIDI::AddTrack(LPCTSTR lpcstrTrack)
{
	BOOL result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x17, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		lpcstrTrack);
	return result;
}

BOOL ICTMIDI::RemoveCurrentTrack()
{
	BOOL result;
	InvokeHelper(0x18, DISPATCH_METHOD, VT_BOOL, (void*)&result, NULL);
	return result;
}


/////////////////////////////////////////////////////////////////////////////
// ICTWave properties

LPDISPATCH ICTWave::GetApplication()
{
	LPDISPATCH result;
	GetProperty(0x1, VT_DISPATCH, (void*)&result);
	return result;
}

void ICTWave::SetApplication(LPDISPATCH propVal)
{
	SetProperty(0x1, VT_DISPATCH, propVal);
}

CString ICTWave::GetFullName()
{
	CString result;
	GetProperty(0x2, VT_BSTR, (void*)&result);
	return result;
}

void ICTWave::SetFullName(LPCTSTR propVal)
{
	SetProperty(0x2, VT_BSTR, propVal);
}

CString ICTWave::GetName()
{
	CString result;
	GetProperty(0x3, VT_BSTR, (void*)&result);
	return result;
}

void ICTWave::SetName(LPCTSTR propVal)
{
	SetProperty(0x3, VT_BSTR, propVal);
}

LPDISPATCH ICTWave::GetParent()
{
	LPDISPATCH result;
	GetProperty(0x4, VT_DISPATCH, (void*)&result);
	return result;
}

void ICTWave::SetParent(LPDISPATCH propVal)
{
	SetProperty(0x4, VT_DISPATCH, propVal);
}

BOOL ICTWave::GetVisible()
{
	BOOL result;
	GetProperty(0x5, VT_BOOL, (void*)&result);
	return result;
}

void ICTWave::SetVisible(BOOL propVal)
{
	SetProperty(0x5, VT_BOOL, propVal);
}

short ICTWave::GetTrackCount()
{
	short result;
	GetProperty(0x6, VT_I2, (void*)&result);
	return result;
}

void ICTWave::SetTrackCount(short propVal)
{
	SetProperty(0x6, VT_I2, propVal);
}

short ICTWave::GetTrackNumber()
{
	short result;
	GetProperty(0x7, VT_I2, (void*)&result);
	return result;
}

void ICTWave::SetTrackNumber(short propVal)
{
	SetProperty(0x7, VT_I2, propVal);
}

CString ICTWave::GetTrackName()
{
	CString result;
	GetProperty(0x8, VT_BSTR, (void*)&result);
	return result;
}

void ICTWave::SetTrackName(LPCTSTR propVal)
{
	SetProperty(0x8, VT_BSTR, propVal);
}

CString ICTWave::GetCollection()
{
	CString result;
	GetProperty(0x9, VT_BSTR, (void*)&result);
	return result;
}

void ICTWave::SetCollection(LPCTSTR propVal)
{
	SetProperty(0x9, VT_BSTR, propVal);
}

CString ICTWave::GetArtiste()
{
	CString result;
	GetProperty(0xa, VT_BSTR, (void*)&result);
	return result;
}

void ICTWave::SetArtiste(LPCTSTR propVal)
{
	SetProperty(0xa, VT_BSTR, propVal);
}

BOOL ICTWave::GetPlaying()
{
	BOOL result;
	GetProperty(0xb, VT_BOOL, (void*)&result);
	return result;
}

void ICTWave::SetPlaying(BOOL propVal)
{
	SetProperty(0xb, VT_BOOL, propVal);
}

BOOL ICTWave::GetStopped()
{
	BOOL result;
	GetProperty(0xc, VT_BOOL, (void*)&result);
	return result;
}

void ICTWave::SetStopped(BOOL propVal)
{
	SetProperty(0xc, VT_BOOL, propVal);
}

BOOL ICTWave::GetPaused()
{
	BOOL result;
	GetProperty(0xd, VT_BOOL, (void*)&result);
	return result;
}

void ICTWave::SetPaused(BOOL propVal)
{
	SetProperty(0xd, VT_BOOL, propVal);
}

BOOL ICTWave::GetPlaylist()
{
	BOOL result;
	GetProperty(0xe, VT_BOOL, (void*)&result);
	return result;
}

void ICTWave::SetPlaylist(BOOL propVal)
{
	SetProperty(0xe, VT_BOOL, propVal);
}

/////////////////////////////////////////////////////////////////////////////
// ICTWave operations

void ICTWave::Quit()
{
	InvokeHelper(0xf, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTWave::Play()
{
	InvokeHelper(0x10, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTWave::PlayTrack(short nTrackNumber)
{
	static BYTE parms[] =
		VTS_I2;
	InvokeHelper(0x11, DISPATCH_METHOD, VT_EMPTY, NULL, parms,
		 nTrackNumber);
}

void ICTWave::Stop()
{
	InvokeHelper(0x12, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTWave::Pause()
{
	InvokeHelper(0x13, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTWave::SkipForward()
{
	InvokeHelper(0x14, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTWave::SkipBackward()
{
	InvokeHelper(0x15, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

void ICTWave::ShowPlaylist()
{
	InvokeHelper(0x16, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}

BOOL ICTWave::AddTrack(LPCTSTR lpcstrTrack)
{
	BOOL result;
	static BYTE parms[] =
		VTS_BSTR;
	InvokeHelper(0x17, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		lpcstrTrack);
	return result;
}

BOOL ICTWave::RemoveCurrentTrack()
{
	BOOL result;
	InvokeHelper(0x18, DISPATCH_METHOD, VT_BOOL, (void*)&result, NULL);
	return result;
}


/////////////////////////////////////////////////////////////////////////////
// ICTMixer properties

LPDISPATCH ICTMixer::GetApplication()
{
	LPDISPATCH result;
	GetProperty(0x1, VT_DISPATCH, (void*)&result);
	return result;
}

void ICTMixer::SetApplication(LPDISPATCH propVal)
{
	SetProperty(0x1, VT_DISPATCH, propVal);
}

CString ICTMixer::GetFullName()
{
	CString result;
	GetProperty(0x2, VT_BSTR, (void*)&result);
	return result;
}

void ICTMixer::SetFullName(LPCTSTR propVal)
{
	SetProperty(0x2, VT_BSTR, propVal);
}

CString ICTMixer::GetName()
{
	CString result;
	GetProperty(0x3, VT_BSTR, (void*)&result);
	return result;
}

void ICTMixer::SetName(LPCTSTR propVal)
{
	SetProperty(0x3, VT_BSTR, propVal);
}

LPDISPATCH ICTMixer::GetParent()
{
	LPDISPATCH result;
	GetProperty(0x4, VT_DISPATCH, (void*)&result);
	return result;
}

void ICTMixer::SetParent(LPDISPATCH propVal)
{
	SetProperty(0x4, VT_DISPATCH, propVal);
}

BOOL ICTMixer::GetVisible()
{
	BOOL result;
	GetProperty(0x5, VT_BOOL, (void*)&result);
	return result;
}

void ICTMixer::SetVisible(BOOL propVal)
{
	SetProperty(0x5, VT_BOOL, propVal);
}

/////////////////////////////////////////////////////////////////////////////
// ICTMixer operations

BOOL ICTMixer::ctmixerGetMaxVolume(long nControlTypeID, long nDeviceID, long nMixerID, long* pnVolLevel)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_I4 VTS_I4 VTS_PI4;
	InvokeHelper(0x6, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nControlTypeID, nDeviceID, nMixerID, pnVolLevel);
	return result;
}

BOOL ICTMixer::ctmixerGetMute(long nControlTypeID, long nDeviceID, long nMixerID, BOOL* pbState)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_I4 VTS_I4 VTS_PBOOL;
	InvokeHelper(0x7, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nControlTypeID, nDeviceID, nMixerID, pbState);
	return result;
}

BOOL ICTMixer::ctmixerSetMute(long nControlTypeID, long nDeviceID, long nMixerID, BOOL bState)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_I4 VTS_I4 VTS_BOOL;
	InvokeHelper(0x8, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nControlTypeID, nDeviceID, nMixerID, bState);
	return result;
}

long ICTMixer::ctmixerGetNumberOfMixers()
{
	long result;
	InvokeHelper(0x9, DISPATCH_METHOD, VT_I4, (void*)&result, NULL);
	return result;
}

CString ICTMixer::ctmixerGetName(long nMixerID)
{
	CString result;
	static BYTE parms[] =
		VTS_I4;
	InvokeHelper(0xa, DISPATCH_METHOD, VT_BSTR, (void*)&result, parms,
		nMixerID);
	return result;
}

BOOL ICTMixer::ctmixerGetVolume(long nControlTypeID, long nDeviceID, long nMixerID, long* pnLeftVolLevel, long* pnRightVolLevel)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_I4 VTS_I4 VTS_PI4 VTS_PI4;
	InvokeHelper(0xb, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nControlTypeID, nDeviceID, nMixerID, pnLeftVolLevel, pnRightVolLevel);
	return result;
}

BOOL ICTMixer::ctmixerSetVolume(long nControlTypeID, long nDeviceID, long nMixerID, long nLeftVolLevel, long nRightVolLevel)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_I4 VTS_I4 VTS_I4 VTS_I4;
	InvokeHelper(0xc, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nControlTypeID, nDeviceID, nMixerID, nLeftVolLevel, nRightVolLevel);
	return result;
}

BOOL ICTMixer::ctmixerIsStereo(long nControlTypeID, long nDeviceID, long nMixerID)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_I4 VTS_I4;
	InvokeHelper(0xd, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nControlTypeID, nDeviceID, nMixerID);
	return result;
}

BOOL ICTMixer::ctmixerGetOutputGain(long nMixerID, long* pnLeftGain, long* pnRightGain)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_PI4 VTS_PI4;
	InvokeHelper(0xe, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nMixerID, pnLeftGain, pnRightGain);
	return result;
}

BOOL ICTMixer::ctmixerSetOutputGain(long nMixerID, long nLeftGain, long nRightGain)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_I4 VTS_I4;
	InvokeHelper(0xf, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nMixerID, nLeftGain, nRightGain);
	return result;
}

BOOL ICTMixer::ctmixerGetInputGain(long nMixerID, long* pnLeftGain, long* pnRightGain)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_PI4 VTS_PI4;
	InvokeHelper(0x10, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nMixerID, pnLeftGain, pnRightGain);
	return result;
}

BOOL ICTMixer::ctmixerSetInputGain(long nMixerID, long nLeftGain, long nRightGain)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_I4 VTS_I4;
	InvokeHelper(0x11, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nMixerID, nLeftGain, nRightGain);
	return result;
}

BOOL ICTMixer::ctmixerGetAGC(long nMixerID, BOOL* pbAGCOn)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_PBOOL;
	InvokeHelper(0x12, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nMixerID, pbAGCOn);
	return result;
}

BOOL ICTMixer::ctmixerSetAGC(long nMixerID, BOOL bAGCOn)
{
	BOOL result;
	static BYTE parms[] =
		VTS_I4 VTS_BOOL;
	InvokeHelper(0x13, DISPATCH_METHOD, VT_BOOL, (void*)&result, parms,
		nMixerID, bAGCOn);
	return result;
}

void ICTMixer::Quit()
{
	InvokeHelper(0x14, DISPATCH_METHOD, VT_EMPTY, NULL, NULL);
}
