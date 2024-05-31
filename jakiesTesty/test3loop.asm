        [bits 32]

        ; esp [ret]
n       equ 5
        mov ecx, n

petla push ecx
      ; esp [eax][ret]
      call getaddr
      
format: 
        db "i = %i", 0xA, 0

getaddr:
        ; esp [format][ecx][ret]
        call [ebx+3*4]
        adc esp, 1*4
        ; esp [ecx][ret]

        ; albo pierwsze usuwanmy z gory i potem dekrementujemy
        ; i warunkowy skok jnz (jump if not zero) do petli
        ;pop ecx ; esp [ret]
        ;dec ecx
        ;jnz petla
        
        ; albo usuwanmy z gory i od razu skaczemy do petli przez loop
         pop ecx ;esp [ret]
         loop petla
        
        push 0
        call [ebx+0*4]