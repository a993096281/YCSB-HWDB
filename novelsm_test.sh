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

cmd="./ycsbc -db leveldb -dbpath $dbpath -threads 1 -P $load -load true -dboption 1 -dbstatistics true >>out.out 2>&1 "
echo $cmd >out.out
echo $cmd
eval $cmd
if [ $? -ne 0 ];then
    exit 1
fi

for file_name in $workloads; do
  CLEAN_CACHE
  cmd="./ycsbc -db leveldb -dbpath $dbpath -threads 1 -P $file_name -run true -dboption 1 -dbstatistics true >>out.out 2>&1 "
  echo $cmd >>out.out
  echo $cmd
  eval $cmd
  if [ $? -ne 0 ];then
      exit 1
  fi
  wait
done
