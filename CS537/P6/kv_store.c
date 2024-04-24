#include "kv_store.h"
#include "common.h"
#include "ring_buffer.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>

//static instance of kv_store_t as there is only one instance of the kv store per server
static kv_store_t* kv_store_instance = NULL;
struct ring *ring = NULL;
char *shmem_area;

//initialize the kv store
kv_store_t* kv_store_init(int size) {
    if (kv_store_instance != NULL) {
        //cant reinitialize instance
        return NULL;
    }

    kv_store_t* store = malloc(sizeof(kv_store_t));
    store->table_size = size;
    store->buckets = calloc(size, sizeof(kv_node_t*));
    store->locks = malloc(size * sizeof(pthread_mutex_t));
    for (int i = 0; i < size; i++) {
        pthread_mutex_init(&store->locks[i], NULL);
    }
    return store;
}

//put a key-value pair into the store
void kv_store_put(key_type key, value_type value) {
    if (kv_store_instance == NULL) {
        return;
    }

    unsigned int index = hash_function(key, kv_store_instance->table_size);
    pthread_mutex_lock(&kv_store_instance->locks[index]); //lock the relevant bucket

    kv_node_t** head = &kv_store_instance->buckets[index];
    while (*head != NULL && (*head)->key != key) {
    	//printf("HELLO\n");
        head = &(*head)->next;
    }

    if (*head == NULL) { //key not found, insert new
    	//printf("HELLO\n");
        *head = malloc(sizeof(kv_node_t));
        (*head)->key = key;
        (*head)->value = value;
        (*head)->next = NULL;
    } else { //key found, update value
        (*head)->value = value;
    }

    pthread_mutex_unlock(&kv_store_instance->locks[index]); //unlock the bucket
}

//retrieve a value by key from the store
value_type kv_store_get(key_type key) {
    if (kv_store_instance == NULL) {
        return 0;
    }

    unsigned int index = hash_function(key, kv_store_instance->table_size);
    pthread_mutex_lock(&kv_store_instance->locks[index]); //lock the relevant bucket

    kv_node_t* head = kv_store_instance->buckets[index];
    while (head != NULL && head->key != key) {
        head = head->next;
    }

    value_type value = (head == NULL) ? 0 : head->value; //assuming 0 is an invalid value

    pthread_mutex_unlock(&kv_store_instance->locks[index]); //unlock the bucket.

    return value;
}

//destroy the KV Store
void kv_store_destroy() {
    if (kv_store_instance == NULL) {
        return;
    }

    for (int i = 0; i < kv_store_instance->table_size; i++) {
        pthread_mutex_destroy(&kv_store_instance->locks[i]);
        kv_node_t* head = kv_store_instance->buckets[i];
        while (head != NULL) {
            kv_node_t* temp = head;
            head = head->next;
            free(temp);
        }
    }
    free(kv_store_instance->buckets);
    free(kv_store_instance->locks);
    free(kv_store_instance);
}

void *server_thread(void *arg){
	while(1){
		//printf("HELLO\n");
		//printf("HELLKSDJFLKSJDLFKJSDF\n");
		struct buffer_descriptor *bd = malloc(sizeof(struct buffer_descriptor *));
		//printf("HELLKSDJFLKSJDLFKJSDF\n");
		ring_get(ring, bd);
		//printf("HELLKSDJFLKSJDLFKJSDFsdlkcvjlksdjflkjasdf\n");
		//printf("HELLO\n");
		if(bd->req_type == PUT){
			//printf("HELLO\n");
			kv_store_put(bd->k, bd->v);
			char *temp_window = shmem_area + bd->res_off;
			struct buffer_descriptor *ready_window = (struct buffer_descriptor*)temp_window;
			ready_window->ready = 1;
			//printf("HELLO\n");
		}
		else{
			//printf("HELLO\n");
			int value = kv_store_get(bd->k);
			char *temp_window = shmem_area + bd->res_off;
			struct buffer_descriptor *ready_window = (struct buffer_descriptor*)temp_window;
			ready_window->v = value;
			ready_window->ready = 1;
			//printf("HELLO\n");
		}
	}

}

int main(int argc, char *argv[]) {
	//printf("HELLO\n");
	int num_threads = 1;
	int table_size = 5;
	int opt;
	//printf("HELLKSDJFLKSJDLFKJSDF\n");
	while ((opt = getopt(argc, argv, "n:s:")) != -1) {
		switch (opt) {
			case 'n':
				num_threads = atoi(optarg);
				break;
			case 's':
				table_size = atoi(optarg);
				break;
			default: /* '?' */
				fprintf(stderr, "Usage: %s -n num_threads -s table_size\n", argv[0]);
				exit(EXIT_FAILURE);
		}
	}
	//printf("HELLO\n");
	//printf("HELLKSDJFLKSJDLFKJSDF\n");
	// Initialize KV Store
	kv_store_instance = kv_store_init(table_size);
	//printf("HELLO\n");
	//printf("HELLKSDJFLKSJDLFKJSDF\n");
	int fd = open("shmem_file", O_CREAT | O_RDWR, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH);
	if(fd < 0)
		perror("open");
	//printf("HELLKSDJFLKSJDLFKJSDF\n");
	struct stat st;
	fstat(fd, &st);
	int temp_size = st.st_size;
	char *mem = mmap(NULL, temp_size, PROT_WRITE | PROT_READ, MAP_SHARED, fd, 0);
	//printf("HELLKSDJFLKSJDLFKJSDF\n");
	if(mem == (void *)-1)
		perror("mmap");
	close(fd);
	//printf("HELLKSDJFLKSJDLFKJSDF\n");
	ring = (struct ring *)mem;
	shmem_area = mem;
	//printf("HELLO\n");
	// Thread handling
	pthread_t threads[num_threads];
	//printf("HELLO\n");
	//printf("HELLKSDJFLKSJDLFKJSDF\n");
	for (int i = 0; i < num_threads; i++) {
		pthread_create(&threads[i], NULL, &server_thread, NULL);
	}
	//printf("MORE HELLOS\n");
	for (int i = 0; i < num_threads; i++) {
		pthread_join(threads[i], NULL);
	}

	// Cleanup not sure if i need to implement a destroy function??
	return 0;
}
