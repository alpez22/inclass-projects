#ifndef MINIT_H
#define MINIT_H

#include "spinlock.h"
#include "types.h"

typedef struct {
	  // Lock state, ownership, etc.
	  uint locked;	// Is the lock held?
	  struct spinlock lk;	// Spinlock protecting this sleep lock
	  int pid;

	// For priority inheritance
  	int waiting_pids[16]; // Array to store PIDs of waiting processes
} mutex;
#endif
