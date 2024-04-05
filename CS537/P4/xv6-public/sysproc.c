#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "x86.h"
#include "fs.h"
#include "spinlock.h" 
#include "sleeplock.h"
#include "file.h"
#include "wmap.h"

/*#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "wmap.h"*/
#define NULL 0

int
sys_fork(void)
{
  return fork();
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
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
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

// Returns whether the address can be used or if it
// is already in use by another address
int checkAddr(uint startingAddr, uint endingAddr){
	int count = 0;
	for(int i=15; i>=0; i--){
		/*if(((myproc()->allAddresses)[i].startingVirtualAddr) <= startingAddr){
			if(((myproc()->allAddresses)[i].endingVirtualAddr) >= startingAddr){
				return 0;
			}
		}

		if(((myproc()->allAddresses)[i].startingVirtualAddr) <= endingAddr){
			if(((myproc()->allAddresses)[i].endingVirtualAddr) >= endingAddr){
				return 0;
			}
		}*/
		/*if(startingAddr >= ((myproc()->allAddresses)[i].startingVirtualAddr) && startingAddr < ((myproc()->allAddresses)[i].endingVirtualAddr)){
			return 0;
		}
		
		if(endingAddr >= ((myproc()->allAddresses)[i].startingVirtualAddr) && endingAddr < ((myproc()->allAddresses)[i].endingVirtualAddr)){
			return 0;
		}

		if(startingAddr < ((myproc()->allAddresses)[i].startingVirtualAddr) && startingAddr >= ((myproc()->allAddresses)[i].endingVirtualAddr)){
			return 0;
		}
		
		if(endingAddr < ((myproc()->allAddresses)[i].startingVirtualAddr) && endingAddr >= ((myproc()->allAddresses)[i].endingVirtualAddr)){
			return 0;
		}*/
		if(((myproc()->allAddresses)[i].startingVirtualAddr) == 0){
			count++;
			continue;
		}
		else if(((myproc()->allAddresses)[i+1].endingVirtualAddr) == 0 && startingAddr >= ((myproc()->allAddresses)[i].endingVirtualAddr)){
			return 1;
		}
		else if(i-1 >= 0 && startingAddr >= ((myproc()->allAddresses)[i-1].endingVirtualAddr) && endingAddr <= ((myproc()->allAddresses)[i].startingVirtualAddr)){
			return 1;
		}
		else if(i == 0 && endingAddr <= ((myproc()->allAddresses)[i].startingVirtualAddr)){
			return 1;
		}
	}

	if(count >= 16){
		//cprintf("HELLOOOOOOOOO\n");
		return 1;
	}
	return 0;
}

// Finds an address that is not already in use
int findAvailableAddr(int length){
	//cprintf("LENGTH: %d\n", length);
	uint checkedAddress = 0x60000000;
	int foundValid = 0;
	//cprintf("%x %x\n",((myproc()->allAddresses)[0].startingVirtualAddr), ((myproc()->allAddresses)[0].endingVirtualAddr));
	//cprintf("CHECKING TRUTH: %x %x %x %x", checkedAddress >= ((myproc()->allAddresses)[0].startingVirtualAddr), checkedAddress < ((myproc()->allAddresses)[0].endingVirtualAddr), checkedAddress+length >= ((myproc()->allAddresses)[0].startingVirtualAddr), checkedAddress+length < ((myproc()->allAddresses)[0].endingVirtualAddr));
	//cprintf("CHECKING TRUTH: %x, %x, %x, %x\n", ((myproc()->allAddresses)[0].startingVirtualAddr) == 0, checkedAddress > ((myproc()->allAddresses)[0].endingVirtualAddr), checkedAddress+length < ((myproc()->allAddresses)[0].startingVirtualAddr));
	while(checkedAddress < 0x80000000){
		foundValid = checkAddr(checkedAddress, checkedAddress+length);

		if(foundValid == 1)
			break;

		checkedAddress += 4096;
	}
	//cprintf("%x %x\n", checkedAddress, checkedAddress+length);

	return checkedAddress;
}

// Adds the address into the appropriate spot
void addAddress(uint startingAddr, uint endingAddr, int pages, int isPrivate, int isAnonymous, struct file *fd, int length){
	int placeHolder = 0;
	int count = 0;
	struct proc *currproc = myproc();

	// Checks where the address needs to be added
	for(count=15; count>=0; count--){
		//cprintf("%d)\n", count);
		if(count == 0){
			
			if(currproc->allAddresses[count].startingVirtualAddr == 0){
				placeHolder = 0;
				//cprintf("bruh1\n");
			}
			else if(endingAddr <= currproc->allAddresses[count].startingVirtualAddr){
				placeHolder = 0;
				//cprintf("hi\n");
			}else{
				//cprintf("hello\n");
				placeHolder = 1;
			}
		}else if(currproc->allAddresses[count - 1].endingVirtualAddr < startingAddr && currproc->allAddresses[count].startingVirtualAddr > endingAddr){
			placeHolder = count;
			//cprintf("hi\n");
			//cprintf("%d) %x < %x && %x < %x\n", count, currproc->allAddresses[count + 1].endingVirtualAddr, startingAddr, endingAddr, currproc->allAddresses[count].startingVirtualAddr);
			break;
		}else if(currproc->allAddresses[count].endingVirtualAddr < startingAddr && currproc->allAddresses[count].endingVirtualAddr != 0){
			placeHolder = count + 1;
			//cprintf("%d > %d\n", currproc->allAddresses[count].startingVirtualAddr, endingAddr);
			//cprintf("hello\n");
			break;
		}
		
		//cprintf("%d) %x > %x && %x > %x\n", count, currproc->allAddresses[count - 1].endingVirtualAddr, startingAddr, endingAddr, currproc->allAddresses[count].startingVirtualAddr);
		// if(currproc->allAddresses[count].startingVirtualAddr > endingAddr){
		// 	//if(count-1 < 0 || ((myproc()->allAddresses)[count-1].endingVirtualAddr) < startingAddr){
		// 		placeHolder = count;
		// 	//}
		// 	cprintf("%x > %x\n", currproc->allAddresses[count].startingVirtualAddr, endingAddr);
		// }else if(currproc->allAddresses[count].startingVirtualAddr == 0){
		// 	placeHolder = count;
		// 	break;
		// }
		
	}
	//cprintf("%x > %x\n", currproc->allAddresses[1].startingVirtualAddr, startingAddr);
	//cprintf("%x\n", currproc->allAddresses[1].startingVirtualAddr > endingAddr);
	//cprintf("final count: %d\n", placeHolder);

	// Shifts all the addresses that come after the new one
	// to the right by one spot
	for(int i=15; i>placeHolder; i--){
		((myproc()->allAddresses)[i]).startingVirtualAddr = ((myproc()->allAddresses)[i-1]).startingVirtualAddr;
		((myproc()->allAddresses)[i]).endingVirtualAddr = ((myproc()->allAddresses)[i-1]).endingVirtualAddr;
		((myproc()->allAddresses)[i]).numberOfPages = ((myproc()->allAddresses)[i-1]).numberOfPages;
		((myproc()->allAddresses)[i]).refCount = ((myproc()->allAddresses)[i-1]).refCount;
		((myproc()->allAddresses)[i]).isPrivate = ((myproc()->allAddresses)[i-1]).isPrivate;
		((myproc()->allAddresses)[i]).isAnonymous = ((myproc()->allAddresses)[i-1]).isAnonymous;
		((myproc()->allAddresses)[i]).fd = ((myproc()->allAddresses)[i-1]).fd;
		((myproc()->allAddresses)[i]).length = ((myproc()->allAddresses)[i-1]).length;
		((myproc()->allAddresses)[i]).physicalPageNumber = ((myproc()->allAddresses)[i-1]).physicalPageNumber;		 
		for(int j=0; j<32; j++){
			((myproc()->allAddresses)[i]).startingPhysicalAddr[j] = ((myproc()->allAddresses)[i-1]).startingPhysicalAddr[j];
			if(j<16){
				((myproc()->allAddresses)[i]).forFork[j] = ((myproc()->allAddresses)[i-1]).forFork[j];
			}
		}
	}

	// Adds the address to the array and adds the necessary info
	((myproc()->allAddresses)[placeHolder]).startingVirtualAddr = startingAddr;
	((myproc()->allAddresses)[placeHolder]).endingVirtualAddr = endingAddr;
	((myproc()->allAddresses)[placeHolder]).numberOfPages = pages;
	((myproc()->allAddresses)[placeHolder]).refCount = 0;
	((myproc()->allAddresses)[placeHolder]).isPrivate = isPrivate;
	((myproc()->allAddresses)[placeHolder]).isAnonymous = isAnonymous;
	((myproc()->allAddresses)[placeHolder]).fd = fd;
	((myproc()->allAddresses)[placeHolder]).length = length;
	//((myproc()->allAddresses)[placeHolder]).ip = myproc()->ofile[(uint)(myproc()->allAddresses[placeHolder].fd)]->ip;
}

uint sys_wmap(void){
	int flags;
	int length;
	int expectedAddr;
	uint endingAddr = 0;
	int goodAddress = 0;
	int pages = 0;
	int isPrivate = 0;
	int isAnonymous = 1;
	struct file *fd;

	// Retrieves the arguments that were passed into
	// the syscall
	if(argint(2, &flags) < 0 || argint(0, &expectedAddr) < 0 || argint(1, &length) < 0)
		return FAILED;

	if((flags & MAP_ANONYMOUS) == 0){
		if(argfd(3, 0, &fd) < 0){
			return FAILED;
		}
		isAnonymous = 0;
	}
	else{
		fd = NULL;
	}
	
	// Makes sure that the address passed in is page aligned
	//cprintf("CURRENT: %x\n", length%4096);
	if(((flags & MAP_FIXED) == 8) && ((expectedAddr & 0xFFF) || ((uint)expectedAddr) < 0x60000000 || ((uint)expectedAddr) > 0x80000000)){
		return FAILED;
	}

	if((flags & MAP_PRIVATE) == 1){
		isPrivate = 1;
	}
	// Figures out the amount of pages needed
	length = length;
	pages = (PGROUNDUP(length)) / 4096;
	// int tempLength = pages % 4096;
	// if(tempLength != 0){
	// 	pages++;
	// }

	// Checks if MAP_FIXED flag is used
	if((flags & MAP_FIXED) == 8){
		endingAddr = expectedAddr + length; // Gets the ending address
		goodAddress = checkAddr(expectedAddr, endingAddr); // Makes sure that the address is unused
		if(goodAddress == 0){ // If not unused, will need to place in another address
			return FAILED;
		}
	}
	else{
		expectedAddr = 0;
	}

	// Checks if the expectedAddress is going to be used
	// and places the needed info in accordingly
	if(expectedAddr){
		addAddress(expectedAddr, endingAddr, pages, isPrivate, isAnonymous, fd, length);
	}
	else{
		expectedAddr = findAvailableAddr(length); // Finds the next available address not being used
		//cprintf("NEW ADDRESS: %x\n", expectedAddr);
		addAddress(expectedAddr, expectedAddr + length, pages, isPrivate, isAnonymous, fd, length);
	}
	return expectedAddr;
}

void removeMapping(pde_t *pgdir, uint startAddr, int numPages, int found) {
    // Removing the entries from the process's page table (pgdir)
	uint a;
    pte_t *pte;

    for (a = startAddr; a < startAddr + numPages * PGSIZE; a += PGSIZE) {
        // get page table entry for the address
        pte = (pte_t*)walkpgdir(pgdir, (char*)a, 0); //takes pgdir + starting va of each page + 0 makes it so it doesn't create a new pt if found
        if (!pte){
            continue; // no entry, move to next page
		}

        if (*pte & PTE_P) {
            // page is present therefore unmap
            uint pa = PTE_ADDR(*pte); // get physical address from the page table entry
            if (pa == 0){
                panic("removeMapping: attempt to unmap an unmapped address");
			}

            // Invalidate the PTE
            *pte = 0;

            // free the physical page
            //struct proc *currproc = myproc();
            //cprintf("PROC: %x %x\n", currproc, currproc->parent);
           // if(initproc == currproc)
           for(int i=0; i<16; i++){
           	
           }

           struct proc *currproc = myproc();
        	if(currproc->allAddresses[found].refCount < 1)
            	kfree((char*)P2V(pa)); // convert pa to virtual (kernel space) before freeing
        }
    }

    // switch to the new page directory to ensure changes are applied
    switchuvm(myproc());
}

int wunMap(uint addr, int flagRemovePhysicalMapping){
	cprintf("ADDR: %x\n", addr);
	struct proc *currproc = myproc();
	int found = -1; 
	int i;
	for(i=0; i<16; i++){
		if(currproc->allAddresses[i].startingVirtualAddr == addr){
			cprintf("FOUND %d\n", i);
			found = i; //found has the index which the addr is
			break;
		}
	}

	if(found == -1){
		return FAILED; //mapping not found
	}

	if(flagRemovePhysicalMapping == 1){
		removeMapping(currproc->pgdir, currproc->allAddresses[found].startingVirtualAddr, currproc->allAddresses[found].numberOfPages, found);

	}

	//shift remaining mappings up in the array
	for(; i<15; i++){
		currproc->allAddresses[i] = currproc->allAddresses[i+1]; //move all other addr up
	}	

	//clear last entry
	currproc->allAddresses[15].startingVirtualAddr = 0;
	currproc->allAddresses[15].endingVirtualAddr = 0;
	currproc->allAddresses[15].numberOfPages = 0;

	return SUCCESS;
}

int sys_wunmap(void){
	uint addr;
	//extract starting addr from syscall
	if(argint(0, (int*)&addr) < 0){
		return FAILED;
	}
	//ensure addr is page aligned
	if((addr & 0xFFF) != 0 || ((uint)addr) < 0x60000000 || ((uint)addr) > 0x80000000 || addr % PGSIZE != 0){
		return FAILED;
	}
	
	wunMap(addr, 1);

	return SUCCESS;
}

int isAdjacentSpaceFree(struct proc *currproc, uint oldaddr, int newsize, int mappedIndex) {
    uint required_end_addr = oldaddr + newsize; //address where the new mapping would end

    if(required_end_addr > 0x80000000){
		return -1;
	}
	if(mappedIndex == 15){//required_end_addr is less than 0x80000000
		return 0;
	}
	
	uint next_start_addr = currproc->allAddresses[mappedIndex+1].startingVirtualAddr;
	if(next_start_addr != 0){//if index to right is mapped
		if(required_end_addr >= next_start_addr){
			return -1;
		}
	}

	return 0;
}

void resizeMappingInPlace(struct proc *currproc, uint oldaddr, int newsize, int mappedIndex, int isShrinking, uint oldEndAddr){
	uint required_end_addr = oldaddr + newsize; 
	int tempPages = currproc->allAddresses[mappedIndex].numberOfPages;

	currproc->allAddresses[mappedIndex].endingVirtualAddr = required_end_addr;
	currproc->allAddresses[mappedIndex].numberOfPages = (PGROUNDUP(newsize)) / 4096;
	if(isShrinking == 1){
		removeMapping(currproc->pgdir, required_end_addr, tempPages - currproc->allAddresses[mappedIndex].numberOfPages, 1);
		if(oldEndAddr){}
		/*for(uint i=required_end_addr; i < oldEndAddr; i+=PGSIZE){
			wunMap(i, 1);
		}*/
	}
}

uint allocateAdditionalPages(struct proc *currproc, uint oldStartingAddr, int addition, int oldIndex) {
    int pagesNeeded = (PGROUNDUP(addition)) / PGSIZE;//store pagesNeeded

    //iterate through the virtual address space to find the first available address space
	for(int i=0; i< NELEM(currproc->allAddresses); i++){
		//if [i=0] is 0 -> this will never happen because then it wouldve remapped in place
		//if i=15 (means that array is fully mapped) || if [i] is mapped and [i+1] is 0
		int availableLength = 0; //reset to 0 every iteration of loop
		if(i == 15 || currproc->allAddresses[i+1].startingVirtualAddr == 0){
			availableLength = KERNBASE - currproc->allAddresses[i].endingVirtualAddr - (2*PGSIZE);
		}else{
			//if [i] is mapped and [i+1] is mapped
			availableLength =  currproc->allAddresses[i+1].startingVirtualAddr - currproc->allAddresses[i].endingVirtualAddr - (2*PGSIZE);
		}
		int availablePages = (PGROUNDUP(availableLength)) / PGSIZE;
		if(availablePages >= pagesNeeded){
			//found location to put map
			//store starting and ending address
			uint startingAddr = currproc->allAddresses[i].endingVirtualAddr + (1*PGSIZE);
			uint endingAddr = startingAddr + addition;
			int isPrivate = currproc->allAddresses[i].isPrivate;
			int isAnonymous = currproc->allAddresses[i].isAnonymous;
			struct file* fd = currproc->allAddresses[i].fd;
			int length = currproc->allAddresses[i].length + addition;
			//currproc->allAddresses[i].startingVirtualAddr
			//NELEM(currproc->allAddresses)
			//how to keep pa and correspond those to the new
			for(int j = 0; j < NELEM(currproc->allAddresses); j++){
				if(currproc->allAddresses[oldIndex].forFork[j] != 0){
					if(mappages(myproc()->pgdir, (char*) startingAddr + j*PGSIZE, PGSIZE, currproc->allAddresses[oldIndex].forFork[j], PTE_W | PTE_U) < 0){ // The actual mapping of the pages
						cprintf("mappages() not working\n");
						myproc()->killed = 1;
						return FAILED;
					}
				}
			}
			//unmap oldIndex
			wunMap(oldStartingAddr, 0);
			//call addAddress which will order this address in the correct location
			addAddress(startingAddr, endingAddr, pagesNeeded, isPrivate, isAnonymous, fd, length);
			return startingAddr;
		}
	}

	//space not found
    return FAILED;
}

uint sys_wremap(void){
	uint oldaddr;
    int oldsize, newsize, flags;
	uint resultStartingAddr = FAILED;
	
	
    // Extract arguments from syscall
    if (argint(0, (int*)&oldaddr) < 0 || argint(1, &oldsize) < 0 || argint(2, &newsize) < 0 || argint(3, &flags) < 0){
        cprintf("failed arguments");
		return FAILED;
	}
	
    // Validate inputs, e.g., page alignment, size > 0
    if (oldaddr % PGSIZE != 0 || newsize <= 0){
		cprintf("invalid inputs: oldaddr / PGSIZE = %x && newsize = %d", oldaddr % PGSIZE, newsize);
		return FAILED;
	}

    //wremap logic here
    // 1. Check if oldaddr and oldsize match an existing mapping
	struct proc *currproc = myproc();
	int mappedIndex = -1;
	for (int i = 0; i < NELEM(currproc->allAddresses); i++) {
		//uint currprocSize = currproc->allAddresses[i].endingVirtualAddr - currproc->allAddresses[i].startingVirtualAddr;
		//cprintf("INDEX: %d currproc->allAddresses[i].startingVirtualAddr: %x oldaddr: %x\n", i, currproc->allAddresses[i].startingVirtualAddr, oldaddr);
		if (currproc->allAddresses[i].startingVirtualAddr == oldaddr) {
			mappedIndex = i;
			break;
		}
	}
	if (mappedIndex == -1) return FAILED; // No matching mapping found

	uint oldEndAddr = currproc->allAddresses[mappedIndex].endingVirtualAddr;

    // 2. Attempt in-place resize if flags == 0
	if (flags == 0 && newsize > oldsize) {
		//check if space after oldaddr is free for newsize
		if (isAdjacentSpaceFree(currproc, oldaddr, newsize, mappedIndex) == -1) {
			return FAILED;// if space is not available, and flags do not allow moving, fail
		}
		//resize the mapping in place
		//update page table and allAddresses as necessary
		resizeMappingInPlace(currproc, oldaddr, newsize, mappedIndex, 0, oldEndAddr);
		resultStartingAddr = oldaddr;
		
		// Successful in-place resize
	}else if (flags == 0 && newsize < oldsize){//shrink
		resizeMappingInPlace(currproc, oldaddr, newsize, mappedIndex, 1, oldEndAddr);
		resultStartingAddr = oldaddr;
	}


    // 3. If in-place resize fails and MREMAP_MAYMOVE is set, attempt to move
	if ((flags & MREMAP_MAYMOVE) && newsize > oldsize) {
		//allocate additional pages and update the mapping's end address
		if(isAdjacentSpaceFree(currproc, oldaddr, newsize, mappedIndex) == -1) {
			resultStartingAddr = allocateAdditionalPages(currproc, oldaddr, newsize, mappedIndex);
		}else{
			resizeMappingInPlace(currproc, oldaddr, newsize, mappedIndex, 0, oldEndAddr);
			resultStartingAddr = oldaddr;
		}
        
	}else if((flags & MREMAP_MAYMOVE) && newsize < oldsize){//shrinking
		//deallocate pages and update the mapping's end address
		resizeMappingInPlace(currproc, oldaddr, newsize, mappedIndex, 1, oldEndAddr);
		resultStartingAddr = oldaddr;
	}

	return resultStartingAddr;
}

int sys_getwmapinfo(void){
	struct wmapinfo *wminfo;
    struct proc *currproc = myproc();
	int count = 0;
	
	//check if arg is a pointer to wmapinfo struct from user space
    if(argptr(0, (void*)&wminfo, sizeof(*wminfo)) < 0){
		return FAILED;
	}

    for (int i = 0; i < MAX_WMMAP_INFO && i < NELEM(currproc->allAddresses); i++) {
        if (currproc->allAddresses[i].startingVirtualAddr >= 0x60000000 && currproc->allAddresses[i].endingVirtualAddr <= 0x80000000) { //check that this is a mapped index
            wminfo->addr[count] = currproc->allAddresses[i].startingVirtualAddr;//starting addr of mapping
            wminfo->length[count] = currproc->allAddresses[i].endingVirtualAddr - currproc->allAddresses[i].startingVirtualAddr;//size of mapping
            wminfo->n_loaded_pages[count] = currproc->allAddresses[i].physicalPageNumber;//count how many page loaded
            count++;
        }
    }
    wminfo->total_mmaps = count; //total num of wmap regions
    return SUCCESS;
}

int sys_getpgdirinfo(void){
	struct proc *currproc = myproc();
	pde_t *pgdir = currproc->pgdir;
	int count = 0;
	struct pgdirinfo *pginfo;
	int inChar = 0;

	if(argptr(0, (void*)&pginfo, sizeof(*pginfo)) < 0)
		return FAILED;

	pte_t *pte;
	uint a = 0;
	
	for(;a < KERNBASE; a=PGROUNDDOWN(a+PGSIZE)){
		pte = (pte_t*)walkpgdir(pgdir, (char*)a, 0);
		
		if (!pte){
            continue; // no entry, move to next page			            
		}
		
		if((*pte & PTE_P) && (*pte & PTE_U)){
			count++;
			pginfo->va[count] = 0;
			pginfo->pa[count] = 0;
			uint pa = PTE_ADDR(*pte);
			if(a >= 0x60000000 && a <= 0x80000000){
				pginfo->va[inChar] = a;
				pginfo->pa[inChar] = pa;
				inChar++;
			}
		}
	}
	
	pginfo->n_upages = count;
	return SUCCESS;
}
