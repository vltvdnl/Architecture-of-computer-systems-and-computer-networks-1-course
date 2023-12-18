format PE console

entry start

include 'win32ax.inc'

section '.data' data readable writable
        fmtINT db '%d', 0
        fmtSTR db '%s', 0
        inputstr db 'Size of input file (10,100,250,500): ',0
        firstline db 'Number of objects in file: %d ',0
        strcrl db 10,13,'CIRCLE Radius: %d Coordinate of center: ( %d , %d ) Color:',0
        crla db ' Area: %d',0
        strrctgl db 10,13, 'Rectangle Coordinate of left corner: ( %d , %d ) Coordinate of right corner: ( %d , %d ) Color:',0
        rctgla db ' Area: %d',0
        strtrngl db 10,13,'Triangle Coordinate of first angle: ( %d , %d ) Coordinate of second angle: ( %d , %d ) Coordinate of third angle ( %d , %d ) Color:',0
        trngla db ' Area: %d',0
        ending db 'End of the programm',0
        fmtRCT db 10,13,'%d %d %d %d %d %d',0
        crlline db '%*d %d %d %d %d', 0
        rctglline db '%*d %d %d %d %d %d', 0
        rctgllinet db ' asdasd %d %d %d %d %d %d', 0
        trnglline db '%*d %d %d %d %d %d %d %d', 0
        file_nameT10 db 'Sort10FileASM.txt', 0
        rfile_nameT10 db 'FILE10C++.txt', 0
        file_nameT100 db 'Sort100FileASM.txt', 0
        rfile_nameT100 db 'FILE100C++.txt', 0
        file_nameT250 db 'Sort250FileASM.txt', 0
        rfile_nameT250 db 'FILE250C++.txt', 0
        file_nameT500 db 'Sort500FileASM.txt', 0
        rfile_nameT500 db 'FILE500C++.txt', 0     ;тестовая версия, надо будет порешать что то с размером файлов
        r db 'r',0
        w db 'w',0
        file_name dd ?
        rfile_name dd ?
        red db ' RED',0
        orange db ' ORANGE', 0
        yellow db ' YELLOW', 0
        green db ' GREEN', 0
        blue db ' BLUE', 0
        darkblue db ' DARKBLUE', 0
        violet db ' VIOLET', 0

        radius dd ?
        x1 dd ?
        y1 dd ?
        color dd ?
        x2 dd ?
        y2 dd ?
        x3 dd ?
        y3 dd ?
        k dd ?    ;used
        rff dd ?   ;used
        ff dd ?    ;used
        n dd ?     ;used
        lines dd 1000*8 dup(0);lines dd ?  ;used     легче сделать статикой
        line dd ?   ;used
        tmp dd ?    ; temp
        tmp1 dd ?
        tmp2 dd ?
        minarea dd ?
        minind dd ?
        nn dd ?
        pi dd 3.14
        startt dd ?
        endt dd ?

        otl db ' %d', 0

        CLM = 500
        ROWS = 9



