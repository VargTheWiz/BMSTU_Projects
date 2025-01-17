;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
;  �����������, ������������ � ������� @ - �����, ��� ��� ������� �� ��������
;
;  �����:
;  ���� ��. �.�. �������, ��5�-61�, 2021 �.
;  ������ �.�.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

code segment	'code'
	assume	CS:code, DS:code
	org	100h
	_start:
	
	jmp _initTSR ; �� ������ ���������
	
	; ������
	ignoredChars 					DB	'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'	;@ ������ ������������ ��������
    replaceWith                     DB  '����������������������������������������������������'
	ignoredLength 				equ	$-ignoredChars				; ����� ������ ignoredChars
	ignoreEnabled 				DB	0							; ���� ������� ������������� �����
	translateFrom 				DB	'HCNEA'						;@ ������� ��� ������ (����� �� ����. ���������)
	translateTo 					DB	'�����'						;@ ������� �� ������� ����� ���� ������
	translateLength				equ	$-translateTo					; ����� ������ trasnlateFrom
	translateEnabled				DB	0							; ���� ������� ��������
	
	signaturePrintingEnabled 		DB	0							; ���� ������� ������ ���������� �� ������
	cursiveEnabled 				DB	0							; ���� �������� ������� � ������

	cursiveSymbol 				DB 00000000b						;@ ������, ������������ �� �������� (��� ��������� �������)
								DB 00000000b
								DB 00000000b
								DB 00111110b
								DB 01000001b
								DB 01000000b
								DB 01000000b
								DB 01000000b
								DB 01000000b
								DB 01000000b
								DB 01000000b
								DB 01000000b
								DB 00000000b
								DB 00000000b
								DB 00000000b
								DB 00000000b
	
	charToCursiveIndex 			DB '�'							;@ ������ ��� ������
	savedSymbol 					DB 16 dup(0FFh)					; ���������� ��� �������� ������� �������
	
	true 						equ	0FFh							; ��������� ����������
	old_int9hOffset 				DW	?							; ����� ������� ����������� int 9h
	old_int9hSegment 				DW	?							; ������� ������� ����������� int 9h
	old_int1ChOffset 				DW	?							; ����� ������� ����������� int 1Ch
	old_int1ChSegment 			DW	?							; ������� ������� ����������� int 1Ch
	old_int2FhOffset 				DW	?							; ����� ������� ����������� int 2Fh
	old_int2FhSegment 			DW	?							; ������� ������� ����������� int 2Fh
	
	unloadTSR					DB	0 							; 1 - ��������� ��������
	notLoadTSR					DB	0							; 1 - �� ���������
	counter	  					DW	0
	printDelay					equ	3 							;@ �������� ����� ������� "�������" � ��������
	printPos						DW	0 							;@ ��������� ������� �� ������. 0 - ����, 1 - �����, 2 - ���
	
	;@ �������� �� ����������� ������. ������������ ������� ���� �� ������ ������� ����� (1� ������).
	signatureLine1				DB	179, '            ������ ���������           ', 179
	Line1_length 					equ	$-signatureLine1
	signatureLine2				DB	179, '                 ��5�-61�                ', 179
	Line2_length 					equ	$-signatureLine2
	signatureLine3				DB	179, '               �������: 3              ', 179
	Line3_length 					equ	$-signatureLine3
	helpMsg DB '>kr.com [/?] [/u]', 10, 13
			DB ' [/?] - ����� ������ �������', 10, 13
			DB ' [/u] - �������� ��������� �� ������', 10, 13
			DB '  F4  - ����� ��� � ������ �� ������� � ������ ������', 10, 13
			DB '  F5  - ��������� � ���������� ���������� ������ �������� ������� �', 10, 13
			DB '  F6  - ��������� � ���������� ��������� ����������� ����������(HCNEA -> �����)', 10, 13
			DB '  F7  - ��������� � ���������� ������ ������ ��������� �������� �� �������', 10, 13
			
	helpMsg_length				equ  $-helpMsg
	errorParamMsg					DB	'������ ���������� ���������� ������', 10, 13
	errorParamMsg_length			equ	$-errorParamMsg
	
	tableTop						DB	218, Line1_length-2 dup (196), 191
	tableTop_length 				equ	$-tableTop
	tableBottom					DB	192, Line1_length-2 dup (196), 217
	tableBottom_length 			equ  $-tableBottom
	
	; ���������		
	installedMsg					DB  '�������� ��������!$'
	alreadyInstalledMsg			DB  '�������� ��� ��������$'
	noMemMsg						DB  '������������ ������$'
	notInstalledMsg				DB  '�� ������� ��������� ��������$'
	
	removedMsg					DB  '�������� ��������'
	removedMsg_length				equ	$-removedMsg
	
	noRemoveMsg					DB  '�� ������� ��������� ��������'
	noRemoveMsg_length			equ	$-noRemoveMsg
	
	F3_txt						DB	'F4'
	F4_txt						DB	'F5'
	F5_txt						DB	'F6'
	F6_txt						DB	'F7'
	fx_length					equ	$-F6_txt
	
	changeFx proc
		push AX
		push BX
		push CX
		push DX
		push BP
		push ES
		xor BX, BX
		
		mov AH, 03h
		int 10h
		push DX
		
		push CS
		pop ES
		
	_checkF3:
		lea BP, F3_txt
		mov CX, fx_length
		mov BH, 0
		mov DH, 0
		mov DL, 78
		mov AX, 1301h
		
		cmp signaturePrintingEnabled, true
		je _greenF3
		
		_redF3:
			mov BL, 01001111b ; red
			int 10h
			jmp _checkF4
		
		_greenF3:
			lea BP, F3_txt
			mov BL, 00101111b ; green
			int 10h
			
	_checkF4:
		lea BP, F4_txt
		mov CX, fx_length
		mov BH, 0
		mov DH, 1
		mov DL, 78
		mov AX, 1301h
		
		cmp cursiveEnabled, true
		je _greenF4
		
		_redF4:
			mov BL, 01001111b ; red
			int 10h
			jmp _checkF5
		
		_greenF4:
			mov BL, 00101111b ; green
			int 10h
		
	_checkF5:
		lea BP, F5_txt
		mov CX, fx_length
		mov BH, 0
		mov DH, 2
		mov DL, 78
		mov AX, 1301h
		
		cmp translateEnabled, true
		je _greenF5
		
		_redF5:
			mov BL, 01001111b ; red
			int 10h
			jmp _checkF6
		
		_greenF5:
			mov BL, 00101111b ; green
			int 10h
			
	_checkF6:
		lea BP, F6_txt
		mov CX, fx_length
		mov BH, 0
		mov DH, 3
		mov DL, 78
		mov AX, 1301h
		
		cmp ignoreEnabled, true
		je _greenF6
		
		_redF6:
			mov BL, 01001111b ; red
			int 10h
			jmp _outFx
		
		_greenF6:
			mov BL, 00101111b ; green
			int 10h
			
	_outFx:
		pop DX
		mov AH, 02h
		int 10h
		
		pop ES
		pop BP
		pop DX
		pop CX
		pop BX
		pop AX
		ret
	changeFx endp
	
    ;����� ����������
    new_int9h proc far
		; ��������� �������� ����, ���������� ��������� � �����
		push SI
		push AX
		push BX
		push CX
		push DX
		push ES
		push DS
		; �������������� CS � DS
		push CS
		pop	DS

		mov	AX, 40h ; 40h-�������,��� �������� ����� ����-� ����������, �����. ����� ����� 
		mov	ES, AX
		in	AL, 60h	; ���������� � AL ����-��� ������� �������
		
		
		;�������� F4-F7
		_test_Fx:
		sub AL, 58 ; � AL ������ ����� �������������� �������
		_F3:
			cmp AL, 4 ; F4
			jne _F4
			not signaturePrintingEnabled
			call changeFx
			jmp _translate_or_ignore
		_F4:
			cmp AL, 5 ; F5
			jne _F5
			not cursiveEnabled
			call changeFx
			call setCursive ; ������� ������� � ������ � ������� � ����������� �� ����� cursiveEnabled
			jmp _translate_or_ignore
		_F5:
			cmp AL, 6 ; F6
			jne _F6
			not translateEnabled
			call changeFx
			jmp _translate_or_ignore
		_F6:
			cmp AL, 7 ; F7
			jne _translate_or_ignore
			not ignoreEnabled
			call changeFx
			jmp _translate_or_ignore
				
		;������������� � �������
		_translate_or_ignore:
		
		pushf
		call dword ptr CS:[old_int9hOffset] ; �������� ����������� ���������� ����������
		mov	AX, 40h 	; 40h-�������,��� �������� ����� ����-� �����,�����. ����� ����� 
		mov	ES, AX
		mov	BX, ES:[1Ch]	; ����� ������
		dec	BX	; ��������� ����� � ����������
		dec	BX	; ��������� �������
		cmp	BX, 1Eh	; �� ����� �� �� �� ������� ������?
		jae	_go
		mov	BX, 3Ch	; ����� ����� �� ������� ������, ������ ��������� �������� ������
				    ; ���������	� ����� ������

	_go:		
		mov DX, ES:[BX] ; � DX 0 �������� ������
		;������� �� ����� ���������� �����?
		cmp ignoreEnabled, true
		jne _check_translate
		
		; ��, �������
		mov SI, 0
		mov CX, ignoredLength ;���-�� ������������ ��������
		
		; ���������, ������������ �� ������� ������ � ������ ������������
	_check_ignored:
		cmp DL,ignoredChars[SI]
		je _block
		inc SI
	loop _check_ignored
		jmp _check_translate
		
	; ���������
	_block:
		mov ES:[BX], AX
        xor AX, AX
		mov AL, replaceWith[SI]
		mov ES:[BX], AX	; ������ �������
		jmp _quit
	
	_check_translate:
		; ������� �� ����� ��������?
		cmp translateEnabled, true
		jne _quit
		
		; ��, �������
		mov SI, 0
		mov CX, translateLength ; ���-�� �������� ��� ��������
		; ���������, ������������ �� ������� ������ � ������ ��� ��������
		_check_translate_loop:
			cmp DL, translateFrom[SI]
			je _translate
			inc SI
		loop _check_translate_loop
		jmp _quit
		
		; ���������
		_translate:		
			xor AX, AX
			mov AL, translateTo[SI]
			mov ES:[BX], AX	; ������ �������
			
	_quit:
		; ��������������� ��� ��������
		pop	DS
		pop	ES
		pop DX
		pop CX
		pop	BX
		pop	AX
		pop SI
		iret
