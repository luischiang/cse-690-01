#
# Cheng-Chun Tu: MB topology parser
# Nov 5, 2012
#
import os
import sys
import random
import logging
import itertools

#logger = logging.getLogger(__name__)
#hdlr = logging.FileHandler("/var/tmp/" + __name__ + ".log")
#hdlr = logging.StreamHandler(sys.stdout)

# some global variables

NUM_LGCHAIN = int(sys.argv[6]) # number of logical chain randomly added to a pair of hosts
NUM_MB = 22 # number of middlebox randomly added
NUM_POLICY = 5 # number of lines (rules) in the Policy File
NUM_HOST = 0
NUM_SW = 0

NODEID = {} 
# all nodes, including switches, MBs, and hosts
#{'S9': 'Atlanta', 'S8': 'Indy', 'H1': 'Host1'}
TOPO_LIST = []

# --- Host --- #
HOST_LIST = []
HOST2SW_RES = 100000 # link cap between host and sw

# --- Switch --- #
SW_LIST = []
NUM_RULE = int(sys.argv[7])

# --- Middle Box --- #
MB_LIST = []
MB_TYPE = ["FIREWALL", "IDS"] 
MB_TYPE_ATTACH = [] # the type of MB we attach to the network
MB_RESOURCE = 1000000 #middlebox resource
MB2SW_RES = 1000000 # link cap between mb and sw
MB_CHAIN_DEPTH = int(sys.argv[8])

# --- Output File Name Prefix --- #
PRE_TOPO = "Topology_"
PRE_MBIN = "MboxInventory_"
PRE_SWIN = "SwitchInventory_"
PRE_POLI = "PolicyChains_"
PRE_CONF = "Config_"
PRE_TM 	 = "TrafficMatrix_"

# --- Traffic Volume --- #
TRAFFIC_MATRIX = {} 
# ex: {"1 2": 100, "2 3": 200}

def convert_node2id(node_str):
	""" 
	ex: node = "S1" , return 1
    	node = "H1", return 44
	sequence: NUMSWITCHES, NUMHOSTNODES, NUMMBOXES
	"""
	global NUM_HOST, NUM_SW
	assert(NUM_HOST != 0 and NUM_SW != 0)

	nid = int(node_str[1:])

	if node_str.startswith("S"):
		nid = nid
	elif node_str.startswith("H"):
		nid = nid	
	elif node_str.startswith("M"):
		nid = nid + NUM_SW + NUM_HOST
	else:
		print "Unsupport Node Type:", node_str
		sys.exit(1)

	return nid

def parse_traffic(filename, out_filename, total_volume):
	"""
	the format is path
	;FractionofTotalTrafficContributedByThisPath e.g.,  
	in abilene "1 4 6 8 7 11 10 ;0.000762114062241613" 
	--> source is 1 (Settle) destination is 10 (Wash) and this traffic contributes 0.00076 of the total network traffic,

	## Ingress Egress PolicyChain Volume
	H1 H2 FIREWALL,IDS 100

	== Output a host to host traffic volume
	"""
	global TRAFFIC_MATRIX
	f = open(filename)
        f_out = open(out_filename, "w+")
	f_out.write("#HostID HostID Volume/Flows\n")	
	
	for line in f:
		path = line.split(';')[0]
		frac = float(line.split(';')[1])
		assert(len(path) >= 1)
		assert(frac <= 1)
		volume = frac * int(total_volume)
		frm = path.split()[0] 
		to = path.split()[-1]
		f_out.write("%s %s %d\n" % (frm, to, volume))
		TRAFFIC_MATRIX["%s %s" % (frm ,to)] = volume
		
	f.close()
	f_out.close()

def parse_nodeid(nodeid_file):
	""" 
	return a dict { id: "name""}, ex: {S1: California} 
	three lists are built here: MB_LIST, HOST_LIST, and SW_LIST
	"""
	global SW_LIST, HOST_LIST, NUM_MB, NUM_HOST, NUM_SW
	nid_dict = {}
	f = open(nodeid_file)

	for line in f:
		#nid = line.split()[-1]
		nid = line.split()[0]
		#cityname =  "".join(line.split()[:-1])
		cityname =  "".join(line.split()[1:])
		swid = "S%s" % nid
		nid_dict[swid] = cityname
		SW_LIST.append(swid)	

		# add host for each switch
		hostid = "H%s" % nid
		nid_dict[hostid] = "Host%s" % nid
		HOST_LIST.append(hostid)

	for i in range(1, NUM_MB+1):
		# add 
		mbid = "M%s" % i
		nid_dict[mbid] = "MB%s" % i
		MB_LIST.append(mbid)

	f.close()	
	NUM_HOST = len(HOST_LIST)
	NUM_SW = len(SW_LIST)
	return nid_dict

