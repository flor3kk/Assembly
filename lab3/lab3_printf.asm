    [bits 32]

    call getaddr
format:                                            

    db "hello world!", 0xA, 0   ;0xA nowa linia, 0 koniec lini
;   declare byte
;   dw dd dq
getaddr:
        call [ebx+3*4]
        add esp, 4

        push 0
        call [ebx+0*4]