new_int9h endp  

;=== ���������� ���������� int 1Ch ===;
;=== ���������� ������ 55 �� ===;
new_int1Ch proc far
	push AX
	push CS
	pop DS
	
	pushf
	call dword ptr CS:[old_int1ChOffset]
	
	cmp signaturePrintingEnabled, true ; ���� ������ ����������� ������� (� ������ ������ F3)
	jne _notToPrint		
	
		cmp counter, printDelay*1000/55 + 1 ; ���� ���-�� "������" ������������ %printDelay% ��������
		je _letsPrint
		
		jmp _dontPrint
		
		_letsPrint:
			not signaturePrintingEnabled
			mov counter, 0
			call printSignature
		
		_dontPrint:
			add counter, 1
		
	_notToPrint:
	
	pop AX
	
	iret
new_int1Ch endp

;=== ���������� ���������� int 2Fh ===;
;=== ������ ���:
;===  1) �������� ����� ����������� TSR � ������ (��� AH=0FFh, AL=0)
;===     ����� ��������� AH='i' � ������, ���� TSR ��� ��������
;===  2) �������� TSR �� ������ (��� AH=0FFh, AL=1)
;===     
new_int2Fh proc
	cmp	AH, 0FFh	;���� �������?
	jne	_2Fh_std	;��� - �� ������ ����������
	cmp	AL, 0	;���������� ��������, �������� �� �������� � ������?
	je	_already_installed
	cmp	AL, 1	;���������� �������� �� ������?
	je	_uninstall	
	jmp	_2Fh_std	;��� - �� ������ ����������
	
