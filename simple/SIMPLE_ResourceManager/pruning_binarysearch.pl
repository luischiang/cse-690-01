#! /usr/bin/perl

use Time::HiRes;
use strict;

system("echo \"Alive\" > /tmp/alive.txt");

if ($#ARGV < 3)
{
	die "usage: configfile topologyname  maxcoverageperclass usetunnel\n";
}
 
my $start = [ Time::HiRes::gettimeofday( ) ];
my $config = $ARGV[0];
my $topology = $ARGV[1];
my $maxbound = $ARGV[2];
my $usetunnel = $ARGV[3];
my $minbound = 1;
my $feasiblefound = 0;


for (my $bound = $maxbound ;$bound >= $minbound and $feasiblefound == 0 ; $bound = $bound/2)
{

	my $suffix= "$topology"."_$bound";
	print "Trying $bound\n";
	my $script = ($usetunnel > 0)? "pruning_ilp_withtunnels.pl": "pruning_ilp.pl";
	system("perl $script $config Formulation$suffix.lp $bound");
	
	
	my $status = `./ilpsolver Formulation$suffix.lp Solution$suffix`;
	
	## feasible solution found
	if ($status =~ /Solution\s+status\s+101/)
	{
		$feasiblefound = 1;
		print "Coverage found = $bound\n";
		my $maxbound1 = $bound*2;
		my $minbound1 = $bound;
		$feasiblefound = 0;
		my $bound1 = int (($maxbound1 + $minbound1)/2);
 
		while ( $bound1 > $minbound1 and  $bound1 < $maxbound1 and $feasiblefound == 0 )
		{
			my $suffix= "$topology"."_$bound1";
			print "Trying $bound1\n";
			my $script = ($usetunnel > 0)? "pruning_ilp_withtunnels.pl": "pruning_ilp.pl";
			system("perl $script $config Formulation$suffix.lp $bound1");
			
			my $status = `./ilpsolver Formulation$suffix.lp Solution$suffix`;
			
			if ($status =~ /Solution\s+status\s+101/){
				$feasiblefound = 1;
				print "Coverage found = $bound1\n";
				$minbound1 = $bound1;
				$feasiblefound = 0;
			} else {

				#print " I am here, max, $maxbound1, bound = $bound1 \n";
				$maxbound1 = $bound1;
			}
			$bound1 = int (($maxbound1 + $minbound1)/2);
		}
		$feasiblefound = 1;
	}
}



my $elapsed = Time::HiRes::tv_interval( $start );
print "Elapsed time: $elapsed seconds!\n";

