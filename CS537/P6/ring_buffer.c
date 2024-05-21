#include "ring_buffer.h"
#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include <stdbool.h>

// Global mutex
pthread_mutex_t global_mutex;

int init_ring(struct ring *r){
    r->p_tail = 0;
    r->p_head = 0;
    r->c_tail = 0;
    r->c_head = 0;
    pthread_mutex_init(&(r->mutex), NULL);
    pthread_mutex_init(&global_mutex, NULL); // Initialize global mutex

    return 0;
}

bool locking(int* addr, int old_val, int new_val){
    //printf("WTF\n");
    return __sync_bool_compare_and_swap(addr, old_val, new_val);
}

void ring_submit(struct ring *r, struct buffer_descriptor *bd){
    pthread_mutex_lock(&global_mutex); // Lock the global mutex

    bd->ready = 0;
    uint32_t next_p_head = (r->p_head + 1) % RING_SIZE;
    uint32_t temp_p_head = r->p_head;

    // Check if the buffer is full
    while(r->c_tail == next_p_head){}

    while(!locking(&r->p_head, temp_p_head, next_p_head)){
        temp_p_head = r->p_head;
        next_p_head = (temp_p_head + 1) % RING_SIZE;
        while(r->c_tail == next_p_head){}
    }
    
    memcpy(&(r->buffer[temp_p_head]), bd, sizeof(struct buffer_descriptor));

    while(!locking(&r->p_tail, temp_p_head, next_p_head)){}
    
    pthread_mutex_unlock(&global_mutex); // Unlock the global mutex
}

void ring_get(struct ring *r, struct buffer_descriptor *bd){
    pthread_mutex_lock(&global_mutex); // Lock the global mutex

    uint32_t temp_c_head = r->c_head;
    uint32_t next_c_head = (r->c_head + 1) % RING_SIZE;

    // Check if the buffer is empty
    while(r->p_tail == temp_c_head){}

    while(!locking(&r->c_head, temp_c_head, next_c_head)){
        temp_c_head = r->c_head;
        next_c_head = (temp_c_head + 1) % RING_SIZE;
        while(r->p_tail == temp_c_head){}
    }

    memcpy(bd, &(r->buffer[temp_c_head]), sizeof(struct buffer_descriptor));
    while(!locking(&r->c_tail, temp_c_head, next_c_head)){}

    pthread_mutex_unlock(&global_mutex); // Unlock the global mutex
}
