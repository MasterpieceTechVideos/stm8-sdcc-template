#ifndef MAIN_H_
#define MAIN_H_

#include <stdint.h>

void Delay(uint16_t nCount);
void GPIO_Config(void);
void ADC_Config(void);
unsigned int ADC_Read(void);

#endif /* MAIN_H_ */