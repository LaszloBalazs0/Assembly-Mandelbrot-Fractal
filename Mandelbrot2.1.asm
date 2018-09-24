; Made By : Balazs Laszlo
; Zoom in and out with Scroll
; Color change with 'C'
; Change precision with 'Q'
; Move with 'WASD'

;Vectorized - > Single - > Double
;Colors - > 256 colors

%include 'io.inc'
%include 'gfx.inc'

%define WIDTH 1360
%define HEIGHT 768

global main

section .text

main:

;Creating the window

MOV		EAX,WIDTH	; Width
MOV		EBX,HEIGHT	; Height

MOV		ECX,1	; MOD (0 - WINDOWED ; 1 - FULLSCREEN)
MOV		EDX,caption	; Name of the window
CALL	gfx_init

TEST	EAX,EAX		; If 0 we have a problem -> ERROR MSG.
JNZ		.init

;ERROR MSG. ===> EXIT
MOV		EAX,errormsg
CALL	io_writestr
CALL	io_writeln
RET

.init:

XOR		ESI,ESI
XOR		EDI,EDI

.mainloop:
CALL	gfx_map

XOR		ECX,ECX

.yloop:

CMP		ECX,HEIGHT
JGE		.yend

XOR		EDX,EDX			

.xloop:

CMP		EDX,WIDTH
JGE		.xend

MOV		EBX,DWORD[singlevagydouble]	; Checks the mode selected by the user,
									; single by default
CMP		EBX,1
JE		.doublere

CALL	MandelbrotSingle			; MANDELBROT SINGLE func. => XMM7 - iterations in XMM7, 4 px
MOVAPS	[iteraciok],XMM7
PUSH	ECX							
MOV		ECX,[iteraciok]

MOV		EBX,[blue+ECX*4]		
MOV		[EAX],BL

MOV		EBX,[green+ECX*4]
MOV		[EAX+1],BL

MOV		EBX,[red+ECX*4]
MOV		[EAX+2],BL

XOR		EBX,EBX
MOV		[EAX+3],BL

ADD		EAX,4

;////////////Next Px\\\\\\\\\\\\\\\\\\\

MOV		ECX,[iteraciok+4]

MOV		EBX,[blue+ecx*4]
MOV		[EAX],BL

MOV		EBX,[green+ecx*4]
MOV		[EAX+1],BL

MOV		EBX,[red+ECX*4]
MOV		[EAX+2],BL

XOR		EBX,EBX
MOV		[EAX+3],BL

ADD		EAX,4

;/////////////Next Px\\\\\\\\\\\\\\\\\\\

MOV		ECX,[iteraciok+8]

MOV		EBX,[blue+ecx*4]
MOV		[EAX],BL

MOV		EBX,[green+ecx*4]
MOV		[EAX+1],BL

MOV		EBX,[red+ECX*4]
MOV		[EAX+2],BL

XOR		EBX,EBX
MOV		[EAX+3],BL

ADD		EAX,4

;/////////////Next Px\\\\\\\\\\\\\\\\\\\

MOV		ECX,[iteraciok+12]

MOV		EBX,[blue+ecx*4]
MOV		[EAX],BL

MOV		EBX,[green+ecx*4]
MOV		[EAX+1],BL

MOV		EBX,[red+ECX*4]
MOV		[EAX+2],BL

XOR		EBX,EBX
MOV		[EAX+3],BL

ADD		EAX,4

POP		ECX			
ADD		EDX,4
JMP		.vege

.doublere:

CALL	MandelbrotDouble	; MandelbrotDouble func. ==> XMM7 - iterations , 2 Pixels

MOVAPD	[iteraciokd],XMM7
PUSH	ECX
MOV		ECX,[iteraciokd]

MOV		EBX,[blue+ecx*4]
MOV		[EAX],BL

MOV		EBX,[green+ecx*4]
MOV		[EAX+1],BL

MOV		EBX,[red+ecx*4]
MOV		[EAX+2],BL

XOR		EBX,EBX
MOV		[EAX+3],BL