_2Fh_std:
	jmp	dword ptr CS:[old_int2FhOffset]	;����� ������� �����������
	
_already_installed:
		mov	AH, 'i'	;������ 'i', ���� �������� ��������	� ������
		iret
	
_uninstall:
	push	DS
	push	ES
	push	DX
	push	BX
	
	xor BX, BX
	
	; CS = ES, ��� ������� � ����������
	push CS
	pop ES
	
	mov	AX, 2509h
	mov DX, ES:old_int9hOffset         ; ���������� ������ ����������
    mov DS, ES:old_int9hSegment        ; �� �����
	int	21h
	
	mov	AX, 251Ch
	mov DX, ES:old_int1ChOffset         ; ���������� ������ ����������
    mov DS, ES:old_int1ChSegment        ; �� �����
	int	21h

	mov	AX, 252Fh
	mov DX, ES:old_int2FhOffset         ; ���������� ������ ����������
    mov DS, ES:old_int2FhSegment        ; �� �����
	int	21h

	mov	ES, CS:2Ch	; �������� � ES ����� ���������			
	mov	AH, 49h		; �������� �� ������ ���������
	int	21h
	jc _notRemove
	
	push	CS
	pop	ES	;� ES - ����� ����������� ���������
	mov	AH, 49h  ;�������� �� ������ ��������
	int	21h
	jc _notRemove
	jmp _unloaded
	
