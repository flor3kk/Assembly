         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

%define  UINT_MAX 4294967295

a        equ 4294967296
b        equ 3

x        equ a % (UINT_MAX + 1)
y        equ a / (UINT_MAX + 1)

         mov eax, x  ; eax = x
         mov edx, y  ; edx = y

         mov ecx, b  ; ecx = b

         div ecx     ; eax = edx:eax / ecx
                     ; edx = edx:eax % ecx

;        div arg     ; eax = edx:eax / arg
                     ; edx = edx:eax % arg

                     ; eax - iloraz
                     ; edx - reszta

         push edx
         push eax

;        esp -> [eax][edx][ret]

         call getaddr
format:
         db "iloraz = %u", 0xA
         db "reszta = %u", 0xA, 0
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