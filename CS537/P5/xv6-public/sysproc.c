#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "minit.h"

int
sys_fork(void)
{
  return fork();
}

int sys_clone(void)
{
  int fn, stack, arg;
  argint(0, &fn);
  argint(1, &stack);
  argint(2, &arg);
  return clone((void (*)(void*))fn, (void*)stack, (void*)arg);
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  if (n == 0) {
    yield();
    return 0;
  }
  acquire(&tickslock);
  ticks0 = ticks;
  myproc()->sleepticks = n;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  myproc()->sleepticks = -1;
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

void adjust_lockholder_priority_aquire(mutex *m){
  struct proc *p;
  Ptable ptable;
  int highestPriority = 19;
  acquire(&ptable.lock);

  //find the highest priority in array
  for(int i = 0; i < 16; i++){
    if(m->waiting_pids[i] != 0){
      //get proc using pid
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
        if(p->waitingPid == m->pid){
          if(p != 0 && p->niceLevel < highestPriority){
            highestPriority = p->niceLevel;
          }
        }
      }
    }
  }

  //adjust lockholder priority
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == m->pid){
      if(p != 0 && highestPriority < p->niceLevel){
        if(p->prevNiceLevelChanged == 0){
          p->previousNiceLevel = p->niceLevel;
          p->prevNiceLevelChanged = 1;
        }
        p->niceLevel = highestPriority;
      }
    }
  }

  release(&ptable.lock);
}

void sys_macquire(void){
	mutex *m;
	if(argptr(0, (void*)&m, sizeof(*m)) < 0)
	    return;

	acquire(&m->lk);
	while(m->locked){
	    // Add the current process to the waiting list
	    for (int i = 0; i < 16; i++) {
	      if (m->waiting_pids[i] == 0) { // Find an empty spot
	        m->waiting_pids[i] = myproc()->pid;
	        break;
	      }
	    }
	    myproc()->waitingPid = m->pid;
	    adjust_lockholder_priority_aquire(m);
		sleep(m, &m->lk);
	}
	adjust_lockholder_priority_aquire(m);
	myproc()->waitingPid = 0;
	m->locked = 1;
	m->pid = myproc()->pid;
	for (int i = 0; i < 16; i++) {
	      if (m->waiting_pids[i] == m->pid){
	      	m->waiting_pids[i] = 0;
	      }
	}
	release(&m->lk);
}

void adjust_lockholder_priority_release(mutex *m){
  struct proc *p;
  Ptable ptable;
  acquire(&ptable.lock);

  //adjust lockholder priority
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == m->pid){
      p->niceLevel = p->previousNiceLevel;
      p->prevNiceLevelChanged = 0;
    }
  }

  release(&ptable.lock);
}

void sys_mrelease(void){
	mutex *m;
	if(argptr(0, (void*)&m, sizeof(*m)) < 0)
	    return;

    acquire(&m->lk);
    m->locked = 0;
    m->pid = 0;
    // Remove the current process from the waiting list
    // and adjust priorities of remaining waiting threads if necessary
    for (int i = 0; i < 16; i++) {
      if (m->waiting_pids[i] == myproc()->pid) {
        m->waiting_pids[i] = 0; // Remove the current thread
        break;
      }
    }
    adjust_lockholder_priority_release(m);
    wakeup(m);
    release(&m->lk);
}

int sys_nice(void){
	int inc;
	struct proc *currproc = myproc();
	
  	if(argint(0, &inc) < 0)
    	return -1;

    currproc->niceLevel += inc;

    if(currproc->niceLevel < -20){
    	currproc->niceLevel = -20;
    }
    else if(currproc->niceLevel > 19){
    	currproc->niceLevel = 19;
    }
	return 0;
}
