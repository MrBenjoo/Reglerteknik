/**
 *	Communication between matlab and arduino due, ued in the curse
 *  inbyggda system och signaler at Malmö University. Communications is controlled
 *	with a state machine, that handles incoming requests from matlab.  
 *	Communication can be run with either a wired interface or via bluethooth.
 *	
 *	Author: Daniel Nordahl
 */

#include <asf.h>
#include "io_control/analog_output.h"
#include "io_control/adc.h"
#include "matlab_coms/matlab_state.h"
#include "io_control/io_uart.h"
#include "common/pin_mapper.h"
#include "io_control/dac.h"

#define UART_BAUDRATE	115200		//Baud must be the same in Matlab

int main (void)
{
	sysclk_init();
	board_init();
	uart_config((uint32_t)UART_BAUDRATE);
	init_adc();
	pwm_setup();
	dac_setup();
	start_coms();					//Run state machine
	
	
}