ADD		EAX,4

;///////////Next px\\\\\\\\\\\\\\\\\\\

MOV		ECX,[iteraciokd+8]

MOV		EBX,[blue+ecx*4]
MOV		[EAX],BL

MOV		EBX,[green+ecx*4]
MOV		[EAX+1],BL

MOV		EBX,[red+ecx*4]
MOV		[EAX+2],BL

XOR		EBX,EBX
MOV		[EAX+3],BL

POP		ECX
ADD		EAX,4
ADD		EDX,2

.vege:
JMP		.xloop

.xend:
INC		ECX
JMP		.yloop

.yend:
CALL	gfx_unmap
CALL	gfx_draw

.eventloop:
; moving with WASD
CALL	gfx_getevent

CMP		EAX,'w'		; W pushed

JE		.fel

CMP		EAX,'s'		

JE		.le

CMP		EAX,'a'

JE		.balra


CMP		EAX,'d'

JE		.jobbra

CMP		EAX,'q'
JE		.pontossagvaltas

JMP		.eventloop2

.fel:
MOVSS		XMM1,DWORD[szaz]
MOVSS		XMM2,DWORD[haromnegyvennyolc]
ADDSS		XMM2,XMM1
MOVSS		DWORD[haromnegyvennyolc],XMM2

MOVSD		XMM1,QWORD[szazd]
MOVSD		XMM2,QWORD[haromnegyvennyolcd]
ADDSD		XMM2,XMM1
MOVSD		QWORD[haromnegyvennyolcd],XMM2


XOR			EAX,EAX
JMP			.mainloop

.le:
MOVSS		XMM1,DWORD[szaz]
MOVSS		XMM2,DWORD[haromnegyvennyolc]
SUBSS		XMM2,XMM1
MOVSS		DWORD[haromnegyvennyolc],XMM2

MOVSD		XMM1,QWORD[szazd]
MOVSD		XMM2,QWORD[haromnegyvennyolcd]
SUBSD		XMM2,XMM1
MOVSD		QWORD[haromnegyvennyolcd],XMM2

XOR			EAX,EAX
JMP			.mainloop

.jobbra:
MOVSS		XMM1,DWORD[szaz]
MOVSS		XMM2,DWORD[hatnyolcvan]
SUBSS		XMM2,XMM1
MOVSS		DWORD[hatnyolcvan],XMM2

MOVSD		XMM1,QWORD[szazd]
MOVSD		XMM2,QWORD[hatnyolcvand]
SUBSD		XMM2,XMM1
MOVSD		QWORD[hatnyolcvand],XMM2

XOR			EAX,EAX
JMP			.mainloop

.balra:
MOVSS		XMM1,DWORD[szaz]
MOVSS		XMM2,DWORD[hatnyolcvan]
ADDSS		XMM2,XMM1
MOVSS		DWORD[hatnyolcvan],XMM2

MOVSD		XMM1,QWORD[szazd]
MOVSD		XMM2,QWORD[hatnyolcvand]
ADDSD		XMM2,XMM1
MOVSD		QWORD[hatnyolcvand],XMM2


XOR			EAX,EAX	
JMP			.mainloop

.pontossagvaltas:
push		eax
mov			eax,dword[singlevagydouble]
cmp			eax,0
je			.doublere2

mov			eax,0
mov			dword[singlevagydouble],eax
jmp			.vege1

.doublere2:
mov			eax,1
mov			dword[singlevagydouble],eax

.vege1:
pop			eax
jmp			.mainloop

.eventloop2:
CMP		EAX,23		; window close button
JE		.end

CMP		EAX,27		; ESC
JE		.end

CMP		EAX,4	; FEL GORGETES - > ZOOM
JE		.zoom

CMP		EAX,5	; ZOOM OUT
JNE		.eventloop

CALL	gfx_getmouse

CVTSI2SS	XMM0,EAX	; LEBEGOPONTOSSA TESZEM AZ X - ET
CVTSI2SS	XMM1,EBX	; LEBEGOPONTOSSA TESZEM AZ Y - T

