#!/bin/bash

echo " =================================="
echo " ===== Running Optimization ====="
echo " =================================="
t=`date +%s`
# optimization
perl optimization_basic.pl Config_$1 /tmp/$1$t.ilp > /tmp/$1$t.route
#time `glpsol --cpxlp /tmp/$1$t.ilp -o /tmp/$1$t.sol &> /dev/null`
time glpsol --cpxlp /tmp/$1$t.ilp -o /tmp/$1$t.sol
python hops.py /tmp/$1$t.route /tmp/$1$t.sol Topology_$1


#exit 0

echo " =================================="
echo " ===== Running Greedy Pruning ====="
echo " =================================="
t=`date +%s`
# pruned
perl optimization_pruned.pl Config_$1 /tmp/$1$t.ilp >  /tmp/$1$t.route
time glpsol --cpxlp /tmp/$1$t.ilp -o /tmp/$1$t.sol 
python hops.py /tmp/$1$t.route /tmp/$1$t.sol Topology_$1

#./get_frac.sh /tmp/$1$t.sol  | wc -l


