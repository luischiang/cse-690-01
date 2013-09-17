#! /usr/bin/perl
use strict;


sub update_hash
{
    my $fullhashref = shift;
    my $adjmatrixnode = shift;
    my $currentnode = shift;
    my $pathsref =  shift;
    my $key ="";
    foreach $key (keys %{$fullhashref})
    {
        if ( (defined $adjmatrixnode->{$key}) and ($fullhashref->{$key} > ( $fullhashref->{$currentnode} + $adjmatrixnode->{$key}) ))
        {
            ## update the node
            $fullhashref->{$key}  = $fullhashref->{$currentnode} + $adjmatrixnode->{$key};
            $pathsref->{$key} = $pathsref->{$currentnode}." ".$key;
        }
    }
}
sub find_min
{
    my $fullhashref = shift;
    my $seenhashref = shift;
    my $key = "";
    foreach $key (sort {$fullhashref->{$a} <=> $fullhashref->{$b}} keys %{$fullhashref})
    {
        if (not defined $seenhashref->{$key})
        {
        #   print "CAME HERE returning $key $fullhashref->{$key}\n";
            return $key;
        }
    }
}


sub dijkstra_shortest_paths
{
    my $numnodes = shift;
    my $adjmatrixref = shift;
    my $node  = 0;

 my %allpaths = ();


    for ($node =1; $node <= $numnodes ;$node++)
    {
        my %nodesalreadyseen = ();
        my %pathstonode = ();
        my %finished = ();
        my $dnode = 1;
        for ($dnode =1; $dnode <= $numnodes ;$dnode++)
        {
            if ($node == $dnode)
            {
                $nodesalreadyseen{$dnode} = 0;
                $pathstonode{$dnode} = "$node";
            }
            elsif (defined $adjmatrixref->{$node}->{$dnode})
            {
                $nodesalreadyseen{$dnode} =$adjmatrixref->{$node}->{$dnode};
                $pathstonode{$dnode} = "$node $dnode";
            }
            else
            {
                $nodesalreadyseen{$dnode} = 10000000;
            }
        }
        my $numseen = 0;
        while ($numseen < $numnodes)
        {
            my $currentmin = find_min( \%nodesalreadyseen,\%finished );
            $finished{$currentmin} = 1;
            update_hash(\%nodesalreadyseen, $adjmatrixref->{$currentmin}, $currentmin, \%pathstonode);
            $numseen++;
        }
        for ($dnode =1; $dnode <= $numnodes ;$dnode++)
	{
		$allpaths{$node}->{$dnode} = $pathstonode{$dnode};
	}
    }
    return \%allpaths;
}


sub compute_shortest_paths
{
    my $numnodes = shift;
    my $adjmatrixref = shift;
    my $node  = 0;
     my %allpaths = ();
    for ($node =1; $node <= $numnodes ;$node++)
    {

	#print "starting at $node\n";
        # breadth first search
        my @queue_of_nodes = ();
        my %prevhop = ();
        my %paths = ();
        my %seen = () ;
        my $covered = 1;


        push(@queue_of_nodes,$node);
        $seen{$node} =1;
        $paths{$node} = $node;
        $allpaths{$node}->{$node}->{"LENGTH"} =  0;
        $prevhop{$node} = "";

        my $flag = 0;
        while($flag == 0)
        {
            my $thisnode = shift(@queue_of_nodes);
            if ($thisnode == "")
            {
                $flag =1;
            }
            my $adjacent = "";
            foreach $adjacent (keys %{$adjmatrixref->{$thisnode}} )
            {
		#print "found adj $adjacent\n";
                if (not defined $seen{$adjacent})
                {
                    push(@queue_of_nodes,$adjacent);
                    $seen{$adjacent} =1;
                    my $prevhop = $thisnode;
                    $paths{$adjacent} = $paths{$prevhop}." ".$adjacent  ;
                    $allpaths{$node}->{$adjacent}->{"PATH"} = $paths{$adjacent};
		    my @patharray = split(/\s+/,$allpaths{$node}->{$adjacent}->{"PATH"});
                    $allpaths{$node}->{$adjacent}->{"LENGTH"} =  $#patharray;
                }
            }
        }

    }
    return \%allpaths;
}


sub remove_src
{
	my $route = shift;
	my @nodes = split(/\s+/,$route);
	my $newroute = join(' ',@nodes[1..$#nodes]);
	return $newroute;
}
1;
