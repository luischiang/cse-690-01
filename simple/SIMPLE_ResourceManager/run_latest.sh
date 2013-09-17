#!/bin/bash

t=`date +%s`

#var = $1;

# change the switch capacity in Config file
cat SwitchInventory_$1 | awk -v var=$2 '{ print $1, var}' > tmp.txt
cat tmp.txt | awk '{ print $1, $2}' > SwitchInventory_$1

# run prunning without tunneling
perl pruning_binarysearch.pl Config_$1 _$2$1 32 0 > latest_run_mininet_nonuniformtarffic/pruning_$2$1$t.result

b=`cat latest_run_mininet_nonuniformtarffic/pruning_$2$1$t.result | awk '{if($1=="Coverage") print $4}' | tail -1`
if [ -n "$b" ];
then
# Run the optimization_pruned.pl to get the lp formulation
perl optimization_pruned.pl Config_$1 $2$1$t.lp Solution_$2$1_$b
# Run the lpsolver to get the lp solution
./lpsolver $2$1$t.lp o latest_run_mininet_nonuniformtarffic/lp_$2$1$t.sol > latest_run_mininet_nonuniformtarffic/lp_$2$1$t.output 
fi


#run prunning with tunneling
perl pruning_binarysearch.pl Config_$1 _t_$2$1 32 1 > latest_run_mininet_nonuniformtarffic/pruning_tunnel_$2$1$t.result
b=`cat latest_run_mininet_nonuniformtarffic/pruning_tunnel_$2$1$t.result | awk '{if($1=="Coverage") print $4}' | tail -1`
if [ -n "$b" ];
then
# Run the optimization_pruned.pl to get the lp formulation
perl optimization_pruned.pl Config_$1 tunnel_$2$1$t.lp Solution_t_$2$1_$b
# Run the lpsolver to get the lp solution
./lpsolver tunnel_$2$1$t.lp o latest_run_mininet_nonuniformtarffic/tunnel_lp_$2$1$t.sol > latest_run_mininet_nonuniformtarffic/tunnel_lp_$2$1$t.output
fi





# Run the optimization code without tunneling
perl optimization_basic.pl Config_$1 $2$1$t.ilp

./ilpsolver $2$1$t.ilp latest_run_mininet_nonuniformtarffic/opt_$2$1$t.sol > latest_run_mininet_nonuniformtarffic/opt_$2$1$t.output


# Run the optimization code with tunneling
perl optimization_basic_tunnels.pl Config_$1 tunnel_$2$1$t.ilp

./ilpsolver tunnel_$2$1$t.ilp latest_run_mininet_nonuniformtarffic/tunnel_opt_$2$1$t.sol > latest_run_mininet_nonuniformtarffic/tunnel_opt_$2$1$t.output




























