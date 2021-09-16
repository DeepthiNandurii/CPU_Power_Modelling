# Makefile : To create and validate power models

make_cpu_model:
	./octave_makemodel.sh -r power_measurement_merged_global.txt -b benchmark_split.txt -f 102,204,307,403,518,614,710,825,921,1036,1132,1224,1326,1428,1555,1632,1734 -p 7 -m 1 -l 8,9,10,11,12,13 -n 6 -c 1 -o 2 -s model_eventgrp2_PWM_255.txt

make_gpu_model:
	./octave_makemodel.sh -r power_measurement_merged_global.txt -b benchmark_split.txt -f 76,153,230,307,384,460,537,614,691,768,844,921,998 -p 7 -m 1 -l 8,9,10,11,12,13 -n 3 -c 1 -o 2 -s model_.txt
