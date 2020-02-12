#include <dos.h>
//#include <conio.h>
//#include <dir.h>
//#include <mem.h>
//#include <stdlib.h>
#include <stdio.h>
#include "jokelib.h"

WORD MCBfirst()
{
	asm {
		mov ah, 52h
		int 21h
		mov ax,es:[bx-2]
	}
}

/*------------- CREATE KEYS func ------------------------------*/
BYTE shell_type()
{
	MCB_struct far *mcb;
	PSP_struct far *psp = (PSP_struct far*)MK_FP(_psp, 0);
	BYTE not_found = 1;
	int i;

	mcb = (MCB_struct far*)MCBfirst();

	while (not_found)
	{
		if (mcb->owner == psp->ParentPSP) not_found = 0;
		if (mcb->sign == 0x5A && not_found) break;
		mcb += mcb->size + 1;
	}

	if (not_found)
		return NOT_FOUND;
	else
		printf("shell_NAME = %.8s\n",mcb->name);


}
