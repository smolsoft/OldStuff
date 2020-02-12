// Machine generated IDispatch wrapper class(es) created with ClassWizard
/////////////////////////////////////////////////////////////////////////////
// ICTCD wrapper class

class ICTCD : public COleDispatchDriver
{
public:
	ICTCD() {}		// Calls COleDispatchDriver default constructor
	ICTCD(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	ICTCD(const ICTCD& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

// Attributes
public:
	LPDISPATCH GetApplication();
	void SetApplication(LPDISPATCH);
	CString GetFullName();
	void SetFullName(LPCTSTR);
	CString GetName();
	void SetName(LPCTSTR);
	LPDISPATCH GetParent();
	void SetParent(LPDISPATCH);
	BOOL GetVisible();
	void SetVisible(BOOL);
	short GetTrackCount();
	void SetTrackCount(short);
	short GetTrackNumber();
	void SetTrackNumber(short);
	CString GetTrackName();
	void SetTrackName(LPCTSTR);
	CString GetCollection();
	void SetCollection(LPCTSTR);
	CString GetArtiste();
	void SetArtiste(LPCTSTR);
	BOOL GetPlaying();
	void SetPlaying(BOOL);
	BOOL GetStopped();
	void SetStopped(BOOL);
	BOOL GetPaused();
	void SetPaused(BOOL);
	BOOL GetPlaylist();
	void SetPlaylist(BOOL);

// Operations
public:
	void Quit();
	void Play();
	void PlayTrack(short nTrackNumber);
	void Stop();
	void Pause();
	void SkipForward();
	void SkipBackward();
	void ShowPlaylist();
	BOOL AddTrack(LPCTSTR lpcstrTrack);
	BOOL RemoveCurrentTrack();
	void Eject();
};
/////////////////////////////////////////////////////////////////////////////
// ICTMIDI wrapper class

class ICTMIDI : public COleDispatchDriver
{
public:
	ICTMIDI() {}		// Calls COleDispatchDriver default constructor
	ICTMIDI(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	ICTMIDI(const ICTMIDI& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

// Attributes
public:
	LPDISPATCH GetApplication();
	void SetApplication(LPDISPATCH);
	CString GetFullName();
	void SetFullName(LPCTSTR);
	CString GetName();
	void SetName(LPCTSTR);
	LPDISPATCH GetParent();
	void SetParent(LPDISPATCH);
	BOOL GetVisible();
	void SetVisible(BOOL);
	short GetTrackCount();
	void SetTrackCount(short);
	short GetTrackNumber();
	void SetTrackNumber(short);
	CString GetTrackName();
	void SetTrackName(LPCTSTR);
	CString GetCollection();
	void SetCollection(LPCTSTR);
	CString GetArtiste();
	void SetArtiste(LPCTSTR);
	BOOL GetPlaying();
	void SetPlaying(BOOL);
	BOOL GetStopped();
	void SetStopped(BOOL);
	BOOL GetPaused();
	void SetPaused(BOOL);
	BOOL GetPlaylist();
	void SetPlaylist(BOOL);

// Operations
public:
	void Quit();
	void Play();
	void PlayTrack(short nTrackNumber);
	void Stop();
	void Pause();
	void SkipForward();
	void SkipBackward();
	void ShowPlaylist();
	BOOL AddTrack(LPCTSTR lpcstrTrack);
	BOOL RemoveCurrentTrack();
};
/////////////////////////////////////////////////////////////////////////////
// ICTWave wrapper class

class ICTWave : public COleDispatchDriver
{
public:
	ICTWave() {}		// Calls COleDispatchDriver default constructor
	ICTWave(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	ICTWave(const ICTWave& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

// Attributes
public:
	LPDISPATCH GetApplication();
	void SetApplication(LPDISPATCH);
	CString GetFullName();
	void SetFullName(LPCTSTR);
	CString GetName();
	void SetName(LPCTSTR);
	LPDISPATCH GetParent();
	void SetParent(LPDISPATCH);
	BOOL GetVisible();
	void SetVisible(BOOL);
	short GetTrackCount();
	void SetTrackCount(short);
	short GetTrackNumber();
	void SetTrackNumber(short);
	CString GetTrackName();
	void SetTrackName(LPCTSTR);
	CString GetCollection();
	void SetCollection(LPCTSTR);
	CString GetArtiste();
	void SetArtiste(LPCTSTR);
	BOOL GetPlaying();
	void SetPlaying(BOOL);
	BOOL GetStopped();
	void SetStopped(BOOL);
	BOOL GetPaused();
	void SetPaused(BOOL);
	BOOL GetPlaylist();
	void SetPlaylist(BOOL);

// Operations
public:
	void Quit();
	void Play();
	void PlayTrack(short nTrackNumber);
	void Stop();
	void Pause();
	void SkipForward();
	void SkipBackward();
	void ShowPlaylist();
	BOOL AddTrack(LPCTSTR lpcstrTrack);
	BOOL RemoveCurrentTrack();
};
/////////////////////////////////////////////////////////////////////////////
// ICTMixer wrapper class

class ICTMixer : public COleDispatchDriver
{
public:
	ICTMixer() {}		// Calls COleDispatchDriver default constructor
	ICTMixer(LPDISPATCH pDispatch) : COleDispatchDriver(pDispatch) {}
	ICTMixer(const ICTMixer& dispatchSrc) : COleDispatchDriver(dispatchSrc) {}

// Attributes
public:
	LPDISPATCH GetApplication();
	void SetApplication(LPDISPATCH);
	CString GetFullName();
	void SetFullName(LPCTSTR);
	CString GetName();
	void SetName(LPCTSTR);
	LPDISPATCH GetParent();
	void SetParent(LPDISPATCH);
	BOOL GetVisible();
	void SetVisible(BOOL);

// Operations
public:
	BOOL ctmixerGetMaxVolume(long nControlTypeID, long nDeviceID, long nMixerID, long* pnVolLevel);
	BOOL ctmixerGetMute(long nControlTypeID, long nDeviceID, long nMixerID, BOOL* pbState);
	BOOL ctmixerSetMute(long nControlTypeID, long nDeviceID, long nMixerID, BOOL bState);
	long ctmixerGetNumberOfMixers();
	CString ctmixerGetName(long nMixerID);
	BOOL ctmixerGetVolume(long nControlTypeID, long nDeviceID, long nMixerID, long* pnLeftVolLevel, long* pnRightVolLevel);
	BOOL ctmixerSetVolume(long nControlTypeID, long nDeviceID, long nMixerID, long nLeftVolLevel, long nRightVolLevel);
	BOOL ctmixerIsStereo(long nControlTypeID, long nDeviceID, long nMixerID);
	BOOL ctmixerGetOutputGain(long nMixerID, long* pnLeftGain, long* pnRightGain);
	BOOL ctmixerSetOutputGain(long nMixerID, long nLeftGain, long nRightGain);
	BOOL ctmixerGetInputGain(long nMixerID, long* pnLeftGain, long* pnRightGain);
	BOOL ctmixerSetInputGain(long nMixerID, long nLeftGain, long nRightGain);
	BOOL ctmixerGetAGC(long nMixerID, BOOL* pbAGCOn);
	BOOL ctmixerSetAGC(long nMixerID, BOOL bAGCOn);
	void Quit();
};
