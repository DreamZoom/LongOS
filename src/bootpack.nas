[FORMAT "WCOFF"]
[INSTRSET "i486p"]
[OPTIMIZE 1]
[OPTION 1]
[BITS 32]
	EXTERN	_io_hlt
[FILE "bootpack.c"]
[SECTION .text]
	GLOBAL	_HariMain
_HariMain:
	PUSH	EBP
	MOV	EDX,655360
	MOV	EBP,ESP
L6:
	MOV	AL,DL
	AND	EAX,15
	MOV	BYTE [EDX],AL
	INC	EDX
	CMP	EDX,720894
	JLE	L6
L7:
	CALL	_io_hlt
	JMP	L7