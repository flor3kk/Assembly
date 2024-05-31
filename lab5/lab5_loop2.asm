         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 3

         mov ecx, n  ; ecx = n

petla    push ecx  ; *(int*)(esp-4) = ecx ; esp = esp - 4

;        esp -> [ecx][ret]

         call getaddr
format:
         db "i = %i", 0xA, 0
getaddr:

;        esp -> [format][ecx][ret]

         call [ebx+3*4]  ; printf("i = %i\n", ecx); // funkcja printf modyfikuje rejestr ecx
         adc esp, 1*4    ; esp = esp + 4

;        esp -> [ecx][ret]

         pop ecx  ; ecx = *(int*)esp ; esp = esp + 4

;        esp -> [ret]

         loop petla 

         push 0          ; esp -> [0][ret]
         call [ebx+0*4]  ; exit(0);

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