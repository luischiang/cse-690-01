# Copyright 2012 James McCauley
#
# This file is part of POX.
#
# POX is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# POX is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.	See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with POX.  If not, see <http://www.gnu.org/licenses/>.

import sys
import os
from pox.core import core
import pox.openflow.libopenflow_01 as of
from pox.lib.revent import *
from collections import defaultdict
from pox.openflow.discovery import Discovery
from pox.lib.util import dpidToStr
from threading import Timer

import time
import datetime
from pox.lib.addresses import IPAddr, EthAddr
from pox.lib.packet.ethernet import ethernet
from pox.lib.packet.ipv4 import ipv4
from pox.lib.packet.icmp import icmp
from pox.lib.packet.arp import arp

# William
from of_parser import *

#simple dir..
simpledir = ""

log = core.getLogger()
ldict = dict()		# the mapping of swid -> swname
rdict = dict()		# just in case we need the reverse of ldict
timeout = 0
calculating = 0
#_adj = defaultdict(lambda:defaultdict(lambda:[]))

def _calc_spanning_tree ():
  def flip (link):
	return Discovery.Link(link[2],link[3], link[0],link[1])

  adj = defaultdict(lambda:defaultdict(lambda:[]))
  switches = set()
  
  for swpt in core.openflow_discovery.swinfo:
	switches.add(swpt.dpid)

	print switches

  # Add all links and switches
  for l in core.openflow_discovery.adjacency:
	adj[l.dpid1][l.dpid2].append(l)
	switches.add(l.dpid1)
	switches.add(l.dpid2)

  # Cull links -- we want a single symmetric link connecting nodes
  for s1 in switches:
	for s2 in switches:
	  if s2 not in adj[s1]:
		continue
	  if not isinstance(adj[s1][s2], list):
		continue
	  assert s1 is not s2
	  good = False
	  for l in adj[s1][s2]:
		if flip(l) in core.openflow_discovery.adjacency:
		  # This is a good one
		  adj[s1][s2] = l.port1
		  adj[s2][s1] = l.port2
		  good = True
		  break
	  if not good:
		del adj[s1][s2]
		if s1 in adj[s2]:
		  # Delete the other way too
		  del adj[s2][s1]

  q = []
  more = set(switches)

  done = set()

  tree = defaultdict(set)

  while True:
	q = sorted(list(more)) + q
	more.clear()
	if len(q) == 0: break
	v = q.pop(False)
	if v in done: continue
	done.add(v)
	for w,p in adj[v].iteritems():
	  if w in tree: continue
	  more.add(w)
	  tree[v].add((w,p))
	  tree[w].add((v,adj[w][v]))

  if True:
	log.debug("*** BEGIN OF SPANNING TREE ***")
	for sw,ports in tree.iteritems():
	  print " ", dpidToStr(sw), ":", sorted(list(ports))
	  print " ", sw, ":", [l[0] for l in sorted(list(ports))]
	  log.debug((" %i : " % sw) + " ".join([str(l[0]) for l in
										   sorted(list(ports))]))
	log.debug("*** END OF SPANNING TREE ***")

  log.debug("Spanning tree updated")

  return tree

_prev = defaultdict(lambda : defaultdict(lambda : None))

def _handle (event):
	
	global timeout
	
	if calculating == 0:
		if timeout != 0:
			timeout.cancel()
		timeout = Timer(10.0, calculate_ruleset)
		timeout.start()
	
	switches = set()
  
	for swpt in core.openflow_discovery.swinfo:
		switches.add(dpidToStr(swpt.dpid))

	#print " ** Printing Switches"
	#print switches

	#print " ** Printing Links"
	#for link in core.openflow_discovery.adjacency:
	#	print "link detected: %s -> %s %i" % (dpidToStr(link.dpid1), dpidToStr(link.dpid2), link.port1)

	#print " ** Printing Links By Lookup"
	#for link in core.openflow_discovery.adjacency:
	#	print "link detected: %s -> %s %i" % (ldict[dpidToStr(link.dpid1)], ldict[dpidToStr(link.dpid2)], link.port1)

