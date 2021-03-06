import sys

arguments = len(sys.argv) - 1
position = 1
name = str(sys.argv[position+1])
while (arguments > position):       # changed >= to > to avoid error
	bench_freq_names = []
	path0 = "./%s/"%name+sys.argv[position]
	position = position+1
	print("the input file is ",path0) 
	c_0 = open(path0,'r')
	header=c_0.readline()
	l_0 = c_0.readline()
	w_0 = l_0.split()
	bench_name = w_0[1]
	freq_value = w_0[3]
	path_out = path0.split("/")
	path_out = path_out[-1].split(".")
	print("the benchmark name is ",bench_name)
	print("the freq value is ",freq_value) 
	bench_freq_names.append([bench_name,freq_value])
	output_file = "./%s/"%name+path_out[0]+"_"+bench_name+"_"+freq_value+".txt"
	m = open(output_file,'a')
	print(header.rstrip('\n'),file=m)
	print(l_0.rstrip('\n'),file=m)
	for l_0 in c_0: #read lines one by one
		w_0 = l_0.split()
		if (w_0[1] == bench_name and w_0[3] == freq_value):
			print(l_0.rstrip('\n'),file=m)
		else: #new_bench_name or new freq_value
			m.close() #close file
			bench_name = w_0[1] #update bench
			freq_value = w_0[3] #update freq
			print("the benchmark name is ",bench_name) 
			print("the freq value is ",freq_value)
			output_file = "./%s/"%name+path_out[0]+"_"+bench_name+"_"+freq_value+".txt"
			m = open(output_file,'a')
			if [bench_name,freq_value] not in bench_freq_names:
				bench_freq_names.append([bench_name,freq_value])
				print(header.rstrip('\n'),file=m)
			print(l_0.rstrip('\n'),file=m)
c_0.close()
m.close()


