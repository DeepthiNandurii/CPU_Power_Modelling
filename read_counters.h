

/*******************************************************************************
--------------------------------------------------------------------------------

		File		: 		read_counters.h

		Date		: 		15/09/2021
		
		Author		:		Deepthi Nanduri
		
		UserID		:		fc20725@bristol.ac.uk
		
		Description	:		Uses inline assembly to read the PMU event count info from system registers.
							PMCCNTR register : Holds the value of processor Cycle count (helps calculate the activity density).
							PMCCNTR increments is dependent on the configuration of the PMCCFILTR_EL0 register.
							PMCCNTR counts processor clock cycles [Reference: ARMv8 Architecture Reference Manual]  
							
----------------------------------------------------------------------------------
**********************************************************************************/


#define SEL 0x8000001f		// Helps select the cycle counter
#define PMCR_E (1<<0)		// Set the enable bit on PMCR register
#define PMCR_RST (1<<1)		// Set the reset bit on PMCR register

typedef unsigned int uint32_t;

/* Save counter value before operation (pre-count values) */
    static int prc0,prc1,prc2,prc3,prc4,prc5,prc6;

/* Save counter value after operation (post-count values) */
    static int poc0,poc1,poc2,poc3,poc4,poc5,poc6;
    static float cnt0,cnt1,cnt2,cnt3,cnt4,cnt5,cycle_count;

    static float ccnt_pre;	/* Variable to store Processor Cycle Count before running a BM */
    static float ccnt_post;	/* Variable to store Processor Cycle Count after running a BM */

    static uint32_t c_count; 
    
    void init_counters()
    {
    
    uint32_t en;
    /* Enable the counting using the Control Register */
    asm volatile("msr pmcr_el0,%0" :: "r" (en|PMCR_E));

    /* Set PM counter set enable register 
    to allow countng on available external system registers
    */ 
    asm volatile("msr pmcntenset_el0,%0" :: "r" (0x8000003f));
    
    asm volatile("msr pmselr_el0, %0" :: "r" (SEL));
    printf("\t read_counters.h::init_counters() \t Value of Processor Cycle Count: %0d \n",c_count);
    
    }

    void read_a57_counters(char sel) {
    if(sel=='b')
    {
    printf("\tReading Performance Counter values before running benchmark \n");
   
    asm volatile("mrs %0, pmevcntr0_el0":"=r"(prc0));
    printf("\t Value of counter 0: %0d \n",prc0);

    asm volatile("mrs %0, pmevcntr1_el0":"=r"(prc1));
    printf("\t Value of counter 1: %0d \n",prc1);
    
    asm volatile("mrs %0, pmevcntr2_el0":"=r"(prc2));
    printf("\t Value of counter 2: %0d \n",prc2);

    asm volatile("mrs %0, pmevcntr3_el0":"=r"(prc3));
    printf("\t Value of counter 3: %0d \n",prc3);

    asm volatile("mrs %0, pmevcntr4_el0":"=r"(prc4));
    printf("\t Value of counter 4: %0d \n",prc4);

    asm volatile("mrs %0, pmevcntr5_el0":"=r"(prc5));
    printf("\t Value of counter 5: %0d \n",prc5);
    
    }
    else if (sel=='a')
    {
    printf("\t read_counters.h::read_a57_counters(): Reading Performance Counter values after running benchmark... \n");
    asm volatile("mrs %0, pmccntr_el0":"=r" (c_count));
    ccnt_post = c_count;
    
    asm volatile("mrs %0, pmevcntr0_el0":"=r"(poc0));
    printf("\t Value of counter 0: %0d \n",poc0);
    cnt0 = (poc0)/ccnt_post;
    printf("\t Counter 0 activity density for the given workload: %0f \n",cnt0);

    asm volatile("mrs %0, pmevcntr1_el0":"=r"(poc1));
    printf("\t Value of counter 1: %0d \n",poc1);
    cnt1 = (poc1)/ccnt_post;
    printf("\t Counter 1 activity density for the given workload: %0f \n",cnt1);
    
    asm volatile("mrs %0, pmevcntr2_el0":"=r"(poc2));
    printf("\t Value of counter 2: %0d \n",poc2);
    cnt2 = (poc2)/ccnt_post;
    printf("\t Counter 2 activity density for the given workload: %0f \n",cnt2);

    asm volatile("mrs %0, pmevcntr3_el0":"=r"(poc3));
    printf("\t Value of counter 3: %0d \n",poc3);
    cnt3 = (poc3)/ccnt_post;
    printf("\t Counter 3 activity density for the given workload: %0f \n",cnt3);

    asm volatile("mrs %0, pmevcntr4_el0":"=r"(poc4));
    printf("\t Value of counter 4: %0d \n",poc4);
    cnt4 = (poc4)/ccnt_post;
    printf("\t Counter 4 activity density for the given workload: %0f \n",cnt4);

    asm volatile("mrs %0, pmevcntr5_el0":"=r"(poc5));
    printf("\t Value of counter 5: %0d \n",poc5);
    cnt5 = (poc5)/ccnt_post;
    printf("\t Counter 5 activity density for the given workload: %0f \n",cnt5);

    printf("\t read_counters.h::read_a57_counters(): FINISHED Reading Performance Counter values after running benchmark... \n");
    
    }
}
void disable_counters()
{
	
    /* Reset event counters */
    asm volatile("msr pmcr_el0,%0" :: "r" (PMCR_RST));
    
}
void proc_cycle_count_mon()	// Function to read Cycle Counts
{
    asm volatile("mrs %0, pmccntr_el0":"=r" (c_count));	// CYCLE_COUNT FILTER REGISTER
    printf("\t read_counters.h::proc_cycle_count_mon() \t Value of Processor Cycle Count: %0d \n",c_count);

}
