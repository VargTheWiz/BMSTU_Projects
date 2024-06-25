:start
@echo off
setlocal enabledelayedexpansion
chcp 65001
echo DZ2 Ryabkin Alexandre IU5C-71B
echo Please input your code, 4 digits, binary
set /p input=
REM set input=1110
set /a inputcode=%input%
if %inputcode% equ 0 goto incorrect
if %inputcode% gtr 1111 goto incorrect
echo Your input code is %inputcode%
echo Your input code is %input% >> out.txt

::тут начинаем преобразовывать в код хэмиинга
set /a c3=%input:~3,1%
set /a c5=%input:~2,1%
set /a c6=%input:~1,1%
set /a c7=%input:~0,1%
set /a c1="( (%c7% ^ %c5%) ^ %c3% )"
set /a c2="( (%c7% ^ %c6%) ^ %c3% )"
set /a c4="( (%c7% ^ %c6%) ^ %c5% )"

::кодовый вектор в десятичное число для сравнения в цикле ошибки
set /a code = %c7%*64+%c6%*32+%c5%*16+%c4%*8+%c3%*4+%c2%*2+%c1%

REM цикл заполнения массива кодами с ошибкой, тут все, от однократных до семикратной
FOR /L %%G IN (0,1,127) DO set /a results[%%G]="%code% ^ %%G"
echo Code vector is %c7% %c6% %c5% %c4% %c3% %c2% %c1% >> out.txt 

set /a A = 0
set /a B = 0
set /a C = 0
set /a D = 0
set /a E = 0
set /a F = 0
set /a H = 0

set /a n=128
set /a i=0
echo код_дек║ ошибка_дек ║ посл_ош_дек ║  ошибка_бин   ║ после_оши_бин ║ h1 ║ h2 ║ h3 ║ исправленное  ║ код_вых >> out.txt 
:cycleaa
REM переводим ошибку из десятичного из массиве в двоичное
set /a o7="!results[%i%]! / 64"
set /a o7h="!results[%i%]! %% 64"
set /a o6=%o7h% / 32
set /a o6h=%o7h% %% 32
set /a o5=%o6h% / 16
set /a o5h=%o6h% %% 16
set /a o4=%o5h% / 8
set /a o4h=%o5h% %% 8
set /a o3=%o4h% / 4
set /a o3h=%o4h% %% 4
set /a o2=%o3h% / 2
set /a o2h=%o3h% %% 2
set /a o1=%o2h% / 1

REM переводим ошибку из десятичного в двоичное 
set /a er7="%i% / 64"
set /a er7h="%i% %% 64"
set /a er6=%er7h% / 32
set /a er6h=%er7h% %% 32
set /a er5=%er6h% / 16
set /a er5h=%er6h% %% 16
set /a er4=%er5h% / 8
set /a er4h=%er5h% %% 8
set /a er3=%er4h% / 4
set /a er3h=%er4h% %% 4
set /a er2=%er3h% / 2
set /a er2h=%er3h% %% 2
set /a er1=%er2h% / 1
set "Value=00%i%"
set Value2=00!results[%i%]!

REM переменные для вывода исправленного кода
set /a i7=%o7%
set /a i6=%o6%
set /a i5=%o5%
set /a i4=%o4%
set /a i3=%o3%
set /a i2=%o2%
set /a i1=%o1%

REM считаем синдром ошибки
set /a h1 ="(%o1% ^ %o3% ^ %o5% ^ %o7%)" 
set /a h2 ="(%o2% ^ %o3% ^ %o6% ^ %o7%)" 
set /a h3 ="(%o4% ^ %o5% ^ %o6% ^ %o7%)"

REM переводим сиднром в разряд
set /a h123 =%h3% * 4 + %h2% * 2 + %h1%

REM исправляем результат с ошибкой при помощи х123 - это разряд ошибки
IF %h123% EQU 7 IF %i7% EQU 1 (set /a i7 =0) else (set /a i7 =1)
if %h123% EQU 6 IF %i6% EQU 1 (set /a i6 =0) else (set /a i6 =1)  
if %h123% EQU 5 IF %i5% EQU 1 (set /a i5 =0) else (set /a i5 =1)  
if %h123% EQU 4 IF %i4% EQU 1 (set /a i4 =0) else (set /a i4 =1)  
if %h123% EQU 3 IF %i3% EQU 1 (set /a i3 =0) else (set /a i3 =1)  
if %h123% EQU 2 IF %i2% EQU 1 (set /a i2 =0) else (set /a i2 =1)  
if %h123% EQU 1 IF %i1% EQU 1 (set /a i1 =0) else (set /a i1 =1)  

REM переводим получившееся в "исходный" для проверки правильности преобразования
set /a ic = %c7% * 8 + %c6% * 4 + %c5% * 2 + %c3%
set /a cc = %i7% * 8 + %i6% * 4 + %i5% * 2 + %i3%

REM считаем количество единичных битов в ошибке - кратность
set /a onecount = 0
if %er7% EQU 1 set /a onecount =%onecount% + 1
if %er6% EQU 1 set /a onecount =%onecount% + 1
if %er5% EQU 1 set /a onecount =%onecount% + 1
if %er4% EQU 1 set /a onecount =%onecount% + 1
if %er3% EQU 1 set /a onecount =%onecount% + 1
if %er2% EQU 1 set /a onecount =%onecount% + 1
if %er1% EQU 1 set /a onecount =%onecount% + 1

REM если кратность такая-то то выводим в такой-то файл
if %onecount% EQU 1 (
set resultscrat1[%%A] = %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3%
echo %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3% >> errres1.txt
set /a A =%A% + 1
)
if %onecount% EQU 2 (
set resultscrat2[%%B] = %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3%
echo %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3% >> errres2.txt
set /a B =%B% + 1
)
if %onecount% EQU 3 (
set resultscrat3[%%C] = %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3%
echo %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3% >> errres3.txt
set /a C =%C% + 1
)
if %onecount% EQU 4 (
set resultscrat4[%%D] = %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3%
echo %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3% >> errres4.txt
set /a D =%D% + 1
)
if %onecount% EQU 5 (
set resultscrat5[%%E] = %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3%
echo %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3% >> errres5.txt
set /a E =%E% + 1
)
if %onecount% EQU 6 (
set resultscrat6[%%F] = %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3%
echo %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3% >> errres6.txt
set /a F =%F% + 1
)
if %onecount% EQU 7 (
set resultscrat7[%%H] = %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3%
echo %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3% >> errres7.txt
set /a H =%H% + 1
)

REM вывод данных таблицы
if %cc% EQU %ic% ( echo   %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3% ║ CORRECT>> out.txt ) ELSE ( echo   %code%  ║    %Value:~-3%     ║     %Value2:~-3%     ║ %er7% %er6% %er5% %er4% %er3% %er2% %er1% ║ %o7% %o6% %o5% %o4% %o3% %o2% %o1% ║ %h3%  ║ %h2%  ║ %h1%  ║ %i7% %i6% %i5% %i4% %i3% %i2% %i1% ║ %i7% %i6% %i5% %i3% >> out.txt )

set /a i=i+1
if %i% lss %n% goto cycleaa

echo check out.txt near the bat file
pause
exit
:incorrect
echo Your input code is incorrect. Start again(Y/n)?
set /p yesno=
if %yesno%==Y goto start
exit
