	TITLE	Lab 4
;
;Damon Rocha Lab4.asm - array
;
	INCLUDE	Irvine32.inc
;

.data				;Define data
LIST		SDWORD	5	DUP(?)				;array 
inprompt	DB		"Enter your number: ", 0		;input prompt
promptl	DB		"Lowest number: ", 0		;lowest number prompt
prompth	DB		"Highest number: ", 0		;highest number prompt
promptfl	DB		"List forwards: ", 0		;forward list prompt
promptbl	DB		"List backwards: ", 0		;backward list prompt
prompts	DB		" ", 0					;space prompt
value	SDWORD	?						;value holder
lowval	SDWORD	?						;lowest value holder
highval	SDWORD    ?						;highest value holder

LOWEST	MACRO    LIST, lowval				;lowest macro
		MOV ESI, OFFSET LIST				;set SI to beginning of list
		MOV EDI, OFFSET LIST + 4				;set DI to 2nd element of list
		MOV ECX, 5						;move ecx to 5
		COMPARE:	
			MOV EAX, [EDI]					;move contents of [DI] into EAX	
			CMP [ESI], EAX					;compare 1st and 2nd values
			JLE SWITCH					;if 1st value is lower or equal to 2nd jump to switch
			JG  SWITCH2					;if 1st value is higher than 2nd jump to switch2
		COMPARE2:
			MOV EAX, lowval				;move lowval into EAX
			CMP [ESI], EAX					;compare eax to ESI
			JLE SWITCH					;if less or equal jump to switch
			JMP INCR						;jump to increase
		SWITCH:
			MOV EAX, [ESI]					;move contents of [ESI] into EAX
			MOV lowval, EAX				;move value si points to into value2
			JMP INCR						;jump to incr
		SWITCH2:
			MOV lowval, EAX				;move value DI points to into value2
			JMP INCR						;jump to incr
		INCR:
			ADD ESI, 4					;add 4 to SI
			ADD EDI, 4					;add 4 to DI
			DEC ECX						;sub 1 from ECX
			CMP ECX, 0					;compare ecx to 0
			JE ENDL						;if = jump to endl
			JMP COMPARE2					;if not jump back to compare2
		ENDL:
			ENDM							;end macro

HIGHEST	MACRO	LIST, highval				;highest macro
		MOV ESI, OFFSET LIST				;set si to point to list
		MOV EDI, OFFSET LIST + 4				;set di to point to second item in list
		MOV ECX, 5						;move ecx to 5
		COMPAREH:
			MOV EAX, [EDI]					;move contents of [DI] into EAX
			CMP [ESI], EAX					;compare value si points to, to value di points to
			JGE HSWITCH					;if greater or equal jump to switch
			JL  HSWITCH2					;if less than jump to switch2
		COMPAREH2:
			MOV EAX, highval				;move highval into eax
			CMP [ESI], EAX					;compare eax to esi
			JGE HSWITCH					;if greater or equal jump to HSWITCH
			JMP INCRH						;jump to INCRH
		HSWITCH:
			MOV EAX, [ESI]					;move value in [ESI] into EAX
			MOV highval, EAX				;move what si points to, to value2
			JMP INCRH						;jump to incrh
		HSWITCH2:
			MOV highval, EAX				;move what di points to, to value2
			JMP INCRH						;jump to incrh
		INCRH:
			ADD ESI, 4					;add 1 to ESI
			ADD EDI, 4					;add 1 to EDI
			DEC ECX						;sub 1 from ecx
			CMP ECX, 0					;compare ecx to 0
			JE ENDH						;if = jumpt to ENDH
			JMP COMPAREH2					;otherwise jump to compare2 
		ENDH:
			ENDM							;end macro

.code				;define code segment
main proc
CALL	WaitMsg			;press any key to continue
CALL Clrscr			;clears screen
MOV	ESI, OFFSET LIST	;have si point to beginning of LIST
MOV	ECX, 5			;move ecx to 5
INPUTNUM:
	CALL	Clrscr				;clear screen
	MOV	dh, 15				;row 15
	MOV	dl, 45				;col 45
	CALL	Gotoxy				;center cursor
	MOV	EDX, OFFSET inprompt	;move address of inprompt into edx
	CALL	WriteString			;write string out to screen
	CALL	ReadInt				;read int from keyboard
	MOV	value, EAX			;move eax into value
	JMP  SET					;if greater jump back to set
SET:
	MOV EAX, value				;move value into EAX
	MOV [ESI], EAX				;move value into list[si]
	ADD ESI, 4				;add 4 to si
	SUB ECX, 1				;sub 1 from ecx
	CMP ECX, 0				;compare ecx to zero
	JE  LOWESTNUM				;jump back to top of input
	JMP INPUTNUM				;jump to INPUTNUM
LOWESTNUM:
	CALL Clrscr				;clear screen
	MOV	  dh, 15				;row 15	
	MOV	  dl, 45				;col 45
	CALL	  Gotoxy				;center cursor
	MOV    EDX, OFFSET promptl	;move address of promptl into edx
	Call	  WriteString			;Write prompt to screen
	LOWEST LIST, lowval			;call LOWEST macro
	CMP	  lowval, 0			;compare lowval to 0
	JL	  NEGNUM1				;if less jump to negnum1
	MOV	  EAX, lowval			;move value into eax
	CALL	  WriteDec			;write lowest number to screen
	JMP	  HIGHESTNUM			;jump to high