_notRemove: ; �� ������� ��������� ��������
    ; ����� ��������� � ��������� ��������
	mov AH, 03h					; �������� ������� �������
	int 10h
	lea BP, noRemoveMsg
	mov CX, noRemoveMsg_length
	mov BL, 0111b
	mov AX, 1301h
	int 10h
	jmp _2Fh_exit
	
_unloaded: ; �������� ������ �������
    ; ����� ��������� �� ������� ��������
	mov AH, 03h					; �������� ������� �������
	int 10h
	lea BP, removedMsg
	mov CX, removedMsg_length
	mov BL, 0111b
	mov AX, 1301h
	int 10h
	
_2Fh_exit:
	pop BX
	pop	DX
	pop	ES
	pop	DS
	iret
new_int2Fh endp

;=== ��������� ������ ������� (���, ������)
;=== ������������� ���������� ���������� � ������ ���������
;===
printSignature proc
	push AX
	push DX
	push CX
	push BX
	push ES
	push SP
	push BP
	push SI
	push DI

	xor AX, AX
	xor BX, BX
	xor DX, DX
	
	mov AH, 03h						;������ ������� ������� �������
	int 10h
	push DX							;�������� ���������� � ��������� ������� � ����
	
	cmp printPos, 0
	je _printTop
	
	cmp printPos, 1
	je _printCenter
	
	cmp printPos, 2
	je _printBottom
	
	;��� ����� ��������� �� ����...
	_printTop:
		mov DH, 0
		mov DL, 15
		jmp _actualPrint
	
	_printCenter:
		mov DH, 9
		mov DL, 15
		jmp _actualPrint
		
	_printBottom:
		mov DH, 19
		mov DL, 15
		jmp _actualPrint
		
	_actualPrint:	
		mov AH, 0Fh					;������ �������� �����������. � BH - ������� ��������
		int 10h

		push CS						
		pop ES						;��������� ES �� CS
		
		;����� '��������' �������
		push DX
		lea BP, tableTop				;�������� � BP ��������� �� ��������� ������
		mov CX, tableTop_length		;� CX - ����� ������
		mov BL, 0111b 				;���� ���������� ������ ref: http://en.wikipedia.org/wiki/BIOS_color_attributes
		mov AX, 1301h					;AH=13h - ����� �-��, AL=01h - ������ ������������ ��� ������ ������� �� �������� ������
		int 10h
		pop DX
		inc DH
		
		
		;����� ������ �����
		push DX
		lea BP, signatureLine1
		mov CX, Line1_length
		mov BL, 0111b
		mov AX, 1301h
		int 10h
		pop DX
		inc DH
		
		;����� ������ �����
		push DX
		lea BP, signatureLine2
		mov CX, Line2_length
		mov BL, 0111b
		mov AX, 1301h
		int 10h
		pop DX
		inc DH
		
		;����� ������� �����
		push DX
		lea BP, signatureLine3
		mov CX, Line3_length
		mov BL, 0111b
		mov AX, 1301h
		int 10h
		pop DX
		inc DH
		
		;����� '����' �������
		push DX
		lea BP, tableBottom
		mov CX, tableBottom_length
		mov BL, 0111b
		mov AX, 1301h
		int 10h
		pop DX
		inc DH
		
		xor BX, BX
		pop DX						;��������������� �� ����� ������� ��������� �������
		mov AH, 02h					;������ ��������� ������� �� ��������������
		int 10h
		call changeFx
		
	pop DI
	pop SI
	pop BP
	pop SP
	pop ES
	pop BX
	pop CX
	pop DX
	pop AX
	
	ret
printSignature endp

