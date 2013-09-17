#! /usr/bin/perl

use strict;
use POSIX;
require "../optimization/inputfileparse.pl";
require "../optimization/shortestpathutils.pl";
require "../optimization/policyutils.pl";

if ($#ARGV < 2)
{
	die "usage: configfile segmentoutput optimization_solution \n";
}


## read the config with 4 inputs -- policy, topology, mbox, switch
my $configfile = $ARGV[0];
my $outfile = $ARGV[1];
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
my $outfile_chains = "/tmp/junk";
my ($SequencesPerClass,$NumSequencesPerClass,$MboxInClassSequenceRef)  = enumerate_physical_sequences($ClassID2PolicyChainRef,$MboxType2SetRef,$outfile_chains);

my ($RoutesPerSequencePerClassRef, $SwitchInClassSequenceRef) = get_switch_cost_per_sequence($ClassID2PolicyChainRef,$ClassID2HostsRef,$SequencesPerClass, $NumSequencesPerClass, $NodeNametoIDRef, $NodeIDtoNameRef,$PathsRef);

# Added by Zafar
#my $PrunedSet = greedy_pruning_sequenceset( $SequencesPerClass, $NumSequencesPerClass, $RoutesPerSequencePerClassRef, $NodeIDtoNameRef,$ClassID2VolumeRef, $SwitchResourcesRef,$MboxResourcesRef );
my @data = `cat $ARGV[2] | awk '{print \$2, \$4}'`;

# Contains the fraction of traffic on each physical middlebox sequence: Solution of optmization problem
my %flow_table = ();
my %ActiveSet = ();

# Filling up the flow table from the optmization solution file
my $i = 0;
for($i=0; $i < @data; $i++)
{
        chomp($data[$i]);
        my ($flow_no, $flow_value) = split(/\s+/,$data[$i]);
        chomp ($flow_no);
        chomp ($flow_value);
        if ($flow_no =~ m/f_.*_.*/)
        {
                $flow_table{$flow_no} = $flow_value;
        }
}

my $flow_key = 0;
foreach $flow_key (sort keys %flow_table)
{

        if($flow_table{$flow_key} == 1)
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
foreach $class (sort {$a<=>$b} keys %ActiveSet)
{
	my $seqid = 0;
	my $i = 0;
	foreach $i (keys %{$ActiveSet{$class}})
	{
		#print "$i \n";
		my $path = $RoutesPerSequencePerClassRef->{$class}->[$i];
		my $pathnames = convert_path_ids_to_names($path,$NodeIDtoNameRef);
		print "Here $class $i Route = $path $pathnames\n";
		## split into segments
		my @pathelements = split(/\s+/,$pathnames);
		my $segmentid = 1;
		print out "Class=$class,Sequence=$i,Segment=$segmentid;"; 
		for (my $j =0; $j <= $#pathelements; $j++)
		{
			## segment ends at a mb
			print out " $pathelements[$j]";
			if ($pathelements[$j] =~ /^M(\d+)/)
			{
				print out "\n";
				$segmentid++;
				print out "Class=$class,Sequence=$i,Segment=$segmentid;"; 
			}
		}
		print out "\n";
	} 

}

close(out);











