#!/bin/bash

t=`date +%s`

#var = $1;

# change the switch capacity in Config file
cat SwitchInventory_$1 | awk -v var=$2 '{ print $1, var}' > tmp.txt
cat tmp.txt | awk '{ print $1, $2}' > SwitchInventory_$1

# run prunning without tunneling
perl pruning_binarysearch.pl Config_$1 _$2$1 32 0 > latest_results_4k/pruning_$2$1$t.result

b=`cat latest_results_4k/pruning_$2$1$t.result | awk '{if($1=="Coverage") print $4}' | tail -1`
if [ -n "$b" ];
then
# Run the optimization_pruned.pl to get the lp formulation
perl optimization_pruned.pl Config_$1 $2$1$t.lp Solution_$2$1_$b
# Run the lpsolver to get the lp solution
./lpsolver $2$1$t.lp o latest_results_4k/lp_$2$1$t.sol > latest_results_4k/lp_$2$1$t.output 
fi


#run prunning with tunneling
perl pruning_binarysearch.pl Config_$1 _t_$2$1 32 1 > latest_results_4k/pruning_tunnel_$2$1$t.result
b=`cat latest_results_4k/pruning_tunnel_$2$1$t.result | awk '{if($1=="Coverage") print $4}' | tail -1`
if [ -n "$b" ];
then
# Run the optimization_pruned.pl to get the lp formulation
perl optimization_pruned.pl Config_$1 tunnel_$2$1$t.lp Solution_t_$2$1_$b
# Run the lpsolver to get the lp solution
./lpsolver tunnel_$2$1$t.lp o latest_results_4k/tunnel_lp_$2$1$t.sol > latest_results_4k/tunnel_lp_$2$1$t.output
fi





# Run the optimization code without tunneling
perl optimization_basic_lp.pl Config_$1 $2$1$t.lp

./lpsolver $2$1$t.lp o latest_results_4k/opt_$2$1$t.sol > latest_results_4k/opt_$2$1$t.output


# Run the optimization code with tunneling
perl optimization_basic_tunnels_lp.pl Config_$1 tunnel_$2$1$t.lp

./lpsolver tunnel_$2$1$t.lp o latest_results_4k/tunnel_opt_$2$1$t.sol > latest_results_4k/tunnel_opt_$2$1$t.output




























