#/bin/bash

workload="./workloads/workloada.spec"
dbpath="/home/lzw/ceshi2"


if [ -n "$dbpath" ];then
    rm -f $dbpath/*
fi
./ycsbc -db rocksdb -dbpath $dbpath -threads 1 -P $workload -load true -dboption 2

echo "run"
./ycsbc -db rocksdb -dbpath $dbpath -threads 1 -P $workload -run true -dboption 2
echo "run"
