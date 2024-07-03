#if defined(D_NEXYS_A7)
   #include <bsp_printf.h>
   #include <bsp_mem_map.h>
   #include <bsp_version.h>
#else
   PRE_COMPILED_MSG("no platform was defined")
#endif
#include <psp_api.h>

#include <i2c.h>
#include <ADT7420.h>

#define SegEn_ADDR      0x80001038
#define SegDig_ADDR     0x8000103C

#define DELAY           10000000    

void delay(int num)
{
    volatile int i;
    for(i=0; i<num; i++);
}

int main(void)
{
    int displayData = 0;

    M_PSP_WRITE_REGISTER_32(SegEn_ADDR, 0xF0);
    M_PSP_WRITE_REGISTER_32(SegDig_ADDR, 0);

    // Initialize Uart
    uartInit();

    // Begin ADT7420 test
	// Initialize ADT7420 Device
	ADT7420_Init();

	while(1)
    {
		displayData = ADT7420_ReadTemp();
        M_PSP_WRITE_REGISTER_32(SegDig_ADDR, displayData);
		Display_Temp(displayData);
        delay(DELAY);
    }
    return 0;
}
