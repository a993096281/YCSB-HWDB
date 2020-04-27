//
//  basic_db.cc
//  YCSB-C
//
//  Created by Jinglei Ren on 12/17/14.
//  Copyright (c) 2014 Jinglei Ren <jinglei@ren.systems>.
//

#include "db/db_factory.h"

#include <string>
#include "db/basic_db.h"

#ifdef YCSB_HWDB
#include "db/hwdb_db.h"
#endif

#ifdef YCSB_ROCKSDB
#include "db/rocksdb_db.h"
#endif

using namespace std;
using ycsbc::DB;
using ycsbc::DBFactory;

DB* DBFactory::CreateDB(utils::Properties &props) {
  if (props["dbname"] == "basic") {
    return new BasicDB;
  } 
#ifdef YCSB_HWDB
  else if (props["dbname"] == "hwdb") {
    std::string dbpath = props.GetProperty("dbpath","/tmp/test-hwdb");
    return new HWDB(dbpath.c_str(), props);
  } 
#endif

#ifdef YCSB_ROCKSDB
  else if (props["dbname"] == "rocksdb") {
    std::string dbpath = props.GetProperty("dbpath","/tmp/test-rocksdb");
    return new RocksDB(dbpath.c_str(), props);
  } 
#endif
  else return NULL;
}

