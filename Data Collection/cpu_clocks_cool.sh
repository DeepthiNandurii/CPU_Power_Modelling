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
		echo -e "\t Inside cpu_clocks_cool.sh::do_temp() Reading CPU temperature from Thermal Zone 1:\n"
		echo -e "\t ${BRED}CPU current temp=$CPU_TEMP ${NC}\n"
}


do_fan()
{
	FAN_SPEED=255
		echo -e "\t ${BRED}Inside cpu_clocks_cool.sh::do_fan() Setting Fan Speed to $FAN_SPEED ${NC}\n"
		echo $FAN_SPEED > /sys/kernel/debug/tegra_fan/target_pwm

}

check_governor()	# Ensures USERSPACE governor is chosen to run benchmarks at different user-defined frequencies
{
	CPU_GOVERNOR=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor`
	SET_GOVERNOR=userspace
	if [[ $CPU_GOVERNOR != $SET_GOVERNOR ]];
	then
		echo -e "\t ${BRED} CPU_CLOCKS_COOL::check_governor() : Please set the governor to userspace ${NC}\n"
		echo -e "\t ${BGREEN} CPU_CLOCKS_COOL::HELP: cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor ${NC}\n"
		echo -e "\t ${BGREEN} Setting SCALING GOVERNOR to $SET_GOVERNOR ${NC}\n"
		echo $SET_GOVERNOR > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
	fi
	
	echo -e "\t ${BGREEN} SCALING GOVERNOR Check : SUCCESS ${NC} \n"	
}

check_cpu_idle()	# Helps DISABLE CPU_IDLE on all cores
{
	# Disable CPU_IDLE on all cores
	CPU0_IDLE=`cat /sys/devices/system/cpu/cpu0/cpuidle/state0/disable`
	CPU1_IDLE=`cat /sys/devices/system/cpu/cpu1/cpuidle/state0/disable`
	CPU2_IDLE=`cat /sys/devices/system/cpu/cpu2/cpuidle/state0/disable`
	CPU3_IDLE=`cat /sys/devices/system/cpu/cpu3/cpuidle/state0/disable`
	if [ $CPU0_IDLE == 0 ];
	then
	    echo -e "\t ${BRED} CPU_IDLE is NOT disabled on CPU0 \n"
	    echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state0/disable
	    echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state1/disable
	    echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state2/disable
	    echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state3/disable
	    echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state4/disable
	    echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state5/disable
	    echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state6/disable
	    echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state7/disable
	    echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state8/disable
	    echo 1 > /sys/devices/system/cpu/cpu0/cpuidle/state9/disable
	    echo -e "\t ${BGREEN} CPU_IDLE is now DISABLED on core 0! \n"
	    if [ $CPU1_IDLE == 0 ];
	    then
	        echo -e "\t ${BRED} CPU_IDLE is NOT disabled on CPU1 \n"
	        echo 1 > /sys/devices/system/cpu/cpu1/cpuidle/state0/disable
	        echo 1 > /sys/devices/system/cpu/cpu1/cpuidle/state1/disable
	        echo 1 > /sys/devices/system/cpu/cpu1/cpuidle/state2/disable
	        echo 1 > /sys/devices/system/cpu/cpu1/cpuidle/state3/disable
	        echo 1 > /sys/devices/system/cpu/cpu1/cpuidle/state4/disable
	        echo 1 > /sys/devices/system/cpu/cpu1/cpuidle/state5/disable
	        echo 1 > /sys/devices/system/cpu/cpu1/cpuidle/state6/disable
	        echo 1 > /sys/devices/system/cpu/cpu1/cpuidle/state7/disable
	        echo 1 > /sys/devices/system/cpu/cpu1/cpuidle/state8/disable
	        echo 1 > /sys/devices/system/cpu/cpu1/cpuidle/state9/disable
	        echo -e "\t ${BGREEN} CPU_IDLE is now DISABLED on core 1! \n"
		if [ $CPU2_IDLE == 0 ];
		then
		    echo -e "\t ${BRED} CPU_IDLE is NOT disabled on CPU2 \n"
		    echo 1 > /sys/devices/system/cpu/cpu2/cpuidle/state0/disable
		    echo 1 > /sys/devices/system/cpu/cpu2/cpuidle/state1/disable
		    echo 1 > /sys/devices/system/cpu/cpu2/cpuidle/state2/disable
		    echo 1 > /sys/devices/system/cpu/cpu2/cpuidle/state3/disable
		    echo 1 > /sys/devices/system/cpu/cpu2/cpuidle/state4/disable
		    echo 1 > /sys/devices/system/cpu/cpu2/cpuidle/state5/disable
		    echo 1 > /sys/devices/system/cpu/cpu2/cpuidle/state6/disable
		    echo 1 > /sys/devices/system/cpu/cpu2/cpuidle/state7/disable
		    echo 1 > /sys/devices/system/cpu/cpu2/cpuidle/state8/disable
		    echo 1 > /sys/devices/system/cpu/cpu2/cpuidle/state9/disable
		    echo -e "\t ${BGREEN} CPU_IDLE is now DISABLED on core 2! \n"
		    if [ $CPU3_IDLE == 0 ];
		    then
		        echo -e "\t ${BRED} CPU_IDLE is NOT disabled on CPU3 \n"
		        echo 1 > /sys/devices/system/cpu/cpu3/cpuidle/state0/disable
		        echo 1 > /sys/devices/system/cpu/cpu3/cpuidle/state1/disable
		        echo 1 > /sys/devices/system/cpu/cpu3/cpuidle/state2/disable
		        echo 1 > /sys/devices/system/cpu/cpu3/cpuidle/state3/disable
		        echo 1 > /sys/devices/system/cpu/cpu3/cpuidle/state4/disable
		        echo 1 > /sys/devices/system/cpu/cpu3/cpuidle/state5/disable
		        echo 1 > /sys/devices/system/cpu/cpu3/cpuidle/state6/disable
		        echo 1 > /sys/devices/system/cpu/cpu3/cpuidle/state7/disable
		        echo 1 > /sys/devices/system/cpu/cpu3/cpuidle/state8/disable
		        echo 1 > /sys/devices/system/cpu/cpu3/cpuidle/state9/disable
		        echo -e "\t ${BGREEN} CPU_IDLE is now DISABLED on core 3! \n"
		    fi
		fi
	    fi
	else	
	    echo -e "\t ${BGREEN} CPU_IDLE CHECK: DISABLED on all cores! \n"
	fi
}

read_cpu()
{

	CPU_MIN_FREQ=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq` 
		CPU_MAX_FREQ=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
		CPU_CUR_FREQ=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq` 
		CPU_CUR_VOLT=`cat /sys/kernel/debug/clock/vdd_cpu_mv`

		# CHECK
		CPU_FREQ_OVERRIDE=`cat /sys/kernel/debug/clock/override.gbus/state`
		echo -e "\n\tInside cpu_clocks_cool.sh::read_cpu()\n \t Min CPU frequency : $CPU_MIN_FREQ \t Max CPU Frequency : $CPU_MAX_FREQ\n"
		#echo "CurrentFreq=$CPU_CUR_FREQ CurrentVDD = $CPU_CUR_VOLT FreqOverride=$CPU_FREQ_OVERRIDE"
		echo -e "\t ${BGREEN}cpu_clocks_cool::read_cpu(): CurrentFreq=$CPU_CUR_FREQ CurrentVDD = $CPU_CUR_VOLT ${NC}\n"

}

do_cpu()
{

	CPU_NEW_FREQ=$1
	echo -e "\t${RED}cpu_clocks_cool.sh::do_cpu() : New Frequency to be set: $CPU_NEW_FREQ kHz${NC}"
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

			echo -e "\t Inside cpu_clocks_cool.sh::do_cpu()\n \t Min CPU frequency : $CPU_MIN_FREQ \t Max CPU Frequency : $CPU_MAX_FREQ\n"
			echo -e "\t${BGREEN}cpu_clocks_cool::do_cpu(): CurrentFreq=$CPU_CUR_FREQ CurrentVDD = $CPU_CUR_VOLT${NC}\n"
}

do_emc()
{
	EMC_MIN_FREQ=`cat /sys/kernel/debug/clock/override.emc/min`
		EMC_MAX_FREQ=`cat /sys/kernel/debug/clock/override.emc/max`
		EMC_CUR_FREQ=`cat /sys/kernel/debug/clock/override.emc/rate`
		EMC_FREQ_OVERRIDE=`cat /sys/kernel/debug/clock/override.emc/state`

		case $ACTION in
		show)
		echo -e "Inside cpu_clocks_cool.sh::do_emc()\n \t Min CPU frequency : $EMC_MIN_FREQ \t Max CPU Frequency : $EMC_MAX_FREQ\n"
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
					check_governor
					check_cpu_idle
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
