#!/usr/bin/python

# Cheng-Chun Tu
# Dec 27, 2012
# Dec 28, merge code with Luis
# Jan 16, integate with new Topo file and POX 

"""
This example creates a multi-controller network from
semi-scratch; note a topo object could also be used and
would be passed into the Mininet() constructor.
"""
import sys
import random
import os
import time
from mininet.net import Mininet
from mininet.node import Controller, OVSKernelSwitch, RemoteController
from mininet.cli import CLI
from mininet.log import setLogLevel
from mininet.link import Intf
from mininet.log import setLogLevel, info, error, debug
from mininet.term import cleanUpScreens, makeTerm

Switch = OVSKernelSwitch

#	Hosts		(hoX)		00:00:11:00:0X:0Y	11.0.X.Y
#	Switches	(swX)		00:00:12:00:0X:0Y	12.0.X.Y
#	MiddleBoxes (mbX)		00:00:13:00:0X:0Y	13.0.X.Y

def print_ifconfig(node_list):
	for nd in node_list:
		print nd.cmd("ifconfig")


class TopoFile:
	"""
	S2 M1 1
	"""
	def add_node(self, nodename):
		""" node type, the first character is type: {S, M, H} """
		if nodename.startswith("S"):
			if nodename not in self.sw_list: self.sw_list.append(nodename)		
		elif nodename.startswith("H"):
			if nodename not in self.host_list: self.host_list.append(nodename)
		elif nodename.startswith("M"):
			if nodename not in self.mb_list: self.mb_list.append(nodename)
		else:
			print "Error when add_node:", nodename
			sys.exit(1)
	
	def add_edge(self, n1, n2):
		""" 
		input: n1="S1", n2="S9", output: [("S1 S2"), ("H1", "S1") ... ]
		"""	
		if (n1, n2) in self.edge_list: return
		if (n2, n1) in self.edge_list: return
		self.edge_list.append((n1,n2))

	def __init__(self, edge_file):
		
		self.edge_file = edge_file
		self.sw_list = []
		self.mb_list = []
		self.host_list = []
		self.edge_list = []

		edgef = open(self.edge_file)
		for line in edgef:
			if line.startswith("NUM"): continue
			if line.startswith("#"): continue
		
			elem = line.split()	
			self.add_node(elem[0])
			self.add_node(elem[1])
			self.add_edge(elem[0], elem[1])

	def __str__(self):	
		return "under construction"

	def dump(self):
		print "host ID:", self.host_list
		print "switch ID:", self.sw_list
		print "MB ID:", self.mb_list
		print "Edge:", self.edge_list

def addMiddleBox(net, name):
	"Create MiddleBox mbN and add to net."
	ip = '13.0.%d.2' % int(name[1:])
	mb = net.addHost(name, ip=ip)
	return mb
	
def addHost(net, name):
	"Create host hN and add to net."
	ip = '11.0.%d.2/24' % int(name[1:])
	ho = net.addHost(name, ip=ip, mac="00:00:11:00:00:0%d" % int(name[1:]) )
	return ho
	
def addTrafficGenerator(net, name):
	"Create host hN and add to net."
	ho = net.addHost(name, ip="10.1.0.1")
	return ho

def addSwitch(net, name):
	return net.addSwitch(name)

def dumpNodeConnections( file, nodes ):
    "Dump connections to/from nodes."

    def dumpConnections( file, node ):
        "Helper function: dump connections to node"
        for intf in node.intfList():
            file.write( ' %s:' % intf )
            if intf.link:
                intfs = [ intf.link.intf1, intf.link.intf2 ]
                intfs.remove( intf )
                file.write( str(intfs[ 0 ]) )
            else:
                file.write( ' ' )

    for node in nodes:
        file.write(  node.name )
        dumpConnections( file, node )
        file.write( '\n' )

def dumpNetConnections( file,  net ):
	"Dump connections in network"
	nodes = net.controllers + net.switches + net.hosts
	dumpNodeConnections( file, nodes )
	
def getConfiguration(topologyName):
	
	netconfigFile = "config/netconfig_" +  topologyName
	
	tmpf = open(netconfigFile)
	swlinks = tmpf.readlines()
	tmpf.close()
	
	ifconfigFile = "config/ifconfig_" + topologyName
	
	tmpf = open(ifconfigFile)
	swmacs = tmpf.readlines()
	tmpf.close()
	
	swlinksPf = {}
	for line in swlinks:
		lineSt = line.strip()
		if lineSt[0] == 'S':
			parts = lineSt.split(" ")
			
			swlinksPf[parts[0]] = []
			for conx in parts[3::]:
				swlinksPf[parts[0]].append(conx.split(":"))
	
	conxFn = "config/conx_" + topologyName
	conxFile = open(conxFn,"w")
	for sw in swlinksPf:
		i = 1
		for conx in swlinksPf[sw]:
			if conx[1].split("-")[0] == "Tg":
				conxFile.write( "%s,%s,%i\n" % (conx[0].split("-")[0] , conx[0].split("-")[0].replace("S","T") , i ) )
			#elif (conx[1].split("-")[0]).startswith("M") or (conx[1].split("-")[0]).startswith("H") :
			else:
				conxFile.write( "%s,%s,%i\n" % (conx[0].split("-")[0] , conx[1].split("-")[0] ,  i ) )
			i = i + 1
	
	conxFile.close()
			
	return 0

