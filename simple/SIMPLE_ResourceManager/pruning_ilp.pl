#! /usr/bin/perl

use strict;

require "inputfileparse.pl";
require "shortestpathutils.pl";
require "policyutils.pl";

if ($#ARGV < 2)
{
	die "usage: configfile outputfile minimreqdperclass\n";
}


## read the config with 4 inputs -- policy, topology, mbox, switch
my $configfile = $ARGV[0];
my $formulationfile = $ARGV[1];
my $numsequencesperclass = $ARGV[2];
open (f,"<$configfile") or die "Cant read configfile\n";
my $data = "";
my $topologyfile = "";
my $policyfile = "";
my $mboxinventory = "";
my $switchinventory = "";

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


my $NumNodes = $NumSwitches+$NumBoxes+$NumHostNodes;

## generate shortest paths
my $PathsRef  =  dijkstra_shortest_paths($NumNodes, $TopologyIDRef);


## generate physical chains at middlebox sequence granularity -- e.g., M1 -->  M2
my $outfile_chains = "allchains";
my ($SequencesPerClass,$NumSequencesPerClass,$MboxInClassSequenceRef)  = enumerate_physical_sequences($ClassID2PolicyChainRef,$MboxType2SetRef,$outfile_chains);


## find route and per-switch cost 
## need a version of this that uses tunnels
my ($RoutesPerSequencePerClassRef, $SwitchInClassSequenceRef) = get_switch_cost_per_sequence($ClassID2PolicyChainRef,$ClassID2HostsRef,$SequencesPerClass, $NumSequencesPerClass, $NodeNametoIDRef, $NodeIDtoNameRef,$PathsRef);
## optimization logic goes here  

open(out1,">$formulationfile") or die "cant open $formulationfile\n";

print out1 "Minimize\n Cost:   LoadFunction \n";

print out1 "Subject To\n";



my $selectedvar = "d"; 

## Coverage for each class 
my $class = "";
foreach $class (keys %{$ClassID2PolicyChainRef})
{
	print out1 "Coverage.$class: ";
	## the sum of fractional values over all physical sequences must be set to 1
	for (my $i =0 ; $i < $NumSequencesPerClass->{$class}; $i++)
	{
		my $thiscoveragevar ="$selectedvar"."_$class"."_$i";	
		if ($i == 0)
		{
			print out1 "$thiscoveragevar";
		}
		else
		{
			print out1 " + $thiscoveragevar";
		}
	}
	print out1 "  >= $numsequencesperclass\n";
}

## Middlebox load is simply the number of chains it lies on
my $mbox = "";
foreach $mbox  (keys %{$MboxInClassSequenceRef})
{	
	my $classchain = "";
	print out1 "ProcLoad.$mbox: Load_$mbox ";
	my $flag = 0;
	foreach $classchain (keys %{$MboxInClassSequenceRef->{$mbox}})
	{
		my ($classid,$chainindex) = split(/\-/,$classchain);
		my $thiscoveragevar ="$selectedvar"."_$classid"."_$chainindex";	
		my $trafficvol =$ClassID2VolumeRef->{$classid};
		print out1 " -  $thiscoveragevar";
	}
	print out1 " = 0\n";
}

## loadfunction is maxload
foreach $mbox  (keys %{$MboxInClassSequenceRef})
{
	print out1 "MaxProcLoadBound.$mbox: Load_$mbox - LoadFunction <= 0\n";
}
	
## Switch constraints
my $switch = "";
foreach $switch  (keys %{$SwitchInClassSequenceRef})
{	
	my $classchain = "";
	print out1 "RuleLoad.$switch: ";
	my $flag = 0;
	foreach $classchain (keys %{$SwitchInClassSequenceRef->{$switch}})
	{
		my ($classid,$chainindex) = split(/\-/,$classchain);
		my $thisactivevar ="$selectedvar"."_$classid"."_$chainindex";	
		my $numoccurs = $SwitchInClassSequenceRef->{$switch}->{$classchain};
		if ($flag == 0)
		{
			print out1 " $numoccurs $thisactivevar";
			$flag  = 1;
		}
		else
		{
			print out1 " + $numoccurs $thisactivevar";

		}	
	}
	my $new_switch_resources_tunneling = $SwitchResourcesRef->{$switch} - $NumSwitches;
	## Need to fix this to also account for the tunneling rules 
	print out1 " <= $SwitchResourcesRef->{$switch}\n";
}

print out1 "Binaries\n";

my $class = "";
foreach $class (keys %{$ClassID2PolicyChainRef})
{
	my ($src,$dst) = split(/\;/,$ClassID2HostsRef->{$class});
	for (my $i =0 ; $i < $NumSequencesPerClass->{$class}; $i++)
	{
		my $thisactivevar ="$selectedvar"."_$class"."_$i";	
		print out1 "$thisactivevar\n";
	}
}


print out1 "End\n";
close(out1); 
