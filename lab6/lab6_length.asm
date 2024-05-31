        [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 1234

         mov ecx, 0   ; ecx = 0
         mov eax, n   ; eax = n
         mov ebp, 10  ; ebp = 10

petla    mov edx, 0  ; edx = 0
         div ebp     ; eax = edx:eax / ebp
                     ; edx = edx:eax % ebp

;        div arg     ; eax = edx:eax / arg
                     ; edx = edx:eax % arg

                     ; eax - iloraz
                     ; edx - reszta

         inc ecx     ; ecx++
         cmp eax, 0  ; eax - 0           ; ZF affected
         jne petla   ; jump if not equal ; jump if ZF = 0

         push ecx

;        esp -> [ecx][ret]

         call getaddr
format:
         db "length = %i", 0xA, 0
getaddr:

;        esp -> [format][ecx][ret]

         call [ebx+3*4] ; printf("length = %i\n", ecx);
         add esp, 2*4   ; esp = esp + 8

;        esp -> [ret]

         push 0         ; esp -> [0][ret]
         call [ebx+0*4] ; exit(0);

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