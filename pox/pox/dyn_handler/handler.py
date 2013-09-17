# Copyright 2011 James McCauley
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
# along with POX.	If not, see <http://www.gnu.org/licenses/>.

"""
Match a packet to the dynamic handler and fix its fields
to continue the previous installed flow

"""

from pox.core import core
import pox
log = core.getLogger()

from pox.lib.packet.ethernet import ethernet
from pox.lib.addresses import IPAddr
from pox.lib.packet.ipv4 import ipv4
from pox.lib.packet.arp import arp

from pox.lib.util import dpidToStr


import pox.openflow.libopenflow_01 as of

from pox.lib.revent import *

import csv
import time

dmaps = dict()		# the mapping from the input file, it matches the flows that the controller its getting

# Timeout for flows
FLOW_IDLE_TIMEOUT = 10

# Timeout for ARP entries
ARP_TIMEOUT = 60 * 2

class Entry (object):
	"""
	Not strictly an ARP entry.
	We use the port to determine which port to forward traffic out of.
	We use the MAC to answer ARP replies.
	We use the timeout so that if an entry is older than ARP_TIMEOUT, we
	 flood the ARP request rather than try to answer it ourselves.
	"""
	def __init__ (self, port, mac):
		self.timeout = time.time() + ARP_TIMEOUT
		self.port = port
		self.mac = mac

	def __eq__ (self, other):
		if type(other) == tuple:
			return (self.port,self.mac)==other
		else:
			return (self.port,self.mac)==(other.port,other.mac)
	def __ne__ (self, other):
		return not self.__eq__(other)

	def isExpired (self):
		return time.time() > self.timeout


class dyn_handler (EventMixin):
	def __init__ (self):
		# For each switch, we map IP addresses to Entries
		self.arpTable = {}

		self.listenTo(core)

	def _handle_GoingUpEvent (self, event):
		self.listenTo(core.openflow)
		log.debug("Up...")

	def _handle_PacketIn (self, event):
		dpid = event.connection.dpid
		inport = event.port
		packet = event.parsed
		if not packet.parsed:
			log.warning("%i %i ignoring unparsed packet", dpid, inport)
			return

		#if dpid not in self.arpTable:
		#	# New switch -- create an empty table
		#	self.arpTable[dpid] = {}

		if packet.type == ethernet.LLDP_TYPE:
			# Ignore LLDP packets
			return

		if isinstance(packet.next, ipv4) and dpid == 1 and str(packet.next.srcip) == "10.1.0.19":
			
			#if str(packet.next.dstip).startswith("10.3."):
			if packet.next.protocol == ipv4.TCP_PROTOCOL:
				tcp_packet = packet.next.payload
				log.debug("Sw: %s Pt: %i IP TCP: %s:%d => %s:%d", dpidToStr(dpid), inport, str(packet.next.srcip), tcp_packet.srcport, str(packet.next.dstip), tcp_packet.dstport )
			
			if packet.next.protocol == ipv4.UDP_PROTOCOL:
				udp_packet = packet.next.payload
				log.debug("Sw: %s Pt: %i IP UDP: %s:%d => %s:%d", dpidToStr(dpid), inport, str(packet.next.srcip), udp_packet.srcport, str(packet.next.dstip), udp_packet.dstport )
			
			#ip only match
			if (dpidToStr(dpid), str(inport), '*', str(packet.next.srcip), str(packet.next.dstip), '*', '*') in dmaps:
				
				log.debug( "matching l3 forwarding" )
			 	(timeout, TOproto, TOipsrc, TOipdst, TOptsrc, TOptdst, outport) = dmaps[dpidToStr(dpid), str(inport), '*', str(packet.next.srcip), str(packet.next.dstip), '*', '*']
			 	
			 	#new message 
			 	msg = of.ofp_flow_mod()
			 	
			 	#match part
			 	msg.match.in_port = inport
			 	
			 	msg.match.nw_src = str(packet.next.srcip)
			 	msg.match.nw_dst = str(packet.next.dstip)
			 	
			 	#action, including timeout
				msg.idle_timeout = int(timeout,10)
				msg.hard_timeout = of.OFP_FLOW_PERMANENT
				
				#msg.actions.append(of.ofp_action_nw_tos(nw_tos = int(of_entry["actions"]["mod_nw_tos"],10)))
				#ckech later
				#if TOproto != "*":
				#	msg.actions.append(of.ofp_action_nw_proto( nw_proto = int(TOproto,10)))
				
				if TOipsrc != "*":
					msg.actions.append(of.ofp_action_nw_addr.set_src( IPAddr(TOipsrc) ))
				
				if TOipdst != "*":
					msg.actions.append(of.ofp_action_nw_addr.set_dst( IPAddr(TOipdst) ))
					
				if TOptsrc != "*":
					msg.actions.append(of.ofp_action_tp_port.set_src( int(TOptsrc,10) ))
					
				if TOptdst != "*":
					msg.actions.append(of.ofp_action_tp_port.set_dst( int(TOptdst,10) ))					
					
				msg.actions.append(of.ofp_action_output(port = int(outport,10) ))
			
			 	event.connection.send(msg)
			 	
			# Try to forward
			#dstaddr = packet.next.dstip
			#if dstaddr in self.arpTable[dpid]:
			# We have info about what port to send it out on...
			#	prt = self.arpTable[dpid][dstaddr].port
			#	if prt == inport:
			#		log.warning("%i %i not sending packet for %s back out of the input port" % (
			#		 dpid, inport, str(dstaddr)))
			#	else:
			#		log.debug("%i %i installing flow for %s => %s out port %i" % (dpid,
			#		inport, str(packet.next.srcip), str(dstaddr), prt))
			#
			#		msg = of.ofp_flow_mod(command=of.OFPFC_ADD,
			#							idle_timeout=FLOW_IDLE_TIMEOUT,					# this could change depending on the input file
			#							hard_timeout=of.OFP_FLOW_PERMANENT,
			#							buffer_id=event.ofp.buffer_id,
			#							action=of.ofp_action_output(port = prt),
			#							match=of.ofp_match.from_packet(packet, inport))
			#		event.connection.send(msg.pack())
 
		return

def load_dynmapping(dynmap):
	
	global dmaps
	
	f = open(dynmap, 'r')
	
	#skip the header
	f.readline()
	
	for line in f:
		if line.startswith("#") == False: 
			
			lparts = line.rstrip().split(",")
			
			if len(lparts) == 14:
				(switch, inport, proto, ipsrc, ipdst, ptsrc, ptdst, timeout, TOproto, TOipsrc, TOipdst, TOptsrc, TOptdst, outport)  = lparts

				dmaps[switch, inport, proto, ipsrc, ipdst, ptsrc, ptdst] = (timeout, TOproto, TOipsrc, TOipdst, TOptsrc, TOptdst, outport)
				print (switch, inport, proto, ipsrc, ipdst, ptsrc, ptdst)
	f.close()

	# how to check if that key exist
	#if ('00-00-00-00-00-01', '4', '*', '10.1.0.19', '10.11.203.108', '*', '*') in dmaps:
	#	print "test ok"
	
def launch (dynmap, simple):
	
	load_dynmapping(dynmap)
	core.registerNew(dyn_handler)

