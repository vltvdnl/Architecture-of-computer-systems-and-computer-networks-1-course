format PE console

entry start

include 'win32ax.inc'

section '.data' data readable writable
        fmtINT db '%d', 0
        fmtSTR db '%s', 0
        otl1 db ' %d ',0
        otl db 10,13, '%d',0
        inputstr db 'Size of input file (10,100,250,500): ',0
        exp db 'gg',0
        strcrl db 10,13,'CIRCLE Radius: %d Coordinate of center: ( %d , %d ) Color: %d Area: %d', 0
        strrctgl db 10,13, 'Rectangle Coordinate of left corner: ( %d , %d ) Coordinate of right corner: ( %d , %d ) Color: %d Area: %d', 0
        strtrngl db 10,13,'Triangle Coordinate of first angle: ( %d , %d ) Coordinate of second angle: ( %d , %d ) Coordinate of third angle ( %d , %d ) Color %d Area: %d', 0
        pppp db 'asd %d asd %d asdasda %d asdasd %d sadasd %d asdasd %d', 0
        ending db 'asdasdasdasd',0
        fmtRCT db 10,13,'%d %d %d %d %d %d',0
        crlline db '%*d %d %d %d %d', 0
        rctglline db '%*d %d %d %d %d %d', 0
        rctgllinet db ' asdasd %d %d %d %d %d %d', 0
        trnglline db '%*d %d %d %d %d %d %d %d', 0
        file_nameT db 'Sort10File.txt', 0
        rfile_nameT db 'FILE10C++.txt', 0     ;�������� ������, ���� ����� �������� ��� �� � �������� ������
        r db 'r',0
        w db 'w',0

        file_name dd ?  ;used
        rfile_name dd ? ;used
        radius dd ? ;� ������ �����, �� �� � ����� (� ��� ��� � ����� �� ����)
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
        areas dd ?  ;used �������� �������� � ������������ ���� ������� �����
        lines dd ?  ;used
        line dd ?   ;used
        tmp dd ?    ; temp
        tmp1 dd ?
        tmp2 dd ?
        minarea dd ?
        minind dd ?


