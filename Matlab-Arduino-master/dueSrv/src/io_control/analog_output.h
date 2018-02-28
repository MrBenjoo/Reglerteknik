/*
 * analog_output.h
 *
 * Created: 2015-07-02 09:04:50
 *  Author: Daniel
 */ 


#ifndef ANALOG_OUTPUT_H_
#define ANALOG_OUTPUT_H_

#define PWM_FREQUENCY	1000
#define PWM_RESOLUTION	255
#define PWM_PIO			PIOB
#define PWM_PERIPHERAL	PIO_PERIPH_B
#define PWM_PIN			PIO_PB16B_PWML0
#define PWM_POLARITY	PWM_LOW

void pwm_setup(void);
void pwm_set_duty(uint32_t);



#endif /* ANALOG_OUTPUT_H_ */