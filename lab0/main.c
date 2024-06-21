#include <stdio.h>
#include <stdlib.h>

int main(int args, char *argv[]){
    int *x = malloc(sizeof(int));
    int *y = malloc(sizeof(int));
    
    *x = 1;
    *y = 2;
    printf("wartosc x = %d\n", *x);
    printf("wartosc y = %d\n", *y);
    
    printf("adres x = %d\n", x);
    printf("adres y = %d\n", y);
    
    printf("Adres x: %p\n", (void*)x);
    printf("Adres y: %p\n", (void*)y);
    
    free(x);
    free(y);
    
    x = NULL;
    y = NULL;
    
    // if (arg) == true, arg <> 0, NULL == 0
    if(x != 0) {
        printf("wartosc x = %d\n", *x);
    }     

    return 0;
}



int main2(int argc, char *argv[]) {
    int x = 1;
    int y = 2;
    
    // pobranie adresu zmiennej x i zapisanie jej do wskaznika 
    void *wsk = &x;
    void *wsk2 = &y;
    
    printf("adres zmiennej x: %p\n", wsk);
    printf("adres zmiennej y: %p\n", wsk2);
    
    // $var1 [94][FE][61][00] var1
    // $var2 [90][FE][61][00] var2
    
    printf("wartosc zmiennej pod adresem wsk: %d\n", *((int *) wsk));    
    printf("wartosc zmiennej pod adresem wsk2: %d\n", *((int *) wsk2));
    
    return 0;
}


