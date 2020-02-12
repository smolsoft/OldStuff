// jokelib.h

#define BYTE unsigned char
#define WORD unsigned int


// for direct access to video memory
typedef struct tegTexel
{
	BYTE ch;
	BYTE attr;
} texel;
typedef texel screen_array[25][80];
screen_array far* screen_ptr = (screen_array far*) 0xB8000000;
#define screen (*screen_ptr)

// for access to Program Segment Prefix (PSP)
#pragma pack(1)
typedef struct
{
	WORD CM_Pexit;
	WORD MemAvail;
	BYTE reserved1;
	BYTE DosDispathcer[5];
	WORD OldInt22[2];
	WORD OldInt23[2];
	WORD OldInt24[2];
	WORD ParentPSP;
	BYTE Handle[20];
	WORD Environment;
	WORD LocalSS_SP[2];
	WORD Handles;
	BYTE far *NewHandles;
	BYTE reserved2[24];
	BYTE DosCall[3];
	BYTE reserved3[10];
	BYTE FCB_1[16];
	BYTE FCB_2[16];
	BYTE reserved4[3];
	BYTE ParamLen;
	BYTE Params[127];
} PSP_struct;

// for access to Memory Control Block (MCB)
typedef struct
{
	BYTE sign;
	WORD owner;
	WORD size;
	BYTE reserved[3];
	BYTE name[8];
} MCB_struct;
#pragma pack()

// коды клавиш
int const HOME			= 0x4700;
int const INSERT		= 0x5200;
int const DELETE		= 0x5300;
int const GREY_PLUS		= 0x4E2B;
int const F8			= 0x4200;
int const ENTER			= 0x1C0D;
int const DISK_C 		= 0x2E43; //"C"
int const DISK_COLON	= 0x273A; //":"

int const stateRSHIFT	= 0x0001;
int const stateLSHIFT	= 0x0002;
int const stateCTRL		= 0x0004;
int const stateALT		= 0x0008;
int const stateSCROLL	= 0x0010;
int const stateNUMLOCK	= 0x0020;
int const stateCAPSLOCK = 0x0040;
int const stateINS_STATE= 0x0080;
int const stateLCTRL	= 0x0100;
int const stateLALT		= 0x0200;
int const stateSYSREQ	= 0x0400;
int const statePAUSE	= 0x0800;
int const stateSCROLL_DN= 0x1000;
int const stateNUM_DN	= 0x2000;
int const stateCAPS_DN	= 0x4000;
int const stateINS_DN	= 0x8000;

// shells
BYTE const NOT_FOUND	= 0x0;
BYTE const VC			= 0x1;
BYTE const NC			= 0x2;
BYTE const DOSNAVI		= 0x3;
BYTE const FAR			= 0x4;
BYTE const DISCOCOM		= 0x5;


