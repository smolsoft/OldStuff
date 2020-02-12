//////////////////////////////////////////////////////////////////////////////////
//				Coder.h: interface for the Coder class.							//
//				(c)1999 SMOLsoft Company. All rights reserved.					//
//						Protected by international laws.						//
//////////////////////////////////////////////////////////////////////////////////


#if !defined(_CODER_INTERFACE_)
#define _CODER_INTERFACE_

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000



const BYTE CODER_NONE	=	0;
const BYTE CODER_CODED	=	1;
const BYTE CODER_UNCODED=	2;


class Coder
{
public:
	Coder(void* start, DWORD len, BYTE st);
	Coder(CString name, BYTE st);
	~Coder();
	void Coding();
	void DeCoding();
	BOOL LoadFromFile(CString name, BYTE st);
	BOOL SaveToFile(CString name);

	BYTE state;

private:
	void* pointer;

	void CodingLR();
	void CodingRL();
	void DeCodingLR();
	void DeCodingRL();
};



#endif // !defined(_CODER_INTERFACE_)
