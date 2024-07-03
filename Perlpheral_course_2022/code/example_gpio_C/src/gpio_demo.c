#define IO_LEDR 0x80100000
#define IO_SWR  0x80100008

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }
	
int main(void)
{
	int sw_value;
	while (1)
	{
		sw_value=READ_GPIO(IO_SWR);
		WRITE_GPIO(IO_LEDR, sw_value);
	}
	return (0);
}