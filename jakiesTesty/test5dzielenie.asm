    [bits 32]
    ;esp [ret]
a   equ 559
b   equ 5

    mov eax, a
    mov ecx, b
    mov edx, 0 ;SLUZY do przechowywania reszty

    div ecx ; w eax jest przechowywany iloraz, eax = eax / ecx
            ; w edx jest przechowyana reszta z dzielenia, edx = eax % ecx

    push edx ; esp[edx][ret]      ;najpierw dodajemy reszte aby pozniej sie wykonala
    push eax ; esp[eax][edx][ret] ;teraz dodajemy iloraz aby zgadzalo sie przy wywolywaniu z formatem

    call getaddr
format:
       db "iloraz = %u", 0xA
       db "reszta = %u", 0xA, 0

getaddr:
        ;esp[format][eax][edx][ret]
        
        call [ebx+3*4]
        adc esp, 3*4
        
        push 0
        call [ebx+0*4]