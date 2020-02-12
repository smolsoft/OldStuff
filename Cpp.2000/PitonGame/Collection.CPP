// Collection.cpp: implementation of the Collection class.
#include "Headers.h"
#include "DirectDrawWin.h"
#include "Collection.h"

#ifdef _DEBUG
#undef THIS_FILE
static char THIS_FILE[]=__FILE__;
#define new DEBUG_NEW
#endif


StringCollection::~StringCollection()
{
	for (int i=0;i<count;i++)
		delete strings[i];
}

BOOL StringCollection::Add(CString text)
{
	if (count==MaxSize)
		return FALSE;
	
	strings[count]=new CString(text);
	count++;
	return TRUE;
}

CString StringCollection::At(int n)
{
	if (n>count-1)
	{
		TRACE ("ERROR in __StringCollection::At(int n)\n");
		return "!!!_ E R R O R _!!!";
	}
	else
		return *strings[n];
}

