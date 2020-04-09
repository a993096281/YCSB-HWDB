//
// 
//

#ifndef YCSB_C_HWDB_H
#define YCSB_C_HWDB_H

#ifdef __cplusplus   
extern "C"{
#endif /* __cplusplus */

//用c方式编译的代码
#include <hwdb/hwdb.h>   //hwdb的头文件，最好放在 /usr/local/include/ 下，

#ifdef __cplusplus
}
#endif /* __cplusplus */

#include "core/db.h"
#include <iostream>
#include <string>
#include "core/properties.h"


using std::cout;
using std::endl;

namespace ycsbc {
    class HWDB : public DB{
    public :
        HWDB(const char *dbfilename, utils::Properties &props);
        int Read(const std::string &table, const std::string &key,
                 const std::vector<std::string> *fields,
                 std::vector<KVPair> &result);

        int Scan(const std::string &table, const std::string &key, const std::string &max_key,
                 int len, const std::vector<std::string> *fields,
                 std::vector<std::vector<KVPair>> &result);

        int Insert(const std::string &table, const std::string &key,
                   std::vector<KVPair> &values);

        int Update(const std::string &table, const std::string &key,
                   std::vector<KVPair> &values);


        int Delete(const std::string &table, const std::string &key);

        void PrintStats();

        ~HWDB();

    private:
        HWDB_OBJ *db_;
        HwdbConfig config_;
        unsigned noResult;

        void SetOptions(const char *dbfilename, utils::Properties &props);
        void SerializeValues(std::vector<KVPair> &kvs, std::string &value);
        void DeSerializeValues(std::string &value, std::vector<KVPair> &kvs);

        

    };
}


#endif //YCSB_C_ROCKSDB_DB_H
