#/bin/bash

#load="workloads/load80G4kb.spec"
load="workloads/test.spec"
workloads="workloads/workloada.spec workloads/workloadb.spec workloads/workloadc.spec workloads/workloadd.spec workloads/workloade.spec workloads/workloadf.spec"
dbpath="/mnt/ssd/ceshi"

CLEAN_CACHE() {
    sleep 2
    sync
    echo 3 > /proc/sys/vm/drop_caches
    free -h >>out.out
    sleep 2
}

if [ -n "$dbpath" ];then
    rm -f $dbpath/*
fi

cmd="./ycsbc -db rocksdb -dbpath $dbpath -threads 1 -P $load -load true -dboption 2 >>out.out 2>&1 "
echo $cmd >out.out
echo $cmd
eval $cmd

for file_name in $workloads; do
  CLEAN_CACHE
  cmd="./ycsbc -db rocksdb -dbpath $dbpath -threads 1 -P $file_name -run true -dboption 2 >>out.out 2>&1 "
  echo $cmd >>out.out
  echo $cmd
  eval $cmd
  wait
done
