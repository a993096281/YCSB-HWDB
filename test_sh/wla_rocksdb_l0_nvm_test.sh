#/bin/bash

#load="workloads/load80G4kb.spec"
#load="workloads/test.spec"
#workloads="workloads/workloada.spec workloads/workloadb.spec workloads/workloadc.spec workloads/workloadd.spec workloads/workloade.spec workloads/workloadf.spec"
workloads="workloads/20M_workloada.spec workloads/1M_workloadb.spec workloads/1M_workloadc.spec workloads/1M_workloadd.spec workloads/1M_workloade.spec workloads/1M_workloadf.spec"
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

echo >out.out   #clear out.out

for file_name in $workloads; do
  CLEAN_CACHE
  cmd="./ycsbc -db rocksdb -dbpath $dbpath -threads 1 -P $file_name -run true -dboption 1 -dbstatistics true -dbwaitforbalance true >>out.out 2>&1 "
  echo $cmd >>out.out
  echo $cmd
  eval $cmd
  if [ $? -ne 0 ];then
      exit 1
  fi
  wait
done
