#!/bin/bash

echo " =================================="
echo " ===== Running Optimization ====="
echo " =================================="
t=`date +%s`
# optimization
perl optimization_basic.pl Config_$1 ./results/$1$t.ilp > ./results/ilp_$1$t.route
#time `glpsol --cpxlp /tmp/$1$t.ilp -o /tmp/$1$t.sol &> /dev/null`
time glpsol --cpxlp ./results/$1$t.ilp -o ./results/ilp_$1$t.sol


#exit 0

