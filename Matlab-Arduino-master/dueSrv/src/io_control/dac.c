/*
 * Digital to analog driver
 *
 * Created: 2013-12-10 08:30:13
 *  Author: Tommy Andersson
 *	Modified by: Daniel Nordahl
 */ 
 #include <asf.h>
 #include "io_control/dac.h"
 #include "common/pin_mapper.h"

 void dac_setup() {
	 pmc_enable_periph_clk(ID_DACC);
	 dacc_reset(DACC);
	 dacc_set_transfer_mode(DACC, 0);
	 dacc_set_timing(DACC,1,1,0);			//1 is shortest refresh period, 1 max. speed, 0 startup time
	 
	 dacc_set_channel_selection(DACC,0);	//Channel DAC0
	 dacc_enable_channel(DACC, 0);			//enable DAC0
 }

 void dac_write(uint32_t value){
	uint32_t dac_val;
	dac_val = map_value(value,0,255,0,4095);
	dacc_write_conversion_data(DACC,dac_val);
 }