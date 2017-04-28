#include <stdint.h>

#define GPEN    (*(volatile uint32_t*)(0x00010000))
#define GPO     (*(volatile uint32_t*)(0x00010004))
#define GPI     (*(volatile uint32_t*)(0x00010008))

void main(void) {
    int i;

    for (i = 0 ; i < 32 ; i++) {
        GPEN = i;
        GPO  = i;
        GPI  = i;
    }
    while (1) {
    }
}
