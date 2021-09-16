import os.path
import sys
run_number=1

name = sys.argv[1]      # FORMAT : run_<fan_speed>_<BM_name>
name2 = sys.argv[2]     # FORMAT : <BM_name>_<fan_speed>

name_split = name.split("_")

#print(f'\n \t name_split values are {name_split}\n')

# cBench training set BMs
#if(name_split[2]=="cBenchtrain"):
 #benchmarks = ["consumer_tiff2bw","automotive_susan_c","automotive_susan_e","automotive_susan_s","office_stringsearch1","security_rijndael_e","security_rijndael_d","automotive_bitcount","consumer_tiffmedian","telecom_adpcm_d","telecom_adpcm_c","telecom_CRC32"]
	
if(name_split[2]=="cBenchtrain"):
 benchmarks = ["telecom_CRC32","consumer_tiffdither","telecom_gsm","bzip2d","consumer_tiffmedian","consumer_jpeg_c","office_stringsearch1","automotive_susan_s","telecom_adpcm_d","automotive_susan_c","security_sha","security_rijndael_d","consumer_tiff2rgba"]
# cBench test set BMs
#if(name_split[2]=="cBenchtest"):
 #benchmarks = ["security_blowfish_e","security_blowfish_d","consumer_tiffdither","automotive_qsort1","network_patricia","office_rsynth","telecom_gsm","security_sha","network_dijkstra"]
 
if(name_split[2]=="cBenchtest"):
 benchmarks = ["consumer_jpeg_d","security_blowfish_e","network_dijkstra","security_blowfish_d","automotive_susan_e","automotive_qsort1","automotive_bitcount","security_rijndael_e","telecom_adpcm_c","bzip2e","network_patricia","office_rsynth","consumer_tiff2bw"]

# CPU frequencies - as per DVFS table
freqs = ["102","204","307","403","518","614","710","825","921","1036","1132","1224","1326","1428","1555","1632","1734"]     # ALL 17 freq

runs = ["1"]

merged_log_path = f'./{name}/power_measurement_merged_global.txt'

m = open(merged_log_path,'w')
for benchmark in benchmarks:
    for freq in freqs:
        
        s_p=[0.0] * 100000
        s_0=[0.0] * 100000
        s_1=[0.0] * 100000
        s_2=[0.0] * 100000
        s_3=[0.0] * 100000
        s_4=[0.0] * 100000
        s_5=[0.0] * 100000
                
        for run in runs:
            fline=0
            path0 = f'./{name}/power_a57_{name2}_'+benchmark+"_"+freq+".txt"    # counter 0, BM, freq
            path1 = f'./{name}/power_a57_{name2}_'+benchmark+"_"+freq+".txt"    # counter 1, BM, freq
            path2 = f'./{name}/power_a57_{name2}_'+benchmark+"_"+freq+".txt"    # counter 2, BM, freq
            path3 = f'./{name}/power_a57_{name2}_'+benchmark+"_"+freq+".txt"    # counter 3, BM, freq
            path4 = f'./{name}/power_a57_{name2}_'+benchmark+"_"+freq+".txt"    # counter 4, BM, freq
            path5 = f'./{name}/power_a57_{name2}_'+benchmark+"_"+freq+".txt"    # counter 5, BM, freq
            
            if os.path.isfile(path0):
                c_0 = open(path0,'r')
            if os.path.isfile(path1):
                c_1 = open(path1,'r')
            if os.path.isfile(path2):
                c_2 = open(path2,'r')
            if os.path.isfile(path3):
                c_3 = open(path3,'r')
            if os.path.isfile(path4):
                c_4 = open(path4,'r')
            if os.path.isfile(path5):
                c_5 = open(path5,'r')
            
            l_0=c_0.readline()
            l_1=c_1.readline()
            l_2=c_2.readline()
            l_3=c_3.readline()
            l_4=c_4.readline()
            l_5=c_5.readline()
            
            no_line=0
            #if benchmark == "binomialOPtions" and freq == "102" and run == "1":    # uncomment if using nvidia BM as training set
            if benchmark == "telecom_CRC32" and freq == "102" and run == "1":
                print(l_0.rstrip('\n'),file=m)
            print(f'\tBenchmark: {benchmark} \t Frequency: {freq}\n')
            for l_0 in c_0: #read lines one by one
                l_1=c_1.readline()
                if len(l_1) == 0:
                    no_line = 1
                l_2=c_2.readline()
                if len(l_2) == 0:
                    no_line = 1
                l_3=c_3.readline()
                if len(l_3) == 0:
                    no_line = 1
                l_4=c_4.readline()
                if len(l_4) == 0:
                    no_line = 1
                l_5=c_5.readline()
                if len(l_5) == 0:
                    no_line = 1
                
                w_0 = l_0.split()
                w_1 = l_1.split()
                w_2 = l_2.split()
                w_3 = l_3.split()
                w_4 = l_4.split()
                w_5 = l_5.split()
                
                if (no_line == 0):
                    if (run == str(run_number)):
                        s_l = (float(w_0[6]))
                        s_p[fline]=(s_p[fline]+s_l)/run_number
                        s_0[fline]=(s_0[fline]+float(w_0[7]))/run_number
                        s_1[fline]=(s_1[fline]+float(w_1[8]))/run_number
                        s_2[fline]=(s_2[fline]+float(w_2[9]))/run_number
                        s_3[fline]=(s_3[fline]+float(w_3[10]))/run_number
                        s_4[fline]=(s_4[fline]+float(w_4[11]))/run_number
                        s_5[fline]=(s_5[fline]+float(w_5[12]))/run_number
                        
                        new_line = w_0[0]+"\t"+w_0[1]+"\t"+w_0[2]+"\t"+w_0[3]+"\t"+w_0[4]+"\t"+w_0[5]+"\t"+str(s_p[fline])+"\t"+str(s_0[fline])+"\t"+str(s_1[fline])+"\t"+str(s_2[fline])+"\t"+str(s_3[fline])+"\t"+str(s_4[fline])+"\t"+str(s_5[fline])
                        
                        print(new_line,file=m)
                    #else:
                    #    if (w_0[7]) == "nan":
                    #        w_0[7] = "0.0"
                    #        s_l = (float(w_0[6]))
                    #        s_p[fline]=s_p[fline]+s_l
                    #        s_0[fline]=s_0[fline]+float(w_0[7])
                fline=fline+1

c_0.close()
c_1.close()
c_2.close()
c_3.close()
c_4.close()
c_5.close()
m.close()
print(f'\tCreating Global Merged Log...DONE!\n')
