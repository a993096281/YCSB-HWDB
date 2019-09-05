#/bin/bash

workload="workloads/400M_load.spec"
dbpath="/home/lzw/ceshi2"
moreworkloads="workloads/50M_workloada.spec:workloads/50M_workloadb.spec:workloads/50M_workloadc.spec:workloads/50M_workloadd.spec:workloads/1M_workloade.spec:workloads/50M_workloadf.spec"

#./ycsbc -db scaledkv -dbpath $dbpath -threads 1 -P $workload -load true -run true -dbstatistics true

#./ycsbc -db scaledkv -dbpath $dbpath -threads 1 -P $workload -load true -morerun $moreworkloads -dbstatistics true


cmd="./ycsbc -db scaledkv -dbpath $dbpath -threads 1 -P $workload -load true -morerun $moreworkloads -dbstatistics true >>out.out 2>&1 "
echo $cmd >out.out
echo $cmd
eval $cmd