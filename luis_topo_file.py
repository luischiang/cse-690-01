#!/usr/bin/python

# Luis Chiang, Cheng-Chun Tu
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
	ho = net.addHost(name, ip=ip)
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
        file.write( node.name )
        dumpConnections( file, node )
        file.write( '\n' )

def dumpNetConnections( file,  net ):
    "Dump connections in network"
    nodes = net.controllers + net.switches + net.hosts
    dumpNodeConnections( file, nodes )
	
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
		Tg.setIP('10.%d.0.2' %  mac, 24, intfname)
		Tg.setMAC('00:00:10:00:00:%d' %  mac, intfname)
		mac = mac + 1
	
	for host_name in tf.host_list:
		ho = hobj_dict[host_name]
		hoid = int(host_name[1:])
		
		for intfname in ho.intfList():
			ho.setMAC('00:00:11:00:%d:%d' % (hoid, mac), intfname)
		
	# Configure the MAC address of the sw port
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
	
	#os.system("rm /tmp/00*")
	#os.system("tcpdump -i lo -w /home/luis/pcap/%s-%s-controller.pcap & > /home/luis/pcap/%s-%s-tcpdumpOut-controller.txt" % (networkName, ruletype, networkName, ruletype) )
	 
	time.sleep(1)
	
	for key in swobj_dict.keys():
		sw = swobj_dict[key]
		#time.sleep(0.5)
		sw.start([c1])
	
	for host_name in tf.host_list:
		ho = hobj_dict[host_name]
		hoid = int(host_name[1:])
		ho.cmd("route add default gw 11.0.%d.1" % hoid)
		ho.cmd("arp -s 11.0.%d.1 1a:2a:3a:1a:2a:3a" % hoid)
		
	max_num_servers = 2
	
	#Configure the ARP TABLE and default route Tg
	#mac = 1
	#for intfname in Tg.intfList():
	#	Tg.cmd('arp -s 10.%d.0.1 00:00:13:13:00:%d' % (mac, mac))
	#	mac = mac + 1
	
	#for iflush in range(max_num_servers):
	#	Tg.cmd("ip address flush dev Tg-eth%d" % iflush)
	
	#Tg.cmd("route add default gw 10.%d.0.1 " % (max_num_servers + 1) )
	
	#Iterate throw all the middle boxes
	#for node in net.switches:
		#print node.name
	#	node.cmd("ovs-vsctl set Bridge %s stp_enable=false" % node.name)
		
	#	for intf in node.intfList():
	#		if intf.link:
			
	#			mbox_name = str( intf.link.intf2 )
				
	#			if mbox_name.startswith("M"):
				
	#				node.cmd( "ovs-dpctl del-if %s %s" % (node.name, str( intf.link.intf1 )) )
					
	#				mbox_number = mbox_name.replace("M","")
	#				mbox_number = mbox_number.replace("-eth0","")
					
	#				node.cmd( "ovs-dpctl add-if %s eth%s" % (node.name, mbox_number ) )
					
	#			if mbox_name.startswith("H"):
	#				host_number = mbox_name.replace("H","")
	#				host_number = host_number.replace("-eth0","")
					
	#				host_number = int(host_number)
					
	#				if host_number < max_num_servers:
	#					node.cmd( "ovs-dpctl del-if %s %s" % (node.name, str( intf.link.intf1 )) )						 
	#					node.cmd( "ovs-dpctl add-if %s eth%s" % (node.name, "2" + str(host_number) )  )
	#					node.cmd( "ifconfig eth%s promisc up" % ("2" + str(host_number) )  )
 		
	print "*** Sleep for reaching the controller (10 seconds)"
	time.sleep(2)
	 
	#print "*** exporting config files"
	
	#path = edgefile.split("/")[0]
	#edgename = edgefile.split("/")[1]
 	 
	#for host_name in tf.host_list:
	#	ho = hobj_dict[host_name]
		#ho.cmd("/home/luis/finalmbox/iperf/%s/%s.sh &" % (networkName, ho.name) )
		#net.terms += makeTerm(ho)
	
	#print "*** running traffic generator"
	#Tg.cmd("sar -n DEV 1 250 > %s/pcap/%s/Tg-performance.txt &" % (wdir, networkName))	
	#Tg.cmd("%s/gtool/startTg.sh" % wdir)
	
	##########
	CLI( net ) 
	
	print "*** Stopping network"
	net.stop()
	
	os.system("./terminate_experiments.sh")

if __name__ == '__main__':
	setLogLevel( 'info' )  # for CLI output
	
	if len(sys.argv) != 4:
		print "Usage: ./ThisProgram <NetworkName> <RuleSet Type> <Topology_xxx>"
		print "ex: abilene optimal topology/abilene_topology.txt" 
		sys.exit(1)

	TopologyHotnet(sys.argv[1], sys.argv[2], sys.argv[3])
