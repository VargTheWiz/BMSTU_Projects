MYCODE SEGMENT 'CODE'
ASSUME CS:MYCODE, DS:MYCODE
LET1  DB '�'          
LET2  DB '�'
LET3  DB '�'
START:
; ����㧪� ᥣ���⭮�� ॣ���� ������ DS
     PUSH CS
     POP  DS         
     
; �뢮� ᨬ���� � �� �࠭
     MOV AH, 02
     MOV DL, LET1
     INT 21H      
; ��ॢ�� �� ����� ��ப� � ������ ���⪨               
     MOV AH, 02
     MOV DL, 13
     INT 21H
     MOV AH, 02
     MOV DL, 10
     INT 21H          
     
; �뢮� ᨬ���� � �� �࠭
     MOV AH, 02
     MOV DL, LET2
     INT 21H      
; ��ॢ�� �� ����� ��ப� � ������ ���⪨               
     MOV AH, 02
     MOV DL, 13
     INT 21H
     MOV AH, 02
     MOV DL, 10
     INT 21H             
     
 ; �뢮� ᨬ���� � �� �࠭
     MOV AH, 02
     MOV DL, LET3
     INT 21H      
; ��ॢ�� �� ����� ��ப� � ������ ���⪨               
     MOV AH, 02
     MOV DL, 13
     INT 21H
     MOV AH, 02
     MOV DL, 10
     INT 21H                 
     
; �������� �����襭�� �ணࠬ��
     MOV AH, 01H
     INT 021H
; ��室 �� �ணࠬ��
     MOV AL, 0
     MOV AH, 4CH
     INT 21H
     
MYCODE ENDS
END START
        
