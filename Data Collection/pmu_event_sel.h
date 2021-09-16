#include <stdio.h>
#include <stdlib.h>

void choose_events(int sel)
{
	printf("\tpmu_event_sel.h::choose_events() : Choosing Events(6) for Monitoring\n");
    switch (sel){
	    case 1:		/*	PMU v3 required events from ARMv8A reference : ARM RECOMMENDED	*/
	    asm volatile("msr pmevtyper4_el0,%0" :: "r" (0x014));	// L1I_CACHE_ACCESS
	    asm volatile("msr pmevtyper1_el0,%0" :: "r" (0x004));	// Attributable L1 data cache access
	    asm volatile("msr pmevtyper2_el0,%0" :: "r" (0x008));	// INSTRUCTION ARCHITECTURALLY EXECUTED
	    asm volatile("msr pmevtyper3_el0,%0" :: "r" (0x01D));	// BUS_CYCLES
	    asm volatile("msr pmevtyper0_el0,%0" :: "r" (0x011));	// CPU_CYCLES
	    asm volatile("msr pmevtyper5_el0,%0" :: "r" (0x012));	// PREDICTABLE BRANCH SPECULATIVELY EXECUTED
    	    printf("\n Counters chosen for monitoring:\n");
    	    printf("Counter 0: L1 INSTRUCTION CACHE ACCESS \n");
    	    printf("Counter 1: L1 DATA CACHE ACCESS \n");
    	    printf("Counter 2: INSTRUCTIONS RETIRED \n");
    	    printf("Counter 3: BUS_CYCLES \n");
    	    printf("Counter 4: CPU CYCLES \n");
    	    printf("Counter 5: PREDICTABLE BRANCH SPECULATIVELY EXECUTED \n");
	    /*
	    Other recommended events:
	    asm volatile("msr pmevtyper0_el0,%0" :: "r" (0x03));	// L1D_CACHE_REFILL : Attributable Level 1 Data Cache Refill
	    asm volatile("msr pmevtyper3_el0,%0" :: "r" (0x10));	// BRANCH_MISPREDICTION
	    0x00: SOFTWARE INCREMENT SW_INCR
	    0x1B - INST_SPEC : Operation Speculatively executed
	    */
	break;
	    case 2:		/* Per-frequency model: As per KN-JNY paper */
	    asm volatile("msr pmevtyper0_el0,%0" :: "r" (0x04));	// L1 data cache access
	    asm volatile("msr pmevtyper1_el0,%0" :: "r" (0x11));	// CPU_CYCLES
	    asm volatile("msr pmevtyper2_el0,%0" :: "r" (0x14));	// L1I_CACHE_ACCESS
	    asm volatile("msr pmevtyper3_el0,%0" :: "r" (0x1D));	// BUS_CYCLES
	    asm volatile("msr pmevtyper4_el0,%0" :: "r" (0x65));	// BUS_PERIPH_ACCESS
    	    asm volatile("msr pmevtyper5_el0,%0" :: "r" (0x79));	// BRANCH_SPEC_EXEC_RET
    	    printf("\n Counters chosen for monitoring:\n");
    	    printf("Counter 0: L1 DATA CACHE ACCESS \n");
    	    printf("Counter 1: CPU CYCLES \n");
    	    printf("Counter 2: L1 INSTRUCTION CACHE ACCESS \n");
    	    printf("Counter 3: BUS_CYCLES \n");
    	    printf("Counter 4: BUS ACCESS - PERIPHERAL \n");
    	    printf("Counter 5: BRANCH SPECULATIVELY EXECUTED - PROCEDURE RETURN \n");
	break;
		
	    case 3:			/*  Rance Rodrigues' model (RP1) */
	    asm volatile("msr pmevtyper2_el0,%0" :: "r" (0x14));	// L1I_CACHE_ACCESS
	    asm volatile("msr pmevtyper0_el0,%0" :: "r" (0x04));	// L1 data cache access
	    asm volatile("msr pmevtyper1_el0,%0" :: "r" (0x09));	// EXCEPTION_TAKEN
	    asm volatile("msr pmevtyper3_el0,%0" :: "r" (0x10));	// BRANCH_MISPREDICTION
    	    printf("\n Counters chosen for monitoring:\n");
    	    printf("Counter 0: L1 INSTRUCTION CACHE ACCESS \n");
    	    printf("Counter 1: L1 DATA CACHE ACCESS \n");
    	    printf("Counter 2: EXCEPTION_TAKEN \n");
    	    printf("Counter 3: BRANCH_MISPREDICTION \n");
	break;

	    case 4:			/*  Matt Walker's model		*/
	    asm volatile("msr pmevtyper0_el0,%0" :: "r" (0x14));	// L1I_CACHE_ACCESS
	    asm volatile("msr pmevtyper1_el0,%0" :: "r" (0x1B));	// INSTRUCTION SPECULATIVELY EXECUTED
	    asm volatile("msr pmevtyper2_el0,%0" :: "r" (0x50));	// L2 data cache access - read
	    asm volatile("msr pmevtyper3_el0,%0" :: "r" (0x19));	// BUS_ACCESS
	    asm volatile("msr pmevtyper4_el0,%0" :: "r" (0x6A));	// UNALIGNED ACCESS
	    asm volatile("msr pmevtyper5_el0,%0" :: "r" (0x11));	// CPU_CYCLES
	    
    	    printf("\n Counters chosen for monitoring:\n");
    	    printf("Counter 0: L1 INSTRUCTION CACHE ACCESS \n");
    	    printf("Counter 1: INSTRUCTION SPECULATIVELY EXECUTED \n");
    	    printf("Counter 2: L2 DATA CACHE ACCESS - read \n");
    	    printf("Counter 3: BUS_ACCESS \n");
    	    printf("Counter 4: UNALIGNED ACCESS \n");
    	    printf("Counter 5: CPU CYCLES \n");
	break;

	    default:
	    printf("\t***Invalid option in choose_events()***\n");
	    printf("Exiting Run...\n");
	    exit(0);
}

}
