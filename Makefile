

ROCKSDB_INCLUDE=/home/lzw/nvm_rocksdb/test_rocksdb/include              #Rocksdb的头文件
ROCKSDB_LIBRARY=/home/lzw/nvm_rocksdb/test_rocksdb/librocksdb.a   #Rocksdb的静态链接库

CC=g++
CFLAGS=-std=c++11 -g -Wall -pthread -I./ 
LDFLAGS= -lpthread -lrocksdb -lleveldb -lz -lsnappy -lpmem
SUBDIRS= core db 
SUBSRCS=$(wildcard core/*.cc) $(wildcard db/*.cc)
OBJECTS=$(SUBSRCS:.cc=.o)
EXEC=ycsbc

all: $(SUBDIRS) $(EXEC)

$(SUBDIRS):
	$(MAKE) -C $@
	#$(MAKE) -C $@ ROCKSDB_INCLUDE=${ROCKSDB_INCLUDE}

$(EXEC): $(wildcard *.cc) $(OBJECTS)
	$(CC) $(CFLAGS) $^ $(LDFLAGS) -o $@

clean:
	for dir in $(SUBDIRS); do \
		$(MAKE) -C $$dir $@; \
	done
	$(RM) $(EXEC)

.PHONY: $(SUBDIRS) $(EXEC)

