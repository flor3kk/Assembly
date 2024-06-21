[bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

extern _printf
extern _exit
extern _scanf
             
section .bss
section .text

global _main
_main:

n        equ 133  ; n = 10

         mov eax, n  ; eax = n

         push eax  ; eax -> stack

;        esp -> [eax][ret]

         call getaddr  ; push on the stack the runtime address of format and jump to getaddr
format:
         db "n = %d ", 0xA, 0
getaddr:
;        esp -> [format][eax][ret]

         call _printf  ; printf(format, eax);
         add esp, 24    ; esp = esp + 8

;        esp -> [ret]

         call getaddr2  ; push on the stack the runtime address of format and jump to getaddr2
format2:
         db "pierwsze =  ", 0
getaddr2:

;        esp -> [format2][ret]

         call _printf  ; printf(format2);
         add esp, 4    ; esp = esp + 8

;        esp -> [ret]

         mov ecx, 2  ; ecx = n

next     push ecx  ; ecx -> stack

;        esp -> [ecx][ret]

         mov edi, 2  ; edi = 2
         mov esi, 0  ; esi = 0

         cmp ecx, 2
         je continue


next2    mov eax, ecx  ; eax = ecx
         mov edx, 0    ; edx = 0

         div edi     ; eax = edx:eax / edi  ; iloraz
                     ; edx = edx:eax % edi  ; reszta



         cmp edx, 0  ; edx - 0  ; OF=0 SF ZF PF CF=0 affected
         jne continue

         mov esi, 1  ; esi = 1

continue:

         mov eax, edi  ;  eax = edi
         mul edi  ; edx:eax = eax edi 

         inc edi  ; edi += 1

         cmp eax, [esp]  ; eax - ecx
         jle next2

         cmp esi, 0  ; edi - 0
         jne next3

         call pierwsze  ; push on the stack the runtime address of format and jump to pierwsze
format3:
         db "[%d] ", 0
pierwsze:

;        esp -> [format3][ecx][ret]

         call _printf  ; printf(format3,ecx);
         add esp, 4    ; esp = esp + 4

next3:

         pop ecx  ; ecx <- stack

         inc ecx

         cmp ecx, n
         jle next

end:

         push 0          ; esp -> [0][ret]
         call _exit  ; exit(0);

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

%ifdef COMMENT

ebx    -> [ ][ ][ ][ ] -> exit
ebx+4  -> [ ][ ][ ][ ] -> putchar
ebx+8  -> [ ][ ][ ][ ] -> getchar
ebx+12 -> [ ][ ][ ][ ] -> printf
ebx+16 -> [ ][ ][ ][ ] -> scanf

%endif
