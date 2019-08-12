#/bin/bash

workload="workloads/test.spc"
dbpath="/home/lzw/ceshi2"


if [ -n "$dbpath" ];then
    rm -f $dbpath/*
fi
./ycsbc -db leveldb -dbpath $dbpath -threads 1 -P $workload -load true -run true -dboption 1

#./ycsbc -db leveldb -dbpath $dbpath -threads 1 -P $workload -run true -dboption 1

./ycsbc -db rocksdb -dbpath /home/lzw/ceshi2 -threads 1 -P workloads/workloade.spec -load true -run true -dboption 2

./ycsbc -db leveldb -dbpath /home/lzw/ceshi2 -threads 1 -P workloads/workloade.spec -load true -run true 

./ycsbc -db rocksdb -dbpath /home/lzw/ceshi2 -threads 1 -P workloads/workloade.spec -load true -run true 

./ycsbc -db rocksdb -dbpath /home/lzw/ceshi -threads 1 -P workloads/workloada.spec -run true -dboption 1 -dbstatistics true -dbwaitforbalance true