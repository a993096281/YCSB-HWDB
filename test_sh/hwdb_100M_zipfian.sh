#/bin/bash

#workload="workloads/test_workloada.spec"
zipfian_workload="workloads/test_zipfian_load.spec"
dbpath="/home/lzw/ceshi"
moreworkloads="workloads/test_workloada.spec:workloads/test_workloadb.spec:workloads/test_workloadc.spec:workloads/test_workloadd.spec:workloads/test_workloade.spec:workloads/test_workloadf.spec"

#./ycsbc -db hwdb -dbpath $dbpath -threads 4 -P $workload -load true -run true -dbstatistics true

#./ycsbc -db hwdb -dbpath $dbpath -threads 4 -P $workload -load true -morerun $moreworkloads -dbstatistics true


cmd="./ycsbc -db hwdb -dbpath $dbpath -threads 4 -P $zipfian_workload -run true -morerun $moreworkloads -dbstatistics true >>out.out 2>&1 "

if [ -n "$1" ];then    #后台运行
cmd="nohup ./ycsbc -db hwdb -dbpath $dbpath -threads 4 -P $zipfian_workload -run true -morerun $moreworkloads -dbstatistics true >>out.out 2>&1  &"
echo $cmd >out.out
fi


echo $cmd
eval $cmd