#/bin/bash

workload="./workloads/workloada.spec"
dbpath="/home/lzw/ceshi2"


if [ -n "$dbpath" ];then
    rm -f $dbpath/*
fi
./ycsbc -db leveldb -dbpath $dbpath -threads 1 -P $workload -load true -dboption 1

./ycsbc -db leveldb -dbpath $dbpath -threads 1 -P $workload -run true -dboption 1