section '.code' code readable executable
start:
;���� ������� �����
        cinvoke printf, inputstr
        cinvoke scanf, fmtINT, n
        mov eax, [n]
        inc eax
        mov [n], eax

        ; �������� ������� �������
        mov eax, [n]
        mul eax
        lea eax, [eax*4]
        cinvoke malloc, eax
        mov [lines], eax

       ; cinvoke sprintf, file_name, file_nameT, [n]  ��� �� ������� � �������������� ������� �����
       ; cinvoke sprintf, rfile_name, rfile_nameT, [n]

        ; �������� ������
        cinvoke fopen,file_nameT, w
        mov [ff], eax
        xor eax, eax

        cinvoke fopen, rfile_nameT, r
        mov [rff], eax




        ;�������� ��������� �� ������� �������� � �����
        mov esi, 1
        ;jmp readingfileloop
        ;���� ������� �� ������� ����� rff
        readingfileloop:
                ; �������� ����� (���� �� �������� ������)
                ;cinvoke printf,fmtRCT, [lines+44],[lines + 48],[lines + 52],[lines + 56],[lines + 60],[lines + 76]
                cinvoke fgets, line, 1000, [rff]
                test eax, eax
                jz entertoloop             ; ��� ����� �������� ��, ��� �� ������ �� ������ �� ��� ������ � ��� ���������� ��������??????????????????

                ; ��������� ������� �������� �������, ������� ���������� ��� �������

                cinvoke sscanf,line,fmtINT, k

                ; �������� �� ��, �������� �� ����� ����������� (k==0)
                mov eax, [k]
                cmp eax, 0
                jz circleloop

                ; ���� ������ �������� �� �����������, ��������� �� ��, �������� �� ���������������
                cmp eax, 1
                jz rectangleloop

                ; ���� ������ � �� ���������� � �� �������������, ������, ������ �����������
                jmp triangleloop

                circleloop:;������ ����������
                        ;������������ ���������� ����������
                        cinvoke sscanf, line, crlline, radius, x1, y1, color
                       ; cinvoke printf,fmtRCT, [lines],[lines + 4],[lines + 8],[lines + 12],[lines + 16],[lines + 32]

                        ; ��������� ������� ����������
                        mov edx, [radius]
                        imul edx, [radius]
                        imul edx, 3

                        ; ������ ������� � ������ ��������
                        ;mov [areas+4*esi], edx
                        mov eax, esi
                        imul eax, [n]
                        mov [lines + 4*(eax+8)], edx
                        ;cinvoke printf, otl,[lines+ 4*(eax+8)] ; ������� ������������

                        ; ������ ������ � ���������� � ������ ������� (�����)
                        mov edx, esi  ;���� � edx �
                        imul edx, [n]
                        ; mov [tmp], edx
                       ; cinvoke printf, otl, [tmp]
                        mov [lines+4*(edx)], 0
                        mov eax, [radius]
                        mov [lines+4*(edx+1)], eax
                        mov eax, [x1]
                        mov [lines+4*(edx + 2)], eax
                        mov eax, [y1]
                        mov [lines+4*(edx + 3)], eax
                        mov eax, [color]
                        mov [lines+4*(edx + 4)], eax

                        ;����������������� �������� (���������)
                        inc esi
                       cinvoke printf,fmtRCT, [lines+4*(edx)],[lines +4*(edx+1)],[lines +4*(edx+2)],[lines +4*(edx+3)],[lines +4*(edx+4) ],[lines +4*(edx+8)]
                        ; ����������� � ���� ������ �����
                        jmp readingfileloop


                rectangleloop: ;������ ��������������
                        ; ������������ ���������� ��������������
                        cinvoke sscanf, line, rctglline, x1,y1,x2,y2,color
                        ; ��������� ������� ��������������
                        mov eax, [x2]
                        mov [x3], eax
                        mov eax, [x1]
                        sub [x3], eax

                        mov eax, [y2]
                        mov [y3], eax
                        mov eax, [y1]    ; �� ���� ������ ������������ ����� ������� ���� �����, ��������� ������ ���� ������������ �� ��� ����
                        sub [y3], eax   ;y2-y1

                        mov edx, [x3]      ; (x2-x1)*(y2-y1)
                        imul edx, [y3]
                        mov ebx, edx
                        neg edx
                        cmovl edx, ebx

                        ; ������ ������ � �������������� � ������ ������� � ������ ������� � ������ ��������
                        mov eax, esi
                        imul eax, [n]
                        mov [lines+ 4*(eax+8)], edx
                       ; cinvoke printf, otl,[lines+ 4*(eax)]    ; ������� ASDASDASDASDASD

                        mov edx, esi
                        imul edx, [n]
                       ;mov [tmp], edx
                        ;cinvoke printf, otl, [tmp]
                        mov [lines + 4*(edx)], 1
                        mov eax, [x1]
                        mov [lines +4*(edx+1)], eax
                        mov eax, [y1]
                        mov [lines + 4*(edx+2)], eax
                        mov eax, [x2]
                        mov [lines +4*(edx+3)], eax
                        mov eax, [y2]
                        mov [lines +4*(edx+4)], eax
                        mov eax, [color]
                        mov [lines +4*(edx+5)], eax
                       ; cinvoke printf, otl,[lines+ 4*(edx+2)]

                       ;����������������� �������� (���������)
                       inc esi
                       cinvoke printf,fmtRCT, [lines],[lines + 4],[lines + 8],[lines + 12],[lines + 16],[lines + 32]
                       ; ����������� � ���� ������ �����
                       jmp readingfileloop

                triangleloop:
                       ;��������� ������ � ������������
                       cinvoke sscanf, line, trnglline, x1,y1,x2,y2,x3,y3,color

                       ; ���������� ��� �������
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
                       add eax, [tmp1]  ; x1*y2 + x2*y3+ x3*y1 - ������� � radius (������ ��� ��������� ����������)
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
                       add eax, [tmp1]  ; tmp+tmp1+tmp2 � eax
                       add eax, [tmp2]

                       mov edx, [radius]
                       sub edx, eax
                       cinvoke printf, fmtINT, [x1]
                       mov ebx, edx
                       neg edx
                       cmovl edx, ebx
                       mov ecx, 2
                       mov eax, edx
                       div ecx
                       mov edx, eax

                       mov eax, esi
                       imul eax, [n]
                       mov [lines + 4*(eax+8)], edx
                       ;cinvoke printf, otl, [lines + 4*(ecx+8)] ;������� ���������������

                       ; ������ ������ � ������������ � ������ �����
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

                       cinvoke printf,fmtRCT, [lines+4*(edx)],[lines +4*(edx+1)],[lines +4*(edx+2)],[lines +4*(edx+3)],[lines +4*(edx+4) ],[lines +4*(edx+8)]

                 ;����������������� ��������
                 inc esi
                 ;������� � ���� ������ �����
                 jmp readingfileloop



        entertoloop:
                 mov [minind], 1
                 mov eax, [lines + 4*(11+8)]    ;��������� ����������� ������� � ������������ ������� �� 0 (������� �� 0-� �������)
                 mov [minarea], eax
                 cinvoke printf, fmtINT, [minarea]

                 mov esi, 1 ; �������� ��� �������� �����
                ; cinvoke printf,fmtRCT, [lines],[lines + 4*7],[lines + 4*8],[lines + 4*9],[lines + 4*10],[lines + 4*(0*7)]
                 ; cinvoke printf,fmtRCT, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+8)]
                   ;cinvoke printf,fmtRCT, [lines + 4*(4+1)],[lines + 4*(4+2)],[lines + 4*(4+3)],[lines + 4*(4+4)],[lines + 4*(4+5)],[lines + 4*(4+8)]
                    ;cinvoke printf,fmtRCT, [lines + 4*(5+1)],[lines + 4*(5+2)],[lines + 4*(5+3)],[lines + 4*(5+4)],[lines + 4*(5+5)],[lines + 4*(5+8)]
                     ;cinvoke printf,fmtRCT, [lines + 4*(6+1)],[lines + 4*(6+2)],[lines + 4*(6+3)],[lines + 4*(6+4)],[lines + 4*(6+5)],[lines + 4*(6+8)]
                      ;cinvoke printf,fmtRCT, [lines + 4*(7+1)],[lines + 4*(7+2)],[lines + 4*(7+3)],[lines + 4*(7+4)],[lines + 4*(7+5)],[lines + 4*(7+8)]
                       ;cinvoke printf,fmtRCT, [lines + 4*(8+1)],[lines + 4*(8+2)],[lines + 4*(8+3)],[lines + 4*(8+4)],[lines + 4*(8+5)],[lines + 4*(8+8)]
                 jmp sortloop



        sortloop:
               ; cinvoke printf, otl, [n] ; �������������������
                cmp esi, [n]  ;������� �������� �����
                jz _ending
                mov ebx, 1 ;�������� ����������� �����
                jmp innerloop
                innerloop:
                        cmp ebx, [n]     ;������� ����������� �����
                        jz sortloopcontinue

                       ; mov edx, esi   ;i-� ������� �������
                       ; imul edx, [n]
                       ; mov eax, [lines + 4*(edx +8)]
                       ; mov [tmp], eax
                       ; mov [tmp], ebx
                       ; cinvoke printf, fmtINT, [tmp] ; �������������������

                        mov edx, ebx  ;j-� ������� �������
                        imul edx, [n]
                        mov eax, [lines +4*(edx+8)]
                        mov [tmp], eax

                        mov eax, [minarea]
                        sub eax, [tmp]  ;��������� � ����������� ��������, ���� ������ ������, �� � reindex   ??????
                        jge reindex
                        inc ebx
                        jmp innerloop
                        reindex:
                          ; cinvoke printf, otl, [tmp]
                           mov eax, ebx
                           mov [minind], eax  ; ���������� ������� ����������� ������� � ���������� ����� ����������� �������
                           mov eax, [tmp]
                           mov [minarea], eax
                           inc ebx
                           jmp innerloop
                sortloopcontinue:
                       ; cinvoke printf, otl, [minarea] ; �����������������������������������������������������������
                        mov eax, [minind]
                        imul eax, [n]
                        mov edx, [lines + 4*(eax)]
                        mov [k], edx
                       ; cinvoke printf, otl, [minind] ;������� ����������������
                        ;mov eax, [k]
                       ; cinvoke printf,strrctgl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+8)]

                        cmp [k], 0
                        jz circlewriting   ;������ � ���� ����� � ��� ����������������

                        cmp [k], 1
                        jz rectanglewriting ; ������ � ���� �������������� � ��� ����������������

                        cmp [k], 2
                        jz trianglewriting ; ������ � ���� �������������� � ��� ����������������

                        circlewriting:
                                cinvoke fprintf, [ff],strcrl, [lines + 4*(eax+1)], [lines + 4*(eax+2)], [lines + 4*(eax+3)], [lines + 4*(eax+4)], [lines + 4*(eax+8)]
                                jmp sortloopending

                        rectanglewriting:
                               ; cinvoke printf, otl, [minind] ;������� ����������������
                               mov eax, [minind]
                               imul eax, [n]
                               cinvoke fprintf,[ff], strrctgl, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+8)]
                              ; cinvoke printf, otl1,  [lines + 4*(eax+1)]
                              ; cinvoke printf, otl1,  [lines + 4*(eax+3)]
                              ; cinvoke printf, otl1,  [lines + 4*(eax+8)]

                             ; cinvoke printf,rctgllinet, [lines + 4*(eax+1)],[lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+8)]
                                jmp sortloopending

                        trianglewriting:
                                cinvoke fprintf, [ff], strtrngl, [lines + 4*(eax+1)], [lines + 4*(eax+2)],[lines + 4*(eax+3)],[lines + 4*(eax+4)],[lines + 4*(eax+5)],[lines + 4*(eax+6)],[lines + 4*(eax+7)],[lines + 4*(eax+8)]
                                jmp sortloopending


                sortloopending:
                       ; cinvoke printf, otl, [minind] ;������� ����������������
                        mov eax, [minind]
                        imul eax, [n]
                        mov [lines + 4*(eax+8)], 60000
                        mov edx, [lines + 4*(eax+8)]
                        mov [minarea], edx
                        inc esi
                        jmp sortloop




        _ending:
        cinvoke printf, ending
        cinvoke free, [lines]
        cinvoke free, [areas]
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
               fclose, 'fclose'