def getMac(swmacs, ifname):
	for line in swmacs:
		if ifname in line:
			parts = line.split(" ")
			pos = [i for i,x in enumerate(parts) if x == "HWaddr"]
			return parts[ pos[0] + 1 ]
			
def TopologyHotnet(networkName, ruletype, edgefile):
	"Create a network with multiple controllers."
	 
	net = Mininet( controller=RemoteController, switch=Switch, autoSetMacs = True)
	print "*** Creating controllers"
	c1 = net.addController('c1', port=6633, ip="127.0.0.1")
	
	wdir = os.getcwd()
	
	swobj_dict = {}
	hobj_dict = {}
	mbobj_dict = {}
	allobj = {}

	print "*** read topology from file"
	tf = TopoFile(edgefile)
	tf.dump()
	
	# Add switches
	for sw_name in tf.sw_list:
		sw = addSwitch(net, sw_name)
		swobj_dict[sw_name] = sw
		print "add switch: ", sw

	# Add MB
	for mb_name in tf.mb_list:
		m = addMiddleBox(net, mb_name)
		mbobj_dict[mb_name] = m
		print "add middlebox: ", m

	# Add HOST
	for ho_name in tf.host_list:
		h = addHost(net, ho_name)
		hobj_dict[ho_name] = h
		print "add host: ", h
		
	# Add Host, only the traffic generator
	Tg = addTrafficGenerator(net, "Tg")
	print "add traffic generator: ", Tg
 
	allobj["S"] = swobj_dict
	allobj["H"] = hobj_dict
	allobj["M"] = mbobj_dict

	# Add edges 
	for edge in tf.edge_list: 
		(n1, n2) = edge
		ntype1 = n1[0]
		ntype2 = n2[0]
		node1 = allobj[ntype1][n1]
		node2 = allobj[ntype2][n2]
		print "add link between two node : ", n1, n2
		net.addLink(node1, node2)
	
	# Add traffic generator
	i = 1
	for sw_name in tf.sw_list: 
		sw = swobj_dict["S" + str(i)]
		net.addLink(sw, Tg) 
		i += 1
		
	# Configure the MAC Tg
	mac = 1
	for intfname in Tg.intfList():
		Tg.setIP('10.%d.0.2' %  mac, 32, intfname)
		Tg.setMAC('00:00:10:00:00:%d' %  mac, intfname)
		mac = mac + 1
				
	# Configure the MAC address
	for sw_name in tf.sw_list:
		sw = swobj_dict[sw_name]
		swid = int(sw_name[1:])
		mac = 0
		for intfname in sw.intfList():
			if swid < 100:
				sw.setMAC('00:00:12:00:%d:%d' % (swid, mac), intfname)
			else:
				sw.setMAC('00:00:12:01:%d:%d' % (swid-100, mac), intfname)
			mac = mac + 1

	print "*** Starting network"
	net.build()
 	
	for key in swobj_dict.keys():
		sw = swobj_dict[key]
		#time.sleep(0.5)
		sw.start([c1])

	print "*** exporting config files"
	
	path = edgefile.split("/")[0]
	edgename = edgefile.split("/")[1]
	
	f = open("config/netconfig_" + edgename, 'w') 
	dumpNetConnections(f, net) 
	f.close()
	
	f = open("config/hosts_" + edgename, 'w')
 	
	i = 1;
	for intfname in Tg.intfList():
			print >>f, 'N%d %s/16 %s' % (i, Tg.IP(intfname), intfname)
			i += 1
	
	for host_name in tf.host_list:
		ho = hobj_dict[host_name]
		for intfname in ho.intfList():
			print >>f, '%s %s %s %s' % (ho.name, ho.IP(intfname), ho.MAC(intfname), intfname)
			
	for mb_name in tf.mb_list:
		mb = mbobj_dict[mb_name]
		for intfname in mb.intfList():
			print >>f, '%s %s %s %s' % (mb.name, mb.IP(intfname), mb.MAC(intfname), intfname)
	
	f.close()
	
	f = open("config/switches_" + edgename, 'w')
	for sw_name in tf.sw_list:
		sw = swobj_dict[sw_name]
		print >>f, '%s,%s-%s-%s-%s-%s-%s' % (sw.name, sw.dpid[4:6],sw.dpid[6:8],sw.dpid[8:10],sw.dpid[10:12],sw.dpid[12:14],sw.dpid[14:16] )
	f.close()
	
	os.system("ifconfig -a | grep Ethernet > " + wdir + "/config/ifconfig_" + edgename)
 	
	getConfiguration(edgename)
 	
	#print "*** Stopping network"
	net.stop()
	
	os.system("./terminate_experiments.sh")

if __name__ == '__main__':
	setLogLevel( 'info' )  # for CLI output
	
	if len(sys.argv) != 4:
		print "Usage: ./ThisProgram <NetworkName> <RuleSet Type> <Topology_xxx>"
		print "ex: abilene optimal topology/abilene_topology.txt" 
		sys.exit(1)

	TopologyHotnet(sys.argv[1], sys.argv[2], sys.argv[3])