def calculate_ruleset():
	
	global calculating
	
	calculating = 1
	
	print "Time out ocurrss, network topology discovered."
	print "Begin Ruleset calculation"

	switches = set()
	for swpt in core.openflow_discovery.swinfo:
		switches.add(swpt.dpid)
	
	linklist = set()
	for link in core.openflow_discovery.adjacency:
		if ((ldict[dpidToStr(link.dpid1)], ldict[dpidToStr(link.dpid2)]) not in linklist):
			linklist.add( (ldict[dpidToStr(link.dpid2)], ldict[dpidToStr(link.dpid1)]) )
			
	# Step 1.. fill the files
	print "Running Step 1.. Matching Network"
	premapping = simpledir + "/premapping/"
	mappingdir = simpledir + "/mapping/"
	rsmanagerdir = simpledir + "/SIMPLE_ResourceManager/"
	rsResults = simpledir + "/SIMPLE_ResourceManager/results/"
	rulegen = simpledir + "/Rule_Generator/"
	ruleset = rulegen + "dynamic_ruleset.txt"
	
	SwPortDict = {}
	
	#Sw - Port, dictionary
	#f = open(premapping + "sw-ports.txt", 'r')
	f = open("/tmp/" + "sw-ports.txt", 'r')
	for line in f:
		swid = line.split(",")[0]
		swpt = line.split(",")[1]
		ptmac = line.split(",")[2]
		ptmac = ptmac.strip()
		
		SwPortDict[(swid,swpt)] = ptmac 
	f.close()
	
	#Config_Dynamic
	f = open(mappingdir + "Config_Dynamic", "w")
	print >>f, "TOPOLOGY Topology_Dynamic"
	print >>f, "POLICY PolicyChains_Dynamic"
	print >>f, "MBOXES MboxInventory_Dynamic"
	print >>f, "SWITCHES SwitchInventory_Dynamic"
	print >>f, "LINKS LinkCaps_Dynamic"
	print >>f, "MAXMBOXLOAD 2"
	f.close()
	
	#Topology_Dynamic
	
	#total number of network elements
	totalsw = 0
	totalmb = 0
	totalnt = 0
	
	fsw = open( premapping + "switches_table.txt", "r")
	for line in fsw:
		totalsw += 1
	fsw.close()
	
	fho = open( premapping + "net-mb-info.txt", "r")
	for line in fho:
		if line.startswith("M"):
			totalmb += 1
		elif line.startswith("T"): 
			totalnt += 1
		
	fho.close()
	
	
	p = open( premapping + "net-mb-ports.txt", "r")		#open(premapping + "pre-topology.txt", "r")
	f = open(mappingdir + "Topology_Dynamic", "w")
	 
	print >>f, "### first node has to of type S*"	#header
	print >>f, "NUMSWITCHES=%d" % totalsw		#NUM_SWITCHES
	print >>f, "NUMHOSTNODES=%d" % totalnt	#NUM_HOSTNODES or networks
	print >>f, "NUMMBOXES=%d" % totalmb		#NUM_MBOXES
	
	for link in linklist:							#add the network information
		print >>f, link[0] + " " + link[1] + " 1"
	
	for line in p:									#copy the second part of the file, the hosts and MB information
		lsplit = line.split(",")
		print >>f,lsplit[0] + " " + lsplit[1] + " 1"
		
	p.close()
	f.close()
	
	#Switches
	r = open( premapping + "net-mb-ports.txt", "r")
	f = open( rulegen + "switches.txt","w")
	
	for line in r:									#copy the second part of the file, the hosts and MB information
		swna = line.split(",")[0]
		hoid = line.split(",")[1]
		swpt = line.split(",")[2]
		swpt = swpt.strip()
		
		swid = rdict[swna]
		
		print >>f, swna + "	" + hoid + "	" + swpt + "	" + SwPortDict[(swid,swpt)]
	
	for link in core.openflow_discovery.adjacency:
		print >>f, ldict[dpidToStr(link.dpid1)] + "	" + ldict[dpidToStr(link.dpid2)] + "	" + str(link.port1) + "	" + SwPortDict[(dpidToStr(link.dpid1),str(link.port1))]
		
	f.close()
	r.close()
	
	#PolicyChains_Dynamic
	os.system("cp " + premapping + "chains.txt " + mappingdir + "PolicyChains_Dynamic")
	
	#MboxInventory_Dynamic
	os.system("cp " + premapping + "mboxes_inventory.txt " + mappingdir + "MboxInventory_Dynamic")
	
	#SwitchInventory_Dynamic
	f = open(mappingdir + "SwitchInventory_Dynamic","w")
	for sw in switches:
		print >>f, ldict[dpidToStr(sw)] + " " + "50000"
		
	f.close()
	
	os.system("cp " + premapping + "net-mb-info.txt " + rulegen + "hosts.txt")
	#os.system("cp " + premapping + "switches.txt " + rulegen + "switches.txt")
	os.system("cp " + premapping + "switches_table.txt " + rulegen + "switches_table.txt")
	
	# Step 2.. copy the files to the corresponding directory
	print "Running Step 2... Preparing for SIMPLE" 
	os.system("cp " + mappingdir + "* " + rsmanagerdir )
	os.system("cp " + mappingdir + "* " + rulegen )
	
	# Step 3.. run simple, and get results
	print "Running Step 3... SIMPLE" 
	
	os.system("rm -f " + rsResults + "* > /dev/null")			#delete previous results
	os.system(rsmanagerdir + "run_simple_optimal.sh Dynamic 50000")
	
	# Step 4.. copy results to the rule generator
	print "Running Step 4... Moving results"
	os.system("cp " + rsResults + "* " + rulegen)			#delete previous results
	# Step 5.. get the rule set
	print "Running Step 5... Generating Ruleset"
	
	os.system("mv " + rulegen + "simple_50000Dynamic*.sol " + rulegen + "simple_50000Dynamic.sol")
	os.system(rulegen + "generate_ruleset.sh > " + rulegen + "dynamic_ruleset.txt")
	
	# Step 6.. read and install
	print "Running Step 6... Installing Rules"
	# iterate over all connected switches and delete all their flows
	for sw in switches:
		cone = core.openflow.getConnection(sw)
		configureRules(cone,ruleset)

