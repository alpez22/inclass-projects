#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char *argv[]) {
    uint addr;
    int length = 4096; //1 page
    int flags = MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS; //default
    int fd = -1; //the mapping is not backed by a file

    //use wmap to map a page
    addr = wmap(0x70000000, length, flags, fd);
    if (addr == (uint)-1) {
        printf(1, "wmap failed\n");
        exit();
    }

    //write to the memory to confirm it's mapped
    char *test_addr = (char *)addr;
    *test_addr = 'A';

    //verify the write
    if (*test_addr != 'A') {
        printf(1, "Memory write after wmap failed\n");
        exit();
    } else {
        printf(1, "Memory write after wmap succeeded\n");
    }

    //wunmap addr
    if (wunmap(addr) != SUCCESS) {
        printf(1, "memory unmapping failed\n");
        exit();
    }

    //try to access the memory after unmapping
    //should cause an error if unmapping worked
    //printf(1, "%c\n", *test_addr);

    // if (*test_addr == 'A') {
    //     printf(1, "Memory access after wunmap unexpectedly succeeded\n");
    // } else {
    //     printf(1, "Memory access after wunmap failed as expected\n");
    // }

    exit();
}

