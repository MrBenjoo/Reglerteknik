/*
 * adc.h
 *
 * Created: 2015-06-15 20:04:55
 *  Author: Daniel	Nordahl
 */ 


#ifndef ADC_H_
#define ADC_H_

#define ADC_CLOCK		1000000

void init_adc(void);

uint16_t read_adc_value(uint32_t);


#endif /* ADC_H_ */