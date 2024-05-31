[bits 32]

push 21
push 2
mov eax, [esp]
add eax, [esp+4]

push eax
call get

for:
    db "x = %i", 0xA, 0
    
get:
    call [ebx+3*4]
    add esp, 2*4
    
    push 0
    call [ebx+0*4]