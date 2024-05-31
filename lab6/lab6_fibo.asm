%ifdef COMMENT
0   1   2   3   4   5   6    indeksy

a   b   d
|---|---|
1   1   2   3   5   8   13   wartosci
    |---|---|
    a   b   d

Przesuniecie ramki:

a = b      ; a = 1
b = d      ; b = 2
d = a + b  ; d = 1 + 2 = 3
%endif

         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 46

         mov esi, ebx  ; esi = ebx

         mov ecx, n  ; ecx = n

         mov eax, 1  ; eax = 1
         mov ebx, 1  ; ebx = 1
         mov edx, 2  ; edx = 2

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

next2:   cmp ecx, 2  ; ecx - 2           ; ZF affected
         jne next3   ; jump if not equal ; jump if ZF = 0
         push edx

;        esp -> [edx][ret]

         jmp done

next3:   sub ecx, 2  ; ecx = ecx - 2

shift:   mov eax, ebx  ; a = b
         mov ebx, edx  ; b = d
         add eax, ebx  ; a = a + b
         mov edx, eax  ; d = a

         loop shift

         push edx

;        esp -> [edx][ret]

done:

         call wypisz
format:
         db "fibo = %u", 0xA, 0
wypisz:

;        esp -> [format][fibo][ret]

         call [esi+3*4]  ; printf("fibo = %u\n", fibo);
         add esp, 2*4    ; esp = esp + 8

;        esp -> [ret]

         push 0          ; esp -> [0][ret]
         call [esi+0*4]  ; exit(0);

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