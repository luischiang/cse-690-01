#! /usr/bin/perl

use strict;
use POSIX;
require "../optimization/inputfileparse.pl";
require "../optimization/shortestpathutils.pl";
require "../optimization/policyutils.pl";

if ($#ARGV < 0)
{
	die "usage: optimization_solution \n";
}



# Added by Zafar
#my $PrunedSet = greedy_pruning_sequenceset( $SequencesPerClass, $NumSequencesPerClass, $RoutesPerSequencePerClassRef, $NodeIDtoNameRef,$ClassID2VolumeRef, $SwitchResourcesRef,$MboxResourcesRef );
my @data = `cat $ARGV[0] | awk '{if(\$1=="<variable") print \$2}' | awk -F"=" '{print \$2}'`;
my @data_value = `cat $ARGV[0] | awk '{if(\$1=="<variable") print \$4}' | awk -F"=" '{print \$2}'`;


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
        if ($flow_no =~ m/d_.*_.*/)
        {
                $flow_table{$flow_no} = $flow_value;
        }
}


my $flow_key = 0;
foreach $flow_key (sort {$a<=>$b} keys %flow_table)
{

	print "Flow=$flow_key , Value=$flow_table{$flow_key} \n";

}


#my $flow_key = 0;
#foreach $flow_key (sort keys %flow_table)
#{

#        if($flow_table{$flow_key} == 1)
#        {

 #               my ($ftag, $classid, $seqid1) = split(/\_/,$flow_key);
                #print "$ftag, $class, $seqid\n";
 #               chomp($ftag, $classid, $seqid1);
                #print "Class = $class, Sequence = $seqid \n";
 #               $ActiveSet{$classid}->{$seqid1}=1;


  #      }

#}
