/*
 * matlab_state.h
 *
 * Created: 2015-06-15 20:31:47
 *  Author: Daniel	Nordahl
 */ 

#include "asf.h"
#ifndef MATLAB_STATE_H_
#define MATLAB_STATE_H_

#define ACK				6
#define ENQUIRY			5
#define PIN_MODE		86
#define DIGITAL_WRITE   87
#define DIGITAL_READ	88
#define ANALOG_WRITE	89
#define ANALOG_READ		90
#define ANALOG_WRITE_D  91

typedef enum{
	STANDBY,
	HANDSHAKE,
	P_MODE,
	D_WRITE,
	D_READ,
	A_WRITE,
	A_WRITE_DAC,
	A_READ
} state;


void start_coms(void);



#endif /* MATLAB_STATE_H_ */