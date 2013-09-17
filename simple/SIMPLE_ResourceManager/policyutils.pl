#! /usr/bin/perl

use strict;

#my $HOMELIB = "/Users/vyas/middleboxsdn";
#use Hash::PriorityQueue;
#use Heap::Priority;

sub get_all_physical
{
	my $sequence = shift;
	my $MboxType2SetRef = shift;
	my @types = split(/,/,$sequence);
	my %AllSequences = ();;
	if ($#types == 0)
	{
		#print "HERE basecase $sequence\n";
		#<STDIN>;
		my $type = $types[0];
		my $node = "";
		foreach $node (keys %{$MboxType2SetRef->{$type}})
		{
			$AllSequences{$node} = 1;
		}
		return \%AllSequences;
	}
	else
	{
		my $seqremain = join(',',@types[1..$#types]);
		#print "HERE recurse $seqremain\n";
		#<STDIN>;
		my $AllSequencesTmp = get_all_physical($seqremain,$MboxType2SetRef);
		my $type = $types[0];
		my $node = "";
		foreach $node (keys %{$MboxType2SetRef->{$type}})
		{
			my $tmpseq = "";
			foreach $tmpseq (keys %{$AllSequencesTmp})
			{
				$AllSequences{"$node,$tmpseq"} = 1;
			}
		}
		return \%AllSequences;
	}
}


## for each policy chain, enumerate all possible physical realizations
sub enumerate_physical_sequences
{
	my $ClassID2PolicyChainRef = shift;
	my $MboxType2SetRef = shift;
	my $outfile = shift;
	open(out,">$outfile") or die "Cant open chain sequence output $outfile\n";
	my %PerClassEnumeration = "";
	my %NumPhysicalPerClass = "";
	my %MboxinClassChain = ();
	
	my $classid = "";
	foreach $classid (keys %{$ClassID2PolicyChainRef})
	{
		my $sequence = $ClassID2PolicyChainRef->{$classid};
#		print "Here classid = $classid\n";
		print out "Class=$classid\n";
		my $allphysicalref = get_all_physical($sequence,$MboxType2SetRef);
		my $seq = "";
		my $index = 0;
		foreach $seq (keys %{$allphysicalref})
		{
			$PerClassEnumeration{$classid}->[$index] = $seq;
			print out "\tIndex=$index Sequence=$seq\n";
			my @boxes = split(/,/,$seq);
			my $box = "";
			foreach $box (@boxes)
			{
				$MboxinClassChain{$box}->{"$classid-$index"} = 1;
			}
			$index++;	
		}
		$NumPhysicalPerClass{$classid} = $index;
	}
	close(out);
	return \%PerClassEnumeration,\%NumPhysicalPerClass,\%MboxinClassChain;	
}


sub get_switch_cost_per_sequence_tunneling
{
	my $ClassID2PolicyChainRef = shift;
	my $ClassID2HostsRef = shift;
	my $SequencesPerClass = shift;
	my $NumSequencesperClass = shift;
	my $NodeNametoIDRef = shift;
	my $NodeIDtoNameRef = shift;
 	my $PathsRef = shift;

	my %SwitchInClassSequence = ();
	my %RoutesPerSequencePerClass = ();
	my $class = "";
	foreach $class (keys %{$ClassID2PolicyChainRef})
	{
		my ($src,$dst) = split(/\;/,$ClassID2HostsRef->{$class});                             	
		#print "Class = $class $src $dst\n";
	        for (my $i =0 ; $i < $NumSequencesperClass->{$class}; $i++)
	        {
	        	my $sequence = $SequencesPerClass->{$class}->[$i]; 
	        	my @nodes = split(/,/,$sequence);
	        	
	        	my $fullroute = "";
	        	for (my $j =0; $j <= $#nodes; $j++)
	        	{
	        		if ($j ==0)
	        		{
	        			my $nodeprev = $NodeNametoIDRef->{$src};
	        			my $nodenext = $NodeNametoIDRef->{$nodes[0]};
	        			my $route =  $PathsRef->{$nodeprev}->{$nodenext};
	        			#print "herestart $nodeprev $nodenext $route\n";
	        			$fullroute = $route;
	        		}
	        		else
	        		{
	        			## route from j-1 --> j 
	        			my $nodeprev = $NodeNametoIDRef->{$nodes[$j-1]};
	        			my $nodenext = $NodeNametoIDRef->{$nodes[$j]};
	        			my $route =  remove_src($PathsRef->{$nodeprev}->{$nodenext});
	        			#print "heremid $nodeprev $nodenext $route\n";
	        			$fullroute = "$fullroute $route";
	        		}
	        	}
	        	## LAST HOP
	        	my $nodeprev = $NodeNametoIDRef->{$nodes[$#nodes]};
	        	my $nodenext = $NodeNametoIDRef->{$dst};
	        	my $route =  remove_src($PathsRef->{$nodeprev}->{$nodenext});
	        	$fullroute = "$fullroute $route";
	        	$RoutesPerSequencePerClass{$class}->[$i] = $fullroute;
	        	my @allnodeids = split(/\s+/,$fullroute);
			#my $nameroute = get_route_by_name(\@allnodeids, $#allnodeids,  $NodeIDtoNameRef);
			#print "$src $dst $class-$i $nameroute\n";
	        	my $nodeid = "";
	        	my $classchain = "$class-$i";
	        	for (my $index = 0; $index <= $#allnodeids; $index++)
	        	{
				my  $nodeid = $allnodeids[$index];
	        		my $nodename = $NodeIDtoNameRef->{$nodeid};
				my $nextnode = -1;
				my $prevnode = -1;
				if ($index != $#allnodeids)
				{
					my  $nextnodeid = $allnodeids[$index+1];
					$nextnode = $NodeIDtoNameRef->{$nextnodeid};
				}
				if ($index != 0)
				{
					my  $prevnodeid = $allnodeids[$index-1];
					$prevnode = $NodeIDtoNameRef->{$prevnodeid};
				}
				## only switches need rules
	        		if ($nodename =~/^S(\d+)/)
	        		{
#	        			
					# if next node is a mbox then need 1 rule for sending a subset to the mbox
					if ($nextnode =~ /^M(\d+)/)
					{
	        				$SwitchInClassSequence{$nodename}->{$classchain} = $SwitchInClassSequence{$nodename}->{$classchain} + 1;
	#					print "\there $nodename mboxrule pre\n";
					}
					# if previous node is a mbox then need 1 rule for tunneling to next switch
					elsif ($prevnode =~ /^M(\d+)/)
					{
	        				$SwitchInClassSequence{$nodename}->{$classchain} = $SwitchInClassSequence{$nodename}->{$classchain} + 1;
	#					print "\there $nodename mboxrule post\n";
					}
					else
					{
						## 0 and #allnodes are actually the host nodes and not switches
						## If ingress or egress switch and they have no mboxes as such then treat it separately 
						## if they have mboxes then dont double count the rule
						if ($index == 1)
						{
	        					$SwitchInClassSequence{$nodename}->{$classchain} = $SwitchInClassSequence{$nodename}->{$classchain} + 1;
	#						print "\there $nodename ingress rule\n";
						}
						if ($index == ($#allnodeids-1) )
						{
	        					$SwitchInClassSequence{$nodename}->{$classchain} = $SwitchInClassSequence{$nodename}->{$classchain} + 1;
	#						print "\there $nodename egress rule\n";
						}
					}
	        		}
	        	}
	        }
	}
	return (\%RoutesPerSequencePerClass, \%SwitchInClassSequence);
}

sub get_switch_cost_per_sequence
{
	my $ClassID2PolicyChainRef = shift;
	my $ClassID2HostsRef = shift;
	my $SequencesPerClass = shift;
	my $NumSequencesperClass = shift;
	my $NodeNametoIDRef = shift;
	my $NodeIDtoNameRef = shift;
 	my $PathsRef = shift;

	my %SwitchInClassSequence = ();
	my %RoutesPerSequencePerClass = ();
	my $class = "";
	foreach $class (keys %{$ClassID2PolicyChainRef})
	{
		my ($src,$dst) = split(/\;/,$ClassID2HostsRef->{$class});                             	
		#print "Class = $class $src $dst\n";
	        for (my $i =0 ; $i < $NumSequencesperClass->{$class}; $i++)
	        {
	        	my $sequence = $SequencesPerClass->{$class}->[$i]; 
	        	my @nodes = split(/,/,$sequence);
	        	
	        	my $fullroute = "";
	        	for (my $j =0; $j <= $#nodes; $j++)
	        	{
	        		if ($j ==0)
	        		{
	        			my $nodeprev = $NodeNametoIDRef->{$src};
	        			my $nodenext = $NodeNametoIDRef->{$nodes[0]};
	        			my $route =  $PathsRef->{$nodeprev}->{$nodenext};
	        			#print "herestart $nodeprev $nodenext $route\n";
	        			$fullroute = $route;
	        		}
	        		else
	        		{
	        			## route from j-1 --> j 
	        			my $nodeprev = $NodeNametoIDRef->{$nodes[$j-1]};
	        			my $nodenext = $NodeNametoIDRef->{$nodes[$j]};
	        			my $route =  remove_src($PathsRef->{$nodeprev}->{$nodenext});
	        			#print "heremid $nodeprev $nodenext $route\n";
	        			$fullroute = "$fullroute $route";
	        		}
	        	}
	        	## LAST HOP
	        	my $nodeprev = $NodeNametoIDRef->{$nodes[$#nodes]};
	        	my $nodenext = $NodeNametoIDRef->{$dst};
	        	my $route =  remove_src($PathsRef->{$nodeprev}->{$nodenext});
	        	#print "hereend $nodeprev $nodenext $route\n";
	        	$fullroute = "$fullroute $route";
	        	$RoutesPerSequencePerClass{$class}->[$i] = $fullroute;
	        	my @allnodeids = split(/\s+/,$fullroute);
	        	my $nodeid = "";
	        	my $classchain = "$class-$i";
	        	foreach $nodeid (@allnodeids)		
	        	{
	        		my $nodename = $NodeIDtoNameRef->{$nodeid};
	        		if ($nodename =~/^S(\d+)/)
	        		{
#	        			print "HERE $nodename\n";
	        			if (not defined $SwitchInClassSequence{$nodename}->{$classchain})
	        			{
	        				$SwitchInClassSequence{$nodename}->{$classchain}= 0;
	        			}
	        			$SwitchInClassSequence{$nodename}->{$classchain}++;
	        		}
	        	}
	        	#print "Seq = $sequence Route= $fullroute\n";
	        }
	}
	return (\%RoutesPerSequencePerClass, \%SwitchInClassSequence);
}

sub get_cost_for_given_class_sequence
{
	my $CurrentClass = shift;
	my $CurrentSequence = shift;
	my $RoutesPerSequencePerClass = shift;
	my $NodeIDtoNameRef = shift;
	my $ClassID2VolumeRef = shift; 

	my $fullroute =	$RoutesPerSequencePerClass->{$CurrentClass}->[$CurrentSequence];
	my @allnodeids = split(/\s+/,$fullroute);
	my $nodeid = "";
	my %switchcost = 0;
	my %mboxcost = ();
	my $totalmboxcost = 0;
	my $totalswitchcost = 0;
	foreach $nodeid (@allnodeids)		
	{
		my $nodename = $NodeIDtoNameRef->{$nodeid};
		if ($nodename =~/^(S\d+)$/)
		{
			$switchcost{$1}++;
			$totalswitchcost++;
		}
		##TODO model mbox cost also
	}
	return (\%switchcost,\%mboxcost,$totalswitchcost,$totalmboxcost);
}

sub check_feasibility
{
	my $SequenceID = shift;
	my $SwitchResourcesLeft = shift;
	my $MboxResourcesLeft = shift;
	my $PerSeqPerSwitchCost = shift;
	my $PerSeqPerMboxCost = shift;
	my $feasible =1;
	my $switch = "";
	foreach $switch (keys %{$SwitchResourcesLeft})
	{
		if ($PerSeqPerSwitchCost->{$SequenceID}->{$switch} > $SwitchResourcesLeft->{$switch})
		{ 
			print "Became infeasible for $SequenceID at switch $switch has only $SwitchResourcesLeft->{$switch} but needs $PerSeqPerSwitchCost->{$SequenceID}->{$switch}\n";
			$feasible = 0;
		}
	}
	## TODO check feasibility on mbox also
	return $feasible;
}

sub incremental_utility
{
	my $CoveredPolicyClasses = shift;
	my $CurrentClass = shift;
	if (not defined $CoveredPolicyClasses->{$CurrentClass})
	{
		return 1;
	}
	else
	{
		return 0.1;
	}
}

sub update_resources_given_selected
{
	my $SelectedSeq = shift;
	my $PerSeqPerSwitchCost = shift;
	my $PerSeqPerMboxCost = shift;
	my $SwitchResourcesLeft = shift;
	my $MboxResourcesLeft = shift;

	my $switch = "";
	foreach $switch (keys %{$PerSeqPerSwitchCost->{$SelectedSeq}})
	{
		print "$switch Before = $SwitchResourcesLeft->{$switch}\n";
		$SwitchResourcesLeft->{$switch} =  $SwitchResourcesLeft->{$switch} - $PerSeqPerSwitchCost->{$SelectedSeq}->{$switch};
		print "$switch After = $SwitchResourcesLeft->{$switch}\n";
	}
	## TODO mbox resources

}


sub greedy_pruning_sequenceset
{
	## this is the output of the enumerate physical chains 
	my $SequencesPerClass = shift;
	my $NumSequencesPerClass = shift;
	## this is the output of get_switch cost 
	my $RoutesPerSequencePerClass = shift;
	## these are basic inputs from parsing the files
	my $NodeIDtoNameRef = shift;
	my $ClassID2VolumeRef = shift;
	my $SwitchResourcesRef = shift;
	my $MboxResourcesRef  = shift;
	my $maxiter = shift;

	my %SwitchResourcesLeft = ();
	my %MboxResourcesLeft = ();
	my %CoveredPolicyClasses = ();

	my %Utility = ();
	my %Cost = ();
	my %UtilityByCost = ();
	my %Feasible = ();

	my %PerSeqPerSwitchCost = "";
	my %PerSeqPerMboxCost = "";
	my %PerSeqTotalSwitchCost = "";
	my %PerSeqTotalMboxCost = "";
	
	##  INITIALIZE STUFF  for resources left
	my $switch ="";
	foreach $switch	(keys %{$SwitchResourcesRef})
	{
		#print "Here!! $switch !! $SwitchResourcesRef->{$switch}\n";
		$SwitchResourcesLeft{$switch} = $SwitchResourcesRef->{$switch};		
	#	<STDIN>;
	}
	my $mbox = "";
	foreach $mbox	(keys %{$MboxResourcesRef})
	{
		$MboxResourcesLeft{$mbox} = $MboxResourcesRef->{$mbox};		
	}	

	## PerSequence initialization of cost/utility
	my $class = "";
	foreach $class (keys %{$SequencesPerClass})
	{
		for (my $i =0; $i < $NumSequencesPerClass->{$class}; $i++)
		{
			my $key = "$class-$i";	
			
			#print "Checking $key\n";
			my ($perswitchcost,$permboxcost,$totalswitchcost,$totalmboxcost) = get_cost_for_given_class_sequence($class,$i, $RoutesPerSequencePerClass, $NodeIDtoNameRef, $ClassID2VolumeRef);
			$PerSeqPerSwitchCost{$key} = $perswitchcost;
			$PerSeqTotalSwitchCost{$key} = $totalswitchcost;
			$PerSeqPerMboxCost{$key} = $permboxcost;
			$PerSeqTotalMboxCost{$key} = $totalmboxcost;

			my $feasible = check_feasibility($key,\%SwitchResourcesLeft,\%MboxResourcesLeft,\%PerSeqPerSwitchCost,\%PerSeqPerMboxCost);
			if ($feasible == 1)
			{
				$Utility{$key} 	= incremental_utility(\%CoveredPolicyClasses,$class);
				$Cost{$key} = $totalswitchcost;		
				$UtilityByCost{$key} = $Utility{$key}/$Cost{$key};
				$Feasible{$key} =1;
				#print "Initialized $key $Utility{$key} $Cost{$key}\n";
			}
			else
			{
				print "Infeasible! $key\n";
			}
		}
	}
	my $progress = 1;
	my $iteration =1;
	## Pick greedy based on utilitybycost 
	my %PrunedSet = ();
	while ($progress == 1 and $iteration <= $maxiter)
	{
		print "Iteration  = $iteration\n";
		my $key = "";
		my $selected_key = -1;

		## ONE GREEDY ITERATION HAPPENS HERE
		foreach $key (sort {$UtilityByCost{$b} <=> $UtilityByCost{$a}} keys %UtilityByCost)
		{
			print "Checking $key $UtilityByCost{$key}\n";
			if (defined $Feasible{$key})
			{
				my $feasible = check_feasibility($key,\%SwitchResourcesLeft,\%MboxResourcesLeft,\%PerSeqPerSwitchCost,\%PerSeqPerMboxCost);
				if ($feasible == 1)
				{
					$selected_key = $key;
					last;
				}
				else
				{
					## remove this key from consideration
					print "$key became infeasible\n";
					delete $Feasible{$key};
					delete $UtilityByCost{$key};
				}
			}
			else
			{	
				print "$key already infeasible\n";
			}
		}
		if ($selected_key ne -1)
		{ 
			my ($class,$selectedid) = split(/-/,$selected_key);
			print "Greedy selecting $class-$selectedid $Utility{$selected_key} $Cost{$selected_key} $UtilityByCost{$selected_key}\n";
			$PrunedSet{$class}->{$selectedid}=1;

			## update resources left on the switches and resource
			update_resources_given_selected($selected_key, \%PerSeqPerSwitchCost, \%PerSeqPerMboxCost, \%SwitchResourcesLeft, \%MboxResourcesLeft);

			## update covered policy classes
			$CoveredPolicyClasses{$class} = $CoveredPolicyClasses{$class} + $Utility{$selected_key};

			## remove this sequence from future consideration since it is already picked
			delete $Feasible{$selected_key};
			delete $UtilityByCost{$selected_key}; # = -100;
		
			## update utility values for all other sequences that cover this class
			for (my $i =0; $i < $NumSequencesPerClass->{$class}; $i++)
			{
				my $newkey = "$class-$i";
				## check if this guy isnt already disabled
				if (defined $UtilityByCost{$newkey})
				{
					$Utility{$newkey}= incremental_utility(\%CoveredPolicyClasses,$class);
					$Cost{$newkey} = $PerSeqTotalSwitchCost{$newkey};
					$UtilityByCost{$newkey} = $Utility{$newkey}/$Cost{$newkey};
				}
			}
		}
		else
		{
			## Resources are saturated exit the loop!
			print "No more resources or no more chains to pick\n";
			$progress =0;
		}
		$iteration++;
	}
	return \%PrunedSet;
}



sub greedy_pruning_sequenceset_maxiter
{
	## this is the output of the enumerate physical chains 
	my $SequencesPerClass = shift;
	my $NumSequencesPerClass = shift;
	## this is the output of get_switch cost 
	my $RoutesPerSequencePerClass = shift;
	## these are basic inputs from parsing the files
	my $NodeIDtoNameRef = shift;
	my $ClassID2VolumeRef = shift;
	my $SwitchResourcesRef = shift;
	my $MboxResourcesRef  = shift;
	my $maxiter = shift;

	my %SwitchResourcesLeft = ();
	my %MboxResourcesLeft = ();
	my %CoveredPolicyClasses = ();

	my %Utility = ();
	my %Cost = ();
	my %UtilityByCost = ();
	my %Feasible = ();

	my %PerSeqPerSwitchCost = "";
	my %PerSeqPerMboxCost = "";
	my %PerSeqTotalSwitchCost = "";
	my %PerSeqTotalMboxCost = "";
	
	##  INITIALIZE STUFF  for resources left
	my $switch ="";
	foreach $switch	(keys %{$SwitchResourcesRef})
	{
		#print "Here!! $switch !! $SwitchResourcesRef->{$switch}\n";
		$SwitchResourcesLeft{$switch} = $SwitchResourcesRef->{$switch};		
	#	<STDIN>;
	}
	my $mbox = "";
	foreach $mbox	(keys %{$MboxResourcesRef})
	{
		$MboxResourcesLeft{$mbox} = $MboxResourcesRef->{$mbox};		
	}	

	## PerSequence initialization of cost/utility
	my $class = "";
	foreach $class (keys %{$SequencesPerClass})
	{
		for (my $i =0; $i < $NumSequencesPerClass->{$class}; $i++)
		{
			my $key = "$class-$i";	
			
			#print "Checking $key\n";
			my ($perswitchcost,$permboxcost,$totalswitchcost,$totalmboxcost) = get_cost_for_given_class_sequence($class,$i, $RoutesPerSequencePerClass, $NodeIDtoNameRef, $ClassID2VolumeRef);
			$PerSeqPerSwitchCost{$key} = $perswitchcost;
			$PerSeqTotalSwitchCost{$key} = $totalswitchcost;
			$PerSeqPerMboxCost{$key} = $permboxcost;
			$PerSeqTotalMboxCost{$key} = $totalmboxcost;

			my $feasible = check_feasibility($key,\%SwitchResourcesLeft,\%MboxResourcesLeft,\%PerSeqPerSwitchCost,\%PerSeqPerMboxCost);
			if ($feasible == 1)
			{
				$Utility{$key} 	= incremental_utility(\%CoveredPolicyClasses,$class);
				$Cost{$key} = $totalswitchcost;		
				$UtilityByCost{$key} = $Utility{$key}/$Cost{$key};
				$Feasible{$key} =1;
				#print "Initialized $key $Utility{$key} $Cost{$key}\n";
			}
			else
			{
				print "Infeasible! $key\n";
			}
		}
	}
	my $progress = 1;
	my $iteration =1;
	## Pick greedy based on utilitybycost 
	my %PrunedSet = ();
	while ($progress == 1 and $iteration <= $maxiter)
	{
		print "Iteration  = $iteration\n";
		my $key = "";
		my $selected_key = -1;

		## ONE GREEDY ITERATION HAPPENS HERE
		foreach $key (sort {$UtilityByCost{$b} <=> $UtilityByCost{$a}} keys %UtilityByCost)
		{
			print "Checking $key $UtilityByCost{$key}\n";
			if (defined $Feasible{$key})
			{
				my $feasible = check_feasibility($key,\%SwitchResourcesLeft,\%MboxResourcesLeft,\%PerSeqPerSwitchCost,\%PerSeqPerMboxCost);
				if ($feasible == 1)
				{
					$selected_key = $key;
					last;
				}
				else
				{
					## remove this key from consideration
					print "$key became infeasible\n";
					delete $Feasible{$key};
					delete $UtilityByCost{$key};
				}
			}
			else
			{	
				print "$key already infeasible\n";
			}
		}
		if ($selected_key ne -1)
		{ 
			my ($class,$selectedid) = split(/-/,$selected_key);
			print "Greedy selecting $class-$selectedid $Utility{$selected_key} $Cost{$selected_key} $UtilityByCost{$selected_key}\n";
			$PrunedSet{$class}->{$selectedid}=1;

			## update resources left on the switches and resource
			update_resources_given_selected($selected_key, \%PerSeqPerSwitchCost, \%PerSeqPerMboxCost, \%SwitchResourcesLeft, \%MboxResourcesLeft);

			## update covered policy classes
			$CoveredPolicyClasses{$class} = $CoveredPolicyClasses{$class} + $Utility{$selected_key};

			## remove this sequence from future consideration since it is already picked
			delete $Feasible{$selected_key};
			delete $UtilityByCost{$selected_key}; # = -100;
		
			## update utility values for all other sequences that cover this class
			for (my $i =0; $i < $NumSequencesPerClass->{$class}; $i++)
			{
				my $newkey = "$class-$i";
				## check if this guy isnt already disabled
				if (defined $UtilityByCost{$newkey})
				{
					$Utility{$newkey}= incremental_utility(\%CoveredPolicyClasses,$class);
					$Cost{$newkey} = $PerSeqTotalSwitchCost{$newkey};
					$UtilityByCost{$newkey} = $Utility{$newkey}/$Cost{$newkey};
				}
			}
		}
		else
		{
			## Resources are saturated exit the loop!
			print "No more resources or no more chains to pick\n";
			$progress =0;
		}
		$iteration++;
	}
	return \%PrunedSet;
}



##(\%Utility, \%Cost, \%Feasible, \%CoveredPolicyClasses, \%PerSeqPerSwitchCost, \%PerSeqPerMboxCost, \%SwitchResourcesLeft, \%MboxResourcesLeft);

sub get_next_best_key
{
	my $UtilityRef = shift;
	my $CostRef = shift;
	my $Feasible = shift;
	my $CoveredPolicyClasses = shift;
	my $PerSeqPerSwitchCost = shift;
	my $SwitchResourcesLeft = shift;
	my $MboxResourcesLeft = shift;
	my $PerSeqPerMboxCost = shift; 
	
	my $bestval = 0;
	my $selected_key = -1;
	my %keystodelete = ();

	my $key = "";
	foreach $key (keys %{$Feasible})	
	{
		my $feasible = check_feasibility($key,$SwitchResourcesLeft,$MboxResourcesLeft,$PerSeqPerSwitchCost,$PerSeqPerMboxCost);
		my ($class,$seqid) = split(/\-/,$key);
		if ($feasible == 1)
		{
			my $Utility 	= incremental_utility($CoveredPolicyClasses,$class);
			my $Cost = $CostRef->{$key};
			my $UtilityByCost = $Utility/$Cost;
			print  "Here $key $Utility $Cost\n"; 
			if ($UtilityByCost > $bestval)
			{
				$selected_key = $key;
				$bestval = $UtilityByCost;
			}
		}
		else
		{
			## remove this key from consideration
			print "$key became infeasible\n";
			$keystodelete{$key} = 1;
		}
	}
	foreach $key (keys %keystodelete)	
	{
		delete $Feasible->{$key};
	}
	return $selected_key;
}

sub greedy_pruning_sequenceset_optimized
{
	## this is the output of the enumerate physical chains 
	my $SequencesPerClass = shift;
	my $NumSequencesPerClass = shift;
	## this is the output of get_switch cost 
	my $RoutesPerSequencePerClass = shift;
	## these are basic inputs from parsing the files
	my $NodeIDtoNameRef = shift;
	my $ClassID2VolumeRef = shift;
	my $SwitchResourcesRef = shift;
	my $MboxResourcesRef  = shift;

	my %SwitchResourcesLeft = ();
	my %MboxResourcesLeft = ();
	my %CoveredPolicyClasses = ();

	my %Utility = ();
	my %Cost = ();
	my %UtilityByCost = ();
	my %Feasible = ();

	my %PerSeqPerSwitchCost = "";
	my %PerSeqPerMboxCost = "";
	my %PerSeqTotalSwitchCost = "";
	my %PerSeqTotalMboxCost = "";
	
	##  INITIALIZE STUFF  for resources left
	my $switch ="";
	foreach $switch	(keys %{$SwitchResourcesRef})
	{
		#print "Here!! $switch !! $SwitchResourcesRef->{$switch}\n";
		$SwitchResourcesLeft{$switch} = $SwitchResourcesRef->{$switch};		
	#	<STDIN>;
	}
	my $mbox = "";
	foreach $mbox	(keys %{$MboxResourcesRef})
	{
		$MboxResourcesLeft{$mbox} = $MboxResourcesRef->{$mbox};		
	}	

	## PerSequence initialization of cost/utility
	my $class = "";
	foreach $class (keys %{$SequencesPerClass})
	{
		for (my $i =0; $i < $NumSequencesPerClass->{$class}; $i++)
		{
			my $key = "$class-$i";	
			
			#print "Checking $key\n";
			my ($perswitchcost,$permboxcost,$totalswitchcost,$totalmboxcost) = get_cost_for_given_class_sequence($class,$i, $RoutesPerSequencePerClass, $NodeIDtoNameRef, $ClassID2VolumeRef);
			$PerSeqPerSwitchCost{$key} = $perswitchcost;
			$PerSeqTotalSwitchCost{$key} = $totalswitchcost;
			$PerSeqPerMboxCost{$key} = $permboxcost;
			$PerSeqTotalMboxCost{$key} = $totalmboxcost;

			my $feasible = check_feasibility($key,\%SwitchResourcesLeft,\%MboxResourcesLeft,\%PerSeqPerSwitchCost,\%PerSeqPerMboxCost);
			if ($feasible == 1)
			{
				$Utility{$key} 	= incremental_utility(\%CoveredPolicyClasses,$class);
				$Cost{$key} = $totalswitchcost;		
				$UtilityByCost{$key} = $Utility{$key}/$Cost{$key};
				$Feasible{$key} =1;
				#print "Initialized $key $Utility{$key} $Cost{$key}\n";
			}
			else
			{
				print "Infeasible! $key\n";
			}
		}
	}
	my $progress = 1;
	my $iteration =1;
	## Pick greedy based on utilitybycost 
	my %PrunedSet = ();
	while ($progress == 1)
	{
		print "Iteration  = $iteration\n";
		my $key = "";
		my $selected_key = get_next_best_key(\%Utility, \%Cost, \%Feasible, \%CoveredPolicyClasses, \%PerSeqPerSwitchCost, \%PerSeqPerMboxCost, \%SwitchResourcesLeft, \%MboxResourcesLeft);
		if ($selected_key ne -1)
		{ 
			my ($class,$selectedid) = split(/-/,$selected_key);
			print "Greedy selecting $class-$selectedid $Utility{$selected_key} $Cost{$selected_key} $UtilityByCost{$selected_key}\n";
			$PrunedSet{$class}->{$selectedid}=1;

			## update resources left on the switches and resource
			update_resources_given_selected($selected_key, \%PerSeqPerSwitchCost, \%PerSeqPerMboxCost, \%SwitchResourcesLeft, \%MboxResourcesLeft);

			## update covered policy classes
			$CoveredPolicyClasses{$class} = $CoveredPolicyClasses{$class} + $Utility{$selected_key};

			## remove this sequence from future consideration since it is already picked
			delete $Feasible{$selected_key};
		}
		else
		{
			## Resources are saturated exit the loop!
			print "No more resources or no more chains to pick\n";
			$progress =0;
		}
		$iteration++;
	}
	return \%PrunedSet;
}


sub convert_path_ids_to_names
{
	my $path_in_id_form = shift;
	my $nodename2nodeidref = shift;
	
	my $result = "";
	my @array = split(/\s+/,$path_in_id_form);
	for (my $i =0; $i <= $#array; $i++)
	{
		if ($i > 0)
		{
			$result = $result." ";
		}
		$result = $result.$nodename2nodeidref->{$array[$i]};
	}
	return $result; 
}

sub get_route_by_name
{
	my $routeidarray = shift;
	my $numnodes = shift;
	my $NodeIDtoNameRef = shift;
	my $result = "";
	for (my $i = 0; $i <= $numnodes; $i++)
	{
		$result = $result." ".$NodeIDtoNameRef->{$routeidarray->[$i]};
	}
	return $result;
}

1;


#sub greedy_pruning_sequenceset_maxiter_priqueue2
#{
#	## this is the output of the enumerate physical chains 
#	my $SequencesPerClass = shift;
#	my $NumSequencesPerClass = shift;
#	## this is the output of get_switch cost 
#	my $RoutesPerSequencePerClass = shift;
#	## these are basic inputs from parsing the files
#	my $NodeIDtoNameRef = shift;
#	my $ClassID2VolumeRef = shift;
#	my $SwitchResourcesRef = shift;
#	my $MboxResourcesRef  = shift;
#	my $maxiter = shift;
#
#	my $prio = Heap::Priority->new();
#
#	my %SwitchResourcesLeft = ();
#	my %MboxResourcesLeft = ();
#	my %CoveredPolicyClasses = ();
#
#	my %Utility = ();
#	my %Cost = ();
#	my %UtilityByCost = ();
#	my %Feasible = ();
#
#	my %PerSeqPerSwitchCost = "";
#	my %PerSeqPerMboxCost = "";
#	my %PerSeqTotalSwitchCost = "";
#	my %PerSeqTotalMboxCost = "";
#	
#	##  INITIALIZE STUFF  for resources left
#	my $switch ="";
#	foreach $switch	(keys %{$SwitchResourcesRef})
#	{
#		#print "Here!! $switch !! $SwitchResourcesRef->{$switch}\n";
#		$SwitchResourcesLeft{$switch} = $SwitchResourcesRef->{$switch};		
#	#	<STDIN>;
#	}
#	my $mbox = "";
#	foreach $mbox	(keys %{$MboxResourcesRef})
#	{
#		$MboxResourcesLeft{$mbox} = $MboxResourcesRef->{$mbox};		
#	}	
#
#	## PerSequence initialization of cost/utility
#	my $class = "";
#	foreach $class (keys %{$SequencesPerClass})
#	{
#		for (my $i =0; $i < $NumSequencesPerClass->{$class}; $i++)
#		{
#			my $key = "$class-$i";	
#			
#			#print "Checking $key\n";
#			my ($perswitchcost,$permboxcost,$totalswitchcost,$totalmboxcost) = get_cost_for_given_class_sequence($class,$i, $RoutesPerSequencePerClass, $NodeIDtoNameRef, $ClassID2VolumeRef);
#			$PerSeqPerSwitchCost{$key} = $perswitchcost;
#			$PerSeqTotalSwitchCost{$key} = $totalswitchcost;
#			$PerSeqPerMboxCost{$key} = $permboxcost;
#			$PerSeqTotalMboxCost{$key} = $totalmboxcost;
#
#			my $feasible = check_feasibility($key,\%SwitchResourcesLeft,\%MboxResourcesLeft,\%PerSeqPerSwitchCost,\%PerSeqPerMboxCost);
#			if ($feasible == 1)
#			{
#				$Utility{$key} 	= incremental_utility(\%CoveredPolicyClasses,$class);
#				$Cost{$key} = $totalswitchcost;		
#				$UtilityByCost{$key} = $Utility{$key}/$Cost{$key};
#				$prio->add($key, $UtilityByCost{$key});
#				$Feasible{$key} =1;
#				#print "Initialized $key $Utility{$key} $Cost{$key}\n";
#			}
#			else
#			{
#				print "Infeasible! $key\n";
#			}
#		}
#	}
#	my $progress = 1;
#	my $iteration =1;
#	## Pick greedy based on utilitybycost 
#	my %PrunedSet = ();
#	while ($progress == 1 and $iteration <= $maxiter)
#	{
#		print "Iteration  = $iteration\n";
#		my $key = "";
#		my $selected_key = -1;
#
#		my $flag = 1;
#		## ONE GREEDY ITERATION HAPPENS HERE
#		while ($flag == 1)
#		{
#			$key = $prio->pop();
#			if ($key)
#			{
#				print "Checking $key $UtilityByCost{$key}\n";
#				if (defined $Feasible{$key})
#				{
#					my $feasible = check_feasibility($key,\%SwitchResourcesLeft,\%MboxResourcesLeft,\%PerSeqPerSwitchCost,\%PerSeqPerMboxCost);
#					if ($feasible == 1)
#					{
#						$selected_key = $key;
#						last;
#					}
#					else
#					{
#						## remove this key from consideration
#						print "$key became infeasible\n";
#						delete $Feasible{$key};
#						delete $UtilityByCost{$key};
#					}
#				}
#				else
#				{	
#					print "$key already infeasible\n";
#				}
#			}
#			else
#			{
#				$selected_key = -1;
#				$flag = 0;
#			}
#		}
#		if ($selected_key ne -1)
#		{ 
#			my ($class,$selectedid) = split(/-/,$selected_key);
#			print "Greedy selecting $class-$selectedid $Utility{$selected_key} $Cost{$selected_key} $UtilityByCost{$selected_key}\n";
#			$PrunedSet{$class}->{$selectedid}=1;
#
#			## update resources left on the switches and resource
#			update_resources_given_selected($selected_key, \%PerSeqPerSwitchCost, \%PerSeqPerMboxCost, \%SwitchResourcesLeft, \%MboxResourcesLeft);
#
#			## update covered policy classes
#			$CoveredPolicyClasses{$class} = $CoveredPolicyClasses{$class} + $Utility{$selected_key};
#
#			## remove this sequence from future consideration since it is already picked
#			delete $Feasible{$selected_key};
#			delete $UtilityByCost{$selected_key}; # = -100;
#		
#			## update utility values for all other sequences that cover this class
#			for (my $i =0; $i < $NumSequencesPerClass->{$class}; $i++)
#			{
#				my $newkey = "$class-$i";
#				## check if this guy isnt already disabled
#				if (defined $UtilityByCost{$newkey})
#				{
#					$Utility{$newkey}= incremental_utility(\%CoveredPolicyClasses,$class);
#					$Cost{$newkey} = $PerSeqTotalSwitchCost{$newkey};
#					$UtilityByCost{$newkey} = $Utility{$newkey}/$Cost{$newkey};
#					$prio->delete_item($newkey);
#					$prio->add($newkey, $UtilityByCost{$newkey});
#				}
#			}
#		}
#		else
#		{
#			## Resources are saturated exit the loop!
#			print "No more resources or no more chains to pick\n";
#			$progress =0;
#		}
#		$iteration++;
#	}
#	return \%PrunedSet;
#}
#
#
#
#sub greedy_pruning_sequenceset_maxiter_priqueue
#{
#	## this is the output of the enumerate physical chains 
#	my $SequencesPerClass = shift;
#	my $NumSequencesPerClass = shift;
#	## this is the output of get_switch cost 
#	my $RoutesPerSequencePerClass = shift;
#	## these are basic inputs from parsing the files
#	my $NodeIDtoNameRef = shift;
#	my $ClassID2VolumeRef = shift;
#	my $SwitchResourcesRef = shift;
#	my $MboxResourcesRef  = shift;
#	my $maxiter = shift;
#
#	my $prio = Hash::PriorityQueue->new();
#
#	my %SwitchResourcesLeft = ();
#	my %MboxResourcesLeft = ();
#	my %CoveredPolicyClasses = ();
#
#	my %Utility = ();
#	my %Cost = ();
#	my %UtilityByCost = ();
#	my %Feasible = ();
#
#	my %PerSeqPerSwitchCost = "";
#	my %PerSeqPerMboxCost = "";
#	my %PerSeqTotalSwitchCost = "";
#	my %PerSeqTotalMboxCost = "";
#	
#	##  INITIALIZE STUFF  for resources left
#	my $switch ="";
#	foreach $switch	(keys %{$SwitchResourcesRef})
#	{
#		#print "Here!! $switch !! $SwitchResourcesRef->{$switch}\n";
#		$SwitchResourcesLeft{$switch} = $SwitchResourcesRef->{$switch};		
#	#	<STDIN>;
#	}
#	my $mbox = "";
#	foreach $mbox	(keys %{$MboxResourcesRef})
#	{
#		$MboxResourcesLeft{$mbox} = $MboxResourcesRef->{$mbox};		
#	}	
#
#	## PerSequence initialization of cost/utility
#	my $class = "";
#	foreach $class (keys %{$SequencesPerClass})
#	{
#		for (my $i =0; $i < $NumSequencesPerClass->{$class}; $i++)
#		{
#			my $key = "$class-$i";	
#			
#			#print "Checking $key\n";
#			my ($perswitchcost,$permboxcost,$totalswitchcost,$totalmboxcost) = get_cost_for_given_class_sequence($class,$i, $RoutesPerSequencePerClass, $NodeIDtoNameRef, $ClassID2VolumeRef);
#			$PerSeqPerSwitchCost{$key} = $perswitchcost;
#			$PerSeqTotalSwitchCost{$key} = $totalswitchcost;
#			$PerSeqPerMboxCost{$key} = $permboxcost;
#			$PerSeqTotalMboxCost{$key} = $totalmboxcost;
#
#			my $feasible = check_feasibility($key,\%SwitchResourcesLeft,\%MboxResourcesLeft,\%PerSeqPerSwitchCost,\%PerSeqPerMboxCost);
#			if ($feasible == 1)
#			{
#				$Utility{$key} 	= incremental_utility(\%CoveredPolicyClasses,$class);
#				$Cost{$key} = $totalswitchcost;		
#				$UtilityByCost{$key} = $Utility{$key}/$Cost{$key};
#				$prio->insert($key, $Cost{$key}/$Utility{$key});
#				$Feasible{$key} =1;
#				#print "Initialized $key $Utility{$key} $Cost{$key}\n";
#			}
#			else
#			{
#				print "Infeasible! $key\n";
#			}
#		}
#	}
#	my $progress = 1;
#	my $iteration =1;
#	## Pick greedy based on utilitybycost 
#	my %PrunedSet = ();
#	while ($progress == 1 and $iteration <= $maxiter)
#	{
#		print "Iteration  = $iteration\n";
#		my $key = "";
#		my $selected_key = -1;
#
#		my $flag = 1;
#		## ONE GREEDY ITERATION HAPPENS HERE
#		while ($flag == 1)
#		{
#			$key = $prio->pop();
#			if ($key)
#			{
#				print "Checking $key $UtilityByCost{$key}\n";
#				if (defined $Feasible{$key})
#				{
#					my $feasible = check_feasibility($key,\%SwitchResourcesLeft,\%MboxResourcesLeft,\%PerSeqPerSwitchCost,\%PerSeqPerMboxCost);
#					if ($feasible == 1)
#					{
#						$selected_key = $key;
#						last;
#					}
#					else
#					{
#						## remove this key from consideration
#						print "$key became infeasible\n";
#						delete $Feasible{$key};
#						delete $UtilityByCost{$key};
#					}
#				}
#				else
#				{	
#					print "$key already infeasible\n";
#				}
#			}
#			else
#			{
#				$selected_key = -1;
#				$flag = 0;
#			}
#		}
#		if ($selected_key ne -1)
#		{ 
#			my ($class,$selectedid) = split(/-/,$selected_key);
#			print "Greedy selecting $class-$selectedid $Utility{$selected_key} $Cost{$selected_key} $UtilityByCost{$selected_key}\n";
#			$PrunedSet{$class}->{$selectedid}=1;
#
#			## update resources left on the switches and resource
#			update_resources_given_selected($selected_key, \%PerSeqPerSwitchCost, \%PerSeqPerMboxCost, \%SwitchResourcesLeft, \%MboxResourcesLeft);
#
#			## update covered policy classes
#			$CoveredPolicyClasses{$class} = $CoveredPolicyClasses{$class} + $Utility{$selected_key};
#
#			## remove this sequence from future consideration since it is already picked
#			delete $Feasible{$selected_key};
#			delete $UtilityByCost{$selected_key}; # = -100;
#		
#			## update utility values for all other sequences that cover this class
#			for (my $i =0; $i < $NumSequencesPerClass->{$class}; $i++)
#			{
#				my $newkey = "$class-$i";
#				## check if this guy isnt already disabled
#				if (defined $UtilityByCost{$newkey})
#				{
#					$Utility{$newkey}= incremental_utility(\%CoveredPolicyClasses,$class);
#					$Cost{$newkey} = $PerSeqTotalSwitchCost{$newkey};
#					$UtilityByCost{$newkey} = $Utility{$newkey}/$Cost{$newkey};
#					$prio->update($newkey, $Cost{$newkey}/$Utility{$newkey});
#				}
#			}
#		}
#		else
#		{
#			## Resources are saturated exit the loop!
#			print "No more resources or no more chains to pick\n";
#			$progress =0;
#		}
#		$iteration++;
#	}
#	return \%PrunedSet;
#}
#
