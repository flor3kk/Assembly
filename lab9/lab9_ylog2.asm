         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

x        equ __?float64?__(256.0)

         sub esp, 2*4  ; esp = esp - 8 ; make room for double precision result

;        esp -> [ ][ ][ret]

         call getaddr  ; get the runtime address of format

format   db "log2 = %f", 0xA, 0
length   equ $ - format

addr_y   dq 1.0  ; y  ; define quad word
addr_x   dq x    ; x  ; define quad word

getaddr:

;                       +4
;        esp -> [format][ ][ ][ret]

         finit ; fpu init
         
;        st = []

         mov eax, [esp]   ; eax = *(int*)esp = format
         add eax, length  ; eax = eax + length = format + length = addr_y

         fld qword [eax]  ; *(double*)eax = *(double*)addr_y = 1 -> st ; fpu load floating-point

;        st = [st0] = [1]

         fld qword [eax+8]  ; *(double*)(eax+8) = *(double*)addr_x = x -> st ; fpu load floating-point

;        st = [st0, st1] = [x, 1]

         fyl2x  ; [st0, st1] => [st0, st1 * log2(st0)] => [st1 * log2(st0)] = [log2(x)]

;        st = [st0] = [log2(x)]

         fstp qword [esp+4]  ; *(double*)(esp+4) <- st = y * log2(x) ; fpu store top element
                                                                     ; and pop fpu stack
;        st = []

         call [ebx+3*4]  ; printf("log2 = %f\n", *(double*)(esp+4));
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
; To co funkcja zwr�ci jest w EAX.
; Po wywolaniu funkcji sciagamy argumenty ze stosu.
;
; https://gynvael.coldwind.pl/?id=387 