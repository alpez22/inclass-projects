#include "types.h"
#include "user.h"
#include "wmap.h"

int main(int argc, char *argv[]) {
    struct wmapinfo wminfo;
    int result;
    int length1 = 4096;
    //int length2 = 8192;
    //int length3 = 24576;
    int flags = MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS; //default
    int fd = -1; //the mapping is not backed by a file

    // uint addr3 = wmap(0x70020000, length3, flags, fd);
    // if (addr3 == (uint)-1) {
    //     printf(1, "wmap failed\n");
    //     exit();
    // }
    // uint addr2 = wmap(0x70000000, length2, flags, fd);
    // if (addr2 == (uint)-1) {
    //     printf(1, "wmap failed\n");
    //     exit();
    // }
    // uint addr4 = wmap(0x60005000, length2, flags, fd);
    // if (addr4 == (uint)-1) {
    //     printf(1, "wmap failed\n");
    //     exit();
    // }
    // uint addr5 = wmap(0x60014000, length2, flags, fd);
    // if (addr5 == (uint)-1) {
    //     printf(1, "wmap failed\n");
    //     exit();
    // }
    // uint addr6 = wmap(0x70100000, length1, flags, fd);
    // if (addr6 == (uint)-1) {
    //     printf(1, "wmap failed\n");
    //     exit();
    // }
    // uint addr = wmap(0x60000000, length1, flags, fd);
    // if (addr == (uint)-1) {
    //     printf(1, "wmap failed\n");
    //     exit();
    // }

    uint addr3 = wmap(0x6000a000, length1*10, flags, fd);
    if (addr3 == (uint)-1) {
        printf(1, "wmap failed\n");
        exit();
    }
    uint addr2 = wmap(0x60000000, length1*10, flags, fd);
    if (addr2 == (uint)-1) {
        printf(1, "wmap failed\n");
        exit();
    }
    
    //attempt to retrieve the memory mapping information
    result = getwmapinfo(&wminfo);

    if (result == FAILED) {
        printf(1, "getwmapinfo failed\n");
        exit();
    }

    printf(1, "Total memory mappings: %d\n", wminfo.total_mmaps);

    for (int i = 0; i < wminfo.total_mmaps; i++) {
        printf(1, "Mapping %d: Addr 0x%x, Length %d, Loaded Pages %d\n",
               i, wminfo.addr[i], wminfo.length[i], wminfo.n_loaded_pages[i]);
    }

    exit();
}
