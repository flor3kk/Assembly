%ifdef COMMENT
0   1   2   3   4   5   6    indeksy

a   b
|---|
1   1   2   3   5   8   13   wartosci
|   |---|
d   a   b

Przesuniecie ramki:

d = a              ; d = 1
a = b              ; a = 1
b = a + d = b + d  ; b = 1 + 1 = 2
%endif

         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 0

         mov esi, ebx  ; esi = ebx

         mov ecx, n  ; ecx = n

         mov eax, 1  ; eax = 1
         mov ebx, 1  ; ebx = 1

         cmp ecx, 0  ; ecx - 0           ; ZF affected
         jne next1   ; jump if not equal ; jump if ZF = 0
         push eax

;        esp -> [eax][ret]

         jmp done

next1:   cmp ecx, 1  ; ecx - 1           ; ZF affected
         jne next2   ; jump if not equal ; jump if ZF = 0
         push ebx

;        esp -> [ebx][ret]

         jmp done

next2:   sub ecx, 1  ; ecx = ecx - 1

shift:   mov edx, eax  ; edx = eax       ; d = a
         mov eax, ebx  ; eax = ebx       ; a = b
         add ebx, edx  ; ebx = ebx + edx ; b = b + d

         loop shift

         push ebx

;        esp -> [ebx][ret]

done:

         call wypisz
format:
         db "fibo = %i", 0xA, 0
wypisz:

;        esp -> [format][ebx][ret]

         call [esi+3*4] ; printf("fibo = %i\n", ebx);
         add esp, 2*4   ; esp = esp + 8

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