MOVSS	XMM2,DWORD[zoom]
MOVSS	XMM3,DWORD[ketto]
DIVSS 	XMM2,XMM3
MOVSS	DWORD[zoom],XMM2
MOVSS	XMM2,DWORD[haromnegyvennyolc]
ADDPS	XMM2,XMM0
DIVPS	XMM2,XMM3
MOVSS	DWORD[haromnegyvennyolc],XMM2

MOVSS	XMM2,DWORD[hatnyolcvan]
ADDPS	XMM2,XMM1
DIVPS	XMM2,XMM3
MOVSS	DWORD[hatnyolcvan],XMM2

CVTSI2SD	XMM0,EAX
CVTSI2SD	XMM1,EBX
MOVSD	XMM2,QWORD[zoomd]
MOVSD	XMM3,QWORD[kettod]
DIVSD	XMM2,XMM3
MOVSD	QWORD[zoomd],XMM2

MOVSD	XMM2,QWORD[haromnegyvennyolcd]
ADDPD	XMM2,XMM0
DIVPD	XMM2,XMM3
MOVSD	QWORD[haromnegyvennyolcd],XMM2

MOVSD	XMM2,QWORD[hatnyolcvand]
ADDPD	XMM2,XMM1
DIVPD	XMM2,XMM3
MOVSD	QWORD[hatnyolcvand],XMM2


JMP		.mainloop
; HA FELGORGETES VOLT, AKKOR LEKERDEZI AZ EGER JELENLEGI KOORDINATAIT
; AHONNAN A GORGETES MEG VOLT HIVVA ,
; ES AZ LESSZ AZ UJ 'KOZEPPONTJA' A KOORDINATA RENDSZERNEK
; A JELENLEGI KOZPONT ES AZ EGER HELYZETENEK KUL. - EL LESSZ ELTOLVA A KOORDINATA RENDSZER

.zoom:
CALL	gfx_getmouse
;EAX - BEN AZ EGER X KOORDINATAJA
;EBX - BEN AZ EGER Y KOORDINATAJA

CVTSI2SS	XMM0,EAX	; LEBEGOPONTOSSA TESZEM AZ X - ET
CVTSI2SS	XMM1,EBX	; LEBEGOPONTOSSA TESZEM AZ Y - T

; HOZZAADJA A deltat a jelenlegi kozponthoz
; a kozpont es az eger kozotti kulonbesegem a delta

MOVSS		XMM2,DWORD[hatnyolcvan]
SUBSS		XMM2,XMM0
MOVSS		XMM3,DWORD[hatnyolcvan]
ADDSS		XMM2,XMM3
MOVSS		DWORD[hatnyolcvan],XMM2

CVTSI2SD	XMM0,EAX
MOVSD		XMM2,QWORD[hatnyolcvand]
SUBSD		XMM2,XMM0
MOVSD		XMM3,QWORD[hatnyolcvand]
ADDSD		XMM2,XMM3
MOVSD		QWORD[hatnyolcvand],XMM2


MOVSS		XMM2,DWORD[haromnegyvennyolc]
SUBSS		XMM2,XMM1
MOVSS		XMM3,DWORD[haromnegyvennyolc]
ADDSS		XMM2,XMM3
MOVSS		DWORD[haromnegyvennyolc],XMM2

CVTSI2SD	XMM1,EBX
MOVSD		XMM2,QWORD[haromnegyvennyolcd]
SUBSD		XMM2,XMM1
MOVSD		XMM3,QWORD[haromnegyvennyolcd]
ADDSD		XMM2,XMM3
MOVSD		QWORD[haromnegyvennyolcd],XMM2

MOVSS		XMM2,DWORD[zoom]
MOVSS		XMM3,DWORD[ketto]
MULSS		XMM2,XMM3
MOVSS		DWORD[zoom],XMM2

MOVSD		XMM2,QWORD[zoomd]
MOVSD		XMM3,QWORD[kettod]
MULSD		XMM2,XMM3
MOVSD		QWORD[zoomd],XMM2

