//
// Created by wujy on 1/23/19.
//
#include <iostream>


#include "hwdb_db.h"
#include "lib/coding.h"

using namespace std;

namespace ycsbc {

    struct Data_S{   //适合hwdb的字符串
        char *data_;  //data前四个字节是size_,然后才是数据

        Data_S():data_(nullptr) {};

        Data_S(const char *str){
            uint32_t size_ = strlen(str);
            data_ = new char[sizeof(uint32_t) + size_];
            uint32_t *len = (uint32_t *)data_;
            *len = size_;
            memcpy(data_ + sizeof(uint32_t), str, size_);
        }

        Data_S(const std::string &str){
            uint32_t size_ = str.size();
            data_ = new char[sizeof(uint32_t) + size_];
            uint32_t *len = (uint32_t *)data_;
            *len = size_;
            memcpy(data_ + sizeof(uint32_t), str.c_str(), size_);
        }

        ~Data_S(){
            if(data_ != nullptr)  delete []data_;
        }

        char *raw_data(){
            return data_;
        }

        uint32_t size(){
            return *(uint32_t *)data_;
        }

        char *data(){
            if(data_ != nullptr) return data_ + sizeof(uint32_t);
            return nullptr;
        }

    };

    HWDB::HWDB(const char *dbfilename, utils::Properties &props) :noResult(0){
    
        //set option
        SetOptions(dbfilename, props);
        

        int s = CreatHwdb((char *)dbfilename, &config_, &db_);
        if(s != 0){
            cerr<<"Can't open hwdb "<<dbfilename<<" "<<s<<endl;
            exit(0);
        }
    }

    void HWDB::SetOptions(const char *dbfilename, utils::Properties &props) {
        //
        SetDefaultHwdbConfig(&config_);
        strcpy(config_.fs_path, dbfilename);
        config_.kLogMaxWriteSize = 4 * 1024 * 1024;  //
        config_.kMaxPthreadNum = 16;
    
    }


    int HWDB::Read(const std::string &table, const std::string &key, const std::vector<std::string> *fields,
                      std::vector<KVPair> &result) {
        Data_S find_key(key);
        char *value = nullptr;
        int s = db_->interface.Getkv(db_->db, find_key.raw_data(), &value);
        if(s == 0) {
            if(value == nullptr){
                noResult++;
                //cerr<<"read not found:"<<noResult<<endl;
                return DB::kOK;
            }
            //printf("value:%lu\n",value.size());
            //DeSerializeValues(std::string(value + 4), result);
            /* printf("get:key:%lu-%s\n",key.size(),key.data());
            for( auto kv : result) {
                printf("get field:key:%lu-%s value:%lu-%s\n",kv.first.size(),kv.first.data(),kv.second.size(),kv.second.data());
            } */
            return DB::kOK;
        }
        else{
            cerr<<"read error"<<endl;
            exit(0);
        }
    }


    int HWDB::Scan(const std::string &table, const std::string &key, const std::string &max_key, int len, const std::vector<std::string> *fields,
                      std::vector<std::vector<KVPair>> &result) {
        void *iter = nullptr;
        int s = db_->interface.RangekvGet(db_->db, Data_S(key).raw_data(), Data_S(max_key).raw_data(), &iter);
        if(s != 0){
            cerr<<"scan error"<<endl;
            exit(0);
        }
        char *val;
        char *k;
        bool ok = true;
        for(int i=0;i < len && ok; i++){
            k = NULL;
            val = NULL;
            s = db_->interface.GetNext(iter, &k, &val);
            if(k != NULL && val != NULL){
                free(k);
                free(val);
            }
            else{
                ok = false;
            }
            
        } 
        db_->interface.DeleteIterator(&iter);
        return DB::kOK;
    }

    int HWDB::Insert(const std::string &table, const std::string &key,
                        std::vector<KVPair> &values){
        int s;
        string value = values.at(0).second;
        //SerializeValues(values,value);
        /* printf("put:key:%lu-%s\n",key.size(),key.data());
        for( auto kv : values) {
            printf("put field:key:%lu-%s value:%lu-%s\n",kv.first.size(),kv.first.data(),kv.second.size(),kv.second.data());
        } */
        s = db_->interface.Putkv(db_->db, Data_S(key).raw_data(), Data_S(value).raw_data());
        if(s != 0){
            cerr<<"insert error\n"<<endl;
            exit(0);
        }
       
        return DB::kOK;
    }

    int HWDB::Update(const std::string &table, const std::string &key, std::vector<KVPair> &values) {
        return Insert(table,key,values);
    }

    int HWDB::Delete(const std::string &table, const std::string &key) {
        int s;
        s = db_->interface.Delkv(db_->db, Data_S(key).raw_data());
        if(s != 0){
            cerr<<"Delete error\n"<<endl;
            exit(0);
        }
        return DB::kOK;
    }

    void HWDB::PrintStats() {
        if(noResult) cout<<"read not found:"<<noResult<<endl;
        char stats[300];
        db_->interface.PrintStats(db_->db, (char *)&stats);
        cout<<stats<<endl;
    }


    HWDB::~HWDB() {
        DeleteHwdb(&db_);
    }

    void HWDB::SerializeValues(std::vector<KVPair> &kvs, std::string &value) {
        value.clear();
        PutFixed64(&value, kvs.size());
        for(unsigned int i=0; i < kvs.size(); i++){
            PutFixed64(&value, kvs[i].first.size());
            value.append(kvs[i].first);
            PutFixed64(&value, kvs[i].second.size());
            value.append(kvs[i].second);
        }
    }

    void HWDB::DeSerializeValues(std::string &value, std::vector<KVPair> &kvs){
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