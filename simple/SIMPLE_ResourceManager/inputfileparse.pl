#! /usr/bin/perl

use strict;



## map traffic class to policy chain
## Ingress Type host, Egress Type host,
## Required Type of middlebox processing = chain DiffMboxTypes
sub read_policy_chains
{
	my $filename = shift;
	open(f,"<$filename") or die "cant read policy file $filename\n";
	my $classid = 1;
	my %ClassID2PolicyChain = ();
	my %ClassID2Hosts = ();
	my %ClassID2Volume = ();
	my $data = "";
	while ($data = <f>)
	{
		chomp($data);
		if ($data =~ /^#/)
		{
			## ignore comment line
		}
		else
		{	
			my ($host1,$host2,$policychain,$volume) = split(/\s+/,$data);
			$ClassID2PolicyChain{$classid} = $policychain;
			$ClassID2Hosts{$classid} = "$host1;$host2";
			$ClassID2Volume{$classid} = $volume;
#			print "Here $classid $host1 $host2 $policychain\n";
			$classid++;
		}
	}
	return (\%ClassID2PolicyChain, \%ClassID2Hosts,\%ClassID2Volume);
}

## first entry is a switch, other entry can be switch, host or mbox
sub validate_topology_input
{
	my $node1 = shift;
	my $node2 = shift;
	if ($node1 =~ /^S\d+$/)
	{
		if ($node2 =~ /^S\d+$/ or $node2 =~ /^M\d+$/ or $node2 =~ /^T\d+$/)
		{
			return 1;
		}
	}
	return 0;
}

## Sequentially numbered starting from switches, then boxes, then hostnodes
sub get_nodename2id
{
	my $nodename = shift;
	my $hashref = shift;
	my $numswitches = shift;
	my $numboxes = shift;
	my $numhosts=  shift;
	if (defined $hashref->{$nodename})
	{
		return $hashref->{$nodename};
	}
	else
	{
		if ($nodename =~ /^S(\d+)$/)
		{
			return $1;
		}	
		elsif ($nodename =~ /^M(\d+)$/)
		{
			return $numswitches + $1;
		}
		elsif ($nodename =~ /^T(\d+)$/)
		{
			return $numswitches + $numboxes + $1;
		}
	}
	print "Error\n";
	
}

## three types of nodes 
## Host, Switch, Middlebox 
sub read_topology
{
	my $filename = shift;
	open(f,"<$filename") or die "cant read topology file $filename\n";
	my $globalnodeid = 1;
	my %NodeNametoID= ();
	my %NodeIDtoName = ();
	my %TopologyName = ();
	my %TopologyID = ();
	my $NumSwitches = 0;
	my $NumBoxes = 0;
	my $NumHostNodes = 0;
	my $data = "";
	while ($data = <f>)
	{
		chomp($data);
		if ($data =~ /^#/)
		{
			## ignore comment line
		}
		elsif ($data=~ /NUMSWITCHES=(\d+)/)
		{
			$NumSwitches = $1;
		}
		elsif ($data=~ /NUMMBOXES=(\d+)/)
		{
			$NumBoxes = $1;
		}
		elsif ($data=~ /NUMHOSTNODES=(\d+)/)
		{
			$NumHostNodes = $1;
		}
		else
		{
			my ($node1,$node2,$cost) = split(/\s+/,$data);
			if (validate_topology_input($node1,$node2) == 1)
			{
				my $nodeid1 = get_nodename2id($node1,\%NodeNametoID,$NumSwitches,$NumBoxes,$NumHostNodes); 
				my $nodeid2 = get_nodename2id($node2,\%NodeNametoID,$NumSwitches,$NumBoxes,$NumHostNodes); 
				$NodeNametoID{$node1} = $nodeid1;
				$NodeNametoID{$node2} = $nodeid2;
				#print "Came here name=$node1 id=$nodeid1\n";
				$NodeIDtoName{$nodeid1} = $node1;
				$NodeIDtoName{$nodeid2} = $node2;
				## assume symmetric link
				## by name
				$TopologyName{$node1}->{$node2}  = $cost;
				$TopologyName{$node2}->{$node1}  = $cost;
				## by nodeid
				$TopologyID{$nodeid1}->{$nodeid2}  = $cost;
				$TopologyID{$nodeid2}->{$nodeid1}  = $cost;
			}
		}
	}
	return (\%TopologyName,\%TopologyID,\%NodeNametoID,\%NodeIDtoName, $NumSwitches,$NumBoxes,$NumHostNodes);
}

## map each middlebox to its  type, resource cap  
sub middlebox_inventory
{
	my $filename = shift;
	open(f,"<$filename") or die "cant read mboxinventory file $filename\n";
	my %MboxName2Type = ();
	my %MboxType2Set = ();
	my %MboxResources = ();
	my $data = "";
	while ($data = <f>)
	{
		chomp($data);
		if ($data =~ /^#/)
		{
			## ignore comment line
		}
		else
		{
			my ($mboxid,$type,$resources) = split(/\s+/,$data);
			$MboxName2Type{$mboxid} = $type;
			$MboxType2Set{$type}->{$mboxid} = 1;
			$MboxResources{$mboxid}  = $resources;
		}
	}
	return \%MboxName2Type, \%MboxType2Set, \%MboxResources;

}
##  how many rules does each switch need to support a specific physical chain
sub switch_inventory
{
	my $filename = shift;
	open(f,"<$filename") or die "cant read switchinventory file $filename\n";
	my %SwitchResources = ();
	my $data = "";
	while ($data = <f>)
	{
		chomp($data);
		if ($data =~ /^#/)
		{
			## ignore comment line
		}
		else
		{
			my ($switchid,$resources) = split(/\s+/,$data);
			#print "here $switchid $resources\n";
			$SwitchResources{$switchid}  = $resources;
		}
	}
#	print "HERE S1 ".$SwitchResources{"S1"}."\n";
	return \%SwitchResources;
}


## Read the switch and host information from mininet and emulab
sub get_sw_info
{
	my $filename = shift;
        open(f,"<$filename") or die "cant read switch info file $filename\n";
        my %SwitchPortInfo = ();
	my %SwitchMacInfo = ();
        my $data = "";
        while ($data = <f>)
        {
                chomp($data);
                if ($data =~ /^#/)
                {
                        ## ignore comment line
                }
                else
                {
                        my ($switchname, $nodename, $port, $macaddr) = split(/\s+/,$data);
                        #print "here $switchid $resources\n";
                        $SwitchPortInfo{$switchname}->{$nodename} = $port;
			$SwitchMacInfo{$switchname}->{$nodename} = $macaddr;
			
                }
        }
#       print "HERE S1 ".$SwitchResources{"S1"}."\n";
        return \%SwitchPortInfo, \%SwitchMacInfo;



}

sub get_hs_mb_info
{
        my $filename = shift;
        open(f,"<$filename") or die "cant read host and mb info file $filename\n";
        my %HostMbMacInfo = ();
        my %HostMbIpInfo = ();
        my $data = "";
        while ($data = <f>)
        {
                chomp($data);
                if ($data =~ /^#/)
                {
                        ## ignore comment line
                }
                else
                {
                        my ($nodename, $ipaddr,$macaddr,$trash) = split(/\s+/,$data);
                        #print "here $switchid $resources\n";
                        $HostMbMacInfo{$nodename} = $macaddr;
                        $HostMbIpInfo{$nodename} = $ipaddr;

                }
        }
#       print "HERE S1 ".$SwitchResources{"S1"}."\n";
        return \%HostMbIpInfo, \%HostMbMacInfo;



}


1;
