#ifndef __RP_FPGA_USR_H
#define __RP_FPGA_USR_H

#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>

// Base address for FPGA_USR
static const size_t RP_FPGA_USR_BASE_ADDR = 0x40600000;
static const size_t RP_FPGA_USR_BASE_SIZE = 0x0000000C;

// fpga usr structure declaration
typedef struct rp_fpga_usr_control_s {
    uint32_t led; // 0x000
    uint32_t pattern;  // 0x004 
    uint32_t period; // 0x008 repetition time
    uint32_t reserved1;
    
} rp_fpga_usr_control_t;

static volatile rp_fpga_usr_control_t *rp_usr = NULL;

static int rp_usr_Init() {
    ECHECK(cmn_Map(RP_FPGA_USR_BASE_SIZE, RP_FPGA_USR_BASE_ADDR, (void**)&rp_usr));
    return RP_OK;
}

static int rp_usr_Release() {
    ECHECK(cmn_Unmap(RP_FPGA_USR_BASE_SIZE, (void**)&rp_usr));
    return RP_OK;
}

#endif // __RP_FPGA_USR_H
