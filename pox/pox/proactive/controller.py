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
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with POX.  If not, see <http://www.gnu.org/licenses/>.

"""
This component is for use with the OpenFlow tutorial.

It acts as a simple hub, but can be modified to act like an L2
learning switch.

It's quite similar to the one for NOX.  Credit where credit due. :)
"""

from pox.core import core
import pox.openflow.libopenflow_01 as of
from pox.lib.addresses import IPAddr, EthAddr
from pox.lib.util import dpidToStr
import time
import datetime

from pox.lib.packet.ethernet import ethernet
from pox.lib.packet.ipv4 import ipv4
from pox.lib.packet.icmp import icmp
from pox.lib.packet.arp import arp

# William
from of_parser import *

log = core.getLogger()
FLOOD_DELAY = 5

class Tutorial (object):
  """
  A Tutorial object is created for each switch that connects.
  A Connection object for that switch is passed to the __init__ function.
  """
  def __init__ (self, connection):
	# Keep track of the connection to the switch so that we can
	# send it messages!
	self.connection = connection

	# This binds our PacketIn event listener
	connection.addListeners(self)

	# Use this table to keep track of which ethernet address is on
	# which switch port (keys are MACs, values are ports).
	self.mac_to_port = {}
 	
  def configureRules (self, event, lruleset):
	""" Configure initial rules """
	
	print "Ready for configure init rules in SW: " + dpidToStr(event.dpid) + " " + str(event.dpid) 
	
	of_fib = parse_of_file(lruleset)
	#print of_fib
	of_list = []
	try:
		of_list = of_fib[dpidToStr(event.dpid)]
	except KeyError:
		print "Oops! There is no information about the Sw " +  dpidToStr(event.dpid) + " in the configuration file"
	 
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
		
		if "priority" in of_entry.keys():
			msg.priority = int(of_entry["priority"], 10)
		
		#ETH
		if "dl_src" in of_entry.keys():
			msg.match.dl_src = EthAddr(of_entry["dl_src"])
			
		if "dl_dst" in of_entry.keys():
			msg.match.dl_dst = EthAddr(of_entry["dl_dst"])
		#IP	 
		if "nw_src" in of_entry.keys():
			msg.match.nw_src = of_entry["nw_src"]
			
		if "nw_dst" in of_entry.keys():
			msg.match.nw_dst = of_entry["nw_dst"]
		
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
			msg.match.dl_vlan = int(of_entry["dl_vlan"],16)
	
		if "vlan_tci" in of_entry.keys():
			msg.match.vlan_tci = int(of_entry["vlan_tci"],16)
		
		#msg.match.tp_dst = 80
		# iterate list of actions
		#output
		#vlan
		if "mod_nw_tos" in of_entry["actions"].keys():
			msg.actions.append(of.ofp_action_nw_tos(nw_tos = int(of_entry["actions"]["mod_nw_tos"],10)))
		
		if "mod_vlan_vid" in of_entry["actions"].keys():
			msg.actions.append(of.ofp_action_vlan_vid(vlan_vid = int(of_entry["actions"]["mod_vlan_vid"],16)))
		 		
		if "mod_dl_src" in of_entry["actions"].keys():
			msg.actions.append(of.ofp_action_dl_addr.set_src(EthAddr(of_entry["actions"]["mod_dl_src"])))
			
		if "mod_dl_dst" in of_entry["actions"].keys():
			print "mod_dl_dst: %s " % of_entry["actions"]["mod_dl_dst"]
			msg.actions.append(of.ofp_action_dl_addr.set_dst(EthAddr(of_entry["actions"]["mod_dl_dst"])))
		
		if "output" in of_entry["actions"].keys():
			msg.actions.append(of.ofp_action_output(port = int(of_entry["actions"]["output"],10)))
			#print "set the output port"
		
		self.connection.send(msg)
	
	#f.write(" ending " + str(time.time()) + "\n")
	#f.close()
	print "Init rules configured, allow traffic for " + dpidToStr(event.dpid)
	
  def send_packet (self, buffer_id, raw_data, out_port, in_port):
	"""
	Sends a packet out of the specified switch port.
	If buffer_id is a valid buffer on the switch, use that.  Otherwise,
	send the raw data in raw_data.
	The "in_port" is the port number that packet arrived on.  Use
	OFPP_NONE if you're generating this packet.
	"""
	return
	msg = of.ofp_packet_out()
	msg.in_port = in_port
	if buffer_id != -1 and buffer_id is not None:
	  # We got a buffer ID from the switch; use that
	  msg.buffer_id = buffer_id
	else:
	  # No buffer ID from switch -- we got the raw data
	  if raw_data is None:
		# No raw_data specified -- nothing to send!
		return
	  msg.data = raw_data

	# Add an action to send to the specified port
	action = of.ofp_action_output(port = out_port)
	msg.actions.append(action)

	# Send message to switch
	#self.connection.send(msg)


  def act_like_hub (self, packet, packet_in):
	"""
	Implement hub-like behavior -- send all packets to all ports besides
	the input port.
	"""

	# We want to output to all ports -- we do that using the special
	# OFPP_FLOOD port as the output port.  (We could have also used
	# OFPP_ALL.)
	#self.send_packet(packet_in.buffer_id, packet_in.data,
	#				 of.OFPP_FLOOD, packet_in.in_port)

	# Note that if we didn't get a valid buffer_id, a slightly better
	# implementation would check that we got the full data before
	# sending it (len(packet_in.data) should be == packet_in.total_len)).
 
  def _handle_PacketIn (self, event):
	"""
	Handles packet in messages from the switch.
	"""
	
	return
	#log.debug("incoming package")
	dpid = event.connection.dpid
	inport = event.port
	
	packet = event.parsed # This is the parsed packet data.
	if not packet.parsed:
	  log.warning("Ignoring incomplete packet")
	  return
	
	def flood ():
	  """ Floods the packet """
	  return
	  log.debug("flood was called")
	  if event.ofp.buffer_id == -1:
		log.warning("Not flooding unbuffered packet on %s",
					dpidToStr(event.dpid))
		return
	  msg = of.ofp_packet_out()
	  if time.time() - self.connection.connect_time > FLOOD_DELAY:
		# Only flood if we've been connected for a little while...
		#log.debug("%i: flood %s -> %s", event.dpid, packet.src, packet.dst)
		msg.actions.append(of.ofp_action_output(port = of.OFPP_FLOOD))
	  else:
		pass
		#log.info("Holding down flood for %s", dpidToStr(event.dpid))
	  msg.buffer_id = event.ofp.buffer_id
	  msg.in_port = event.port
	  #self.connection.send(msg)
	
	#packet_in = event.ofp # The actual ofp_packet_in message. 
	# Comment out the following line and uncomment the one after
	# when starting the exercise.
	#self.act_like_hub(packet, packet_in)
	#self.act_like_switch(packet, packet_in)
	#log.warning("Traffic in SW: %s -> %s on %s.  Drop." % (packet.src, packet.dst, event.port), dpidToStr(event.dpid))
	#log.debug("Traffic in SW: %s -> %s on %s.  Drop." % (packet.src, packet.dst, event.port))
	if packet.dst.isMulticast():
	  flood() # 3a
	else:
	 if packet.type == 0x0800:
	   ip_packet = packet.next
	   log.debug("Is Ethernet package")
	   if ip_packet.protocol == 0x01:
		icmp_packet = ip_packet.next
		log.debug("Is ICMP package")
		log.debug("SW:%s InPort:%i IP %s => %s", dpidToStr(event.dpid), inport, str(ip_packet.srcip), str(ip_packet.dstip))
	   if ip_packet.protocol == 0x17:
	   	udp_packet = ip_packet.next
		log.debug("Is UDP package")
		log.debug("SW:%s InPort:%i IP %s => %s", dpidToStr(event.dpid), inport, str(ip_packet.srcip), str(ip_packet.dstip))
	log.debug("SW:%s InPort:%i Eth %s => %s", dpidToStr(event.dpid), inport, str(packet.src), str(packet.dst))
	 
def launch (ruleset):
  """
  Starts the component
  """
  
  lruleset = ruleset

  def start_switch (event):
	log.debug("Controlling %s" % (event.connection,))
	sw = Tutorial(event.connection)
	sw.configureRules(event, lruleset)

  core.openflow.addListenerByName("ConnectionUp", start_switch)