;=== �������, ������� � ����������� �� ����� cursiveEnabled ������ ���������� ������� � ������� �� ������� � �������
;=== ���� ����� ���������� � ��������� changeFont, � ����� ���������������� ������
setCursive proc
	push ES ; ��������� ��������
	push AX
	push CS
	pop ES

	cmp cursiveEnabled, true
	jne _restoreSymbol
	; ���� ���� ����� true, ��������� ������ ������� �� ��������� �������,
	; �������������� �������� ������ ������ � savedSymbol
	
	call saveFont
	mov CL, charToCursiveIndex
_shifTtable:
	; �� �������� � BP ������� ���� ��������. ����� ��������� �� ������ 0
	; ������� ����� ��������� ����� 16*X - ��� X - ��� �������
	add BP, 16
	loop _shiftTable
	
	; �p� savefont ��������� p�����p ES
	; ������y �p�������� ������ ����� ���������, ����� 
	; �������� ���y������ ������� � savedSymbol
	; swap(ES, DS) � ���������� ������� �������� DS
	push DS
	pop AX
	push ES
	pop DS
	push AX
	pop ES
	push AX

	mov SI, BP
	lea DI, savedSymbol
	; ���p����� � ��p�����y� savedSymbol
	; ������y �y����� �������
	mov CX, 16
	; movsb �� DS:SI � ES:DI
	rep movsb
	; �������� ������� ��������� ����p�����	
	pop DS ; �������������� DS

	; ������� ��������� ������� �� �yp���
	mov CX, 1
	mov DH, 0
	mov DL, charToCursiveIndex
	lea BP, cursiveSymbol
	call changeFont
	jmp _exitSetCursive
	
_restoreSymbol:	
	; ���� ���� ����� 0, ��������� ������ ���������� ������� �� ������ �������

	mov CX, 1
	mov DH, 0
	mov DL, charToCursiveIndex
	lea bp, savedSymbol
	call changeFont
	
_exitSetCursive:
	pop AX
	pop ES
	ret
setCursive endp	
	
;=== ������� ����� ���������� ������� (������/����������)
;===
changeFont proc
	push AX
	push BX
	mov AX, 1100h
	mov BX, 1000h
	int 10h
	pop AX
	pop BX
	ret
changeFont endp

;=== ������� ���������� ����������� ���������� �������
;===
 saveFont proc
	push AX
	push BX
	mov AX, 1130h
	mov BX, 0600h
	int 10h
	pop AX
	pop BX
	ret
saveFont endp


;=== ������ ���������� ���������� �������� ����� ��������� ===;
;===
_initTSR:                         	; ����� ���������
	mov AH, 03h
	int 10h
	push DX
	mov AH,00h					; ��������� ����������� (83h  �����  80x25  16/8  CGA,EGA  b800  Comp,RGB,Enhanced), ��� ������� ������
	mov AL,83h
	int 10h
	pop DX
	mov AH, 02h
	int 10h
	
	
    call commandParamsParser    
	mov AX,3509h                    ; �������� � ES:BX ������ 09
    int 21h                         ; ����������
	
	;@ === �������� ��������� �� ������ ===
	;@ ���� �� �������� ���������� ��������� �������� �� ���������� ������� ����������, 
	;@ ����� ���������������� ��������� 3 ������, � �����
	;@ ���������� ����� _finishTSR �-�� commandParamsParser, �� �� ���� �����!
	cmp unloadTSR, true
	je _removingOnParameter
	jmp _notRemovingNow

	_removingOnParameter:
		mov AH, 0FFh
		mov AL, 0
		int 2Fh
		cmp AH, 'i'  ; �������� ����, ��������� �� ��� ���������
		je _remove 
		mov AH, 09h				;@ ��� �������� ��������� �� ���������� ������� ���������������� ��� ������
		lea DX, notInstalledMsg	;@ ��� �������� ��������� �� ���������� ������� ���������������� ��� ������
		int 21h					;@ ��� �������� ��������� �� ���������� ������� ���������������� ��� ������
		int 20h					;@ ��� �������� ��������� �� ���������� ������� ���������������� ��� ������
	 
	_notRemovingNow:
	
	cmp notLoadTSR, true			; ���� ���� �������� �������
	je _exit_tmp						; ������ �������

	;@ ���� �� �������� ���������� ��������� �������� �� ���������� �������, �� ������������ 5 ����� ����
	;@ ���� ���������� ��������� �� ��������� ���������� ������, �� ��������� ��
	mov AH, 0FFh
	mov AL, 0
	int 2Fh
	cmp AH, 'i'  ; �������� ����, ��������� �� ��� ���������
	je _alreadyInstalled
    
	jmp _tmp
	
	_exit_tmp:
		jmp _exit
	
	_tmp:
	push ES
    mov AX, DS:[2Ch]                ; psp
    mov ES, AX
    mov AH, 49h                     ; ������ ������ ���� ��������
    int 21h                         ; ����������?
    pop ES
    jc _notMem                      ; �� ������� - �������
	
	;== int 09h ==;

	mov	word ptr CS:old_int9hOffset, BX
	mov	word ptr CS:old_int9hSegment, ES
    mov AX, 2509h                   ; ��������� ������ �� 09
    mov DX, offset new_int9h            ; ����������
    int 21h
	
	;== int 1Ch ==;
	mov AX,351Ch                    ; �������� � ES:BX ������ 1C
    int 21h                         ; ����������
	mov	word ptr CS:old_int1ChOffset, BX
	mov	word ptr CS:old_int1ChSegment, ES
	mov AX, 251Ch                   ; ��������� ������ �� 1C
	mov DX, offset new_int1Ch            ; ����������
	int 21h
	
	;== int 2Fh ==;
	mov AX,352Fh                    ; �������� � ES:BX ������ 1C
    int 21h                         ; ����������
	mov	word ptr CS:old_int2FhOffset, BX
	mov	word ptr CS:old_int2FhSegment, ES
	mov AX, 252Fh                   ; ��������� ������ �� 2F
	mov DX, offset new_int2Fh            ; ����������
	int 21h

	call changeFx
    mov DX, offset installedMsg         ; ������� ��� ��� ��
    mov AH, 9
    int 21h
    mov DX, offset _initTSR       ; �������� � ������ ����������
    int 27h                         ; � �������
    ; ����� �������� ���������  
