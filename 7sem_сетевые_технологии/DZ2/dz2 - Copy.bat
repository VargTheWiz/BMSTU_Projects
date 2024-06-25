:start
@echo off
setlocal enabledelayedexpansion
chcp 65001
echo Please input your code, 4 digits, binary
set /p input=
set /a inputcode=%input%
if %inputcode% equ 0 goto incorrect
if %inputcode% gtr 1111 goto incorrect
echo Your input code is %inputcode%

::тут начинаем преобразовывать в код хэмиинга
set /a c3=%input:~3,1%
set /a c5=%input:~2,1%
set /a c6=%input:~1,1%
set /a c7=%input:~0,1%
set /a c1="( (%c7% ^ %c5%) ^ %c3% )"
set /a c2="( (%c7% ^ %c6%) ^ %c3% )"
set /a c4="( (%c7% ^ %c6%) ^ %c5% )"

echo Кодовый вектор %c7% %c6% %c5% %c4% %c3% %c2% %c1%

::ввод ошибки
echo Please input your error code, 7 digits, binary
set /p err=

set /a e1=%err:~6,1%
set /a e2=%err:~5,1%
set /a e3=%err:~4,1%
set /a e4=%err:~3,1%
set /a e5=%err:~2,1%
set /a e6=%err:~1,1%
set /a e7=%err:~0,1%

echo Ошибка %e7% %e6% %e5% %e4% %e3% %e2% %e1%

::кодовый вектор в десятичное число для сравнения в цикле ошибки
set /a code = %c7%*64+%c6%*32+%c5%*16+%c4%*8+%c3%*4+%c2%*2+%c1%
echo Новый информационный вектор %code%
::тут будет цикл
set /a res = "%code% ^ 16"
echo Новый результат с ошибкой %res%

FOR /L %%G IN (0,1,127) DO set /a results[%%G]="%code% ^ %%G"
FOR /L %%G IN (0,1,127) DO >>out.txt echo !results[%%G]! 

::результат ошибки
set /a ce1="(%c1% ^ %e1%)" 
set /a ce2="(%c2% ^ %e2%)"
set /a ce3="(%c3% ^ %e3%)"
set /a ce4="(%c4% ^ %e4%)"
set /a ce5="(%c5% ^ %e5%)"
set /a ce6="(%c6% ^ %e6%)"
set /a ce7="(%c7% ^ %e7%)"

echo Результат с ошибкой %ce7% %ce6% %ce5% %ce4% %ce3% %ce2% %ce1%

pause
exit
:incorrect
echo Your input code is incorrect. Start again(Y/n)?
set /p yesno=
if %yesno%==Y goto start
exit