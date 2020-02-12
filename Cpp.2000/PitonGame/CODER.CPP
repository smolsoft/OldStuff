//////////////////////////////////////////////////////////////////////////////////
//				Coder.cpp: implementation for the Coder class.							//
//				(c)1999 SMOLsoft Company. All rights reserved.					//
//						Protected by international laws.						//
//////////////////////////////////////////////////////////////////////////////////

#include "Headers.h"
#include "Coder.h"


#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


///////////////////////////////////////////////////////////////////////
//******************	Coder class		*******************************
///////////////////////////////////////////////////////////////////////

//------------------------------------------------------- CONSTRUCTOR Coder
Coder::Coder(void* start, DWORD len, BYTE st)
{
	;
}

//------------------------------------------------------- CONSTRUCTOR Coder
Coder::Coder(CString name, BYTE st)
{
	LoadFromFile(name, st);
}

//------------------------------------------------------- DESTRUCTOR Coder
Coder::~Coder()
{
	;
}

//------------------------------------------------------- Coder::Coding()
void Coder::Coding()
{
	;
}

//------------------------------------------------------- Coder::DeCoding()
void Coder::DeCoding()
{
	;
}

//------------------------------------------------------- Coder::LoadFromFile()
BOOL Coder::LoadFromFile(CString name, BYTE st)
{
	return TRUE;
}

//------------------------------------------------------- Coder::SaveToFile()
BOOL Coder::SaveToFile(CString name)
{
	return TRUE;
}


//------------------------------------------------------- Coder::CodingLR()
void Coder::CodingLR()
{
	;
}

//------------------------------------------------------- Coder::CodingRL()
void Coder::CodingRL()
{
	;
}

//------------------------------------------------------- Coder::DeCodingLR()
void Coder::DeCodingLR()
{
	;
}

//------------------------------------------------------- Coder::DeCodingRL()
void Coder::DeCodingRL()
{
	;
}



