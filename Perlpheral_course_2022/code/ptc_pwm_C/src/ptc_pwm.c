#define RPTC_CNTR     0x80001200
#define RPTC_HRC      0x80001204
#define RPTC_LRC      0x80001208
#define RPTC_CTRL     0x8000120c

#define READ_Reg(dir) (*(volatile unsigned *)dir)
#define WRITE_Reg(dir, value) { (*(volatile unsigned *)dir) = (value); }

int main ( void )
{
    // 设定PWM周期和占空比
    unsigned int pwm_period = 100000; // 假设系统时钟为50MHz，这将产生大约1kHz的PWM信号
    unsigned int duty_cycle = 50; // 占空比为50%

    // 计算高电平和低电平的持续时间
    unsigned int high_time = (pwm_period * duty_cycle) / 100;
    unsigned int low_time = pwm_period - high_time;

    // 设置PWM高电平和低电平持续时间
    WRITE_Reg(RPTC_HRC, 0);
    WRITE_Reg(RPTC_LRC, low_time);

    int counter_value=0;

    while (1) {
        WRITE_Reg(RPTC_CTRL, 0xC0);
        WRITE_Reg(RPTC_CTRL, 0x29);
        while(1){
            counter_value = READ_Reg(RPTC_CTRL);
            counter_value = counter_value & 0x40;
            if(counter_value!=0){
                break;
            }
        }

    }

    return(0);
}
