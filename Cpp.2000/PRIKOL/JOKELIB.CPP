#include <dos.h>
//#include <conio.h>
//#include <dir.h>
//#include <mem.h>
//#include <stdlib.h>
#include <stdio.h>
#include "jokelib.h"

WORD MCBfirst (void)
{
	asm {
		mov ah, 52h
		int 21h
		mov ax,es:[bx-2]
	}
}

/*------------- CREATE KEYS func ------------------------------*/
BYTE shell_type (void)
{
	MCB_struct far *mcb;
	PSP_struct far *psp = (PSP_struct far*)MK_FP(_psp, 0);
	char shell_name[9];
	BYTE not_found = 1;
	int i;


	while (not_found)
	{
		if (mcb->owner == psp->ParentPSP) not_found = 0;
		if (mcb->sign == 0x5A && not_found) break;
		mcb += mcb->size + 1;
	}

	if (not_found)
		return NOT_FOUND;
	else
	{
		for (i=0; i<8; i++)
			shell_name[i] = mcb->name[i];
		shell_name[i] = '\0';
		printf("ParentsPSP1 = %Fp\n",(PSP_struct far*)MK_FP(psp->ParentPSP,0));
		puts(shell_name);
	}


}
