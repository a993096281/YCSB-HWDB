
CC=g++
CXXFLAGS= -std=c++11 -g -Wall -I./ 
LDFLAGS= -lpthread 

LIB_SOURCES= \
		core/core_workload.cc  \
		db/db_factory.cc   \
		db/hashtable_db.cc  \

##HWDB
HWDB_SOURCES= db/hwdb_db.cc
HWDB_LIBRARY= -lhwdb
HWDB_DEFS= -DYCSB_HWDB
HWDB_OBJECTS=$(HWDB_SOURCES:.cc=.o)
##

##rocksdb
ROCKSDB_SOURCES= db/rocksdb_db.cc
ROCKSDB_LIBRARY= -lrocksdb -lz    ### -lz -lzstd -llz4 -lsnappy是rocksdb编译的时候如果检测到这些压缩链接库会使用，所以这里也要添加
ROCKSDB_DEFS= -DYCSB_ROCKSDB
ROCKSDB_OBJECTS=$(ROCKSDB_SOURCES:.cc=.o)
##


OBJECTS=$(LIB_SOURCES:.cc=.o)
EXEC=ycsbc

ONLY_HWDB_SOURCES=$(LIB_SOURCES) $(HWDB_SOURCES)
ONLY_ROCKSDB_SOURCES=$(LIB_SOURCES) $(ROCKSDB_SOURCES)
ALL_SOURCES=$(LIB_SOURCES) $(HWDB_SOURCES) $(ROCKSDB_SOURCES)

all: clean
	$(CC) $(CXXFLAGS) $(HWDB_DEFS) $(ROCKSDB_DEFS) ycsbc.cc $(ALL_SOURCES) -o $(EXEC) $(LDFLAGS) $(HWDB_LIBRARY) $(ROCKSDB_LIBRARY)

hwdb: clean
	$(CC) $(CXXFLAGS) $(HWDB_DEFS) ycsbc.cc $(ONLY_HWDB_SOURCES) -o $(EXEC) $(LDFLAGS) $(HWDB_LIBRARY)

rocksdb: clean
	$(CC) $(CXXFLAGS) $(ROCKSDB_DEFS) ycsbc.cc $(ONLY_ROCKSDB_SOURCES) -o $(EXEC) $(LDFLAGS) $(ROCKSDB_LIBRARY)


clean:
	rm -f $(EXEC) 

.PHONY: clean rocksdb hwdb

