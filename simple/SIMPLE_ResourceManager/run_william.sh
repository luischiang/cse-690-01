#!/bin/bash

echo " =================================="
echo " ===== Running Optimization ====="
echo " =================================="
t=`date +%s`
# optimization
perl optimization_basic_lp.pl Config_$1 ./results/$1$t.lp > ./results/$1$t.route
#time `glpsol --cpxlp /tmp/$1$t.ilp -o /tmp/$1$t.sol &> /dev/null`
time glpsol --cpxlp ./results/$1$t.lp -o ./results/$1$t.sol
python hops.py ./results/$1$t.route ./results/$1$t.sol Topology_$1 > ./results/output_$1$t


#exit 0

echo " =================================="
echo " ===== Running Greedy Pruning ====="
echo " =================================="
t=`date +%s`
# pruned
perl optimization_pruned.pl Config_$1 ./results/greedy_$1$t.lp  > ./results/greedy_$1$t.route
time glpsol --cpxlp ./results/greedy_$1$t.lp -o ./results/greedy_$1$t.sol 
python hops.py ./results/greedy_$1$t.route ./results/greedy_$1$t.sol Topology_$1 > ./results/greedy_output_$1$t

#./get_frac.sh /tmp/$1$t.sol  | wc -l


