#include "ring_buffer.h"
#include "common.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <pthread.h>
#include <unistd.h>
#include <stdbool.h>

int init_ring(struct ring *r){
	r->p_tail = 0;
	r->p_head = 0;
	r->c_tail = 0;
	r->c_head = 0;
	pthread_mutex_init(&(r->mutex), NULL);

	return 0;
}

bool locking(int* addr, int old_val, int new_val){
	return __sync_bool_compare_and_swap(addr, old_val, new_val);
}

void ring_submit(struct ring *r, struct buffer_descriptor *bd){
	bd->ready = 0;
	//printf("SUBMITTING\n");
	//pthread_mutex_lock(&(r->mutex));
	uint32_t next_p_head = (r->p_head + 1) % RING_SIZE;
	uint32_t temp_p_head = r->p_head;
	//printf("SUBMITTING\n");

	// Check if the buffer is full
	while(r->c_tail == next_p_head){}

	while(!locking(&r->p_head, temp_p_head, next_p_head)){
		temp_p_head = r->p_head;
		next_p_head = (temp_p_head + 1) % RING_SIZE;
		while(r->c_tail == next_p_head){}
	}

	//pthread_mutex_lock(&(r->mutex));
	//uint32_t temp_c_tail = r->c_tail;
	//r->p_head = next_p_head;
	//pthread_mutex_unlock(&(r->mutex));
	
	memcpy(&(r->buffer[temp_p_head]), bd, sizeof(struct buffer_descriptor));

	/*while(r->p_tail != temp_p_head){
		continue;
	}
	pthread_mutex_lock(&(r->mutex));
	r->p_tail = next_p_head;
	pthread_mutex_unlock(&(r->mutex));*/
	while(!locking(&r->p_tail, temp_p_head, next_p_head)){}
	        
}

void ring_get(struct ring *r, struct buffer_descriptor *bd){
	//printf("GETTING\n");
	//pthread_mutex_lock(&(r->mutex));
	uint32_t temp_c_head = r->c_head;
	//uint32_t temp_p_tail = r->p_tail;
	uint32_t next_c_head = (r->c_head + 1) % RING_SIZE;
	//printf("GETTING\n");

	// Check if the buffer is empty
	while(r->p_tail == temp_c_head){}
	/*if (next_c_head == temp_p_tail){
		pthread_mutex_unlock(&(r->mutex));
		return;
	}*/
	while(!locking(&r->c_head, temp_c_head, next_c_head)){
		//printf("GETTING1\n");
		temp_c_head = r->c_head;
		//printf("GETTING2\n");
		next_c_head = (temp_c_head + 1) % RING_SIZE;
		//printf("GETTING3\n");
		while(r->p_tail == temp_c_head){}
	}
	//printf("GETTING\n");
	//r->c_head = next_c_head;
	//printf("GETTING %d %d %d %d %d\n", r->buffer[temp_c_head].req_type,  r->buffer[temp_c_head].k,  r->buffer[temp_c_head].v,  r->buffer[temp_c_head].res_off,  r->buffer[temp_c_head].ready );
	//bd->k = r->buffer[temp_c_head];
	memcpy(bd, &(r->buffer[temp_c_head]), sizeof(struct buffer_descriptor));
	//printf("GETTING\n");
	while(!locking(&r->c_tail, temp_c_head, next_c_head)){}
	//printf("GETTING\n");
	//printf("GETTING\n");
	//r->buffer[temp_c_head] = NULL;
	//r->c_tail = r->c_head;
	//printf("GETTING\n");
	//pthread_mutex_unlock(&(r->mutex));
}
