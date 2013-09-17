#!/bin/bash

gtoolDir="/home/openflow/advpro/net-tunnel/gtool"
loop=1
tracefile="exp2.pcap"

$gtoolDir/bittwistx -l $loop -m 0 $gtoolDir/mapping.txt $gtoolDir/$tracefile > $gtoolDir/Tg-output.txt