def gen_topo(filename, output):
	global MB_LIST, SW_LIST

	i = 0
	topo_list = []	
	sw_list = [] #switch list
	mb_list = [] #MB list

	# switch topology
	f = open(filename)
	for line in f:
		(frm ,to, weight) = line.split()
		topo_list.append((frm, to, weight))
	f.close()

	of = open(output, 'w+')

	of.write("NUMSWITCHES=%d\nNUMHOSTNODES=%d\nNUMMBOXES=%d\n" 
		% (len(SW_LIST), len(HOST_LIST), len(MB_LIST)))
	
	for (frm, to, weight) in topo_list:
		of.write("S%s S%s %s\n" % (frm, to, weight))

	# attach the same number of hosts to switches
	assert(len(SW_LIST) > 0)
	for sw in SW_LIST:
		index = sw.index("S")
		nid = sw[index+1:]
		of.write("%s H%s %d\n" % (sw, nid, HOST2SW_RES))
	
	# randomly append middlebox to switch	
	assert(len(MB_LIST) > 0)
	#assert(len(MB_LIST) <= len(SW_LIST))
	
	rest_mb = len(MB_LIST)
	
	while rest_mb > 0:	
		if rest_mb >= len(SW_LIST):
			for sw in random.sample(SW_LIST, len(SW_LIST)):
				of.write("%s %s %d\n" % (sw, MB_LIST[i], MB2SW_RES))	
				i = i + 1
			rest_mb = rest_mb - len(SW_LIST)
		else:
			for sw in random.sample(SW_LIST, rest_mb):
				of.write("%s %s %d\n" % (sw, MB_LIST[i], MB2SW_RES))	
				i = i + 1
			break		
			
	of.close()	

	return topo_list


def gen_mb_inventory(filename):
	"""
	generate MiddleBox inventory file 
	@filename: output filename 
	## Mboxname Type Resources
	M1 FIREWALL 100 
	M2 IDS 100
	"""
	global MB_LIST
	assert(len(MB_LIST) != 0)

	f = open(filename, "w+")
	f.write("## Mboxname Type Resources\n")
	for mb in MB_LIST: 
		mb_type = random.sample(MB_TYPE, 1)[0]
		MB_TYPE_ATTACH.append(mb_type)
		f.write("%s %s %d\n" % (mb, mb_type, MB_RESOURCE))	
	
	f.close();


def gen_sw_inventory(filename):
	""" 
	generate Switch inventory file 
	@filename: output filename
	## Switchname Numrules
	S1 10
	S2 10
	"""
	global SW_LIST
	assert(len(SW_LIST) != 0)

	f = open(filename, "w+")
	f.write("## Switchname Numrules\n")
	for sw in SW_LIST:
		f.write("%s %d\n" % (sw, NUM_RULE))

	f.close();

def gen_policy_chain_allpair(filename, k):
	"""
	update Dec 1, 2012
	create all pair policy chain, 
		for each pair, randomly pick K logical sequence 
	"""
	debug = 1
	f = open(filename, "w+")
	f.write("## Ingress Egress PolicyChain Volume\n")

	allpair = list(itertools.combinations(HOST_LIST, 2))
	allmbpair = list(itertools.combinations(list(set(MB_TYPE_ATTACH)), MB_CHAIN_DEPTH))
	#print "All mb pair ", allmbpair, MB_TYPE_ATTACH
	for pair_str in allpair:
		(frm, to) = pair_str
		pair = frm + " " + to

		mb_pairs = random.sample(allmbpair, k)
		#print "sample ", mb_pairs
		for mb_pair in mb_pairs:
			f.write(pair + " ")
			f.write(",".join(mb_pair) + " ")

			# lookup the traffic matrix to get the volume
			#if key in TRAFFIC_MATRIX.keys():
			volume = 0
			tm_pair = "%d %d" % (convert_node2id(frm), convert_node2id(to))

			if tm_pair in TRAFFIC_MATRIX.keys():
				volume = TRAFFIC_MATRIX[tm_pair]
			f.write("%d" % volume)	
			f.write("\n")
	f.close();


