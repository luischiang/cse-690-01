#
# Cheng-Chun Tu: Openvswitch parser
# Nov 28, 2012
# Dec 14, 2012: add mac address support for action with : as separator 

import os
import sys
import random
import logging
import re

#logger = logging.getLogger(__name__)
#hdlr = logging.FileHandler("/var/tmp/" + __name__ + ".log")
#hdlr = logging.StreamHandler(sys.stdout)
DEBUG = 0
MIN_LINE_LEN = 6

def ipaddr(ipstr):
	ip =  re.findall( r'[0-9]+(?:\.[0-9]+){3}', ipstr)	
	if len(ip) <= 0: 
		return ipstr
	return ip[0]


def rm_space(line):
	""" remove space from a string """
	line = line.strip()
	return line.replace(' ', '')


def parse_of_action(of_actions):
	"""  
	OpenFlow action parser
	example: 1. output:1,mod_vlan_vid:100
		2. mod_dl_src:00:02:b3:23:79:15,
	"""
	debug = 0
	action_dict = {} 
	if of_actions.find("=") >= 0:
		print "Error OpenFlow action list:", of_actions
		sys.exit(1)

	for entry in of_actions.split(','):
	
		elems = entry.split(":") 
		if len(elems) > 2:
			if debug: print "parsing:", elems
			key = elems[0]
			value = ":".join(elems[1:])
			if debug: print "key=", key, " value=", value
		else:
			(key, value) = entry.split(":")	
		
		action_dict[key] = value	

	return action_dict

def parse_of_entry(of_entry_str):
	"""
	Parse each line in the file, example
	in_port=LOCAL,table=0,idle_timeout=60,ip,hard_timeout=60,vlan_tci=0x0000,dl_src=78:2b:cb:4b:db:c5,dl_dst=00:09:8a:02:80:c0,nw_proto=1,nw_dst=192.168.1.100,
	nw_src=192.168.7.189,actions=output:1,mod_vlan_vid:100
	"""	
	of_dict = {}
	act_str = [] #list of actions

	of_entry = rm_space(of_entry_str) # remove all space

	if DEBUG: print "Parsing line content:", of_entry
	tokens = of_entry.split(",")
	for t in tokens:
		if (DEBUG): print t
		try: 
			(key, value)= t.split("=")		
		except Exception, e:
			print "skip parsing token: ", t
		 
		if key == "actions":
			break
		of_dict[key] = value

	#parse action list
	ind = of_entry.find("actions") + len("actions=")
	action_str = of_entry[ind:]
	action_dict = parse_of_action(action_str)
	of_dict["actions"] = action_dict
	
	return of_dict

# some global variables
def parse_of_file(filename):
	"""
	Switch S1:
	dl_type=ethertype, dl_src=src_mac_address, dl_dst=destination_mac_address, in_port=ingress_port, dl_vlan=vlan, nw_src=src_ip_address, 
	nw_dst=dst_ip_address, nw_proto=ip, tcp_src=src_port, tcp_dst=dst_port, actions=output:port, mod_vlan_vid=vlan_vid
	
	"""
	sw_fib = {}
	f = open(filename)
	for line in f:
		if line.startswith("#"):
			continue		
		if len(line) < MIN_LINE_LEN:
			continue

		# per switch entry
		ret = line.find("Switch")
		if ret >= 0:
			sw_id = line.split("Switch")[1]
			sid = rm_space(sw_id)
			sid = sid[:sid.find(":")]
			sw_fib[sid] = []
			continue 

		of_entry = parse_of_entry(line) # this is a dict 
		sw_fib[sid].append(of_entry)
	f.close()
	if (DEBUG): print sw_fib
	return sw_fib	

		
if __name__ == "__main__":

	""" 
	We need 4 output files
	"""	
		
	if (len(sys.argv) != 2):
		print "./ThisProgram <outputfile to program to OF switch>"
		print "Example:"
		sys.exit("Invalid Number of Input Parameters: %d" % len(sys.argv))

		
	of_file = sys.argv[1]

	#usage example

	print "input file: ", of_file
	
	macaddr = "00-02-b3-3f-74-49"
	dd = parse_of_file(of_file)
	for macaddr in dd.keys():
		print "MAC: ", macaddr
		entry_list = dd[macaddr]
		try:	
			entry1 = dd[macaddr][0]
			print "------ test cases ------"
			print "nw_dst= ", entry1["nw_dst"]
			print "dl_dst= ", entry1["dl_dst"]
			print "actions.output= ", entry1["actions"]["output"]
			print "actions.mod_dl_src=", entry1["actions"]["mod_dl_src"]
			print "actions.mod_vlan_vid=", entry1["actions"]["mod_vlan_vid"]
		except Exception, e:
			print "skip key error"






