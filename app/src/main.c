/* Includes ------------------------------------------------------------------*/
#include "stm8s.h"
#include "main.h"

#define MAX(a,b) (((a)>(b))?(a):(b))

void main(void)
{
  unsigned int adc_value = 0;
  uint16_t delay_val = 0xFFFF;

  GPIO_Config();
  ADC_Config();

  while (1)
  {
    adc_value = ADC_Read();
    delay_val = MAX(adc_value * 60, 5000);

    /* Toggles LEDs */
    GPIO_WriteHigh(GPIOB, GPIO_PIN_5);
    Delay(delay_val);
    GPIO_WriteLow(GPIOB, GPIO_PIN_5);
    Delay(delay_val);
  }

}

void Delay(uint16_t nCount)
{
  /* Decrement nCount value */
  while (nCount != 0)
  {
    nCount--;
  }
}

void GPIO_Config(void){
  //prepare Port A for working
	GPIO_DeInit(GPIOB);
	
	//Declare PA3  as input pull up pin 
	GPIO_Init(GPIOB, GPIO_PIN_5, GPIO_MODE_OUT_PP_LOW_FAST);
}

void ADC_Config(void){
	ADC1_DeInit();
	ADC1_Init(ADC1_CONVERSIONMODE_CONTINUOUS, 
             ADC1_CHANNEL_2,
             ADC1_PRESSEL_FCPU_D18, 
             ADC1_EXTTRIG_TIM, 
             DISABLE, 
             ADC1_ALIGN_RIGHT, 
             ADC1_SCHMITTTRIG_ALL, 
             DISABLE);
	ADC1_Cmd(ENABLE);
	ADC1_StartConversion();
}

unsigned int ADC_Read(void){
	uint16_t result = 0;
	
	while(ADC1_GetFlagStatus(ADC1_FLAG_EOC) == FALSE);
  result = ADC1_GetConversionValue();
  ADC1_ClearFlag(ADC1_FLAG_EOC);
	
	return result; 
}

#ifdef USE_FULL_ASSERT 
void assert_failed(uint8_t* file, uint32_t line)
{ 
  /* User can add his own implementation to report the file name and line number,
     ex: printf("Wrong parameters value: file %s on line %d\r\n", file, line) */

  /* Infinite loop */
  while (1);
}
#endif
