%ifdef COMMENT

0! = 1
n! = n*(n-1)!

%endif

         [bits 32]

;        esp -> [ret]  ; ret - adres powrotu do asmloader

n        equ 5

         mov ecx, n ; ecx = n

;        esp -> [ret]

         call silnia  ; eax = suma(ecx) ; fastcall

addr:

;        esp -> [ret]

         push eax

;        esp -> [eax][ret]

         call getaddr
format   db "silnia = %u", 0xA, 0
getaddr:

;        esp -> [format][eax][ret]

         call [ebx+3*4] ; printf("silnia = %u\n", eax);
         add esp, 2*4   ; esp = esp + 8

;        esp -> [ret]

         push 0         ; esp -> [0][ret]
         call [ebx+0*4] ; exit(0);

;        eax silnia(ecx)

silnia   cmp ecx, 0   ; ecx - 0           ; ZF affected
         jne rec      ; jump if not equal ; jump if ZF = 0
         mov eax, 1   ; eax = 1
         ret

rec      push ecx     ; ecx -> stack = n
         dec ecx      ; ecx = ecx - 1 = n-1
         call silnia  ; eax = silnia(ecx) = silnia(n-1)
         pop ecx      ; ecx <- stack = n
         mul ecx      ; eax = eax*ecx = silnia(n-1)*n
         ret

%ifdef COMMENT
eax = silnia(ecx)

* silnia(1) =         * silnia(1) = 1
  ecx -> stack = 1      ecx -> stack = 1
  ecx = ecx - 1 = 0     ecx = ecx - 1 = 0
  eax = silnia(0) =     eax = silnia(0) = 1
  ecx <- stack = 1      ecx <- stack = 1
  eax = eax*ecx =       eax = eax*ecx = 1*1 = 1
  return eax =          return eax = 1

* silnia(0) =         * silnia(0) = 1
  eax = 1               eax = 1
  return eax = 1        return eax = 1
%endif

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