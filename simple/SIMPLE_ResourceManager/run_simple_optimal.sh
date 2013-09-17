#!/bin/bash

#LC: Fix to allow execute from another program without changing the references
cd "$(dirname "$0")"

# Takes two inputs: Config file and the switch capacity to be set.
# Generates as output the SIMPLE and OPTIMAL solutions w and w/o tuneling
# Requires the helper parser files and CPLEX installed

EXPECTED_ARGS=2
 
if [ $# -ne $EXPECTED_ARGS ]
then
  echo "Usage: Config_file Switch_capacity"
  exit 
fi

t=`date +%s`

#-------------------------------------------#
# change the switch capacity in Config file
#-------------------------------------------#
cat SwitchInventory_$1 | awk -v var=$2 '{ print $1, var}' > tmp.txt
cat tmp.txt | awk '{ print $1, $2}' > SwitchInventory_$1


#--------------------------------------#
# run SIMPLE without tunneling 
#--------------------------------------#

echo "RUN SIMPLE without tunneling"

perl pruning_binarysearch.pl Config_$1 _$2$1 32 0 > results/pruning_$2$1$t.result

echo "Binary Search Done"

b=`cat results/pruning_$2$1$t.result | awk '{if($1=="Coverage") print $4}' | tail -1`
if [ -n "$b" ];
then

	echo "Run the optimization_pruned.pl to get the lp formulation"
	perl optimization_pruned.pl Config_$1 $2$1$t.lp Solution_$2$1_$b

	echo "Run the lpsolver to get the lp solution"

	./lpsolver $2$1$t.lp o results/simple_$2$1$t.sol > results/simple_$2$1$t.output 

fi

#---------------------------------------#
# run SIMPLE with tunneling
#---------------------------------------#
echo "RUN SIMPLE with tunneling"

perl pruning_binarysearch.pl Config_$1 _t_$2$1 32 1 > results/pruning_tunnel_$2$1$t.result

echo "Binary Search Done"

b=`cat results/pruning_tunnel_$2$1$t.result | awk '{if($1=="Coverage") print $4}' | tail -1`

if [ -n "$b" ];
then
	# Run the optimization_pruned.pl to get the lp formulation
	perl optimization_pruned.pl Config_$1 tunnel_$2$1$t.lp Solution_t_$2$1_$b
	# Run the lpsolver to get the lp solution
	./lpsolver tunnel_$2$1$t.lp o results/tunnel_simple_$2$1$t.sol > results/tunnel_simple_$2$1$t.output
fi

#---------------------------------------------#
# Run the OPTIMIZATION code without tunneling
#--------------------------------------------#
perl optimization_basic.pl Config_$1 $2$1$t.ilp

./ilpsolver $2$1$t.ilp results/opt_$2$1$t.sol > results/opt_$2$1$t.output

#------------------------------------------#
# Run the OPTIMIZATION code with tunneling
#------------------------------------------#
perl optimization_basic_tunnels.pl Config_$1 tunnel_$2$1$t.ilp

./ilpsolver tunnel_$2$1$t.ilp results/tunnel_opt_$2$1$t.sol > results/tunnel_opt_$2$1$t.output




























