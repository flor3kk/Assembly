    [bits 32]
    
a   equ 60
b   equ 1000

    ; esp [ret]
    
    ;ZAD 3.6 SUB.ASM
  ;  mov eax, a ;dodanie na gore eax wartosci z a
 ;   mov ecx, b
;    sub eax, ecx

; add eax, ecx DODAWANIE

     ;ZAD 3.6 SUB2.asm
     mov eax, a
     sub eax, b
    push eax
    ;eso [eax][ret]

    call getaddr

format:
       db "suma: %d", 0xA, 0
       
getaddr:
     ;esp [format][eax][ret]
     
     call [ebx+3*4] ; wywolanie
     add esp, 2*4 ;bo dwie opcje musimy usunac
     
     ; teraz mamy esp[ret]
     push 0
     call [ebx+0*4]