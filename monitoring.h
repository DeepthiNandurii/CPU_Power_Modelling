#ifndef __MONITORING__H__
#define __MONITORING__H__

#include <stdio.h>
#include <unistd.h>
#include <pthread.h>
#include <string.h>
#include <math.h>
#include <sys/time.h>
#include <time.h>


struct a57_sample {

	struct timeval start_time;
	struct timeval end_time;

	double  cpu_power;
	double  in_power;
	struct a57_sample *next;
};



void *a57_read_samples(void *head);
void *a57_read_sample_pthread();
void a57_read_sample_start();
void a57_read_sample_stop(); 
void a57_save_average_pthread(struct a57_sample *head, char *file_name);
void a57_clear_sample_pthread(struct a57_sample *head);

void file_power_profile_create (char *file_name);
void power_monitoring_prologue();
void power_monitoring_epilogue();
void power_monitoring_stop();



#endif //__MONITORING__H__
