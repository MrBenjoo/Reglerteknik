/*
 * matlab_functions.h
 *
 * Created: 2015-06-15 20:32:38
 *  Author: Daniel Nordahl
 */ 

#include <asf.h>
#ifndef MATLAB_FUNCTIONS_H_
#define MATLAB_FUNCTIONS_H_

void io_pin_dir(uint8_t,int8_t);
void io_pin_level(int8_t,int8_t);
int8_t io_pin_status(int8_t);
extern void send_char_term(uint8_t);
extern void send_char_no_term(uint8_t);
extern uint8_t read_char(void);
extern uint8_t read_when_ready(void);
extern void send_number(uint16_t);
void io_pwm_duty(uint8_t);
uint16_t io_adc_value(uint32_t);
void io_dac_value(uint8_t);



#endif /* MATLAB_FUNCTIONS_H_ */