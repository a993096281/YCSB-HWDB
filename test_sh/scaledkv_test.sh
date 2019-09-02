#/bin/bash

workload="workloads/workloada.spec"
dbpath="/home/lzw/ceshi2"
moreworkloads="workloads/workloada.spec:workloads/workloadb.spec:workloads/workloadc.spec:workloads/workloadd.spec:workloads/workloade.spec:workloads/workloadf.spec"

#./ycsbc -db scaledkv -dbpath $dbpath -threads 1 -P $workload -load true -run true -dbstatistics true

./ycsbc -db scaledkv -dbpath $dbpath -threads 1 -P $workload -load true -morerun $moreworkloads -dbstatistics true