; Рябкин Александр ИУ5Ц-61Б ЛР6

MYCODE segment 'CODE'
    assume cs:MYCODE, ds:data
	start:
	mov ax, data
	mov es, ax
	main:
	call clrscr;
	mov si, 80h
	mov cl, [si]
	sub cl, 1
	add si, 2
		cycle: 
		mov al, [si]
		cmp al, ' '
		je copy
		inc si
	loop cycle
	copy:
	mov si, 80h
	mov al, [si]
	sub al, cl
	mov cl, al
	sub cl, 1
	push cx
	push cx
	mov si, 80h
	mov cl, [si]
	sub cl, 1	
	mov si, 80h
	add si, 2
	lea di, buf
	rep movsb
	push ES
 pop DS
	mov dx, offset firstStr
	call putst
	lea di, buf
	lea si, surnameStr
	pop cx
	repe cmpsb
	jne neq
	je eq
	neq:
	mov dx, offset wrongFirstStr
	call putst
	call clrf 
	jmp second
	eq:
	mov dx, offset successFirstStr
	call putst
	mov dx, offset surnameStr
	call putst
	call clrf
	second:
	mov si, offset buf
	pop cx
	add si, cx
	add si, 1
	mov al, [si]
	cmp al, '1'
	je err
	jne succ
	succ:
	mov dx, offset successSecondStr
	call putst
	call clrf
	jmp exit
	err:
	mov dx, offset wrongSecondStr
	call putst
	call clrf
exit:
	call getch
	call clrscr;
	mov al, 0
	mov ah, 4ch
	int 021h
	putst proc
		mov ah, 09h
		int 021h
		ret
	putst endp
	putch proc
		mov ah, 02h
		int 021h
		ret
	putch endp
	clrf proc
		mov dl, 10
		call putch
		mov dl, 13
		call putch
		ret
	clrf endp 
	getch proc   
		mov ah, 08h
		int 021h
        ret
	getch endp
	clrscr proc   
		mov ah, 00h 
		mov al, 02
		int 10h
		ret
	clrscr endp

MYCODE ends
data segment
	buf db 20 dup ('1')
	surnameStr db 'Badanin$'
	firstStr db 'First argument $'
	successFirstStr db 'right = $'
	wrongFirstStr db 'wrong$'
	successSecondStr db 'First argument!$'
	wrongSecondStr db 'Second argument is missing!$'
data ends
end start
