#if defined(D_NEXYS_A7)
#include <bsp_mem_map.h>
#include <bsp_printf.h>
#include <bsp_version.h>
#else
PRE_COMPILED_MSG("no platform was defined")
#endif
#include "bsp_external_interrupts.h"
#include "bsp_printf.h"
#include "bsp_timer.h"
#include "psp_api.h"
#include "psp_ext_interrupts_eh1.h"

// 宏定义
#define GPIO_LEDs 0x80100000
#define GPIO1_INOUT 0x80100004
#define GPIO_SWs 0x80100008
#define GPIO2_INOUT 0x8010000C
#define GPIO_GIER 0x8010011C
#define GPIO_IER 0x80100128
#define GPIO_ISR 0x80100120

#define PWM_BASE 0x80120000
#define SegEn_ADDR 0x80001038
#define SegDig_ADDR 0x8000103C
#define UART_ISR 0x80120000
#define RPTC_CNTR 0x80001200
#define RPTC_HRC 0x80001204
#define RPTC_LRC 0x80001208
#define RPTC_CTRL 0x8000120c
#define Select_INT 0x80001018

#define READ_IO(dir) (*(volatile unsigned *)dir)
#define WRITE_IO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define M_UART_RD_REG_LSR() (*((volatile unsigned int *)(D_UART_BASE_ADDRESS + (4 * 0x05))))
#define D_UART_LSR_RBRE_BIT (0x01)

// 全局变量
int SegDisplCount = 0;
unsigned int value = 0;
unsigned int period = 0;

extern D_PSP_DATA_SECTION D_PSP_ALIGNED(1024) pspInterruptHandler_t G_Ext_Interrupt_Handlers[8];

// 延迟函数
void delay() {
  volatile unsigned int j;
  for (j = 0; j < (1000000); j++)
    ; // 延迟
}

// UART 输入字节读取函数
char uart_inbyte(void) {
  unsigned int RecievedByte;

  // 检查 UART FIFO 中是否有数据
  while ((M_UART_RD_REG_LSR() & D_UART_LSR_RBRE_BIT) == 0)
;

  RecievedByte = READ_IO(D_UART_BASE_ADDRESS);

  return (char)RecievedByte;
}

// GPIO 初始化
void GPIO_Initialization(void) {
  // 配置 LED 和开关
  M_PSP_WRITE_REGISTER_32(GPIO1_INOUT, 0x0);
  M_PSP_WRITE_REGISTER_32(GPIO2_INOUT, 0xFFFF); // GPIO_INOUT
  M_PSP_WRITE_REGISTER_32(GPIO_LEDs, 0xF);      // GPIO_LEDs

  // 配置 GPIO 中断
  M_PSP_WRITE_REGISTER_32(GPIO_IER, 0x2); // 启用通道 2 输入中断
  M_PSP_WRITE_REGISTER_32(GPIO_GIER, 0x80000000); // 启用中断
}

// PWM 中断服务程序
void pwm_ISR(void) {
  printfNexys("进入 pwm_ISR 中断，设置 value 为 0\n");
  value = '0';
  period = (value - 0x30) * 110000;

  // 将占空比宽度（周期）写入 PL PWM 外设
  WRITE_IO(PWM_BASE, period);

  // 清除 UART 中断
  M_PSP_WRITE_REGISTER_32(GPIO_ISR, 0x2);
  bspClearExtInterrupt(2);
}

// UART 中断服务程序
void uart_ISR(void) {
  // PWM IP 测试
  // 提示用户选择一个亮度值，范围为 0 到 9
  printfNexys("选择一个亮度值，范围为 0 到 9\n");

  // 从控制台读取输入值
  value = uart_inbyte();

  // 将输入的 ASCII 字符转换为整数值
  period = (value - 0x30) * 110000;

  // 将输入值打印回控制台，以向用户提供反馈
  printfNexys("选择的亮度等级是: %c\n", value);

  // 将占空比宽度（周期）写入 PL PWM 外设
  WRITE_IO(PWM_BASE, period);

  // 清除 GPIO 中断
  //M_PSP_WRITE_REGISTER_32(GPIO_ISR, 0x2);
  bspClearExtInterrupt(4);
}

