#!/bin/bash
# Copyright (c) 2015-2016, NVIDIA CORPORATION. All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions
# are met:
#  * Redistributions of source code must retain the above copyright
#    notice, this list of conditions and the following disclaimer.
#  * Redistributions in binary form must reproduce the above copyright
#    notice, this list of conditions and the following disclaimer in the
#    documentation and/or other materials provided with the distribution.
#  * Neither the name of NVIDIA CORPORATION nor the names of its
#    contributors may be used to endorse or promote products derived
#    from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS ``AS IS'' AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT OWNER OR
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY
# OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

CONF_FILE=${HOME}/l4t_dfs.conf
RED='\e[0;31m'
GREEN='\e[0;32m'
BLUE='\e[0;34m'
BRED='\e[1;31m'
BGREEN='\e[1;32m'
BBLUE='\e[1;34m'
NC='\e[0m' # No Color

do_temp()
{
	CPU_TEMP=`cat /sys/devices/virtual/thermal/thermal_zone1/temp`	# Thermal Zone 1: CPU
		echo -e "\t Inside cpu_clocks.sh::do_temp() Reading CPU temperature from Thermal Zone 1:\n"
		echo -e "\t${BRED} CPU current temp=$CPU_TEMP ${NC}\n"
}


do_fan()
{
	#FAN_SPEED=0	# trial 1	
	#FAN_SPEED=32	# trial 2
	#FAN_SPEED=64	# trial 3
	#FAN_SPEED=128	# trial 4
	#FAN_SPEED=160	# trial 5
	#FAN_SPEED=192	# trial 6
	FAN_SPEED=255	# trial 7, less than 2 hours
		echo -e "\t ${BRED}Inside cpu_clocks.sh::do_fan() Setting Fan Speed to $FAN_SPEED ${NC}\n"
		echo $FAN_SPEED > /sys/kernel/debug/tegra_fan/target_pwm

}


read_cpu()
{
	CPU_MIN_FREQ=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq` 
		CPU_MAX_FREQ=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
		CPU_CUR_FREQ=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq` 
		CPU_CUR_VOLT=`cat /sys/kernel/debug/clock/vdd_cpu_mv`

		CPU_FREQ_OVERRIDE=`cat /sys/kernel/debug/clock/override.gbus/state`
		echo -e "\n\tInside cpu_clock.sh::read_cpu() \n \t Min CPU frequency : $CPU_MIN_FREQ \t Max CPU Frequency : $CPU_MAX_FREQ\n"
		echo -e "\t${BGREEN}cpu_clocks.sh::read_cpu(): CurrentFreq=$CPU_CUR_FREQ CurrentVDD = $CPU_CUR_VOLT ${NC}\n"	
}

do_cpu()
{
	CPU_NEW_FREQ=$1
		echo -e "\t ${RED}cpu_clocks.sh::do_cpu() : New Frequency to be set: $CPU_NEW_FREQ kHz ${NC}"
		echo $CPU_NEW_FREQ > /sys/devices/system/cpu/cpu0/cpufreq/scaling_setspeed 
		echo $CPU_NEW_FREQ > /sys/devices/system/cpu/cpu1/cpufreq/scaling_setspeed 
		echo $CPU_NEW_FREQ > /sys/devices/system/cpu/cpu2/cpufreq/scaling_setspeed 
		echo $CPU_NEW_FREQ > /sys/devices/system/cpu/cpu3/cpufreq/scaling_setspeed 

		echo 1 > /sys/kernel/debug/clock/override.gbus/state
		ret=$?
		if [ ${ret} -ne 0 ]; then
			echo "Error: Failed to set new CPU frequency!"
				fi

				CPU_MIN_FREQ=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq` 
				CPU_MAX_FREQ=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
				CPU_CUR_FREQ=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq` 
				CPU_CUR_VOLT=`cat /sys/kernel/debug/clock/vdd_cpu_mv`
				CPU_FREQ_OVERRIDE=`cat /sys/kernel/debug/clock/override.gbus/state`	
				echo -e "\tInside cpu_clocks.sh::do_cpu()\n \t Min CPU frequency : $CPU_MIN_FREQ \t Max CPU Frequency : $CPU_MAX_FREQ\n"
				echo -e "\t${BGREEN}cpu_clocks.sh::do_cpu(): CurrentFreq=$CPU_CUR_FREQ CurrentVDD = $CPU_CUR_VOLT${NC}\n"	
}

do_emc()
{
		EMC_MIN_FREQ=`cat /sys/kernel/debug/clock/override.emc/min`
		EMC_MAX_FREQ=`cat /sys/kernel/debug/clock/override.emc/max`
		EMC_CUR_FREQ=`cat /sys/kernel/debug/clock/override.emc/rate`
		EMC_FREQ_OVERRIDE=`cat /sys/kernel/debug/clock/override.emc/state`

		case $ACTION in
		show)
		echo -e "Inside cpu_clocks.sh::do_emc()\n \t Min CPU frequency : $EMC_MIN_FREQ \t Max CPU Frequency : $EMC_MAX_FREQ\n"
		echo "EMC MinFreq=$EMC_MIN_FREQ MaxFreq=$EMC_MAX_FREQ CurrentFreq=$EMC_CUR_FREQ FreqOverride=$EMC_FREQ_OVERRIDE"
		;;
	store)
		store /sys/kernel/debug/clock/override.emc/rate
		store /sys/kernel/debug/clock/override.emc/state
		;;
	*)
		echo $EMC_MAX_FREQ > /sys/kernel/debug/clock/override.emc/rate
		echo 1 > /sys/kernel/debug/clock/override.emc/state
		;;
	esac
}



main ()
{

	[ `whoami` != root ] && echo Error: Run this script\($0\) as a root user && exit 1

		CPUFREQ=$2	

			while [ -n "$1" ]; do
	case "$1" in
				--set)
					ACTION=set
					;;
				--read)		
					ACTION=read
					;;
				esac
					shift 1
					done
					case $ACTION in
					set)
					do_fan
					do_cpu $CPUFREQ
					do_temp
					#do_emc
					#do_fan
					;;
				read)
					read_cpu
					do_temp
					;;
				esac
}

main $@
exit 0
