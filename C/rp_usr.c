#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "redpitaya/rp.h"

// HH : 2017-02-18 test the user specific interfaces to the FPGA

int main (int argc, char **argv) {
    //int unsigned period = 1000000; // uS
    //int unsigned led;

    // index of blinking LED can be provided as an argument
    //if (argc > 1) {
    //    led = atoi(argv[1]);
    // otherwise LED 0 will blink
    //} else {
    //    led = 0;
    //}
    //printf("Blinking LED[%u]\n", led);
    printf("set A\n");
    //led += RP_LED0;

    // Initialization of API
    if (rp_Init() != RP_OK) {
        fprintf(stderr, "Red Pitaya API init failed!\n");
        return EXIT_FAILURE;
    }

    //int unsigned retries = 1000;
    //while (retries--){
    //    rp_DpinSetState(led, RP_HIGH);
    //    usleep(period/2);
    //    rp_DpinSetState(led, RP_LOW);
    //    usleep(period/2);
    //}
    rp_usr_SetPattern((uint32_t)0x0A);
    //rp_usr_SetPeriodTime((uint32_t)0x03FAFFFF);
    //rp_LEDSetState((uint32_t)0xAA);

    // Releasing resources
    rp_Release();

    return EXIT_SUCCESS;
}

