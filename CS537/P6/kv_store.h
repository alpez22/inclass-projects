#include "common.h"
#include <pthread.h>

typedef struct kv_node {
    key_type key;
    value_type value;
    struct kv_node* next;
} kv_node_t;

typedef struct {
    kv_node_t** buckets; //array of pointers to kv_node_t
    int table_size;
    pthread_mutex_t* locks; //array of mutexes for fine-grained locking.
} kv_store_t;

kv_store_t* kv_store_init(int size);
//void kv_store_put(kv_store_t* store, key_type key, value_type value);
void kv_store_put(key_type key, value_type value);
//value_type kv_store_get(kv_store_t* store, key_type key);
value_type kv_store_get(key_type key);
//void kv_store_destroy(kv_store_t* store);
void kv_store_destory();