def configureRules (connection, lruleset):
	""" Configure initial rules """
	
	#print "Ready for configure init rules in SW: " + dpidToStr(connection.dpid) + " " + str(connection.dpid) 
	
	of_fib = parse_of_file(lruleset)
	#print of_fib
	of_list = []
	try:
		of_list = of_fib[dpidToStr(connection.dpid)]
	except KeyError:
		print "Oops! There are no for the Sw " +  dpidToStr(connection.dpid)
		
	#f = open('/tmp/' + dpidToStr(event.dpid), 'wa')
	#f.write( dpidToStr(event.dpid) + " begin " + str(time.time()))
	#of_entry = of_list[0]
	#print of_entry
	
	for of_entry in of_list:
		msg = of.ofp_flow_mod()
		#print "writing OpenFlow entry:", of_entry
		#msg.priority = 42

		if "dl_type" in of_entry.keys():
			msg.match.dl_type = int(of_entry["dl_type"], 16)
			 
		if "nw_proto" in of_entry.keys():
			msg.match.nw_proto = int(of_entry["nw_proto"], 10)
			
		#ETH
		if "dl_src" in of_entry.keys():
			msg.match.dl_src = EthAddr(of_entry["dl_src"])
			
		if "dl_dst" in of_entry.keys():
			msg.match.dl_dst = EthAddr(of_entry["dl_dst"])
		#IP	 
		if "nw_src" in of_entry.keys():
			msg.match.nw_src = of_entry["nw_src"]
			#msg.match.nw_src = IPAddr(of_entry["nw_src"])
			
		if "nw_dst" in of_entry.keys():
			msg.match.nw_dst = of_entry["nw_dst"]
			#msg.match.nw_dst = IPAddr(of_entry["nw_dst"])
		
		if "nw_tos" in of_entry.keys():
			msg.match.nw_tos = int(of_entry["nw_tos"],10)
		
		#UDP
		if "tp_dst" in of_entry.keys():
			msg.match.tp_dst = int(of_entry["tp_dst"],10)
			
		if "tp_src" in of_entry.keys():
			msg.match.tp_src = int(of_entry["tp_src"],10)
		
		#OTHERS
		if "in_port" in of_entry.keys():
			msg.match.in_port = int(of_entry["in_port"],10)
		
		if "dl_vlan" in of_entry.keys():
			msg.match.dl_vlan = int(of_entry["dl_vlan"],10)
	
		if "dl_vlan_pcp" in of_entry.keys():
			msg.match.dl_vlan_pcp = int(of_entry["dl_vlan_pcp"],10)
		
		#msg.match.tp_dst = 80
		# iterate list of actions
		#output
		#vlan
		if "mod_nw_tos" in of_entry["actions"].keys():
			msg.actions.append(of.ofp_action_nw_tos(nw_tos = int(of_entry["actions"]["mod_nw_tos"],10)))
		
		if "mod_vlan_vid" in of_entry["actions"].keys():
			msg.actions.append(of.ofp_action_vlan_vid(vlan_vid = int(of_entry["actions"]["mod_vlan_vid"],10)))
			
		if "mod_vlan_pcp" in of_entry["actions"].keys():
			msg.actions.append(of.ofp_action_vlan_pcp(vlan_pcp = int(of_entry["actions"]["mod_vlan_pcp"],10)))
		 		
		if "mod_dl_src" in of_entry["actions"].keys():
			msg.actions.append(of.ofp_action_dl_addr.set_src(EthAddr(of_entry["actions"]["mod_dl_src"])))
			
		if "mod_dl_dst" in of_entry["actions"].keys():
			msg.actions.append(of.ofp_action_dl_addr.set_dst(EthAddr(of_entry["actions"]["mod_dl_dst"])))
		
		if "output" in of_entry["actions"].keys():
			msg.actions.append(of.ofp_action_output(port = int(of_entry["actions"]["output"],10)))
			#print "set the output port"
		
		connection.send(msg)
	
	#f.write(" ending " + str(time.time()) + "\n")
	#f.close()
	print "Rules configured, allow traffic for " + dpidToStr(connection.dpid)
	
def create_dictionary(simple):
	
	global ldict
	
	swmaps = simple + "/premapping/" + "switches_table.txt"
	
	f = open(swmaps, 'r')
	
	for line in f:
		swname = line.split(",")[0]
		swid = line.split(",")[1]
		swid = swid.strip()
		
		ldict[swid] = swname
		rdict[swname] = swid
	f.close()
	
def launch (simple):
	
	global simpledir
	simpledir = simple
	create_dictionary(simple)
	os.system("rm /tmp/sw-ports.txt")
	core.openflow_discovery.addListenerByName("LinkEvent", _handle)
