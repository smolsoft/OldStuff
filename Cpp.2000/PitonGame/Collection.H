// Collection.h: interface for the Collection class.

#if !defined(string_collection)
#define string_collection

#if _MSC_VER > 1000
#pragma once
#endif // _MSC_VER > 1000


const WORD MaxSize=256;

class StringCollection : CObject
{
private:
	CString* strings[MaxSize];
	int count;
public:
	StringCollection()		// Constructor
		: CObject() { count=0; }
	~StringCollection();	// Virtual destructor

	BOOL Add(CString text);	// Add string to collection
	CString At(int n);		// Return string 'n' from collection
	int Count()				// Return number of last string in collection
		{ return count; }
};



#endif // !defined(string_collection)
