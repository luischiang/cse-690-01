import sys
import os

# output fiile: MAPPING
if __name__ == "__main__":
	

	f = open(sys.argv[1])
	fout = open("MAPPING", "w+")
	for line in f:
		a1 = line.split(':')[1:] 
		a2 = a1[0]
		a3 = a2.split()
		nodeid = a3[-1]
		nodename = "".join(a3[:-1])
		print nodeid, nodename

		fout.write("%s %s \n" % (nodename, nodeid))

	f.close()
	fout.close()
