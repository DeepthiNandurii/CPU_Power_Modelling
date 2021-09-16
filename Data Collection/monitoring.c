#include "monitoring.h"


struct a57_sample *head;


void power_monitoring_prologue () {

	head = (struct a57_sample *)a57_read_sample_pthread();

	a57_read_sample_start();
}



void power_monitoring_stop() {
	
	a57_read_sample_stop();
}
void power_monitoring_epilogue() {
	power_monitoring_stop();
	a57_clear_sample_pthread(head);
}


