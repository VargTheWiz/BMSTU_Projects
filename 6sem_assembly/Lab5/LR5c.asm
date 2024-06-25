;Рябкин Александр ИУ5Ц-61Б ЛР5
MYCODE segment 'CODE'
    assume cs:MYCODE, ds:data

start:
	mov ax, data
	mov ds, ax
	mov bx, offset HEX_STRING
	buf db 20 dup (' ')
	call clrscr;
	mov cx, 10
	main:
		mov dx, offset startStr
		call putst
		call clrf
		
		lea si, buf
		vvod:
		
		call getch
		mov [si], al
		cmp al, '$'
		je startvivod
		inc si
		jmp vvod 
		startvivod:
		mov dx, 32
		call putch
		mov dx, 205
		call putch
		mov dx, 32
		call putch
		push cx
		mov cx, si
		lea si, buf
		sub cx, si
		vivod:
		mov al, [si]
		inc si
		mov dl, al
		call hex
		mov dx, 32
		call putch
		loop vivod
		pop cx
		call clrf
		mov dx, offset continueStr
		call putst
		call getch
		cmp al, 'q'
		je exit 
		call clrf
	loop main
	
exit:
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
		mov ah, 01h
		int 021h
        ret
	getch endp
	clrscr proc   
		mov ah, 00h 
		mov al, 02
		int 10h
		ret
	clrscr endp
	
	hex proc
	push ax
	shr al, 4
	xlat 
	mov dl, al
	call putch
	pop ax
	and al, 00001111b
	xlat 
	mov dl, al
	call putch
	mov dx, 104
    call putch
    ret
	hex endp
	
MYCODE ends
data segment
HEX_STRING db '0123456789abcdef'
startStr db 'Enter converting string$'
continueStr db 'For program stop enter "q": $'
data ends
end start
