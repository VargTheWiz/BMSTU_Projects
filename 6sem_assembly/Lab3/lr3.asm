MYCODE SEGMENT 'CODE'
ASSUME CS:MYCODE, DS:MYCODE
LET1  DB 'A'          
LET2  DB '�'
LET3  DB '�'
START:
; �������� ����������� �������� ������ DS
     PUSH CS
     POP  DS         
     
; ����� ������� � �� �����
     MOV AH, 02
     MOV DL, LET1
     INT 21H      
; ������� �� ����� ������ � ������� �������               
     MOV AH, 02
     MOV DL, 13
     INT 21H
     MOV AH, 02
     MOV DL, 10
     INT 21H          
     
; ����� ������� � �� �����
     MOV AH, 02
     MOV DL, LET2
     INT 21H      
; ������� �� ����� ������ � ������� �������               
     MOV AH, 02
     MOV DL, 13
     INT 21H
     MOV AH, 02
     MOV DL, 10
     INT 21H             
     
 ; ����� ������� � �� �����
     MOV AH, 02
     MOV DL, LET3
     INT 21H      
; ������� �� ����� ������ � ������� �������               
     MOV AH, 02
     MOV DL, 13
     INT 21H
     MOV AH, 02
     MOV DL, 10
     INT 21H                 
     
; �������� ���������� ���������
     MOV AH, 01H
     INT 021H
; ����� �� ���������
     MOV AL, 0
     MOV AH, 4CH
     INT 21H
     
MYCODE ENDS
END START
        
