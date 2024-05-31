%ifdef COMMENT
0   1   2   3   4   5   6    indeksy

a   b   d
|---|---|
1   1   2   3   5   8   13   wartosci
    |---|---|
    a   b   d

Przesuniecie ramki:

b = 1
d = 2

a = b      ; a = 1
b = d      ; b = 2
d = a + b  ; d = 1 + 2 = 3
%endif

         [bits 32]

;        esp -> [ret] ; ret - adres powrotu do asmloader

         mov esi, ebx ; esi = ebx

         mov ebx, 1  ; ebx = 1
         mov edx, 2  ; edx = 2

shift:   mov eax, ebx  ; a = b
         mov ebx, edx  ; b = d
         add eax, ebx  ; a = a + b
         mov edx, eax  ; d = a

;        a = b = 1
;        b = d = 2
;        a = a + b = 1 + 2 = 3
;        d = a = 3

         push edx
         push ebx
         push eax

;        esp -> [eax][ebx][edx][ret]

         call wypisz
format:
         db "a = %i", 0xA,
         db "b = %i", 0xA,
         db "d = %i", 0xA, 0
wypisz:

;        esp -> [format][eax][ebx][edx][ret]

         call [esi+3*4] ; printf("a = %i\nb = %i\nd = %i\n", eax, ebx, edx);
         add esp, 4*4   ; esp = esp + 16

;        esp -> [ret]

         push 0         ; esp -> [0][ret]
         call [esi+0*4] ; exit(0);

; asmloader API
;
; ESP wskazuje na prawidlowy stos
; argumenty funkcji wrzucamy na stos
; EBX zawiera pointer na tablice API
;
; call [ebx + NR_FUNKCJI*4] ; wywolanie funkcji API
;
; NR_FUNKCJI:
;
; 0 - exit
; 1 - putchar
; 2 - getchar
; 3 - printf
; 4 - scanf
;
; To co funkcja zwróci jest w EAX.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387