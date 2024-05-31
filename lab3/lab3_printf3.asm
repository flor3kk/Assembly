    [bits 32]

a   equ 23
b   equ 10

    push a
    push b

    call getaddr
format:
                                                   
    db "b = %d, a = %d", 0xA, 0
getaddr:
        call [ebx+3*4]
        add esp, 2*4

        push 0
        call [ebx+0*4]