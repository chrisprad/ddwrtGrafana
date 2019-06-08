#!/bin/sh

cpuTemp="$(cat /sys/devices/virtual/hwmon/hwmon0/temp1_input)"
wanRxBytes="$(cat /sys/class/net/eth0/statistics/rx_bytes)"
wanTxBytes="$(cat /sys/class/net/eth0/statistics/tx_bytes)"
connections="$(cat /proc/net/nf_conntrack | grep ipv4 | wc -l)"
load=`cat /proc/loadavg`
load1=`echo "$load" | awk '{print $1}'`
load5=`echo "$load" | awk '{print $2}'`
load15=`echo "$load" | awk '{print $3}'`
google=`ping -c 10 8.8.8.8 | tail -2`
packet=`echo "$google" |grep "packet loss" | cut -d "," -f 3 | cut -d " " -f 2| sed 's/.$//'`
latency=`echo "$google" |grep "round-trip" | cut -d "=" -f 2 | cut -d "/" -f 1 | sed 's/\s*//'`

curl -i -XPOST 'http://GRAFANA_SERVER_HERE/write?db=router' --data-binary "cpu_temp,host=192.168.1.1 value=$cpuTemp
wan_rx_bytes,host=192.168.1.1 value=$wanRxBytes
wan_tx_bytes,host=192.168.1.1 value=$wanTxBytes
connection_count,host=192.168.1.1 value=$connections
load1,host=192.168.1.1 value=$load1
load5,host=192.168.1.1 value=$load5
load15,host=192.168.1.1 value=$load15
packetLoss,host=192.168.1.1 value=$packet
latency,host=192.168.1.1 value=$latency
"
