#! /usr/bin/perl

use strict;


my $HOME = "/home/zaqazi/middleboxsdn/optimization/";
require "$HOME/inputfileparse.pl";
require "$HOME/shortestpathutils.pl";
require "$HOME/policyutils.pl";

if ($#ARGV < 1)
{
	die "usage: configfile outputfile\n";
}


## read the config with 4 inputs -- policy, topology, mbox, switch
my $configfile = $ARGV[0];
my $formulationfile = $ARGV[1];
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
print "Done with enumeration\n";
my ($SequencesPerClass,$NumSequencesPerClass,$MboxInClassSequenceRef)  = enumerate_physical_sequences($ClassID2PolicyChainRef,$MboxType2SetRef,$outfile_chains);


## find route and per-switch cost 
## This stuff will go into our preprocessor ..
my ($RoutesPerSequencePerClassRef, $SwitchInClassSequenceRef) = get_switch_cost_per_sequence($ClassID2PolicyChainRef,$ClassID2HostsRef,$SequencesPerClass, $NumSequencesPerClass, $NodeNametoIDRef, $NodeIDtoNameRef,$PathsRef);


## Get pruned set -- hashmap {class}->{id}
print "Done with pruning\n";
my $PrunedSet = greedy_pruning_sequenceset( $SequencesPerClass, $NumSequencesPerClass, $RoutesPerSequencePerClassRef, $NodeIDtoNameRef,$ClassID2VolumeRef, $SwitchResourcesRef,$MboxResourcesRef );
## optimization logic goes here  

open(out1,">$formulationfile") or die "cant open $formulationfile\n";

print out1 "Minimize\n Cost:   LoadFunction \n";

print out1 "Subject To\n";



my $fractionvar = "f"; 
my $activefractionvar = "a"; 

## Coverage for each class 
my $class = "";
foreach $class (keys %{$ClassID2PolicyChainRef})
{
	print out1 "Coverage.$class: ";
	## the sum of fractional values over all physical sequences must be set to 1
	#for (my $i =0 ; $i < $NumSequencesPerClass->{$class}; $i++)
	my $i =0;
	foreach $i (keys %{$PrunedSet->{$class}})
	{
		my $thiscoveragevar ="$fractionvar"."_$class"."_$i";	
		if ($flag == 0)
		{
			print out1 "$thiscoveragevar";
			$flag = 1;
		}
		else
		{
			print out1 " + $thiscoveragevar";
		}
	}
	print out1 "  = 1\n";
}

## Middlebox load
my $mbox = "";
foreach $mbox  (keys %{$MboxInClassSequenceRef})
{	
	my $classchain = "";
	print out1 "ProcLoad.$mbox: Load.$mbox ";
	my $flag = 0;
	foreach $classchain (keys %{$MboxInClassSequenceRef->{$mbox}})
	{
		my ($classid,$chainindex) = split(/\-/,$classchain);
		if (defined $PrunedSet->{$classid}->{$chainindex})
		{
			my $thiscoveragevar ="$fractionvar"."_$classid"."_$chainindex";	
			my $trafficvol =$ClassID2VolumeRef->{$classid};
			print out1 " - $trafficvol $thiscoveragevar";
		}
	}
	print out1 " = 0\n";
}
foreach $mbox  (keys %{$MboxInClassSequenceRef})
{
	print out1 "ProcLoadBound.$mbox: Load.$mbox <= $MboxResourcesRef->{$mbox}\n";
}

## loadfunction is maxload
foreach $mbox  (keys %{$MboxInClassSequenceRef})
{
	print out1 "MaxProcLoadBound.$mbox: Load.$mbox - LoadFunction <= 0\n";
}
	


print out1 "Bounds\n";

my $class = "";
foreach $class (keys %{$ClassID2PolicyChainRef})
{
	my ($src,$dst) = split(/\;/,$ClassID2HostsRef->{$class});
	#for (my $i =0 ; $i < $NumSequencesPerClass->{$class}; $i++)
	my $i = 0;
	foreach $i (keys %{$PrunedSet->{$class}})
	{
		my $thiscoveragevar ="$fractionvar"."_$class"."_$i";	
		print out1 " 0 <= $thiscoveragevar <= 1\n";
	}
}

### needs to filled in 
print out1 "End\n";
close(out1); 
