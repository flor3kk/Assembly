    [bits 32]

a   equ 5

    push a

    call getaddr
format:
                                                   
    db "a = %d", 0xA, 0

getaddr:
        call [ebx+3*4]
        add esp, 2*4

        push 0
        call [ebx+0*4]