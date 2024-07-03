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

#define GPIO_GIER 0x8010011C
#define GPIO_IER 0x80100128
#define GPIO_ISR 0x80100120

#define PWM_BASE 0x80120000
#define Select_INT 0x80001018

#define READ_IO(dir) (*(volatile unsigned *)dir)
#define WRITE_IO(dir, value) { (*(volatile unsigned *)dir) = (value); }

#define M_UART_RD_REG_LSR() (*((volatile unsigned int *)(D_UART_BASE_ADDRESS + (4 * 0x05))))
#define D_UART_LSR_RBRE_BIT (0x01)

unsigned int value = 0;
unsigned int period = 0;

extern D_PSP_DATA_SECTION D_PSP_ALIGNED(1024) pspInterruptHandler_t G_Ext_Interrupt_Handlers[8];

void delay() {
  volatile unsigned int j;
  for (j = 0; j < (1000000); j++);
}

char uart_inbyte(void) {
  unsigned int RecievedByte;

  while ((M_UART_RD_REG_LSR() & D_UART_LSR_RBRE_BIT) == 0);

  RecievedByte = READ_IO(D_UART_BASE_ADDRESS);

  return (char)RecievedByte;
}

void pwm_ISR(void) {
  printfNexys("进入 pwm_ISR 中断，设置 value 为 0\n");
  value = '0';
  period = (value - 0x30) * 110000;

  WRITE_IO(PWM_BASE, period);

  bspClearExtInterrupt(2);
}

void uart_ISR(void) {
  printfNexys("选择一个亮度值，范围为 0 到 9\n");

  value = uart_inbyte();

  period = (value - 0x30) * 110000;

  printfNexys("选择的亮度等级是: %c\n", value);

  WRITE_IO(PWM_BASE, period);

  //M_PSP_WRITE_REGISTER_32(PWM_BASE, 0x2);
  bspClearExtInterrupt(3);
}

void DefaultInitialization(void)
{
  u32_t uiSourceId;

  /* Register interrupt vector */
  pspInterruptsSetVectorTableAddress(&M_PSP_VECT_TABLE);

  /* Set external-interrupts vector-table address in MEIVT CSR */
  pspExternalInterruptSetVectorTableAddress(G_Ext_Interrupt_Handlers);

  /* Put the Generation-Register in its initial state (no external interrupts are generated) */
  bspInitializeGenerationRegister(D_PSP_EXT_INT_ACTIVE_HIGH);

  for (uiSourceId = D_BSP_FIRST_IRQ_NUM; uiSourceId <= D_BSP_LAST_IRQ_NUM; uiSourceId++)
  {
    /* Make sure the external-interrupt triggers are cleared */
    bspClearExtInterrupt(uiSourceId);
  }

  /* Set Standard priority order */
  pspExtInterruptSetPriorityOrder(D_PSP_EXT_INT_STANDARD_PRIORITY);

  /* Set interrupts threshold to minimal (== all interrupts should be served) */
  pspExtInterruptsSetThreshold(M_PSP_EXT_INT_THRESHOLD_UNMASK_ALL_VALUE);

  /* Set the nesting priority threshold to minimal (== all interrupts should be served) */
  pspExtInterruptsSetNestingPriorityThreshold(M_PSP_EXT_INT_THRESHOLD_UNMASK_ALL_VALUE);
}


void ExternalIntLine_Initialization(u32_t uiSourceId, u32_t priority, pspInterruptHandler_t pTestIsr)
{
  /* Set Gateway Interrupt type (Level) */
  pspExtInterruptSetType(uiSourceId, D_PSP_EXT_INT_LEVEL_TRIG_TYPE);

  /* Set gateway Polarity (Active high) */
  pspExtInterruptSetPolarity(uiSourceId, D_PSP_EXT_INT_ACTIVE_HIGH);

  /* Clear the gateway */
  pspExtInterruptClearPendingInt(uiSourceId);

  /* Set IRQ4 priority */
  pspExtInterruptSetPriority(uiSourceId, priority);
    
  /* Enable IRQ4 interrupts in the PIC */
  pspExternalInterruptEnableNumber(uiSourceId);

  /* Register ISR */
  G_Ext_Interrupt_Handlers[uiSourceId] = pTestIsr;
}

int main(void) {
  DefaultInitialization();
  pspExtInterruptsSetThreshold(5); 

  ExternalIntLine_Initialization(2, 6, pwm_ISR);
  ExternalIntLine_Initialization(1, 6, uart_ISR);
  M_PSP_WRITE_REGISTER_32(Select_INT, 0x3);

  uartInit(); 
  value = uart_inbyte();

  pspInterruptsEnable(); 
  M_PSP_SET_CSR(D_PSP_MIE_NUM, D_PSP_MIE_MEIE_MASK); 

  while (1) {
  }
}
