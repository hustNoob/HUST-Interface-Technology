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
#include <stdio.h>

#define AUDIO_BASE    0x80140000
#define SegEn_ADDR      0x80001038
#define SegDig_ADDR     0x8000103C

#define READ_IO(dir) (*(volatile unsigned *)dir)
#define WRITE_IO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define M_UART_RD_REG_LSR()  (*((volatile unsigned int*)(D_UART_BASE_ADDRESS + (4*0x05) ))) 
#define D_UART_LSR_RBRE_BIT  (0x01)

#define DELAY           10000000    

void delay(int num)
{
    volatile int i;
    for(i=0; i<num; i++);
}

char uart_inbyte(void) 
{
	unsigned int RecievedByte;

    /* Check for space in UART FIFO */
    while((M_UART_RD_REG_LSR() & D_UART_LSR_RBRE_BIT) == 0);
	
	RecievedByte = READ_IO(D_UART_BASE_ADDRESS);

	return (char)RecievedByte;
}

float get_decimal(float decimal){
    decimal /= 16;
    int i = decimal;
    decimal = decimal - i;
    return decimal;
}

int main(void)
{
    int data = 0, data_2, temp_thre; //data接收温度，然后data整数部分，data_2小数部分，temp_thre阈值
    float temp = 0;
    WRITE_IO(SegEn_ADDR, 0xF8); //只要3位数码管
    WRITE_IO(SegDig_ADDR, 0);
    WRITE_IO(AUDIO_BASE, 0);

    uartInit();
    ADT7420_Init();

    printfNexys("第一次需要先设置温度阈值");
    temp_thre = uart_inbyte() - 0x30;
    temp_thre = temp_thre * 10 + uart_inbyte() - 0x30;

    while(1){
        if(M_UART_RD_REG_LSR() & D_UART_LSR_RBRE_BIT) {//中途输入任何字符，进入这个程序
            printfNexys("请设置新的温度阈值：");
            temp_thre = uart_inbyte();//这句话无所谓，用于抵消缓存区的字符
            temp_thre = uart_inbyte() - '0';
            temp_thre = temp_thre * 10 + uart_inbyte() - '0';
        }
        data = ADT7420_ReadTemp();
        M_PSP_WRITE_REGISTER_32(SegDig_ADDR, data); //16进制显示温度，最完全且不易改
        temp = data;
        data /= 16; //整数部分
        temp = get_decimal(temp);
        data_2 = temp * 10;//小数部分，取一位小数
	    printfNexys("T = %d.%d℃", data, data_2);
        if (data+data_2*0.1 > temp_thre) {
            WRITE_IO(AUDIO_BASE, 1);
        } else {
            WRITE_IO(AUDIO_BASE, 0);
        }
        delay(DELAY);
        //temp_set = uart_inbyte() - 0x30;
    /*else{
        printfNexys("请设置温度阈值");
        temp_thre = uart_inbyte() - 0x30;
        temp_thre = temp_thre * 10 + uart_inbyte() - 0x30;
        temp_set = 0;
        WRITE_IO(D_UART_BASE_ADDRESS, 0);
    }*/
    }
    return 0;
}
