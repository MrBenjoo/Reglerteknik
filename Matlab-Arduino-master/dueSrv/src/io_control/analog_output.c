/*
 * Functions for creating a motor control
 * signal. This is done by using the pwm support in 
 * the SAM3x processor. DAC1 pin on due board is the pwm 
 * output. Signal frequency is set to 1kHz. Resolution is 
 * set to 255. 
 * Created: 2015-07-02 09:04:33
 *  Author: Daniel Nordahl
 */ 

#include <asf.h>
#include <pwm.h>
#include "analog_output.h"

static pwm_channel_t pwm_channel_instance;

void pwm_setup(){
	/* Enable the specified peripheral clock (PWM clock).
	   If function returns 0, then we can proceed... */
	if (pmc_enable_periph_clk(ID_PWM) == 0) {
		pwm_channel_disable(PWM, PWM_CHANNEL_0);
		pwm_clock_t clock_setting = {
			.ul_clka = PWM_FREQUENCY * PWM_RESOLUTION,
			.ul_clkb = 0,
			.ul_mck = sysclk_get_cpu_hz()
		};
		pwm_init(PWM, &clock_setting);
		pwm_channel_instance.alignment = PWM_ALIGN_LEFT;
		pwm_channel_instance.polarity = PWM_POLARITY;
		pwm_channel_instance.ul_prescaler = PWM_CMR_CPRE_CLKA;
		pwm_channel_instance.ul_period = PWM_RESOLUTION;
		pwm_channel_instance.ul_duty = 0;
		pwm_channel_instance.channel = PWM_CHANNEL_0;
		pwm_channel_init(PWM, &pwm_channel_instance);
		/* setup PWM for pin */
		pio_set_peripheral(PWM_PIO, PWM_PERIPHERAL, PWM_PIN);
		/* enable PWM channel */
		pwm_channel_enable(PWM, PWM_CHANNEL_0);	
		pwm_set_duty(0);
	}
}


void pwm_set_duty(uint32_t duty_cycle){
	/*Set duty cycle*/
	pwm_channel_update_duty(PWM,&pwm_channel_instance,duty_cycle);
}
