#if defined(D_NEXYS_A7)
   #include <bsp_printf.h>
   #include <bsp_mem_map.h>
   #include <bsp_version.h>
#else
   PRE_COMPILED_MSG("no platform was defined")
#endif
#include <psp_api.h>

#define SegEn_ADDR      0x80001038
#define SegDig_ADDR     0x8000103C

#define SPI_BASE        0x80001100
#define SPI_ENABLE      0x80001120  //spe 
#define SPI_DATA        0x80001110 //data 

#define READ_IO(dir) (*(volatile unsigned *)dir)
#define WRITE_IO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define Mydelay 1000

void delay(int num)
{
    volatile int i;
    for(i=0; i<1000; i++);
}

//模式0工作
void SPI_INIT() {
    WRITE_IO(SPI_BASE, 0x43);
    delay(Mydelay);
}

void SPI_WRITE(unsigned data) {    
    WRITE_IO(SPI_DATA, data);
    delay(Mydelay);
}

unsigned SPI_READ() {
    unsigned data;
    
    data = READ_IO(SPI_DATA);
    delay(Mydelay);
    
    return data;
}

void ADXL362_WRITE(unsigned int addr, unsigned int data) {
    WRITE_IO(SPI_ENABLE, 1);
    delay(Mydelay);

    SPI_WRITE(0xA);
    delay(Mydelay);
    
    SPI_WRITE(addr);
    delay(Mydelay);
    
    SPI_WRITE(data); 
    delay(Mydelay);

    WRITE_IO(SPI_ENABLE, 0);
    delay(Mydelay);
}

void ADXL362_READ(unsigned int addr, unsigned int *data) {
    WRITE_IO(SPI_ENABLE, 1);
    delay(Mydelay);

    SPI_WRITE(0xB);
    delay(Mydelay);

    SPI_WRITE(addr); //目标地址
    delay(Mydelay);
    
    SPI_WRITE(0x0); //正在和adxl362通信
    delay(Mydelay);
    
    *data = SPI_READ();
    delay(Mydelay);

    *data = SPI_READ();
    delay(Mydelay);

    *data = SPI_READ();
    delay(Mydelay);

    WRITE_IO(SPI_ENABLE, 0);
    delay(Mydelay);
}

void ADXL362_INIT() {
    ADXL362_WRITE(0x20, 0xFA);
    ADXL362_WRITE(0x21, 0); //将运动阈值设为250mg
    ADXL362_WRITE(0x23, 0x96);
    ADXL362_WRITE(0x24, 0); //将静止阈值设为150mg
    ADXL362_WRITE(0x25, 0x1E); //将静止定时器设为30个样本或约5秒
    ADXL362_WRITE(0x27, 0x3F);  //配置环路模式的运动检测并使能相对运动和静止检测
    ADXL362_WRITE(0x2B, 0x40); //将AWAKE位映射到INT2。INT2引脚与开关的栅极相连
    ADXL362_WRITE(0x2D, 0xA); //开始在唤醒模式下进行测量
}


int main() {
    unsigned int displayData=0;
    unsigned int realData=0;
    unsigned int x_low, y_low, z_low, x_high, y_high, z_high;
    WRITE_IO(SegEn_ADDR, 0x24); //启用要用的
    WRITE_IO(SegDig_ADDR, displayData);
    SPI_INIT();
    ADXL362_INIT();
    while(1) {
        ADXL362_READ(0xE, &x_low);
        ADXL362_READ(0xF, &x_high);
        ADXL362_READ(0x10, &y_low);
        ADXL362_READ(0x11, &y_high);
        ADXL362_READ(0x12, &z_low);
        ADXL362_READ(0x13, &z_high);

        realData = 0;
        x_low = x_high<<4 | x_low>>4;
        y_low = y_high<<4 | y_low>>4;
        z_low = z_high<<4 | z_low>>4;

        x_low -= 0xFA;
        y_low -= 0xFC;
        z_low -= 0xC4;
        realData |= x_low << 24;
        realData |= y_low << 12;
        realData |= z_low;
        WRITE_IO(SegDig_ADDR, realData);
          delay(Mydelay);
    }

    return 0;
}
