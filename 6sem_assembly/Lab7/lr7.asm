;Рябкин Александр ИУ5Ц-61Б ЛР7

MYCODE segment 'CODE'
assume cs:MYCODE, ds:data
start:
	mov ax, data
	mov ds, ax
main:
	call clrscr;
	mov dl, offset startStr
	call putst
	call clrf
	mov cx, 0 
	mov bx, 0
	char_hand:
		call getch_no_echo
		cmp al, '*'
		je exit
		call hex_to_mach
	cmp cx, 4
	jne char_hand
	push bx
	mov dl, ' '
	call putch
	mov dl, '='
	call putch
	mov dl, ' '
	call putch
	mov dx, bx
	push dx
	mov al, dh
	call hex
	pop dx
	mov al, dl
	call hex
	mov dx, 'h'
	call putch
	mov dl, ' '
	call putch
	mov dl, '-'
	call putch
	mov dl, ' '
	call putch
	pop bx
	call mach_to_dec
	call clrf
	call getch_no_echo
jmp main
exit:
	call clrscr;
	mov dl, offset infStr
	call putst
	call clrf
	call getch_no_echo
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
getch_echo proc
	mov ah, 01h
	int 021h
ret
getch_echo endp
getch_no_echo proc   
	mov ah, 08h
	int 021h
    ret
getch_no_echo endp
clrscr proc   
	mov ah, 00h 
	mov al, 02
	int 10h
	ret
clrscr endp
hex proc
	mov bx, offset hexStr
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
	ret
hex endp
hex_to_mach proc
	mov dl, al
	check_num:
		cmp al,'0' 
		jb check_big_let    
		cmp al,'9'
		ja check_big_let   
		sub al,'0' 
		push ax
	jmp correct
	check_big_let: 
		cmp al,'A' 
		jb check_lit_let
		cmp al,'F'
		ja check_lit_let
		sub al,'A' 
		add al, 10  
		push ax
	jmp correct
	check_lit_let:
		cmp al,'a' 
		jb finish
		cmp al,'f'
		ja finish
		sub al,'a' 
		add al, 10 
		push ax
	jmp correct	
	correct: 
		call putch 
		pop ax 
		mov ah, 0    
		shl bx, 4
		add bx, ax	
	inc cx 
	finish: 
	ret
hex_to_mach endp
mach_to_dec proc 
	mov ax, bx        	
	mov si, 0
	cycle:
		mov dx, 0	
		mov bx, mas[si]
		div bx	
		push dx
		add ax,'0'		
		mov dl,al
		call putch
		pop ax
		inc si
		inc si
		cmp si, 10
	jb cycle	
ret
mach_to_dec	endp

MYCODE ends
data segment
	startStr db, 'Enter number (HHHH) :$'
	hexStr db '0123456789abcdef'
	mas dw 10000, 1000, 100, 10, 1
data ends
end start
