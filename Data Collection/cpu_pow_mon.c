
/*******************************************************************************
--------------------------------------------------------------------------------

		File		: 		Wrapper Script - cpu_pow_mon.c

		Date		: 		15/09/2021
		
		Author		:		Deepthi Nanduri
		
		UserID		:		fc20725@bristol.ac.uk
		
		Description	:		This file is the wrapper script to control the frequencies to be set
							and launches the scripts to start the benchmark run
							
----------------------------------------------------------------------------------
**********************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include "utilities.h"
#include "monitoring.h"
#include "jtx1inst.h"
#include "unistd.h"

int main(void) {

	printf("\n\t\t CPU POW MON:: Starting power monitor...\n");

	int freqs[17] = {102000, 204000, 307200, 403200, 518400, 614400, 710400, 825600, 921600, 1036800, 1132800, 1224000, 1326000, 1428000, 1555500, 1632000, 1734000};	//CPU frequency in kHz

	char cmdbuf[256];

	snprintf(cmdbuf,sizeof(cmdbuf),"./cpu_clocks_cool.sh --set 102000"); 
	int ret = system(cmdbuf);
	if (ret == -1)
	{
	printf("\tThis system method failed\n");
	}
	
	usleep(100000000); //wait for some for temperature to settle

	printf("\tStarting Monitoring prologue...\n");
	power_monitoring_prologue ();
	printf("\tMonitoring prologue Done...\n");

	for(int cfreq=0;cfreq<17;cfreq++)	
	{
		printf("\t cpu_pow_mon.c::main() : Setting CPU frequency (kHz) to %d\n",freqs[cfreq]);

		snprintf(cmdbuf,sizeof(cmdbuf),"./cpu_clocks.sh --set %d",freqs[cfreq]);
		system(cmdbuf);
		
		
		// Launch Train set (cBench) benchmarks
		printf("\tLaunching cBench_training BM...\n");
		
		system("./cBench_V1.1_dataset/all_run__1_dataset_timestamp");
		
		printf("\tFinished cBench_training BM...\n");

	}

	printf("\tStarting Monitoring epilogue...\n");
	power_monitoring_epilogue();
	printf("\tMonitoring epilogue Done...\n");


	printf("\t Finishing power monitor...\n");

	printf("\tRead CPU freqs...\n");
	system("./cpu_clocks.sh --read");


	return 0;	
}
