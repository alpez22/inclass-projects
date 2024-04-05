#include "types.h"
#include "user.h"
#include "wmap.h"

int main(void) {
    int length1 = 4096;
    // struct wmapinfo wminfo;
    //int result;
    //int length2 = 8192;
    //int length3 = 24576;
    int flags = MAP_FIXED | MAP_ANONYMOUS; //default
    int fd = -1; //the mapping is not backed by a file

    //uint addr1;
    uint addr2;
    //uint addr3;

    //use wmap to map a page
    // addr1 = wmap(0x6000a000, length1*10, flags, fd);
    // if (addr1 == (uint)-1) {
    //     printf(1, "wmap failed\n");
    //     exit();
    // }
    addr2 = wmap(0x60002000, length1*5, flags, fd);
    if (addr2 == (uint)-1) {
        printf(1, "wmap failed\n");
        exit();
    }

    //this should go now to the end of the mapping
    uint addr = 0x60000000;
    int oldsize = length1*5;
    int newsize = length1*1;
    int flag = MREMAP_MAYMOVE;

    char *arr = (char *)addr;
    int value = 'y';
    for (int i = 0; i < length1 * 3; i++)
        arr[i] = value;

    uint newaddr = wremap(addr, oldsize, newsize, flag);
    if (newaddr == (uint) -1) {
        printf(1, "wremap failed\n");
    } else {
        printf(1, "wremap succeeded, new address: 0x%x\n", newaddr);
    }

    // getwmapinfo(&wminfo);
    // for (int i = 0; i < wminfo.total_mmaps; i++) {
    //     printf(1, "Mapping %d: Addr 0x%x, Length %d, Loaded Pages %d\n",
    //            i, wminfo.addr[i], wminfo.length[i], wminfo.n_loaded_pages[i]);
    // }

    exit();
}