JMP			.mainloop
TEST		EAX,EAX				; 0 - NINCS TOBB PARANCS

JNZ			.eventloop

.end:
CALL		gfx_destroy
ret

;///////MANDELBROT SINGLE\\\\\\\\\\\\\\\\

MandelbrotSingle:
PUSH	EAX
PUSH	EBX
PUSH	ECX
PUSH	EDX

XORPS	XMM6,XMM6
MOVAPS	[iteraciok],XMM6


CVTSI2SS	XMM0,EDX			; LEBEGOPONTOSSA 'VARAZSOLOM' AZ EDXET
SHUFPS		XMM0,XMM0,00H		; 'BROADCASTOLOM' , MIVEL XMM0 LEGALSO RESZEBEN VAN BENNE CSAK

MOVAPS		XMM1,[index]
ADDPS		XMM0,XMM1

CVTSI2SS	XMM1,ECX
SHUFPS		XMM1,XMM1,00H

MOVSS		XMM2,[hatnyolcvan]			; KOORDINATARENDSZER JELENLEGI KOZEPE(ENNYI PIXELT VONOK KI MINDEN PIXELBOL)
SHUFPS		XMM2,XMM2,00H

MOVSS		XMM3,[haromnegyvennyolc]	; KOORDINATARENDSZER JELENLEGI KOZEPE(Y)(ENNYIT VONOK KI MINDEN PIXELBOL)
SHUFPS		XMM3,XMM3,00H

MOVSS		XMM7,[zoom]					;FELOSZTAS
SHUFPS		XMM7,XMM7,00H

SUBPS		XMM0,XMM2					; X0 LEVETITVE KOORDINATARENDSZEREMBE
DIVPS		XMM0,XMM7

SUBPS		XMM1,XMM3					; Y0 LEVETITVE KOORDINATARENDSZEREMBE
DIVPS		XMM1,XMM7

MOVSS		XMM3,[minuszegy]			; SZOROZNI KELL MINUSZEGGYEL , MERT Y FORDITVA VAN
SHUFPS		XMM3,XMM3,00H

MULPS		XMM1,XMM3

MOVSS		XMM2,[nulla]				; X
SHUFPS		XMM2,XMM2,00H				

MOVAPS		XMM3,XMM2					; Y

MOVSS		XMM6,[negy]					; OSSZEHASONLITASHOZ
SHUFPS		XMM6,XMM6,00H

XORPS		XMM7,XMM7
MOVSS		XMM7,[nulla]
SHUFPS		XMM7,XMM7,00H				; ITERACIOKAT XMM7BEN SZAMOLOM

;//////////////// FOISM\\\\\\\\\\\\\\\\\\\\\

.ismetel:

MOVAPS		XMM4,XMM2					; XMM4 <- X
CMPLTPS		XMM4,XMM6
XOR			EAX,EAX
MOVMSKPS	EAX,XMM4					; OSSZEHASONLITASBOL AZ ELOJELBITEK EAX BE KERULNEK
TEST		EAX,EAX
JZ			.vege						; HA MIND > 4 , AKKOR VEGE

MOVAPS		XMM4,XMM2
CMPNEQPS	XMM4,XMM6					; HA MIND = 4 , AKKOR VEGE
XOR			EAX,EAX
MOVMSKPS	EAX,XMM4
TEST		EAX,EAX
JZ			.vege

MOVAPS		XMM4,XMM2
MULPS		XMM4,XMM2

;PUSH XMM4

MOVAPS 		[seged2],XMM4
CMPLTPS		XMM4,XMM6
XOR			EAX,EAX
MOVMSKPS	EAX,XMM4
TEST		EAX,EAX
JZ			.vege
MOVAPS		XMM4,[seged2]

CMPNEQPS	XMM4,XMM6
XOR			EAX,EAX
MOVMSKPS	EAX,XMM4
TEST		EAX,EAX
JZ			.vege

MOVAPS		XMM4,[seged2]

