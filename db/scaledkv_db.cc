//
// Created by wujy on 1/23/19.
//
#include <iostream>


#include "scaledkv_db.h"
#include "lib/coding.h"

using namespace std;

namespace ycsbc {
    static inline void fillchar8wirhint64(char *key, uint64_t value) {
        key[0] = ((char)(value >> 56)) & 0xff;
        key[1] = ((char)(value >> 48)) & 0xff;
        key[2] = ((char)(value >> 40) )& 0xff;
        key[3] = ((char)(value >> 32)) & 0xff;
        key[4] = ((char)(value >> 24)) & 0xff;
        key[5] = ((char)(value >> 16)) & 0xff;
        key[6] = ((char)(value >> 8)) & 0xff;
        key[7] = ((char)value) & 0xff;
    }
    ScaledKV::ScaledKV(const char *dbfilename, utils::Properties &props) :noResult(0){
    
        //set option
        SetOptions(props);
        if(AllocatorInit(path, nvm_size, valuepath, nvm_value_size) < 0) {
            printf("Initial allocator failed\n");
        }
        

        db_ = new scaledkv::NVMScaledKV();
        if(!db_) {
            printf("creat scaledkv error\n");
            AllocatorExit();
        }
        db_->Initialize(m, key_size, buf_size);
    }

    void ScaledKV::SetOptions(utils::Properties &props) {
        path = "/pmem0/key";
        valuepath = "/pmem0/value";
        nvm_size = 100 * (1ULL << 30);
        nvm_value_size = 200 * (1ULL << 30);
        m = 10;
        key_size = scaledkv::NVM_KeySize;
        value_size = scaledkv::NVM_ValueSize;
        buf_size = key_size + value_size + 1;

    }


    int ScaledKV::Read(const std::string &table, const std::string &key, const std::vector<std::string> *fields,
                      std::vector<KVPair> &result) {
        string value;
        value = db_->Get(key);
        if(value.empty()){
            noResult++;
        }
        return DB::kOK;
    }


    int ScaledKV::Scan(const std::string &table, const std::string &key, int len, const std::vector<std::string> *fields,
                      std::vector<std::vector<KVPair>> &result) {
        std::vector<std::string> values;
        db_->GetRange(key, "", values, len);
        return DB::kOK;
    }

    int ScaledKV::Insert(const std::string &table, const std::string &key,
                        std::vector<KVPair> &values){
        string value;
        value.append(value_size, 'a');
        db_->Insert(key, value);
        return DB::kOK;
    }

    int ScaledKV::Update(const std::string &table, const std::string &key, std::vector<KVPair> &values) {
        return Insert(table,key,values);
    }

    int ScaledKV::Delete(const std::string &table, const std::string &key) {
        db_->Delete(key);
        return DB::kOK;
    }

    void ScaledKV::PrintStats() {
        //if(noResult != 0) {
            cout<<"read not found:"<<noResult<<endl;
        //}
        //db_->Print();
    }

    ScaledKV::~ScaledKV() {
        delete db_;
        AllocatorExit();
    }

    void ScaledKV::SerializeValues(std::vector<KVPair> &kvs, std::string &value) {
        value.clear();
        PutFixed64(&value, kvs.size());
        for(unsigned int i=0; i < kvs.size(); i++){
            PutFixed64(&value, kvs[i].first.size());
            value.append(kvs[i].first);
            PutFixed64(&value, kvs[i].second.size());
            value.append(kvs[i].second);
        }
    }

    void ScaledKV::DeSerializeValues(std::string &value, std::vector<KVPair> &kvs){
        uint64_t offset = 0;
        uint64_t kv_num = 0;
        uint64_t key_size = 0;
        uint64_t value_size = 0;

        kv_num = DecodeFixed64(value.c_str());
        offset += 8;
        for( unsigned int i = 0; i < kv_num; i++){
            ycsbc::DB::KVPair pair;
            key_size = DecodeFixed64(value.c_str() + offset);
            offset += 8;

            pair.first.assign(value.c_str() + offset, key_size);
            offset += key_size;

            value_size = DecodeFixed64(value.c_str() + offset);
            offset += 8;

            pair.second.assign(value.c_str() + offset, value_size);
            offset += value_size;
            kvs.push_back(pair);
        }
    }
}
