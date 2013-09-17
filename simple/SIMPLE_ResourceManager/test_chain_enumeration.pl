#! /usr/bin/perl

use strict;
require "inputfileparse.pl";
require "policyutils.pl";

my $policyfile = "PolicyChains_Hotnets";
my $mboxinventory = "MboxInventory_Hotnets";


my ($ClassID2PolicyChainRef, $ClassID2HostsRef,$ClassID2VolumeRef) = read_policy_chains($policyfile);
my ($MboxName2TypeRef, $MboxType2SetRef, $MboxResourcesRef) = middlebox_inventory($mboxinventory);

my ($perclass,$numperclass)  = enumerate_physical_chains($ClassID2PolicyChainRef,$MboxType2SetRef);
#print "$ClassID2PolicyChainRef->{1}\n";
my $classid= "";
foreach $classid (keys %{$ClassID2PolicyChainRef})
{
	print "Policy = $ClassID2PolicyChainRef->{$classid}\n";
	for (my $i =0 ; $i < $numperclass->{$classid}; $i++)
	{
		print "\t\t$perclass->{$classid}->[$i]\n";
	}
}	
