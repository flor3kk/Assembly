         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

a        equ -2147483648
b        equ -3

         mov eax, a  ; eax = a
         mov ecx, b  ; edx = b

         cdq         ; edx:eax = eax ; signed conversion 
         idiv ecx    ; eax = edx:eax / ecx
                     ; edx = edx:eax % ecx

;        idiv arg    ; eax = edx:eax / arg
                     ; edx = edx:eax % arg

                     ; eax - iloraz
                     ; edx - reszta

         push edx
         push eax

;        esp -> [eax][edx][ret]

         call getaddr
format:
         db "iloraz = %d", 0xA
         db "reszta = %d", 0xA, 0
getaddr:

;        esp -> [format][eax][edx][ret]

         call [ebx+3*4]  ; printf(format, eax, edx);
         add esp, 3*4    ; esp = esp + 12

;        esp -> [ret]

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