def gen_policy_chain(filename, num):
	"""
	Note: generate <num> line
	generate policy chain file
	@filename: output filename
	
	## Ingress Egress PolicyChain Volume
	H1 H2 FIREWALL,IDS 100
	"""
	global HOST_LIST, TRAFFIC_MATRIX
	assert(len(HOST_LIST) != 0)
	i = 0
	
	#print HOST_LIST
	f = open(filename, "w+")
	f.write("## Ingress Egress PolicyChain Volume\n")

	for i in range(0, num):
#	while (i <= num):
		#pair = random.sample(HOST_LIST, 2)	
		pair =	random.sample(TRAFFIC_MATRIX.keys(), 1)[0]
		mb_pair = random.sample(MB_TYPE_ATTACH, MB_CHAIN_DEPTH)	
		#f.write(" ".join(pair) + " ")
		
		f.write(pair + " ")
		f.write(",".join(mb_pair) + " ")

		# lookup the traffic matrix to get the volume
		#if key in TRAFFIC_MATRIX.keys():
		
		volume = TRAFFIC_MATRIX[pair]
		f.write("%d" % volume)	
		f.write("\n")
		i = i + 1			

	f.close();

def gen_config(filename, prjname):
	"""
	TOPOLOGY Topology_Hotnets
	POLICY PolicyChains_Hotnets 
	MBOXES MboxInventory_Hotnets
	SWITCHES SwitchInventory_Hotnets 
	"""	
	# file existence checking
	assert(os.path.exists(PRE_TOPO + prjname));
	assert(os.path.exists(PRE_POLI + prjname));
	assert(os.path.exists(PRE_MBIN + prjname));
	assert(os.path.exists(PRE_SWIN + prjname));
	
	f = open(filename, "w+")
	f.write("TOPOLOGY %s\n" % (PRE_TOPO + prjname));
	f.write("POLICY %s\n" % (PRE_POLI + prjname));
	f.write("MBOXES %s\n" % (PRE_MBIN + prjname));
	f.write("SWITCHES %s\n" % (PRE_SWIN + prjname));
	f.close()


if __name__ == "__main__":

	""" 
	We need 4 output files
	1. (O) TOPOLOGY Topology_<prjname>
	2. (O) POLICY PolicyChains_<prjname>  
	3. (O) MBOXES MboxInventory_<prjname>
	4. (O) SWITCHES SwitchInventory_<prjname>
	"""	

	if (len(sys.argv) != 9):
		print "./ThisProgram <nodeid: MAPPING> <topology: TOPOLOGY> <gravity> <total volume> <project name> "
		print "Example:"
		print "python topo.py MAPPING TOPOLOGY paths_abilene.GRAVITY 100000 test"
		sys.exit("Invalid Number of Input Parameters: %d" % len(sys.argv))
	
	nodeid_file = sys.argv[1]
	topo_file = sys.argv[2]
	gravity_file = sys.argv[3]
	total_volume = sys.argv[4]
	prjname = sys.argv[5]

	print "Node ID file: ", nodeid_file
	print "Input topology file: ", topo_file
	print "Path gravity file: ", gravity_file
	print "Total traffic volume", total_volume
	print "Output project name: ", prjname
	

	NODEID = parse_nodeid(nodeid_file).copy()
	
	print "=== output files ==="	
	parse_traffic(gravity_file, PRE_TM + prjname, total_volume)
	print "Traffic Matrix file: ", PRE_TM + prjname	

	TOPO_LIST = gen_topo(topo_file, PRE_TOPO + prjname)[:]
	print "Topology file: ", PRE_TOPO + prjname	
	
	gen_mb_inventory(PRE_MBIN + prjname)
	print "MB inventory file: ", PRE_MBIN + prjname

	gen_sw_inventory(PRE_SWIN + prjname)
	print "SW inventory file: ", PRE_SWIN + prjname

#	gen_policy_chain(PRE_POLI + prjname, NUM_POLICY)
#	print "Policy Chain file: ", PRE_POLI + prjname

	gen_policy_chain_allpair(PRE_POLI + prjname, NUM_LGCHAIN)
	print "All Pair Policy Chain file: ", PRE_POLI + prjname

	gen_config(PRE_CONF + prjname, prjname)
	print "Config file: ", PRE_CONF + prjname