// PTC 中断服务程序
void PTC_ISR(void) {
  // 写入 7 段显示器
  M_PSP_WRITE_REGISTER_32(SegDig_ADDR, SegDisplCount);
  SegDisplCount++;

  // 如果 SegDisplCount > 10，修改 IRQ3 优先级
  if (SegDisplCount > 10)
    pspExtInterruptSetPriority(3, 5);

  // 清除 PTC 中断
  M_PSP_WRITE_REGISTER_32(RPTC_CNTR, 0x0);
  M_PSP_WRITE_REGISTER_32(RPTC_CTRL, 0x40);
  M_PSP_WRITE_REGISTER_32(RPTC_CTRL, 0x31);

  // 停止生成特定的外部中断
  bspClearExtInterrupt(3);
}

// 默认初始化
void DefaultInitialization(void) {
  u32_t uiSourceId;

  // 注册中断向量
  pspInterruptsSetVectorTableAddress(&M_PSP_VECT_TABLE);

  // 在 MEIVT CSR 中设置外部中断向量表地址
  pspExternalInterruptSetVectorTableAddress(G_Ext_Interrupt_Handlers);

  // 将生成寄存器置于初始状态（不生成外部中断）
  bspInitializeGenerationRegister(D_PSP_EXT_INT_ACTIVE_HIGH);

  for (uiSourceId = D_BSP_FIRST_IRQ_NUM; uiSourceId <= D_BSP_LAST_IRQ_NUM;
       uiSourceId++) {
    // 确保清除外部中断触发
    bspClearExtInterrupt(uiSourceId);
  }

  // 设置标准优先级顺序
  pspExtInterruptSetPriorityOrder(D_PSP_EXT_INT_STANDARD_PRIORITY);

  // 将中断阈值设置为最小（即所有中断都应被处理）
  pspExtInterruptsSetThreshold(M_PSP_EXT_INT_THRESHOLD_UNMASK_ALL_VALUE);

  // 将嵌套优先级阈值设置为最小（即所有中断都应被处理）
  pspExtInterruptsSetNestingPriorityThreshold(
      M_PSP_EXT_INT_THRESHOLD_UNMASK_ALL_VALUE);
}

// 外部中断线路初始化
void ExternalIntLine_Initialization(u32_t uiSourceId, u32_t priority,
                                    pspInterruptHandler_t pTestIsr) {
  // 设置网关中断类型（电平触发）
  pspExtInterruptSetType(uiSourceId, D_PSP_EXT_INT_LEVEL_TRIG_TYPE);

  // 设置网关极性（高电平有效）
  pspExtInterruptSetPolarity(uiSourceId, D_PSP_EXT_INT_ACTIVE_HIGH);

  // 清除网关
  pspExtInterruptClearPendingInt(uiSourceId);

  // 设置 IRQ4 优先级
  pspExtInterruptSetPriority(uiSourceId, priority);

  // 启用 PIC 中的 IRQ4 中断
  pspExternalInterruptEnableNumber(uiSourceId);

  // 注册 ISR
  G_Ext_Interrupt_Handlers[uiSourceId] = pTestIsr;
}

// PTC 初始化
void PTC_Initialization(void) {
  // 配置带中断的 PTC
  M_PSP_WRITE_REGISTER_32(RPTC_LRC, 0x2FFFFFF);
  M_PSP_WRITE_REGISTER_32(RPTC_CNTR, 0x0);
  M_PSP_WRITE_REGISTER_32(RPTC_CTRL, 0x40);
  M_PSP_WRITE_REGISTER_32(RPTC_CTRL, 0x31);
}

// 主函数
int main(void) {
  DefaultInitialization();         // 默认初始化
  pspExtInterruptsSetThreshold(5); // 设置中断阈值为 5

  ExternalIntLine_Initialization(
      2, 6,
      pwm_ISR); // 设置当 PWM 模块的输入值超过阈值时（阈值范围为 0-9），通过中断服务程序将 PWM 的输入值重置为 0
  ExternalIntLine_Initialization(4, 6, uart_ISR); // 设置用开关触发中断方式进行 UART 的输入
  //ExternalIntLine_Initialization(3, 6, PTC_ISR); // 初始化 IRQ3，优先级为 6，设置 PTC_ISR 作为中断服务程序
  M_PSP_WRITE_REGISTER_32(Select_INT, 0x3);

  // 初始化 UART
  uartInit(); 
  GPIO_Initialization(); // 初始化 GPIO
  //PTC_Initialization(); // 初始化 PTC
  //M_PSP_WRITE_REGISTER_32(SegEn_ADDR, 0x0);

  pspInterruptsEnable(); // 启用所有 mstatus CSR 中的中断
  M_PSP_SET_CSR(
      D_PSP_MIE_NUM,
      D_PSP_MIE_MEIE_MASK); // 启用 mie CSR 中的外部中断

  while (1) {
    // 无限循环等待中断
  }
}
