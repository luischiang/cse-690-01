#! /usr/bin/perl

## Routeoutput is the file where the routes are output
## LC: update, tunneling, 19 / April / 2013

use strict;
use POSIX;
require "inputfileparse.pl";
require "shortestpathutils.pl";
require "policyutils.pl";

if ($#ARGV < 4)
{
	die "usage: configfile Routeoutput optimization_solution switch_info host_info \n";
}

## read the config with 4 inputs -- policy, topology, mbox, switch
my $configfile = $ARGV[0];
my $outfile = $ARGV[1];
my $switchinfo = $ARGV[3];
my $hostinfo = $ARGV[4];
open (f,"<$configfile") or die "Cant read configfile\n";
my $data = "";
my $topologyfile = "";
my $policyfile = "";
my $mboxinventory = "";
my $switchinventory = "";
my %switch_table = ();
my $flag = -4;
while ($data = <f>)
{
	chomp($data);
	## topology
	if ($data =~/TOPOLOGY\s+(.*)/)
	{
		$topologyfile =$1;
		$flag++;
	}
	## policy req
	if ($data =~/POLICY\s+(.*)/)
	{
		$policyfile =$1;
		$flag++;
	}
	## mboxtypes
	if ($data =~/MBOXES\s+(.*)/)
	{
		$mboxinventory =$1;
		$flag++;
	}
	## switch resources
	if ($data =~/SWITCHES\s+(.*)/)
	{
		$switchinventory =$1;
		$flag++;
	}
}
close(f);

## read the input files

my ($TopologyNameRef,$TopologyIDRef,$NodeNametoIDRef, $NodeIDtoNameRef,$NumSwitches,$NumBoxes,$NumHostNodes) = read_topology($topologyfile);
my ($ClassID2PolicyChainRef, $ClassID2HostsRef,$ClassID2VolumeRef) = read_policy_chains($policyfile);
my ($MboxName2TypeRef, $MboxType2SetRef, $MboxResourcesRef) = middlebox_inventory($mboxinventory);
my ($SwitchResourcesRef) = switch_inventory($switchinventory);

# Getting the host, mb and switch information
my ($SwitchPortInfo, $SwitchMacInfo) = get_sw_info($switchinfo);
my ($HostMbIpInfo, $HostMbMacInfo) = get_hs_mb_info($hostinfo);

my $NumNodes = $NumSwitches+$NumBoxes+$NumHostNodes;

## generate shortest paths
my $PathsRef  =  dijkstra_shortest_paths($NumNodes, $TopologyIDRef);
 
## generate physical chains at middlebox sequence granularity -- e.g., M1 -->  M2
my $outfile_chains = "/tmp/junk";
my ($SequencesPerClass,$NumSequencesPerClass,$MboxInClassSequenceRef)  = enumerate_physical_sequences($ClassID2PolicyChainRef,$MboxType2SetRef,$outfile_chains);

my ($RoutesPerSequencePerClassRef, $SwitchInClassSequenceRef) = get_switch_cost_per_sequence($ClassID2PolicyChainRef,$ClassID2HostsRef,$SequencesPerClass, $NumSequencesPerClass, $NodeNametoIDRef, $NodeIDtoNameRef,$PathsRef);

# Added by Zafar
#my $PrunedSet = greedy_pruning_sequenceset( $SequencesPerClass, $NumSequencesPerClass, $RoutesPerSequencePerClassRef, $NodeIDtoNameRef,$ClassID2VolumeRef, $SwitchResourcesRef,$MboxResourcesRef );
my @data = `cat $ARGV[2] | awk '{if(\$1=="<variable") print \$2}' | awk -F"=" '{print \$2}'`;
my @data_value = `cat $ARGV[2] | awk '{if(\$1=="<variable") print \$5}' | awk -F"=" '{print \$2}'`;

#LC
#print "data: @data\n";
#print "data val: @data_value\n";

# Contains the fraction of traffic on each physical middlebox sequence: Solution of optmization problem
my %flow_table = ();
my %ActiveSet = ();

# Filling up the flow table from the optmization solution file
my $i = 0;

for($i=0; $i < @data; $i++)
{
	chomp($data[$i], $data_value[$i]);
	my ($trash, $flow_no, $trash_1) = split(/"/,$data[$i]);
	chomp ($flow_no);
	#print "$flow_no  \n";
	my($trash, $flow_value, $trash_1) = split(/"/,$data_value[$i]);
	chomp ($flow_value);
	#print "$flow_value  \n";

	chomp ($flow_value);
	if ($flow_no =~ m/f_.*_.*/)
	{
			$flow_table{$flow_no} = $flow_value;
	}
}

my $flow_key = 0;
foreach $flow_key (sort keys %flow_table)
{
	#LC
	#print "flow_key: $flow_key \n";
	
	if($flow_table{$flow_key} != 0)
	{
			my ($ftag, $classid, $seqid1) = split(/\_/,$flow_key);
			#print "$ftag, $class, $seqid\n";
			chomp($ftag, $classid, $seqid1);
			#print "Class = $class, Sequence = $seqid \n";
			$ActiveSet{$classid}->{$seqid1}=1;
	}
}

open(out,">$outfile");

my $class = 0;
my $tp_src = 1500;
my $tp_dst = 1500;
my $counter = 0;
#my $nw_tos_int = "";
#my $mod_nw_tos_int = "";

foreach $class (sort {$a<=>$b} keys %ActiveSet)
{
	my $seqid = 0;
	my $i = 0;
	$tp_src = $tp_src + 1;
	$tp_dst = $tp_dst + 1;
	my $nw_tos_int = 4;
	my $mod_nw_tos_int = 4;
	my $nw_tos_int_rev = 240;
	my $mod_nw_tos_int_rev = 240;
	
	foreach $i (keys %{$ActiveSet{$class}})
	{
		#print "$i \n";
		my $path = $RoutesPerSequencePerClassRef->{$class}->[$i];
		my $pathnames = convert_path_ids_to_names($path,$NodeIDtoNameRef);
	        #print out "$class $i Route = $path $pathnames\n";
		print out "$pathnames\n";
	 
		## split into segments
		my @pathelements = split(/\s+/,$pathnames);
		my @path = split(/\s+/,$path);
		my $dl_src = "";
		my $dl_src_rv = "";
		my $dl_dst = "";
		my $dl_dst_rv = "";
		my $in_port = 0;
		my $in_port_rv = 0;
		my $nw_src = "";
		my $nw_dst = "";
		my $mod_dl_src = "";
		my $mod_dl_src_rv = "";
		my $mod_dl_dst = "";
		my $mod_dl_dst_rv = "";
		my $output = 0;
		my $output_rv = 0;
		my $host_src_id = "";
		my $host_dst_id = "";
		my $dl_type= "0x0800";
		my $sw_id = "";
		my $node_id = "";		
		my $rule = "";
		my $rule_rv = "";
		my $sw_id = "";
		my $switch_id = "";
		my $nw_src_rv = "";
		my $nw_dst_rv = "";
		
		my $vlan_id = 0;
		
		#Network src and destination address
		#my($trash, $id)  = split(//,$pathelements[0]);
		#$host_src_id = "ho".$id;
		$host_src_id = $pathelements[0];
		$nw_src = $HostMbIpInfo->{$host_src_id};
		$nw_dst_rv = $nw_src;
		#print "$nw_src \n";
		#my($trash, $id) = split(//,$pathelements[$#pathelements]);
		#$host_dst_id = "ho".$id;
		$host_dst_id = $pathelements[$#pathelements];
                $nw_dst = $HostMbIpInfo->{$host_dst_id};
		$nw_src_rv = $nw_dst;
                #print "$nw_dst \n";

		my $k = 0;
		my $tunel_ahead = 0;
		my $tunel_end = -1;
		my $tunel_start = -1;
		#print out "Class=$clGass,Sequence=$i,Segment=$segmentid;"; 
		
		#pathelements cointains the sequence
		for (my $j =0; $j <= $#pathelements; $j++)
		{
			## segment ends at a mb
			#print out " $pathelements[$j]";
			#$nw_tos_int =  sprintf("0x%x",$nw_tos_int_int);
                	#$mod_nw_tos_int = sprintf("0x%x",$mod_nw_tos_int_int);
		
			if ($pathelements[$j] =~ /^S(\d+)/)
			{
				#LC
				#print "Element:  $pathelements[$j] \r\n";
				
				if($tunel_ahead == 0){
					$tunel_start = $j;
					for ($tunel_end = $j+1; $tunel_end <= $#pathelements; $tunel_end++){
						if($pathelements[$tunel_end] eq $pathelements[$j]){
							#print "Tunel Eq: $pathelements[$tunel_end] eq $pathelements[$j] \n";
							last;
						}					
					}
					
					if($tunel_end - $j > 2 && $tunel_end <= $#pathelements){
						$tunel_ahead = 1;
						#print "Tunel ahead - $tunel_end - $j - $pathelements[$j] - $pathelements[$tunel_end]\n";
						$vlan_id += 1;
					}
				}
				
				$k = $k+1;
					$nw_tos_int = $mod_nw_tos_int;
					$mod_nw_tos_int = 4 * ($k);
				$nw_tos_int_rev = 240-(4*$k);

				#my($trash, $id)  = split(//,$pathelements[$j]);
				my $id = substr($pathelements[$j],1);
				#$sw_id = "sw".$id;
				$sw_id = $pathelements[$j];
				$switch_id = $id;
				
				# Start adding a rule in the switch
				# First identify whether the switch is connected to a host, middlebox or another switch
				# Previous element in the chain
				if ($pathelements[$j-1] =~ /^S(\d+)/)
				{
					#my($trash, $id)  = split(//,$pathelements[$j-1]);
					$node_id = $pathelements[$j-1];
					$dl_src = $SwitchMacInfo->{$node_id}->{$sw_id};
                			$dl_dst = $SwitchMacInfo->{$sw_id}->{$node_id};
					$in_port = $SwitchPortInfo->{$sw_id}->{$node_id};
					 
					# Setup the reverse path
				        $mod_dl_dst_rv = $SwitchMacInfo->{$node_id}->{$sw_id};
                			$mod_dl_src_rv = $SwitchMacInfo->{$sw_id}->{$node_id};
					$output_rv = $SwitchPortInfo->{$sw_id}->{$node_id};
				}
 
				if ($pathelements[$j-1] =~ /^T(\d+)/)
				{
					#my($trash, $id)  = split(//,$pathelements[$j-1]);
					$node_id = $pathelements[$j-1];
					$dl_src = $HostMbMacInfo->{$node_id};
					$in_port = $SwitchPortInfo->{$sw_id}->{$node_id};
					$dl_dst = $SwitchMacInfo->{$sw_id}->{$node_id};
					 
					#Setup the reverse path
					$mod_dl_dst_rv = $HostMbMacInfo->{$node_id};
						$mod_dl_src_rv = $SwitchMacInfo->{$sw_id}->{$node_id};
					$output_rv = $SwitchPortInfo->{$sw_id}->{$node_id};
				}


				if ($pathelements[$j-1] =~ /^M(\d+)/)
				{
					#the end of the tunnel
					$tunel_ahead = 0;
					$tunel_end = $j;
					
					#my($trash, $id)  = split(//,$pathelements[$j-1]);
					$node_id = $pathelements[$j-1];
					$dl_src = $HostMbMacInfo->{$node_id};
					$in_port = $SwitchPortInfo->{$sw_id}->{$node_id};
					$dl_dst = $SwitchMacInfo->{$sw_id}->{$node_id};

					#Setup the reverse path
					$mod_dl_dst_rv = $HostMbMacInfo->{$node_id};
                			$mod_dl_src_rv = $SwitchMacInfo->{$sw_id}->{$node_id};
					$output_rv = $SwitchPortInfo->{$sw_id}->{$node_id};
				}
				
				# Next element in the chain
				if ($pathelements[$j+1] =~ /^S(\d+)/)
				{
					#my($trash, $id)  = split(//,$pathelements[$j+1]);
					$node_id = $pathelements[$j+1];
					$mod_dl_src = $SwitchMacInfo->{$sw_id}->{$node_id};
					$mod_dl_dst = $SwitchMacInfo->{$node_id}->{$sw_id};
					$output = $SwitchPortInfo->{$sw_id}->{$node_id};

					#Setup the reverse path
					$dl_src_rv = $SwitchMacInfo->{$node_id}->{$sw_id};
                			$dl_dst_rv = $SwitchMacInfo->{$sw_id}->{$node_id};
					$in_port_rv = $SwitchPortInfo->{$sw_id}->{$node_id};
				}

				if ($pathelements[$j+1] =~ /^T(\d+)/)
				{
					#my($trash, $id)  = split(//,$pathelements[$j+1]);
					$node_id = $pathelements[$j+1];
					$mod_dl_dst = $HostMbMacInfo->{$node_id};
					$output = $SwitchPortInfo->{$sw_id}->{$node_id};
					$mod_dl_src = $SwitchMacInfo->{$sw_id}->{$node_id};

					#Setup the reverse path
					$dl_src_rv = $HostMbMacInfo->{$node_id};
                                        $in_port_rv = $SwitchPortInfo->{$sw_id}->{$node_id};
					$dl_dst_rv = $SwitchMacInfo->{$sw_id}->{$node_id};
				}


				if ($pathelements[$j+1] =~ /^M(\d+)/)
				{
					#my($trash, $id)  = split(//,$pathelements[$j+1]);
					$node_id = $pathelements[$j+1];
						$mod_dl_dst = $HostMbMacInfo->{$node_id};
					$output = $SwitchPortInfo->{$sw_id}->{$node_id};
					$mod_dl_src = $SwitchMacInfo->{$sw_id}->{$node_id};

					#Setup the reverse path
					$dl_src_rv = $HostMbMacInfo->{$node_id};
						$in_port_rv = $SwitchPortInfo->{$sw_id}->{$node_id};
					$dl_dst_rv = $SwitchMacInfo->{$sw_id}->{$node_id};
				}

				#print "$pathelements[$j] ( S-E-J): $tunel_start $tunel_end - $j \n";
				
				# 
				# Forward path rules
				if($k == 1)
				{
					if( $tunel_ahead == 0){
					
						$rule = "dl_type=$dl_type, " . 
									"nw_src=$nw_src, nw_dst=$nw_dst, in_port=$in_port, " . 
								"actions=mod_dl_src:$mod_dl_src, mod_dl_dst:$mod_dl_dst, " . 
									"output:$output";	
					}else{
					
						$rule = "dl_type=$dl_type, " . 
									"nw_src=$nw_src, nw_dst=$nw_dst, in_port=$in_port, " . 
								"actions=mod_vlan_vid:$vlan_id, mod_dl_src:$mod_dl_src, mod_dl_dst:$mod_dl_dst, " . 
									"output:$output";
					
					}
					
					#print "$rule \n";
					$switch_table{$switch_id} = $switch_table{$switch_id}.$rule."\n";
				
				} else {
					
					if($pathelements[$j+1] =~ /^T(\d+)/){
					
						if( $tunel_ahead == 0){
						
						$rule = "dl_type=$dl_type, " . 
									"dl_src=$dl_src, dl_dst=$dl_dst, " .
										"in_port=$in_port, nw_src=$nw_src, nw_dst=$nw_dst, " . 
								"actions=mod_dl_src:$mod_dl_src, " . 
									"output:$output";

						}else{
						
						$rule = "dl_vlan=$vlan_id, dl_type=$dl_type, " . 
									"dl_src=$dl_src, dl_dst=$dl_dst, " .
										"in_port=$in_port, nw_src=$nw_src, nw_dst=$nw_dst, " . 
								"actions=mod_dl_src:$mod_dl_src, " . 
									"output:$output";
									
						}
					#print "$rule \n";
						$switch_table{$switch_id} = $switch_table{$switch_id}.$rule."\n";
					}elsif($pathelements[$j+1] =~ /^M(\d+)/){
					
						if( $tunel_ahead == 0){
						
						$rule = "dl_type=$dl_type, " . 
									"dl_src=$dl_src, dl_dst=$dl_dst, " .
										"in_port=$in_port, nw_src=$nw_src, nw_dst=$nw_dst, " . 
								"actions=mod_dl_src:$mod_dl_src, mod_dl_dst:$mod_dl_dst, " . 
									"output:$output";

						}else{
						
						$rule = "dl_vlan=$vlan_id, dl_type=$dl_type, " . 
									"dl_src=$dl_src, dl_dst=$dl_dst, " .
										"in_port=$in_port, nw_src=$nw_src, nw_dst=$nw_dst, " . 
								"actions=mod_dl_src:$mod_dl_src, mod_dl_dst:$mod_dl_dst, " . 
									"output:$output";
									
						}
						
						$switch_table{$switch_id} = $switch_table{$switch_id}.$rule."\n";
						
					}else{
						
						if( $tunel_ahead == 0){
							
							if($tunel_end == $j){
							
							$rule = "dl_type=$dl_type, " . 
										"dl_src=$dl_src, dl_dst=$dl_dst, in_port=$in_port, " . 
											"nw_src=$nw_src, nw_dst=$nw_dst, " . 
									"actions=mod_dl_src:$mod_dl_src, mod_dl_dst:$mod_dl_dst, " . 
											"output:$output";
											
							}elsif($tunel_start < $j){
							
							$rule = "dl_vlan=$vlan_id, dl_type=$dl_type, " . 
										"dl_src=$dl_src, dl_dst=$dl_dst, in_port=$in_port, " . 
											"nw_src=$nw_src, nw_dst=$nw_dst, " . 
									"actions=mod_dl_src:$mod_dl_src, mod_dl_dst:$mod_dl_dst, " . 
											"output:$output";

							}else{
							
							$rule = "dl_type=$dl_type, " . 
										"dl_src=$dl_src, dl_dst=$dl_dst, in_port=$in_port, " . 
											"nw_src=$nw_src, nw_dst=$nw_dst, " . 
									"actions=mod_dl_src:$mod_dl_src, mod_dl_dst:$mod_dl_dst, " . 
											"output:$output";

							}							
						}else{
							
							if($tunel_start == $j){
							$rule = "dl_type=$dl_type, " . 
									"dl_src=$dl_src, dl_dst=$dl_dst, in_port=$in_port, " . 
										"nw_src=$nw_src, nw_dst=$nw_dst, " . 
								"actions=mod_vlan_vid:$vlan_id, " . 
									"mod_dl_src:$mod_dl_src, mod_dl_dst:$mod_dl_dst, " . 
										"output:$output";
							}else{
							
							$rule = "dl_vlan=$vlan_id, dl_type=$dl_type, " . 
									"dl_src=$dl_src, dl_dst=$dl_dst, in_port=$in_port, " . 
										"nw_src=$nw_src, nw_dst=$nw_dst, " . 
								"actions=mod_vlan_vid:$vlan_id, " . 
									"mod_dl_src:$mod_dl_src, mod_dl_dst:$mod_dl_dst, " . 
										"output:$output";
										
							}
						}
						
						#print "$rule \n";
						$switch_table{$switch_id} = $switch_table{$switch_id}.$rule."\n";
					}
				}

				# Reverse path rules
				#if($pathelements[$j+1] =~ /^T(\d+)/){
				#	
				#	$rule_rv =  "dl_type=$dl_type, in_port=$in_port_rv, " . 
				#					"nw_src=$nw_src_rv, nw_dst=$nw_dst_rv, " .
				#				"actions=mod_vlan_vid:$mod_nw_tos_int_rev, " .
				#					"mod_dl_src:$mod_dl_src_rv, mod_dl_dst:$mod_dl_dst_rv, " . 
				#						"output:$output_rv";
				#						
				#	$switch_table{$switch_id} = $switch_table{$switch_id}.$rule_rv."\n";
				#	
				#}elsif($pathelements[$j-1] =~ /^T(\d+)/){
				#
				#	$rule_rv = 	"dl_type=$dl_type, dl_src=$dl_src_rv, " .
				#					"dl_dst=$dl_dst_rv, dl_vlan=$nw_tos_int_rev, in_port=$in_port_rv, " .
				#						"nw_src=$nw_src_rv, nw_dst=$nw_dst_rv, " . 
				#				"actions=mod_vlan_vid:$mod_nw_tos_int_rev, " . 
				#					"mod_dl_src:$mod_dl_src_rv, " . 
				#						"output:$output_rv";
				#					
				#	$switch_table{$switch_id} = $switch_table{$switch_id}.$rule_rv."\n";
				#}else{
				#	#mod_dl_dst_rv
				#	$rule_rv = 	"dl_type=$dl_type, dl_src=$dl_src_rv, " . 
				#					"dl_dst=$dl_dst_rv, dl_vlan=$nw_tos_int_rev, in_port=$in_port_rv, " .
				#						"nw_src=$nw_src_rv, nw_dst=$nw_dst_rv, " . 
				#				"actions=mod_vlan_vid:$mod_nw_tos_int_rev, " . 
				#					"mod_dl_src:$mod_dl_src_rv, mod_dl_dst:$mod_dl_dst_rv, " . 
				#						"output:$output_rv";
				#
				#	$switch_table{$switch_id} = $switch_table{$switch_id}.$rule_rv."\n";
				#}
				
				$mod_nw_tos_int_rev = $nw_tos_int_rev;
 
				#print out "\n";
				#$segmentid++;
				#print out "Class=$class,Sequence=$i,Segment=$segmentid;"; 
			}
		}
	
	last;	#print out "\n";
	}
}

close(out);


# The switch table contains the rules to be installed at each switch
# Parse each path, adding rules in the switch on the path

# LC, fix to match the sw id
my @swtable;

open stable, "switches_table.txt" or die $!;

while (chomp(my $line = <stable>)) {
	
	my @sparts = split(',', $line);
	
	#print "p0 $sparts[0] p1 $sparts[1]";
	
	push(@swtable, $sparts[0]);
	push(@swtable, $sparts[1]);
	
}

close(stable);

my %swmapping = @swtable;

my $key= "";
foreach $key (sort{$a<=>$b} keys %{switch_table})
{  
#LC: fix to find the switch id
 print "Switch " . $swmapping{"S" . $key} . ": \n$switch_table{$key}\n";
}

#my $test = "M10";
#my $sw1_id = "S5";
#print "$SwitchMacInfo->{$sw1_id}->{$test} \n";
