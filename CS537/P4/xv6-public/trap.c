#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "traps.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"

// Interrupt descriptor table (shared by all CPUs).
struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S: array of 256 entry pointers
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));
}

void addPhysicalPage(uint mappedAddress, char* mem, int page){
	struct proc *currproc = myproc();

	for(int i=0; i<16; i++){
		if((currproc->allAddresses)[i].startingVirtualAddr <= mappedAddress && (currproc->allAddresses)[i].endingVirtualAddr > mappedAddress){
			//uint tempHolder = (mappedAddress - (currproc->allAddresses)[i].startingVirtualAddr)/PGSIZE;
			//cprintf("%x %x\n",(currproc->allAddresses)[i].startingVirtualAddr, tempHolder );
			((currproc->allAddresses)[i].physicalPageNumber)++;
			for(int j=0; j<16; j++){
				if(j == page){
					((currproc->allAddresses)[i].forFork[j]) = V2P(mem);
					break;
				}
			}
			//((currproc->allAddresses)[i].forFork[tempHolder]) = V2P(mem);
		}
	}
}

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

	case T_PGFLT: // T_PGFLT = 14
		uint tempAddress = PGROUNDDOWN(rcr2()); // Fetches the address that needs to have memory physically allocated
		int inAddressSpace = 0;
		//int pages = 0;
		int placement = 0;
		int page = 0;

		// Finds which spot the memory is mapped and
		// gets the number of pages that need to be allocated
		//if(tempAddress >= 0x60000000 && tempAddress <= 0x80000000){
			for(int i=0; i<16; i++){
				if((myproc()->allAddresses)[i].startingVirtualAddr <= tempAddress && (myproc()->allAddresses)[i].endingVirtualAddr >= tempAddress){
					//cprintf("Number of pages: %d\n", pages);
					inAddressSpace = 1;
					placement = i;
				}
			}

			for(int i=0; i<16; i++){
				uint findAddress = myproc()->allAddresses[placement].startingVirtualAddr + i*PGSIZE;
				if(findAddress <= tempAddress && findAddress+PGSIZE > tempAddress){
					page = i;
				}
				
			}

			// Checks to make sure that this is part of the mapped memories
			if(inAddressSpace != 0){

				// Gets a physical address for all the pages
			
				char* mem = kalloc();
				if(mem == 0){
					cprintf("Not able to kalloc\n");
					myproc()->killed = 1;
				}else{
					if(myproc()->allAddresses[placement].isAnonymous == 1){
						memset(mem, 0, PGSIZE);
					}
					else{
						int fd = -1;
						struct file *f;
						for (int i = 0; i < NOFILE; i++) {
							f = myproc()->ofile[i];
							if (f == myproc()->allAddresses[placement].fd)
								fd = i;
						}
						//cprintf("%")
						struct inode* ip = (myproc()->ofile)[fd]->ip;
						readi(ip, (char*)mem, (uint)page*PGSIZE, (uint)PGSIZE);
						
						/*memset(mem, 0, PGSIZE);
						for(int i=0; i<NOFILE; i++){
							cprintf("FILE: %x",myproc()->ofile[i], );
						}*/
					}
					
					if(mappages(myproc()->pgdir, (char*)tempAddress, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0){ // The actual mapping of the pages
						cprintf("mappages() not working\n");
						myproc()->killed = 1;
					}
				}
				addPhysicalPage(tempAddress, mem, page);
				//if(myproc()->allAddresses[placement].isAnonymous == 0 && myproc()->allAddresses[placement].startingVirtualAddr == tempAddress)
					//memmove(mem, myproc()->allAddresses[placement].fd, myproc()->allAddresses[placement].numberOfPages*PGSIZE);
			}
			else{
				cprintf("Segmentation Fault\n");
				myproc()->killed = 1;
			}
	//	}
		
			break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}


/*for(int i=0; i<16; i++){
	if(currproc->allAddresses[found].forFork[i] != 0){
		if(mappages(currproc->pgdir, (char*)currproc->allAddress[found]->startingVirtualAddr + i*PGSIZE, PGSIZE, (currproc->allAddresses[found].forFork[i]), PTE_W | PTE_U) < 0){ // The actual mapping of the pages
			cprintf("mappages() not working\n");
			myproc()->killed = 1;
		}
	}
}

0x6000 - forFork[1]
0x6100 - forFork[2]
*/
