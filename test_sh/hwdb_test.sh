#/bin/bash

workload="workloads/workloada.spec"
dbpath="/media/psf/lzw/ceshi"
moreworkloads="workloads/workloada.spec:workloads/workloadb.spec:workloads/workloadc.spec:workloads/workloadd.spec:workloads/workloade.spec:workloads/workloadf.spec"

#./ycsbc -db hwdb -dbpath $dbpath -threads 1 -P $workload -load true -run true -dbstatistics true

#./ycsbc -db hwdb -dbpath $dbpath -threads 1 -P $workload -load true -morerun $moreworkloads -dbstatistics true


cmd="./ycsbc -db hwdb -dbpath $dbpath -threads 1 -P $workload -load true -morerun $moreworkloads -dbstatistics true "
echo $cmd
eval $cmd