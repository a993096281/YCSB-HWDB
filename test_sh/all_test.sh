#/bin/bash

load="workloads/load80G4kb.spec"
#load="workloads/test.spec"
workloads="workloads/workloada.spec workloads/workloadb.spec workloads/workloadc.spec workloads/workloadd.spec workloads/workloade.spec workloads/workloadf.spec"
dbpath="/home/lzw/ceshi2"


if [ -n "$dbpath" ];then
    rm -f $dbpath/*
fi

cmd="./ycsbc -db rocksdb -dbpath $dbpath -threads 1 -P $load -load true -dboption 2 >>out.out 2>&1 "
echo $cmd >out.out
echo $cmd
eval $cmd

for file_name in $workloads; do

  cmd="./ycsbc -db rocksdb -dbpath $dbpath -threads 1 -P $file_name -run true -dboption 2 >>out.out 2>&1 "
  echo $cmd >>out.out
  echo $cmd
  eval $cmd
  wait
done