MOVAPS		XMM5,XMM3
CMPLTPS		XMM5,XMM6
XOR			EAX,EAX
MOVMSKPS	EAX,XMM5
TEST		EAX,EAX
JZ			.vege

MOVAPS		XMM5,XMM3
CMPNEQPS	XMM5,XMM6
XOR			EAX,EAX
MOVMSKPS	EAX,XMM5
TEST		EAX,EAX
JZ			.vege

MOVAPS		XMM5,XMM3
MULPS		XMM5,XMM3


MOVAPS 		[seged],XMM4

ADDPS		XMM4,XMM5
CMPLTPS		XMM4,XMM6

XOR			EAX,EAX
MOVMSKPS	EAX,XMM4
TEST		EAX,EAX
JZ			.vege

MOVAPS 		[seged2],XMM5
MOVSS		XMM5,[valtozo]
SHUFPS		XMM5,XMM5,00H
ANDPS		XMM4,XMM5
ADDPS		XMM7,XMM4

MOVAPS		XMM5,[seged2]
MOVAPS		XMM4,[seged]

CMPNEQPS	XMM4,XMM6
XOR			EAX,EAX
MOVMSKPS	EAX,XMM4

TEST		EAX,EAX
JZ			.vege

MOVAPS		XMM4,[seged]

MOV			EDX,DWORD[max_iteracio]
CMP			EBX,EDX
JGE			.vege

MOVAPS		XMM4,XMM2
MULPS		XMM4,XMM2

SUBPS		XMM4,XMM5
ADDPS		XMM4,XMM0

MOVSS		XMM5,[ketto]
SHUFPS		XMM5,XMM5,00H

MULPS		XMM5,XMM2
MULPS		XMM5,XMM3
ADDPS		XMM5,XMM1

MOVAPS		XMM3,XMM5
MOVAPS		XMM2,XMM4

INC			EBX
JMP			.ismetel

.vege:
POP			EDX
POP			ECX
POP			EBX
POP			EAX
RET

MandelbrotDouble:
PUSH	EAX
PUSH	EBX
PUSH	ECX
PUSH	EDX

XORPD 		XMM6,XMM6
MOVAPD		[iteraciokd],XMM6
mov			ebx,0
; EDX - ben van ax X
; ECX - ben van az Y

CVTSI2SD	XMM0,EDX					; fp - a teszem az edx -et
SHUFPD		XMM0,XMM0,00H				; 'broadcastolom' az edx - et az XMM0 - ba

MOVAPD		XMM1,[indexd]				; hozzaadom az indexeket
ADDPD		XMM0,XMM1
;XMM0 - ban van [EDX] - [EDX + 1]

CVTSI2SD	XMM1,ECX					; ECX - el is ezt teszem, csak nem novelem az indexeket, mert egy sorban van a 4 EDX pixel
SHUFPD		XMM1,XMM1,00H
;XMM1 - ben van 4x[ECX]

MOVSD		XMM2,[hatnyolcvand]			; XMM2 - ben a kozep X
SHUFPD		XMM2,XMM2,00H				; broadcast 

MOVSD		XMM3,[haromnegyvennyolcd]	; XMM3 - ban a kozep Y
SHUFPD		XMM3,XMM3,00H				; broadcast

MOVSD		XMM7,[zoomd]					; XMM7 - ben a ZOOM
SHUFPD		XMM7,XMM7,00H				; broadcast

SUBPD		XMM0,XMM2					; kivonom a kozepet(X)
DIVPD		XMM0,XMM7					; eloszotom a felosztassal
										; XMM1 - ben vannak a megfelelo X koordinatak

SUBPD		XMM1,XMM3					; ugyanigy jarok el az Y - al is
DIVPD		XMM1,XMM7					; XMM1 - ben az Y

MOVSD		XMM3,[minuszegyd]			; szorzom meg -1 el mivel a koordinata rendszerben
SHUFPD		XMM3,XMM3,00H				; a felso reszben negativak lesznek az ertekek

MULPD		XMM1,XMM3					; XMM1 - ben van 4x az Y koordinata

