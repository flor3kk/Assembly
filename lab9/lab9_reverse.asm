         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

         call getaddr  ; push on the stack the run-time address of format

format   db 'Ala ma kota.'
length   equ $ - format

revers   times length db 0
         db 0xA, 0

getaddr:

;        esp -> [format][ret]

         mov ecx, length  ; ecx = length

         mov esi, [esp]             ; esi = *(int*)esp = format
         lea edi, [esi+2*length-1]  ; edi = esi + 2*length-1 = format + 2*length - 1 = revers + length - 1

.loop    mov al, [esi]  ; al = *(char*)esi
         mov [edi], al  ; *(char*)edi = al

         inc esi  ; esi++
         dec edi  ; edi--

         loop .loop

;        esp -> [format][ret]

         add dword [esp], length ; *(int*)esp = *(int*)esp + length = format + length = reverse

;        esp -> [reverse][ret]

         call [ebx+3*4]  ; printf(reverse);
         add esp, 1*4    ; esp = esp + 4

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