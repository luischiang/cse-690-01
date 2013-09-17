#! /usr/bin/perl

$t=`date +%s`;
$topo = $ARGV[0];
$switchcap = $ARGV[1];
chomp($t, $topo, $switchcap);
# change the switch capacity in Config file
`cat SwitchInventory_$topo | awk '{ print \$1, $switchcap}' > tmp.txt`;
`cat tmp.txt | awk  '{ print \$1, \$2}' > SwitchInventory_$topo`;

# run prunning without tunneling
`perl pruning_binarysearch.pl Config_$topo $switchcap$topo 32 0 > pruning_$switchcap$topo$t.result`;

#run prunning with tunneling
`perl pruning_binarysearch.pl Config_$topo t_$switchcap$topo 32 1 > pruning_tunnel_$switchcap$topo$t.result`;


