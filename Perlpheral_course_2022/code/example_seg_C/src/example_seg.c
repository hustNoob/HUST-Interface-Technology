#if defined(D_NEXYS_A7)
   #include <bsp_printf.h>
   #include <bsp_mem_map.h>
   #include <bsp_version.h>
#else
   PRE_COMPILED_MSG("no platform was defined")
#endif
#include <psp_api.h>

#define PWM_BASE    0x80120000
#define SEG_BASE    0x80130000

#define READ_IO(dir) (*(volatile unsigned *)dir)
#define WRITE_IO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define M_UART_RD_REG_LSR()  (*((volatile unsigned int*)(D_UART_BASE_ADDRESS + (4*0x05) ))) 
#define D_UART_LSR_RBRE_BIT  (0x01)

void delay() 
{
	volatile unsigned int j;
	for (j = 0; j < (1000000); j++) ;	// delay 
}

char uart_inbyte(void) 
{
	unsigned int RecievedByte;

    /* Check for space in UART FIFO */
    while((M_UART_RD_REG_LSR() & D_UART_LSR_RBRE_BIT) == 0);
	
	RecievedByte = READ_IO(D_UART_BASE_ADDRESS);

	return (char)RecievedByte;
}

int main(void)
{
   unsigned int input = 0;
   unsigned int number = 0;
   unsigned int data = 0;
   unsigned int Seg_Display = 0;

   /* Initialize Uart */
   uartInit();

   while(1){
        input = 0;
        number = 0;
        data = 0;
        Seg_Display = 0;

        printfNexys("Please enter the number of segment:\n");
        number = uart_inbyte() - 0x30;
        if (number > 8 || number < 1){
            printfNexys("Your input is illegal!\n");
            continue;
        }
        number -= 1;

        printfNexys("Please input data of segment:\n");
        input = uart_inbyte() - 0x30;
        data = input * 10;
        input = uart_inbyte() - 0x30;
        data += input;
        if (data > 15 || number < 0){
            printfNexys("Your input is illegal!\n");
            continue;
        }
        data = data*8;

        Seg_Display = number + data;
        WRITE_IO(SEG_BASE, Seg_Display);
        
        /*if (value>132)
            value = 12;
        else {
            WRITE_IO(SEG_BASE, value);
            value += 8;
        }*/
		
        delay( );
   }

   return 0;
}
