# YCSB-HWDB

Yahoo! Cloud Serving Benchmark in C++, a C++ version of YCSB (https://github.com/brianfrankcooper/YCSB/wiki)

YCSB的c++版本，这个版本暂时支持HWDB(个人开发)、rocksdb。

## 代码解析

建议看懂ycsbc.cc，这个文件主要是运行测试基础，包括一些参数；

数据库接口在``db/``目录下，例如rocksdb的接口在db/rocksdb_db.cc里面；

新加数据库接口需要增加db/*文件和修改db/db_factory.cc文件。

## 编译

别的数据库的链接库可以放到``/usr/local/lib``目录下，头文件放到``/usr/local/include``下面，如果找不到，则添加环境变量：

```
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
```

编译：
```
make               #编译所有数据库
或 make hwdb       #只编译hwdb数据库
或 make rocksdb    #只编译rocksdb数据库
```

## 运行
运行代码可参考目录``test_sh/``下的文件，参数可看ycsbc.cc文件。

## 建议
建议看懂代码，可以自己添加别的数据库，然后进行测试。