_remove: ; �������� ��������� �� ������
	mov AH, 0FFh
	mov AL, 1
	int 2Fh
	jmp _exit
_alreadyInstalled:
	mov AH, 09h
	lea DX, alreadyInstalledMsg
	int 21h
	jmp _exit
_notMem:                            ; �� ������� ������, ����� �������� ����������
    mov DX, offset noMemMsg
    mov AH, 9
    int 21h
_exit:                               ; �����
    int 20h

;=== ��������� �������� ���������� ���. ������ ===;
;===
commandParamsParser proc
	push CS
	pop ES
	mov unloadTSR, 0
	mov notLoadTSR, 0
	
	mov SI, 80h   				;SI=�������� ��������� ������.
	lodsb        					;������� ���-�� ��������.
	or AL, AL     				;���� 0 �������� �������, 
	jz _exitHelp   				;�� ��� � �������. 

	_nextChar:
	
	inc SI       					;������ SI ��������� �� ������ ������ ������.
	
	cmp [SI], BYTE ptr 13
	je _exitHelp
	
	
		lodsw       				;�������� ��� �������
		cmp AX, '?/' 				;��� '/?' (������ ����������� � �������� ������, �.�. AL:AH ������ AH:AL)
		je _question
		cmp AX, 'u/'
		je _finishTSR
		
		;cmp AH, '/'
		;je _errorParam
		
		jmp _exitHelp
   
	_question:
		; ����� ������ ������
			mov AH,03
			int 10h	
			lea BP, helpMsg
			mov CX, helpMsg_length
			mov BL, 0111b
			mov AX, 1301h
			int 10h
		; ����� ������ ������ ������
		not notLoadTSR	        ;���� ����, ��� ���������� �� ��������� ��������
		jmp _nextChar
	
	;@ === �������� ��������� �� ������ ===
	;@ ���� �� �������� ���������� ��������� �������� �� ��������� '/u' ���������� ������, 
	;@ ����� ������������ ��������� ���, � ��������� ������� ���������� ���������������� 
	;@ ���� ���, ����� �������� �����! (�� ������� ����� ���������� � �� �����, �� ��������� ����������� �������������)
	_finishTSR:
		not unloadTSR		      ;���� ����, ��� ���������� �������� ��������
		jmp _nextChar

	jmp _exitHelp

	_errorParam:
		;����� ������
			mov AH,03
			int 10h	
			lea BP, CS:errorParamMsg
			mov CX, errorParamMsg_length
			mov BL, 0111b
			mov AX, 1301h
			int 10h
		;����� ������ ������
	_exitHelp:
	ret
commandParamsParser endp

code ends
end _start