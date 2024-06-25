@echo off
REM от кракозябр
chcp 65001
echo второй аргумент был = n

set arg1=%1
set arg2=%2
set fname="test.txt"
SHIFT /1

:menu
REM если второй аргумент = n то экран не будет очищаться
IF (%arg2%)==(n) goto noclear
cls

:noclear
echo 1. Справка
echo 2. CLS
echo 3. MKDIR
echo 4. TYPE
echo 5. EXIT
choice /n /c:12345 /m "Выбери номер пункта меню"
IF %ERRORLEVEL% ==1 goto 1
IF %ERRORLEVEL% ==2 goto 2
IF %ERRORLEVEL% ==3 goto 3
IF %ERRORLEVEL% ==4 goto 4
IF %ERRORLEVEL% ==5 goto 5

:1
echo Первое - справка
CALL MY_help.bat %arg1% %arg2%
pause
goto menu

:2
echo Второе - CLS
CLS
goto menu 

:3
echo Третье - MKDIR
REM создает директорию
MKDIR TestMD
pause
goto menu

:4
echo Четвертое - TYPE
REM копирует солержание файла в переменной fname в файл typee
REM typee потому что type - у меня выделяется как код
type %fname% > typee.txt
pause
goto menu

:5
echo Пятое - EXIT
REM если первый аргумент = y то при выходе вызовет MY_help
IF (%arg1%)==(y) CALL MY_help.bat 
pause
exit /B

