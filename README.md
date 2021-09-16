# CPU_Power_Modelling
# Power Modelling of ARM Cortex-A57 CPU on NVIDIA Jetson TX1

*******************************************************************************
# Step 1: Data Collection (Requires NVIDIA Jetson TX1)
1)  Go to Data_Collection/
2)  Run the makefile to compile the files: 
            make -f Makefile_cpu cpu_pow
4)  Run executable to start the benchmark run and collect data: 
            sudo ./pmon_cpu
5)  Raw data file is dumped: 
            power_measurement_log_a57.dat
*******************************************************************************

# Step 2: Post Processing (Offline)
1)  Transfer the raw data file (.dat) obtained in step 1 onto another machine 
    which can run python3.6 and bash scripts.
2)  Go to Post_Processing/
3)  Run the step which splits the .dat file into individual BM+Freq logs using: 
            python3.6 splitter_freq.py power_measurement_log_a57.dat
4)  Merge the files obtained in step-3 into a global log using: 
5)          python3.6 global_merger_nvidia.py
6)  To complete steps 3 & 4, there are separate targets within the
    Makefile_split_and_merge_new such as: 
            make -f Makefile_split_and_merge_new dir_0_cBenchtrain 
    This will create a separate directory called run_0_cBenchtrain after running 
    steps 3 & 4.
6)  Run step 5 for all the required BM logs.
7)  Concatenate merged logs obtained for training set (cBenchtrain) and test
    set(cBenchtest) using one of the targets in the Makefile_split_and_merge_new as:
            make -f Makefile_split_and_merge_new create_run_0_dir
8)  The concatenated file is fed to the script in the modeling and validation
    step.

***********************************************************************************

# Step 3: Power Modeling and Validation
1)  Go to Modeling_and_Validation
2)  Ensure the following files are present in the directory:
	   build_model.m
	   load_build_model.m
	   octave_makemodel.sh (Make it executable using chmod u+x
    octave_makemodel.sh).
	   benchmark_split.txt
3)  Generate and Validate the power model by launching the command: 
            make make_cpu_model
4)  The model details can be output into an output log using the -s option.
5)  Use ./octave_makemodel.sh -h to open the help menu.

#################################################################################

CREDITS:
1)  Dr Jose Nunez Yanez, Department of Electrical and Electronic Engineering, University of Bristol
2)  Dr Kris Nikov, Department of Computer Science, University of Bristol

This project work serves as an extension to the work carried out by Dr Jose Nunez-Yanez
and Dr Kris Nikov in their published work for the Maxwell GPU on Jetson TX1:

"Run-Time Power Modelling in Embedded GPUs with Dynamic Voltage and Frequency 
Scaling" published in the PARMA-DITAM 2020 as part of the HIPEAC conference.
Authors: Jose Nunez-Yanez, Kris Nikov, Kerstin Eder, Mohammad Hosseinabady
Department of Electrical and Electronic Engineering, University of Bristol, 
United Kingdom

*********************************************************************************

REFERENCES:
1)  GPU Power Model: https://github.com/kranik/ARMPM_BUILDMODEL/tree/GPU_tx1
2)  Original Modeling scripts adopted from Dr Kris Nikov's Doctoral Thesis
    project: https://github.com/kranik/ARMPM_BUILDMODEL/tree/master
3)  Kris Nikov. Robust Energy and Power Predictor Selection. url: 
    https://github.com/TSL-UOB/TP-REPPS
4)  Kris Nikov and Jose Nunez-Yanez. "Intra and Inter-Core Power Modelling
    for Single-ISA Heterogeneous Processors". In: International Journal
    of Embedded Systems (2020)

#################################################################################
