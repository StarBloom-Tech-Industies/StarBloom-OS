#include "print.h"
#include <stdint.h>
#include <stddef.h>
void kernel_main(){
    print_clear();
    print_set_color(PRINT_COLOR_GREEN, PRINT_COLOR_BLACK); 
    print_str("Welcome to StartBloom OS\n");

}
