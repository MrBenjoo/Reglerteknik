/*
 *	This state machine handles communication with Matlab 
 *	each function in Matlab has a corresponding state. 
 *	The current functions are:
 *		pinMode
 *		digitalWrite
 *		digitalRead
 *		analogWrite
 *		analogRead
 *	More can be added if needed.
 *
 *  Created: 2015-06-15 20:31:34
 *  Author: Daniel
 */ 

#include <asf.h>
#include "io_control/io_uart.h"
#include "matlab_coms/matlab_functions.h"
#include "matlab_coms/matlab_state.h"


void start_coms(){
	
	uint8_t pin;
	uint8_t val;
	uint16_t adc_val;
	pin = 0;
	val = 0;
	adc_val = 0;
	
	state next_state = STANDBY;
	state current_state = STANDBY;
	/*Run state machine*/
	while (1)
	{
		switch(current_state){
			case STANDBY:
			switch (read_char())
			{
				case ENQUIRY:
				next_state = HANDSHAKE;
				break;
				case PIN_MODE:
				next_state = P_MODE;
				break;
				case DIGITAL_WRITE:
				next_state = D_WRITE;
				break;
				case DIGITAL_READ:
				next_state = D_READ;
				break;
				case ANALOG_WRITE:
				next_state = A_WRITE;
				break;
				case ANALOG_READ:
				next_state = A_READ;
				break;
				case ANALOG_WRITE_D:
				next_state = A_WRITE_DAC;
				break;
			}
			break;
			
			case HANDSHAKE: /*Handshake with matlab*/
			send_char_term(ACK);
			next_state = STANDBY;
			break;
			
			case P_MODE: 
			pin = read_when_ready();
			val = read_when_ready();
			io_pin_dir(pin,(val-10));	//calculate value
			pin = 0;
			val = 0;
			next_state = STANDBY;
			break;
			
			case D_WRITE:
			pin = read_when_ready();
			val = read_when_ready();
			io_pin_level(pin,(val-10));	//calculate value
			pin = 0;
			val = 0;
			next_state = STANDBY;
			break;
			
			case D_READ:
			pin = read_when_ready();
			val = io_pin_status(pin);
			send_number(val);
			pin = 0;
			val = 0;
			next_state = STANDBY;
			break;
			
			case A_WRITE:
			val = read_when_ready();
			io_pwm_duty(val);
			val = 0;
			next_state = STANDBY;
			break;

			case A_WRITE_DAC:
			val = read_when_ready();
			io_dac_value(val);
			val = 0;
			next_state = STANDBY;
			break;
			
			case A_READ:
			pin = read_when_ready();
			adc_val = io_adc_value(pin);
			send_number(adc_val);
			pin = 0;
			adc_val = 0;
			next_state = STANDBY;
			break;
			
			
		}
		
		current_state = next_state;
		
		
	}
}