section '.code' code readable executable
start:
;ввод размера файла
        cinvoke printf, inputstr
        cinvoke scanf, fmtINT, n
        cinvoke clock
        mov [startt], eax

      ; cinvoke sprintf, file_name, file_nameT, [nn]  ;что то сделать с восприниманием размера файла
      ; cinvoke sprintf, rfile_name, rfile_nameT, [nn]

        mov eax, [n]
        mov [nn], eax   ;количество элементов в файле

        mov eax, ROWS   ; итерирование по списку
        mov [n], eax

        ; открытие файлов
        cmp [nn], 10
        jz file10open
        cmp [nn], 100
        jz file100open
        cmp [nn], 250
        jz file250open
        cmp [nn], 500
        jz file500open

        file10open:
         cinvoke fopen,file_nameT10, w
          mov [ff], eax
          xor eax, eax
          cinvoke fopen, rfile_nameT10, r
          mov [rff], eax
          jmp prepare

        file100open:
         cinvoke fopen,file_nameT100, w
          mov [ff], eax
          xor eax, eax
          cinvoke fopen, rfile_nameT100, r
          mov [rff], eax
          jmp prepare

        file250open:
         cinvoke fopen,file_nameT250, w
          mov [ff], eax
          xor eax, eax
          cinvoke fopen, rfile_nameT250, r
          mov [rff], eax
          jmp prepare

        file500open:
          cinvoke fopen, rfile_nameT500, r
          mov [rff], eax
          cinvoke fopen, rfile_nameT500, r
          mov [rff], eax
          jmp prepare

        prepare:
        cinvoke fprintf, [ff], firstline, [nn]
        inc [nn]
        ;создание итератора по массиву площадей и линий
        mov esi, 1
        jmp readingfileloop

        ;цикл прохода по строкам файла rff
        readingfileloop:
                ; проверка цикла (пока не кончатся строки)
                mov [tmp], esi

                cinvoke fgets, line, 1000, [rff]
                test eax, eax
                jz entertoloop

                ; получение первого элемента строчки, который определяет тип объекта

                cinvoke sscanf,line,fmtINT, k

                ; проверка на то, является ли обект окружностью (k==0)
                mov eax, [k]
                cmp eax, 0
                jz circleloop

                ; если объект оказался не окружностью, проверяем на то, является ли прямоугольником
                cmp eax, 1
                jz rectangleloop

                ; если объект и не окружность и не прямоугольник, значит, объект треугольник
                jmp triangleloop

                circleloop:;чтение окружности
                        ;сканирование параметров окружности
                        cinvoke sscanf, line, crlline, radius, x1, y1, color

                        ; получение площади окружности
                        mov edx, [radius]
                        imul edx, [radius]
                        imul edx, 3

                        ; запись площади и данных об окружности в массив

                        mov eax, esi
                        imul eax, [n]                     ; запись площади
                        mov [lines + 4*(eax+8)], edx

                        mov edx, esi
                        imul edx, [n]
                        mov [lines+4*(edx)], 0
                        mov eax, [radius]
                        mov [lines+4*(edx+1)], eax
                        mov eax, [x1]                      ; запиьс остальны данных
                        mov [lines+4*(edx + 2)], eax
                        mov eax, [y1]
                        mov [lines+4*(edx + 3)], eax
                        mov eax, [color]
                        mov [lines+4*(edx + 4)], eax

                        ;инкрементирование регистра (итератора)
                        inc esi
                      ; cinvoke printf,fmtRCT, [lines+4*(edx)],[lines +4*(edx+1)],[lines +4*(edx+2)],[lines +4*(edx+3)],[lines +4*(edx+4) ],[lines +4*(edx+8)]
                        ; возвращение в цикл чтения строк
                        jmp readingfileloop


                rectangleloop: ;чтение прямоугольника
                        ; сканирование параметров прямоугольника
                        cinvoke sscanf, line, rctglline, x1,y1,x2,y2,color
                        ; получение площади прямоугольника
                        mov eax, [x2]
                        mov [x3], eax
                        mov eax, [x1]    ;x2-x1
                        sub [x3], eax

                        mov eax, [y2]
                        mov [y3], eax
                        mov eax, [y1]    ; по идее модуль произведения можно сделать чуть проще, замодулив именно само произведение но мне лень
                        sub [y3], eax   ;y2-y1  (СДЕЛАНО)

                        mov edx, [x3]      ; (x2-x1)*(y2-y1)
                        imul edx, [y3]
                        mov ebx, edx
                        neg edx
                        cmovl edx, ebx

                        ; запись данных о прямоугольнике в массив строчек и запись площади в массив площадей
                        mov eax, esi
                        imul eax, [n]                    ; запись площади
                        mov [lines+ 4*(eax+8)], edx

                        mov edx, esi
                        imul edx, [n]
                        mov [lines + 4*(edx)], 1
                        mov eax, [x1]
                        mov [lines +4*(edx+1)], eax
                        mov eax, [y1]
                        mov [lines + 4*(edx+2)], eax        ;запись данных о прямоугольнике
                        mov eax, [x2]
                        mov [lines +4*(edx+3)], eax
                        mov eax, [y2]
                        mov [lines +4*(edx+4)], eax
                        mov eax, [color]
                        mov [lines +4*(edx+5)], eax

                       ;инкрементирование регистра (итератора)
                       inc esi
                       ; возвращение в цикл чтения строк
                       jmp readingfileloop

                triangleloop:
                       ;получение данных о треугольнике
                       cinvoke sscanf, line, trnglline, x1,y1,x2,y2,x3,y3,color

                       ; нахождение его площади
                       mov eax, [x1]
                       imul eax, [y2]  ; x1*y2
                       mov [tmp], eax

                       mov eax, [x2]
                       imul eax, [y3]  ; x2*y3
                       mov [tmp1], eax

                       mov eax, [x3]
                       imul eax, [y1]   ;x3*y1
                       mov [tmp2], eax

                       mov eax, [tmp]
                       add eax, [tmp1]  ; x1*y2 + x2*y3+ x3*y1 - записть в radius (потому что свободная переменная)
                       add eax, [tmp2]
                       mov [radius], eax

                       mov eax, [x2]
                       imul eax, [y1] ; x2*y1
                       mov [tmp], eax

                       mov eax, [x3]
                       imul eax, [y2]  ; x3*y2
                       mov [tmp1], eax

                       mov eax, [x1]
                       imul eax, [y3]  ; x1*y3
                       mov [tmp2], eax

                       mov eax, [tmp]
                       add eax, [tmp1]  ; tmp+tmp1+tmp2 в eax
                       add eax, [tmp2]

                       mov edx, [radius]
                       sub edx, eax
                       mov ebx, edx
                       neg edx
                       cmovl edx, ebx     ;разница между radius и eax, потом деление на 2 с помощью битового сдвига вправо (sar)
                       sar edx, 1
                       mov [tmp], edx

                       mov eax, esi
                       imul eax, [n]
                       mov [lines + 4*(eax+8)], edx

                       ; запись данных о треугольнике в массив линий
                       mov edx, esi
                       imul edx, [n]
                       mov [lines + 4*(edx)], 2
                       mov eax, [x1]
                       mov [lines +4*(edx+1)], eax
                       mov eax, [y1]
                       mov [lines + 4*(edx+2)], eax
                       mov eax, [x2]
                       mov [lines +4*(edx+3)], eax
                       mov eax, [y2]
                       mov [lines +4*(edx+4)], eax
                       mov eax, [x3]
                       mov [lines +4*(edx+5)], eax
                       mov eax, [y3]
                       mov [lines +4*(edx+6)], eax
                       mov eax, [color]
                       mov [lines +4*(edx+7)], eax



                 ;инкрементирование счетчика
                 inc esi
                 ;возврат в цикл чтения файла
                 jmp readingfileloop



        entertoloop:
                 mov [minind], 1
                 mov edx, 1
                 imul edx, [n]
                 mov eax, [lines + 4*(edx+8)]    ;установка минимальной площади и минимального индекса за 1 (площадь за 1-й элемент)
                 mov [minarea], eax
                ; cinvoke printf, otl, [minarea]

                 mov esi, 1 ; итератор для внешнего цикла
                 jmp sortloop


        ; т.к сделать такой цикл, как и в C/C++ не выйдет (т.к. массивы работают немного не так), следовательно нужно изменить принцип
        ; посколько пузырек, можно сделать так, чтобы минимальный элемент всплывал, выовдился в файл, и потом удалялся, тем самым давая места стать минимальным элементам другим объектам
        sortloop:
                cmp esi, [nn]  ;условие внешнего цикла
                jz _ending
                mov ebx, 1 ;итератор внутреннего цикла
                jmp innerloop
                innerloop:
                        cmp ebx, [nn]     ;условие внутреннего цикла
                        jz sortloopcontinue

                        mov edx, ebx  ;j-й элемент массива
                        imul edx, [n]
                        mov eax, [lines +4*(edx+8)]
                        mov [tmp], eax

                        mov eax, [minarea]
                        sub eax, [tmp]  ;сравнение с минимальным площадью, если площад меньше, то в reindex   ??????
                        jge reindex
                        inc ebx
                        jmp innerloop
                        reindex:
                           mov eax, ebx
                           mov [minind], eax  ; перезапись индекса минимальной площади и перезапись самой минимальной площади
                           mov eax, [tmp]
                           mov [minarea], eax
                           inc ebx
                           jmp innerloop
                sortloopcontinue:
                        mov eax, [minind]
                       imul eax, [n]
                        mov edx, [lines + 4*(eax)]  ; "всплывший" минимальный элемент массива, который выводится в файл (т.к по возрастанию)
                        mov [k], edx

                        cmp [k], 0
                        jz circlewriting   ;запись в файл круга с его характеристиками

                        cmp [k], 1
                        jz rectanglewriting ; запись в файл прямоугольника с его характеристиками

                        cmp [k], 2
                        jz trianglewriting ; запись в файл прямоугольника с его характеристиками

                        circlewriting:
                               cmp [lines + 4*(eax+4)], 0
                               jz redCrc
                               cmp [lines + 4*(eax+4)], 1
                               jz ornCrc
                               cmp [lines + 4*(eax+4)], 2       ;switch на цвета + запись в файл
                               jz yelCrc
                               cmp [lines + 4*(eax+4)], 3
                               jz greenCrc
                               cmp [lines + 4*(eax+4)], 4
                               jz blueCrc
                               cmp [lines + 4*(eax+4)], 5
                               jz dblueCrc
                               cmp [lines + 4*(eax+4)], 6
                               jz vioCrc

                               redCrc:
                                cinvoke fprintf,[ff], strcrl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)];,[lines + 4*(eax+8)]
                               cinvoke fprintf, [ff], red
                                mov eax, [minind]
                                imul eax, [n]
                               cinvoke fprintf, [ff], crla, [lines + 4*(eax+8)]

                                jmp sortloopending

                               ornCrc:
                                cinvoke fprintf,[ff], strcrl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)];,[lines + 4*(eax+8)]
                               cinvoke fprintf, [ff], orange
                               mov eax, [minind]
                       imul eax, [n]
                               cinvoke fprintf, [ff], crla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               yelCrc:
                                 cinvoke fprintf,[ff], strcrl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)];,[lines + 4*(eax+8)]
                               cinvoke fprintf, [ff], yellow
                               mov eax, [minind]
                       imul eax, [n]
                               cinvoke fprintf, [ff], crla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               greenCrc:
                                 cinvoke fprintf,[ff], strcrl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)];,[lines + 4*(eax+8)]
                               cinvoke fprintf, [ff], green
                               mov eax, [minind]
                       imul eax, [n]
                               cinvoke fprintf, [ff], crla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               blueCrc:
                                 cinvoke fprintf,[ff], strcrl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)];,[lines + 4*(eax+8)]
                               cinvoke fprintf, [ff], blue
                               mov eax, [minind]
                       imul eax, [n]
                               cinvoke fprintf, [ff], crla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               dblueCrc:
                                cinvoke fprintf,[ff], strcrl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)];,[lines + 4*(eax+8)]
                               cinvoke fprintf, [ff], darkblue
                               mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], crla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               vioCrc:
                                cinvoke fprintf,[ff], strcrl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)];, [lines + 4*(eax+8)]
                               cinvoke fprintf, [ff], violet
                               mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], crla, [lines + 4*(eax+8)]
                                jmp sortloopending

                        rectanglewriting:

                               cmp [lines + 4*(eax+5)], 0
                               jz redRec
                               cmp [lines + 4*(eax+5)], 1
                               jz ornRec
                               cmp [lines + 4*(eax+5)], 2       ;switch на цвета + запись в файл
                               jz yelRec
                               cmp [lines + 4*(eax+5)], 3
                               jz greenRec
                               cmp [lines + 4*(eax+5)], 4
                               jz blueRec
                               cmp [lines + 4*(eax+5)], 5
                               jz dblueRec
                               cmp [lines + 4*(eax+5)], 6
                               jz vioRec

                               redRec:
                                cinvoke fprintf,[ff], strrctgl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)]
                                cinvoke fprintf, [ff], red
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], rctgla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               ornRec:
                               cinvoke fprintf,[ff], strrctgl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)]
                                cinvoke fprintf, [ff], orange
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], rctgla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               yelRec:
                                cinvoke fprintf,[ff], strrctgl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)]
                                cinvoke fprintf, [ff], yellow
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], rctgla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               greenRec:
                                cinvoke fprintf,[ff], strrctgl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)]
                                cinvoke fprintf, [ff], green
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], rctgla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               blueRec:
                                cinvoke fprintf,[ff], strrctgl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)]
                                cinvoke fprintf, [ff], blue
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], rctgla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               dblueRec:
                                cinvoke fprintf,[ff], strrctgl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)]
                                cinvoke fprintf, [ff], darkblue
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], rctgla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               vioRec:
                               cinvoke fprintf,[ff], strrctgl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)]
                                cinvoke fprintf, [ff], violet
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], rctgla, [lines + 4*(eax+8)]
                                jmp sortloopending

                        trianglewriting:

                               cmp [lines + 4*(eax+7)], 0
                               jz redTrn
                               cmp [lines + 4*(eax+7)], 1
                               jz ornTrn
                               cmp [lines + 4*(eax+7)], 2       ;switch на цвета + запись в файл
                               jz yelTrn
                               cmp [lines + 4*(eax+7)], 3
                               jz yelTrn
                               cmp [lines + 4*(eax+7)], 4
                               jz blueTrn
                               cmp [lines + 4*(eax+7)], 5
                               jz dblueTrn
                               cmp [lines + 4*(eax+7)], 6
                               jz vioTrn

                               redTrn:
                                cinvoke fprintf, [ff], strtrngl, [lines + 4*(eax+1)], [lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+6)]
                                cinvoke fprintf, [ff], red
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], trngla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               ornTrn:
                                cinvoke fprintf, [ff], strtrngl, [lines + 4*(eax+1)], [lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+6)]
                                cinvoke fprintf, [ff], orange
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], trngla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               yelTrn:
                                cinvoke fprintf, [ff], strtrngl, [lines + 4*(eax+1)], [lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+6)]
                                cinvoke fprintf, [ff], yellow
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], trngla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               greenTrn:
                               cinvoke fprintf, [ff], strtrngl, [lines + 4*(eax+1)], [lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+6)]
                                cinvoke fprintf, [ff], green
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], trngla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               blueTrn:
                                cinvoke fprintf, [ff], strtrngl, [lines + 4*(eax+1)], [lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+6)]
                                cinvoke fprintf, [ff], blue
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], trngla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               dblueTrn:
                                cinvoke fprintf, [ff], strtrngl, [lines + 4*(eax+1)], [lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+6)]
                                cinvoke fprintf, [ff], darkblue
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], trngla, [lines + 4*(eax+8)]
                                jmp sortloopending

                               vioTrn:
                                cinvoke fprintf, [ff], strtrngl, [lines + 4*(eax+1)], [lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+6)]
                                cinvoke fprintf, [ff], violet
                                mov eax, [minind]
                       imul eax, [n]
                                cinvoke fprintf, [ff], trngla, [lines + 4*(eax+8)]
                                jmp sortloopending




                sortloopending:
                        mov eax, [minind]
                        imul eax, [n]
                        mov [lines + 4*(eax+8)], 60000
                        mov edx, [lines + 4*(eax+8)]
                        mov [minarea], edx
                        inc esi
                        jmp sortloop

        _ending:
        cinvoke clock
        sub eax, [startt]
        mov [endt], eax
        cinvoke printf, fmtINT, [endt]
        cinvoke printf, ending
        cinvoke free, [lines]
        cinvoke fclose, [ff]
        cinvoke fclose, [rff]
        cinvoke getch
        cinvoke ExitProcess, 0



section '.idata' import data readable writable
        library kernel, 'kernel32.dll',\
                msvcrt, 'msvcrt.dll'

        import kernel,\
               ExitProcess, 'ExitProcess'

        import msvcrt,\
               printf, 'printf',\
               scanf, 'scanf',\
               sscanf, 'sscanf',\
               fopen, 'fopen',\
               malloc, 'malloc',\
               free, 'free',\
               getch, '_getch',\
               fgets, 'fgets',\
               sprintf, 'sprintf',\
               fprintf, 'fprintf',\
               fclose, 'fclose',\
               clock, 'clock',\
               CLOCKS_PER_SEC, 'CLOCKS_PER_SEC'


