[bits 32]
      ;esp [ret]

suma equ 0    ; na rejestrze EDI jest bo EAX sie krzaczy
licznik equ 0

mov esi, ebx     ; esi = ebx

call liczba_iteracji

print:
      db "ile razy wykonac petle?: ", 0

liczba_iteracji:     ;esp [print][ret]
      call [esi+3*4]
      push esp      ;esp [----][zmienna][ret]
      call skanuj_liczbe

print2:
      db "%i", 0

skanuj_liczbe:       ;esp [%i][----][zmienna][ret]
      call [esi+4*4]
      add esp, 2*4   ;esp [zmienna][ret]
      call przypisanie

print3:
      db "ilosc iteracji: %i", 0xA, 0

przypisanie:  ;esp [print3][zmienna][ret]
      call [esi+3*4]
      mov ecx, [esp+4] ; ILE PETLI SIE WYKONA

      mov edi, suma    ; eax = 0
      mov ebx, licznik ;ebx = 0 licznik do dzielenia

      add esp, 2*4  ; esp [ret]

petla:
      push ecx ;esp [ecx][ret]

      call getaddr

      format:
             db "x = ", 0

      getaddr:   ;esp [zmienna][ecx][ret]
             call [esi+3*4]
             push esp   ;esp [----][zmienna][ecx][ret]
             call getaddr2

      format2:
             db "%i", 0

      getaddr2:   ;esp [%i][----][zmienna][ecx][ret]
             call [esi+4*4]
             add esp, 2*4   ;esp [zmienna][ecx][ret]
             call getaddr3

      format3:
             db "wprowadzona liczba: %i", 0xA, 0

      getaddr3:     ;esp [x=][zmienna][ecx][ret]
             call [esi+3*4]

             add edi, [esp+4] ; eax = eax + zmienna
             ;add edi,1

             add esp, 2*4  ;esp [ecx][ret]

             pop ecx   ;esp [ret]
             inc ebx
             loop petla

             ;mov eax, 10
             push edi   ;esp [eax][ret]
             call wypisz_sume

laczna_suma:
      db "suma = %i", 0xA, 0

wypisz_sume:              ;esp [laczna_suma=][eax][ret]
      call [esi+3*4]
      add esp, 2*4  ;esp [ret]


      push ebx      ;esp[ebx][ret]
      call wypisz

ile_liczb:
      db "ile liczb: %i", 0xA, 0

wypisz:     ;esp [ile_liczb][ebx][ret]
      call [esi+3*4]
      add esp, 2*4  ;esp [ret]
       
      mov eax, edi  ;eax = edi, czyli nasza suma
      xor edx, edx  ;ustawienie edx = 0
      div ebx       ;edx:eax / ebx

      push edx      ;esp [edx = reszta][ret]
      push eax      ;esp [eax = iloraz][edx][ret]
      call koniec

srednia:
      db "iloraz: %i, "
      db "reszta: %i", 0xA, 0

koniec:    ;esp [srednia][eax = iloraz][edx = reszta][ret]
      call [esi+3*4]
      add esp, 3*4

      push 0       ;esp [0][ret]
      call [esi+0*4]


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