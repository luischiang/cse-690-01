#!/bin/bash

sudo ovs-vsctl add-port S2 eth2
sudo ifconfig eth2 promisc up

sudo ovs-vsctl add-port S2 eth1
sudo ifconfig eth1 promisc up

sudo ovs-vsctl add-port S3 eth7
sudo ifconfig eth7 promisc up

sudo ovs-vsctl add-port S4 eth5
sudo ifconfig eth5 promisc up


