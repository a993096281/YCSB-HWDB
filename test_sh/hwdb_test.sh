#/bin/bash

workload="workloads/workloada.spec"
zipfian_workload="workloads/test_zipfian_load.spec"
dbpath="/home/share/ceshi"
moreworkloads="workloads/workloada.spec:workloads/workloadb.spec:workloads/workloadc.spec:workloads/workloadd.spec:workloads/workloade.spec:workloads/workloadf.spec"

#./ycsbc -db hwdb -dbpath $dbpath -threads 1 -P $workload -load true -run true -dbstatistics true

#./ycsbc -db hwdb -dbpath $dbpath -threads 1 -P $workload -load true -morerun $moreworkloads -dbstatistics true


#cmd="./ycsbc -db hwdb -dbpath $dbpath -threads 4 -P $workload -load true -morerun $moreworkloads -dbstatistics true "
#cmd="./ycsbc -db hwdb -dbpath $dbpath -threads 4 -P $workload -load true -dbstatistics true "
cmd="./ycsbc -db hwdb -dbpath $dbpath -threads 4 -P $zipfian_workload -run true -dbstatistics true "
#cmd="./ycsbc -db basic -dbpath $dbpath -threads 1 -P $workload -load true -morerun $moreworkloads -dbstatistics true "

echo $cmd
eval $cmd