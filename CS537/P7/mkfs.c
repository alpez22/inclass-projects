#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <assert.h>
#include <dirent.h>
#include <stdbool.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include "wfs.h"

#define BLOCK_OFFSET 32

struct wfs_sb sb;

void createSuperBlock(int inodeCount, int blockCount, char *mem){
  sb.num_inodes = inodeCount;
  sb.num_data_blocks = blockCount;
  sb.i_bitmap_ptr = sizeof(sb);
  sb.d_bitmap_ptr = sb.i_bitmap_ptr + inodeCount / 8;
  sb.i_blocks_ptr = sb.d_bitmap_ptr + blockCount / 8;
  sb.d_blocks_ptr = sb.i_blocks_ptr + BLOCK_SIZE*inodeCount;

  memmove(mem, &sb, sizeof(sb));
}

int getBit(off_t offset, int bitNum, char *mem){
	int index = bitNum/8;
	int bitIndex = 7 - (bitNum % 8);
	unsigned char tempMask = 1 << bitIndex;
	return (mem[offset+index] & tempMask) != 0;
}

void setBit(off_t offset, int bitNum, int newValue, char *mem){
	int index = bitNum / 8;
	int bitIndex = 7 - (bitNum%8);
	unsigned char tempMask = 1 << bitIndex;
	if(newValue){
			mem[offset + index] |= tempMask;
	}
	else{
		mem[offset + index] &= ~tempMask;
	}
}

int getInodeNum(struct wfs_sb sb, char *mem){
	for(int i=0; i<(int)sb.num_inodes; i++){
		if(getBit(sb.i_bitmap_ptr, i, mem) == 0){
			return i;
		}
	}
	return -1;
}

int main(int argc, char *argv[]){
  char diskPath[MAX_NAME];
  int inodeCount = 0;
  int blockCount = 0;
  int tempBlockCount = 0;
  int fd;

  if(argc != 7)
    return 1;

  for (int i = 1; i < argc; i++) {
    if (strcmp(argv[i], "-d") == 0) {
      strcpy(diskPath, argv[i + 1]);
      i++;
    } else if (strcmp(argv[i], "-i") == 0) {
      inodeCount = atoi(argv[i + 1]);

      if((tempBlockCount = inodeCount % BLOCK_OFFSET) != 0){
	inodeCount += (BLOCK_OFFSET - tempBlockCount);
      }
      i++;
    } else if (strcmp(argv[i], "-b") == 0) {
      blockCount = atoi(argv[i + 1]);

      if((tempBlockCount = blockCount % BLOCK_OFFSET) != 0){
	blockCount += (BLOCK_OFFSET - tempBlockCount);
      }
      i++;
    } else {
      printf("Unknown option: %s\n", argv[i]);
      return 1;
    }
  }

  fd = open(diskPath, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH);
  if(fd < 0){
    perror("open");
    return 1;
  }
  struct stat st;
  fstat(fd, &st);
  int tempSize = st.st_size;
  char *mem = mmap(NULL, tempSize, PROT_WRITE | PROT_READ, MAP_SHARED, fd, 0);

  if(mem == (void*) - 1){
    perror("mmap");
    return 1;
  }

  memset(mem, 0, tempSize);
  close(fd);

  createSuperBlock(inodeCount, blockCount, mem);
  if(sb.d_blocks_ptr+BLOCK_SIZE*blockCount+BLOCK_SIZE > tempSize){
    return 1;
  }

  struct wfs_inode tempInode;
  tempInode.num = 0;
  tempInode.mode = S_IFDIR;
  tempInode.uid = getuid();
  tempInode.gid = getgid();
  tempInode.size = 0;
  tempInode.nlinks = 1;
  tempInode.atim = time(NULL);
  tempInode.mtim = time(NULL);
  tempInode.ctim = time(NULL);
  for(int i=0; i<IND_BLOCK; i++){
  	tempInode.blocks[i] = 0;
  }

  int tempInodeNum = getInodeNum(sb, mem);
  setBit(sb.i_bitmap_ptr, tempInodeNum, 1, mem);
  //mem[offset+index] = 1;
	memcpy(mem+sb.i_blocks_ptr, &tempInode, sizeof(struct wfs_inode));

  return 0;
}
