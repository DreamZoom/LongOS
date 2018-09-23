; hello-os
; TAB=4
CYLS	EQU		10

		ORG		0x7c00			

		JMP		entry
		DB		0x90
		DB		"HELLOIPL"		
		DW		512				
		DB		1				
		DW		1				
		DB		2				
		DW		224				
		DW		2880			
		DB		0xf0			
		DW		9				
		DW		18				
		DW		2				
		DD		0			
		DD		2880			
		DB		0,0,0x29		
		DD		0xffffffff		
		DB		"HELLO-OS   "	
		DB		"FAT12   "		
		RESB	18				



entry:
		MOV		AX,0			
		MOV		SS,AX
		MOV		SP,0x7c00
		MOV		DS,AX
		MOV		ES,AX

load:
		MOV		AX,0x0820
		MOV		ES,AX
		MOV		CH,0
		MOV		DH,0
		MOV		CL,2
readloop:
		MOV		SI,0
retry:
		MOV		AH,0x02			; AH=0x02 : 僨傿僗僋撉傒崬傒
		MOV		AL,1			; 1僙僋僞
		MOV		BX,0
		MOV		DL,0x00			; A僪儔僀僽
		INT		0x13			; 僨傿僗僋BIOS屇傃弌偟
		JNC		next				; 僄儔乕偑偍偒側偗傟偽fin傊
		ADD		SI,1			; SI偵1傪懌偡
		CMP		SI,5			; SI偲5傪斾妑
		JAE		error			; SI >= 5 偩偭偨傜error傊
		MOV		AH,0x00
		MOV		DL,0x00			; A僪儔僀僽
		INT		0x13			; 僪儔僀僽偺儕僙僢僩
		JMP		retry
next:
		MOV		AX,ES			; 傾僪儗僗傪0x200恑傔傞
		ADD		AX,0x0020
		MOV		ES,AX			; ADD ES,0x020 偲偄偆柦椷偑側偄偺偱偙偆偟偰偄傞
		ADD		CL,1			; CL偵1傪懌偡
		CMP		CL,18			; CL偲18傪斾妑
		JBE		readloop		; CL <= 18 偩偭偨傜readloop
		
		MOV		CL,1
		ADD		DH,1
		CMP		DH,2
		JB		readloop		
		MOV		DH,0
		ADD		CH,1
		CMP		CH,CYLS
		JB		readloop	
			
		JMP		0xc200
error:
		MOV		SI,msg
putloop:
		MOV		AL,[SI]
		ADD		SI,1			
		CMP		AL,0
		JE		fin
		MOV		AH,0x0e			
		MOV		BX,15			
		INT		0x10			
		JMP		putloop

fin:
		HLT						
		JMP		fin
msg:
		DB		0x0a, 0x0a		
		DB		"error"
		DB		0x0a			
		DB		0

		RESB	0x7dfe-$		

		DB		0x55, 0xaa
