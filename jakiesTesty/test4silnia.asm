    [bits 32]
    ;esp [ret]
n   equ 5

    mov ecx, n
    mov eax, 1 ; od tego zaczynamy

petla mul ecx ;w pierwszym ruchu mamy eax = 1 * 5 (5)
              ;w drugim przez loop zmniejszamy o 1, czyli mamy eax = 5 * 4 (20)
              ;w trzecim przez loop zmniejszamy o 1, czyli mamy eax = 20 * 3 (60)
              ;w czwartym przez loop zmniejszamy o 1, czyli mamy eax = 60 * 2 (120)
              ;w piatym przez loop zmnijeszamy o 1, czyli mamy eax = 120 * 1 (120)
              ;szostego nie ma bo juz jest 0 czyli pushujemy eax na stos

      loop petla

      push eax
      ;esp [eax][ret]
      call getaddr

format:
       db "silnia: %u", 0xA, 0

getaddr:
        ;esp[format][eax][ret]
        
        call [ebx+3*4]
        adc esp, 2*4
        
        push 0
        call [ebx+0*4]