MOVSD		XMM2,[nullad]				; x0
SHUFPD		XMM2,XMM2,00H

MOVAPD		XMM3,XMM2					; y0

MOVSD		XMM6,[negyd]
SHUFPD		XMM6,XMM6,00H

XORPD		XMM7,XMM7
MOVSD		XMM7,[nullad]
SHUFPD		XMM7,XMM7,00H

;////////////FOISM.\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\

.ismetel:
MOVAPD		XMM4,XMM2					; XMM4 <- X
CMPLTPD		XMM4,XMM6					
XOR			EAX,EAX
MOVMSKPD 	EAX, XMM4					; maszkot atviszem EAX - be  -> elojelbitek

TEST		EAX,EAX
JZ			.vege	

MOVAPD		XMM4,XMM2
CMPNEQPD	XMM4,XMM6					; egyenloek - e 4 - el
XOR			EAX,EAX
MOVMSKPD	EAX,XMM4
TEST		EAX,EAX
JZ			.vege						
				
MOVAPD		XMM4,XMM2
MULPD		XMM4,XMM2
										; XMM4 <- X * X
MOVAPD		[seged2d],XMM4				; kimentem XMM4 - et
CMPLTPD		XMM4,XMM6					; megnezem , hogy X^2 kisseb - e , mint 4
XOR			EAX,EAX
MOVMSKPD	EAX,XMM4
movapD		xmm4,[seged2d]
TEST		EAX,EAX
JZ			.vege

CMPNEQPD	XMM4,XMM6					; megnezem , hogy X^2 egyenlo - e 4el
XOR			EAX,EAX
MOVMSKPD	EAX,XMM4
TEST		EAX,EAX
JZ			.vege
MOVAPD		XMM4,[seged2d]				; visszateszem XMM4 - et


MOVAPD		XMM5,XMM3					; XMM5 <- Y
CMPLTPD		XMM5,XMM6
XOR			EAX,EAX
MOVMSKPD	EAX,XMM5
TEST		EAX,EAX
JZ			.vege
MOVAPD		XMM5,XMM3
CMPNEQPD	XMM5,XMM6
XOR			EAX,EAX
MOVMSKPD	EAX,XMM5
TEST		EAX,EAX
JZ			.vege	

MOVAPD		XMM5,XMM3					; XMM5 <- Y*Y
MULPD		XMM5,XMM3

movapD		[segedd],xmm4
ADDPD		XMM4,XMM5
CMPLTPD		XMM4,XMM6				; XMM4 - ben van az utolso maszkom
									; maszkot eaxbe

MOVMSKPD	EAX,XMM4	
TEST		EAX,EAX
JZ			.vege		
						
MOVAPD		[seged2d],XMM5
MOVSD		XMM5,[valtozod]
SHUFPD		XMM5,XMM5,0h
ANDPD		XMM4,XMM5
ADDPD		XMM7,XMM4
MOVAPD		XMM5,[seged2d]
MOVAPD		XMM4,[segedd]
CMPNEQPD	XMM4,XMM6
XOR			EAX,EAX
MOVMSKPD	eax,XMM4
test		eax,eax
JZ			.vege
movapD		XMM4,[segedd]	

MOV			EDX,DWORD[max_iteracio]
CMP			EBX,EDX
JGE			.vege

MOVAPD		XMM4,XMM2				; XTEMP = X 
MULPD		XMM4,XMM2				; XTEMP = X * X

SUBPD		XMM4,XMM5				; XTEMP = X * X - Y * Y
ADDPD		XMM4,XMM0				; XTEMP = X * X - Y * Y + X0

MOVSD		XMM5,[kettod]			; Y = 2
SHUFPD		XMM5,XMM5,00H
MULPD		XMM5,XMM2				; Y = 2 * X
MULPD		XMM5,XMM3				; Y = 2 * X * Y
ADDPD		XMM5,XMM1				; Y = 2 * X * Y + Y0

MOVAPD		XMM3,XMM5				; 
MOVAPD		XMM2,XMM4				; X = XTEMP
	
inc			ebx
JMP			.ismetel

