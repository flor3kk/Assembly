[bits 32]
      ;esp [ret]

;DO execa:
;nasm projekt_ask.asm -o projekt_ask.o -f win32
;gcc projekt_ask.o -o projekt_ask.exe -m32
              
extern _printf
extern _exit
extern _scanf
             
section .bss
section .text

global _main
_main:

finit         ; INICJALIZACJA COprocesora
suma equ 0    ; na rejestrze EDI jest bo EAX sie krzaczy
licznik equ 0

mov esi, ebx     ; esi = ebx

call liczba_iteracji

print:
      db "Ile liczb chcesz podac? = ", 0

liczba_iteracji:     ;esp [print][ret]
      call _printf
      push esp      ;esp [----][zmienna][ret]
      call skanuj_liczbe

print2:
      db "%i", 0

skanuj_liczbe:       ;esp [%i][----][zmienna][ret]
      call _scanf
      add esp, 2*4   ;esp [zmienna][ret]
      call przypisanie

print3:
      db "Ilosc liczb = %i", 0xA, 0

przypisanie:  ;esp [print3][zmienna][ret]
      call _printf
      mov ecx, [esp+4] ; ILE PETLI SIE WYKONA

      cmp ecx, 0       ; porownanie czy wartosc nie jest ujemna
      jecxz domyslna      ; jesli ecx = 0 skocz do wartosci domyslnej
      jg poprawna           ; jesli > 0 skocz do negacji
      neg ecx          ; ecx = -ecx

poprawna:
      mov edi, suma    ;edi = 0
      mov ebx, licznik ;ebx = 0 licznik do dzielenia

      add esp, 2*4  ; esp [ret]

      jmp petla

domyslna:
      mov ecx, 1
      
      mov edi, suma
      mov ebx, licznik
      
      add esp, 2*4
      jmp petla

petla:
      push ecx ;esp [ecx][ret]

      call getaddr

      format:
             db "x = ", 0

      getaddr:   ;esp [zmienna][ecx][ret]
             call _printf
             push esp   ;esp [----][zmienna][ecx][ret]
             call getaddr2

      format2:
             db "%i", 0 ;%lf

      getaddr2:   ;esp [%i][----][zmienna][ecx][ret]
             call _scanf
             add esp, 2*4   ;esp [zmienna][ecx][ret]
             call getaddr3

      format3:
             db "wprowadzona liczba: [%i]", 0xA, 0

      getaddr3:     ;esp [format3=][zmienna][ecx][ret]
             call _printf

             mov eax, [esp+4]  ; do testu czy wartosc jest ujemna
             test eax, eax     ; test
             jge negat         ; skok jesli niej jest ujemna
             neg eax           ; eax = -eax

      negat:
             add edi, eax ; edi = edi + zmienna
             add esp, 2*4  ;esp [ecx][ret]

             pop ecx   ;esp [ret]
             inc ebx   ;ebx++
             loop petla

             push edi   ;esp [edi][ret]
             call wypisz_sume

laczna_suma:
      db "suma = %i", 0xA, 0

wypisz_sume:   ;esp [laczna_suma=][edi][ret]
      call _printf

      fild qword [esp]   ;st = [st0] = [edi]

      add esp, 2*4  ;esp [ret]

      push ebx      ;esp[ebx][ret]
      call wypisz

ile_liczb:
      db "ile liczb = %i", 0xA, 0

wypisz:     ;esp [ile_liczb][ebx][ret]
      call _printf

      fild qword [esp]    ;st = [st0, st1] = [ebx, edi]

      add esp, 2*4  ;esp [ret]
      
      fdiv
      sub esp, 8
      fstp qword [esp]

      call koniec

srednia:
      db "srednia: %0.2f", 0xA, 0

koniec:    ;esp [srednia][][][ret]
      call _printf
      add esp, 3*4

      push 0       ;esp [0][ret]
      call _exit


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