HIGHESTNUM:
	MOV	   dh, 16				;row 15
	MOV	   dl, 45				;col 45
	CALL	   Gotoxy				;center cursor
	MOV     EDX, OFFSET prompth	;move address of prompth into edx 
	Call	   WriteString			;write prompt to screen
	HIGHEST LIST, highval		;call HIGHEST macro
	CMP	   highval, 0			;compare highval to 0
	JL	   NEGNUM2			;if less jump to negnum2
	MOV	   EAX, highval		;move value into eax
	CALL	   WriteDec			;write out value to screen
	MOV	   ECX, 5				;set ECX to 5
	MOV     dh, 17				;row 17
	MOV	   dl, 45				;col 45
	CALL	   Gotoxy				;center cursor
	MOV	   EDX, OFFSET promptfl	;set edx = to address of promptfl
	CALL	   WriteString		     ;write to screen
	MOV	   ESI, OFFSET LIST		;set ESI TO beginning of list
	JMP	   LOWHIPUT			;jump to exit program
LOWHIPUT:
	MOV	   EBX, [ESI]			;move contents of ESI into ebx
	CMP	   EBX, 0				;compare to zero
	JL	   NEGNUM3			; if less jump to NEGNUM3
	MOV	   EAX, [ESI]			;move what esi points to into eax
	CALL    WriteDec			;write it out
	MOV     EDX, OFFSET prompts	;set edx = to address of prompts
	CALL	   WriteString			;write to screen
	ADD	   ESI, 4				;add four to esi
	DEC     ECX				;sub one to ecx
	CMP     ECX, 0				;compare ecx to 0
	JG	   LOWHIPUT			;if less or equal to 5 jump to LOWHIPUT
	MOV	   ECX, 5				;move 5 into ecx
	MOV     dh, 18				;row 18
	MOV	   dl, 45				;col 45
	CALL	   Gotoxy				;center cursor
	MOV	   EDX, OFFSET promptbl	;set edx = to address of promptbl
	CALL	   WriteString			;write to screen
	MOV	   ESI, OFFSET LIST + 16	;set esi to last member of list
	JMP	   HILOWPUT			;jump to HILOWPUT
HILOWPUT:
	MOV	   EBX, [ESI]			;move esi into ebx
	CMP	   EBX, 0				;compare ebx to zero
	JL	   NEGNUM4			;if less jump to NEGNUM4
	MOV	   EAX, [ESI]			;move contents of esi into eax
	CALL    WriteDec			;write to screen
	MOV     EDX, OFFSET prompts	;set edx = to prompts
	CALL	   WriteString			;write to screen
	SUB	   ESI, 4				;sub 4 from esi 
	DEC     ECX				;sub 1 to ecx
	CMP     ECX, 0				;compare ecx to 0
	JE	   EXITPROGRAM			;if greater jump to exit program
	JMP     HILOWPUT			;otherwise jump to HILOWPUT
NEGNUM1:
	MOV	  EAX, lowval			;move value into eax
	CALL	  WriteInt			;write lowest number to screen
	JMP	  HIGHESTNUM			;jump to highesnumber
NEGNUM2:
	MOV	   EAX, highval		;move value into eax
	CALL	   WriteInt			;write out value to screen
	MOV	   ECX, 5				;set ECX to 5
	MOV     dh, 17				;row 17
	MOV	   dl, 45				;col 45
	CALL	   Gotoxy				;center cursor
	MOV	   EDX, OFFSET promptfl	;set edx = to address of promptfl
	CALL	   WriteString		     ;write to screen
	MOV	   ESI, OFFSET LIST		;set ESI TO beginning of list
	JMP	   LOWHIPUT			;jump to exit program
NEGNUM3:
	MOV	   EAX, [ESI]			;move esi into eax
	CALL    WriteInt			;write it out
	MOV     EDX, OFFSET prompts	;set edx = to address of prompts
	CALL	   WriteString			;write to screen
	ADD	   ESI, 4				;add four to esi
	DEC     ECX				;sub one to ecx
	CMP     ECX, 0				;compare ecx to 0
	JG	   LOWHIPUT			;if less or equal to 5 jump to LOWHIPUT
	MOV	   ECX, 5				;move 5 into ecx
	MOV     dh, 18				;row 18
	MOV	   dl, 45				;col 45
	CALL	   Gotoxy				;center cursor
	MOV	   EDX, OFFSET promptbl	;set edx = to address of promptbl
	CALL	   WriteString			;write to screen
	MOV	   ESI, OFFSET LIST + 16	;set esi to last member of list
	JMP	   HILOWPUT			;jump to HILOWPUT
NEGNUM4:
	MOV	   EAX, [ESI]			;move contents of esi into eax
	CALL    WriteInt			;write to screen
	MOV     EDX, OFFSET prompts	;set edx = to prompts
	CALL	   WriteString			;write to screen
	SUB	   ESI, 4				;sub 4 from esi 
	DEC     ECX				;sub 1 to ecx
	CMP     ECX, 0				;compare ecx to 0
	JE	   EXITPROGRAM			;if greater jump to exit program
	JMP     HILOWPUT			;otherwise jump to HILOWPUT

CALL	WaitMsg			;press any key to continue
CALL Clrscr			;clears screen	

nop							;dummy instruction
EXITPROGRAM:
	call Crlf				;print CR/LF
	call	WaitMsg			;allow use to see output
	exit					;exit execution
main endp
	end main				;end source code