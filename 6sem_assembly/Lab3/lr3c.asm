MYCODE SEGMENT 'CODE'
ASSUME CS:MYCODE, DS:MYCODE
LET1  DB 'А'          
LET2  DB 'Б'
LET3  DB 'В'
START:
; Загрузка сегментного регистра данных DS
     PUSH CS
     POP  DS         
     
; Вывод символа А на экран
     MOV AH, 02
     MOV DL, LET1
     INT 21H      
; Перевод на новую строку и возврат каретки               
     MOV AH, 02
     MOV DL, 13
     INT 21H
     MOV AH, 02
     MOV DL, 10
     INT 21H          
     
; Вывод символа Б на экран
     MOV AH, 02
     MOV DL, LET2
     INT 21H      
; Перевод на новую строку и возврат каретки               
     MOV AH, 02
     MOV DL, 13
     INT 21H
     MOV AH, 02
     MOV DL, 10
     INT 21H             
     
 ; Вывод символа В на экран
     MOV AH, 02
     MOV DL, LET3
     INT 21H      
; Перевод на новую строку и возврат каретки               
     MOV AH, 02
     MOV DL, 13
     INT 21H
     MOV AH, 02
     MOV DL, 10
     INT 21H                 
     
; Ожидание завершения программы
     MOV AH, 01H
     INT 021H
; Выход из программы
     MOV AL, 0
     MOV AH, 4CH
     INT 21H
     
MYCODE ENDS
END START
        
