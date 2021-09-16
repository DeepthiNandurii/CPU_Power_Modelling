#!/usr/bin/python3.6
'''
File: plotter.py
Author: Varun Anand(qm19068)
Description:    This script is used to generate 2D/3D plots from
                raw data files.
Usage:
    python3 plotter.py <.dat file>
    .dat files should be in the format: power_a57_<benchmark set>_<fan PWM>.dat
'''

import numpy as np
import matplotlib.pyplot as plt
import matplotlib.pylab as plb
from mpl_toolkits.mplot3d import Axes3D
import sys
import seaborn as sns
import statsmodels

# Open file for reading
f = sys.argv[1]                                                        
#print(f'filename is {f}')
items = str(f).split('_')
#print(f'split values of filename is {items}')
BM = items[2]
#print(f'BM is {BM}')
speed_val= items[3].split('.')
speed = speed_val[0]
#print(f'Fan PWM is {speed}')

# Extract columns
# 1. Power - col 7
# 2. Frequency - col 4
# 3. Temperature - col 5
# 4. Voltage - col 6
freq = [x.split(' ')[3] for x in open(f).readlines()[1:]]
freq_float = list(map(float,freq))                      # Frequency Values in floating point
temp = [x.split(' ')[4] for x in open(f).readlines()[1:]]
temp_float = list(map(float,temp))                      # Temperature Values in floating point
volt = [x.split(' ')[5] for x in open(f).readlines()[1:]]
volt_float = list(map(float,volt))                      # Voltage Values in floating point
power = [x.split(' ')[6] for x in open(f).readlines()[1:]]
power_float = list(map(float,power))                    # Power Values in floating point

'''
fig_name = f'FTP_plot_{BM}_{speed}'
print(f' figure name to be saved : {fig_name}')
'''

# Plot figures
#sns.set_style("white")
sns.set_style("dark")

# To plot Freq v/s Power plot
fig1 = plt.figure()
ax1 = plt.axes()                                         # For 2D plots
fig_name1 = f'FreqVSPower_plot_{BM}_{speed}'
print(f' figure name to be saved : {fig_name1}')
sns.regplot(freq_float,power_float,lowess=True,color='g')
plt.title(f'{fig_name1}')
ax1.set_xlabel('Frequency (MHz)')                       # For 2D/3D plot - Freq,temp,power
ax1.set_ylabel('Power (Watt)')                           # For 2D plot - Temp/Freq v/s Power
plt.savefig(f'{fig_name1}.png',dpi=300)
#plt.show()

# To plot Temp v/s Power plot
fig2 = plt.figure()
ax2 = plt.axes()                                         # For 2D plots
fig_name2 = f'TempVSPower_plot_{BM}_{speed}'
print(f' figure name to be saved : {fig_name2}')
sns.regplot(temp_float,power_float,lowess=True,color='g')
plt.title(f'{fig_name2}')
ax2.set_xlabel('Temperature (C)')                        # For 2D plot - Temp v/s Power
ax2.set_ylabel('Power (Watt)')                           # For 2D plot - Temp/Freq v/s Power
plt.savefig(f'{fig_name2}.png',dpi=300)
#plt.show()


# To plot Voltage v/s Power plot
fig3 = plt.figure()
ax3 = plt.axes()                                         # For 2D plots
fig_name3 = f'VoltageVSPower_plot_{BM}_{speed}'
print(f' figure name to be saved : {fig_name3}')
sns.regplot(volt_float,power_float,lowess=True,color='g')
plt.title(f'{fig_name3}')
ax3.set_xlabel('Voltage (V)')                          # For 2D plot - Voltage v/s Power
ax3.set_ylabel('Power (Watt)')                          # For 2D plot - Temp/Freq v/s Power
plt.savefig(f'{fig_name3}.png',dpi=300)
#plt.show()

# 3-axis graph for P,freq,temp comparison
fig4 = plt.figure()
ax4 = plt.axes(projection='3d')                         # For 3D plots
fig_name4 = f'Freq_Temp_Power_plot_{BM}_{speed}'
print(f' figure name to be saved : {fig_name4}')
ax4.scatter(freq_float,temp_float,power_float,color='g')                    # 3D scatter plot Freq,Temp,Power
#ax4.plot_trisurf(freq_float,temp_float,power_float,cmap=plt.cm.CMRmap)     # 3D scatter plot with solid surface
#ax4.plot_trisurf(freq_float,temp_float,power_float,cmap=plt.cm.Spectral)   # 3D scatter plot with solid surface
plt.title(f'{fig_name4}')
ax4.set_xlabel('Frequency (MHz)')                       # For 2D/3D plot - Freq,temp,power
ax4.set_ylabel('Temperature (C)')                       # For 3D plot - Freq,temp,power
ax4.set_zlabel('Power (Watt)')                          # For 3D plot - Freq,temp,power
plt.savefig(f'{fig_name4}.png',dpi=300)
plt.show()