.vege:

POP			EDX
POP			ECX
POP			EBX
POP			EAX
RET

section .data
caption		db	"Mandelbrot Set",0
errormsg	db	"ERROR",0

egyegeszot	DD  1.5
nulla		DD	0.0
negy		DD	4.0
ketto		DD	2.0
minuszegy	DD	-1.0
hatnyolcvan	DD	680.0
haromnegyvennyolc	DD	348.0
zoom		DD	350.0
egy			DD	1.0
oldx		DD	0.0
oldy		DD	0.0
max_iteracio DD	216
valtozo			DD 	1
szaz			DD	100.0
singlevagydouble	DD	0

nullad		DQ	0.0
negyd		DQ	4.0
kettod		DQ	2.0
minuszegyd	DQ	-1.0
hatnyolcvand	DQ	680.0
haromnegyvennyolcd	DQ	348.0
zoomd		DQ	350.0
egyd			DQ	1.0
oldxd		DQ	0.0
oldyd		DQ	0.0
szazd			DQ	100.0
valtozod		DQ 1
egyegeszotd		DQ 1.5


green	DD 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 0 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 51 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 102 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 153 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 204 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 , 255 
blue	DD 0 , 0 , 0 , 0 , 0 , 0 , 51 , 51 , 51 , 51 , 51 , 51 , 102 , 102 , 102 , 102 , 102 , 102 , 153 , 153 , 153 , 153 , 153 , 153 , 204 , 204 , 204 , 204 , 204 , 204 , 255 , 255 , 255 , 255 , 255 , 255 , 0 , 0 , 0 , 0 , 0 , 0 , 51 , 51 , 51 , 51 , 51 , 51 , 102 , 102 , 102 , 102 , 102 , 102 , 153 , 153 , 153 , 153 , 153 , 153 , 204 , 204 , 204 , 204 , 204 , 204 , 255 , 255 , 255 , 255 , 255 , 255 , 0 , 0 , 0 , 0 , 0 , 0 , 51 , 51 , 51 , 51 , 51 , 51 , 102 , 102 , 102 , 102 , 102 , 102 , 153 , 153 , 153 , 153 , 153 , 153 , 204 , 204 , 204 , 204 , 204 , 204 , 255 , 255 , 255 , 255 , 255 , 255 , 0 , 0 , 0 , 0 , 0 , 0 , 51 , 51 , 51 , 51 , 51 , 51 , 102 , 102 , 102 , 102 , 102 , 102 , 153 , 153 , 153 , 153 , 153 , 153 , 204 , 204 , 204 , 204 , 204 , 204 , 255 , 255 , 255 , 255 , 255 , 255 , 0 , 0 , 0 , 0 , 0 , 0 , 51 , 51 , 51 , 51 , 51 , 51 , 102 , 102 , 102 , 102 , 102 , 102 , 153 , 153 , 153 , 153 , 153 , 153 , 204 , 204 , 204 , 204 , 204 , 204 , 255 , 255 , 255 , 255 , 255 , 255 , 0 , 0 , 0 , 0 , 0 , 0 , 51 , 51 , 51 , 51 , 51 , 51 , 102 , 102 , 102 , 102 , 102 , 102 , 153 , 153 , 153 , 153 , 153 , 153 , 204 , 204 , 204 , 204 , 204 , 204 , 255 , 255 , 255 , 255 , 255 , 255 
red		DD 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 , 0 , 51 , 102 , 153 , 204 , 255 

align 32
index		dd	0.0 , 1.0 , 2.0 , 3.0
iteraciok	dd 	0.0 , 0.0 , 0.0 , 0.0
egyketto	dd	1.0 , 1.0 , 1.0 , 1.0
seged		dd	0.0	, 0.0 , 0.0 , 0.0
seged2		dd  0.0 , 0.0 , 0.0 , 0.0


align 64
indexd		dq	0.0 , 1.0
segedd		dq 	0.0 , 0.0
seged2d		dq	0.0	, 0.0
iteraciokd	dq	0.0	, 0.0