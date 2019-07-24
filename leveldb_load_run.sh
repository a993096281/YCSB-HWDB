#/bin/bash

workloads="workloads/workloada.spec workloads/workloadb.spec workloads/workloadc.spec"
dbpath="/home/lzw/ceshi2"


if [ -n "$dbpath" ];then
    rm -f $dbpath/*
fi
./ycsbc -db leveldb -dbpath $dbpath -threads 1 -P $workload -load true -dboption 1

#./ycsbc -db leveldb -dbpath $dbpath -threads 1 -P $workload -run true -dboption 1

for file_name in $workloads; do
  echo "Running  $file_name"
  wait
done
