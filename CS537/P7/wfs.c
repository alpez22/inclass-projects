#define FUSE_USE_VERSION 30
#include <fuse.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <stdbool.h>
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

#define ROOT_INODE_NUM 2

//extern FILE *disk;
struct wfs_sb superblock;
unsigned char *inode_bitmap;
unsigned char *data_block_bitmap;
char fileName[28];

char *diskImage = NULL;
struct wfs_sb *superBlock;

// callback functions
int load_superblock(struct wfs_sb *sb);
unsigned char *load_bitmap(off_t start, size_t size);
static int wfs_getattr(const char *path, struct stat *stbuf);
static int wfs_mknod(const char *path, mode_t mode, dev_t rdev);
static int wfs_mkdir(const char *path, mode_t mode);
static int wfs_unlink(const char *path);
static int wfs_rmdir(const char *path);
static int wfs_read(const char *path, char *buf, size_t size, off_t offset, struct fuse_file_info *fi);
static int wfs_write(const char *path, const char *buf, size_t size, off_t offset, struct fuse_file_info *fi);
static int wfs_readdir(const char *path, void *buf, fuse_fill_dir_t filler, off_t offset, struct fuse_file_info *fi);

// FUSE operations structure
static struct fuse_operations ops = {
  .getattr = wfs_getattr,
  .mknod   = wfs_mknod,
  .mkdir   = wfs_mkdir,
  .unlink  = wfs_unlink,
  .rmdir   = wfs_rmdir,
  .read    = wfs_read,
  .write   = wfs_write,
  .readdir = wfs_readdir,
};


// Main function with init
void InitFileSystem(char * fileName){
    //open file for read/write
	int fd = open(fileName, O_RDWR);
	if (fd < 0){
        perror("fd threw an error with open");
    }
    //populate stbuf with fd info including stat size
	struct stat stbuf;
	fstat(fd, &stbuf);
	int diskSize = stbuf.st_size;

    //maps the entire file specified by the file descriptor fd into memory.
    //changes to the mapping are shared back to the file and with other processes mapping the same file
	char * mem = mmap(NULL, diskSize, PROT_WRITE | PROT_READ, MAP_SHARED, fd, 0);
	close(fd);
    //stores the address of the memory-mapped file in diskImage
	diskImage = mem;
    //Casts the memory address to a pointer of type struct wfs_sb ; beginning of map is superblock
	superBlock = (struct wfs_sb *)mem;
	
}
int main (int argc, char *argv[]){
	//argv[1] = disk path
    //arg
    InitFileSystem(argv[1]);
    //shift over for [FUSE options] mount_point
	
	for(int i=1; i<argc; i++){
		if(i+1<argc)
			argv[i] = argv[i+1];
	}
		
	argv[argc-1] = NULL;
	argc--;
	return fuse_main(argc, argv, &ops, NULL);
}

int getBit(off_t offset, int bitNum, char *mem){
  int index = bitNum/8;
  int bitIndex = 7 - (bitNum % 8);
  unsigned char tempMask = 1 << bitIndex;
  //printf("HERE: %d\n", mem[offset+index]);
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

int getDblockNum(struct wfs_sb sb, char *mem){
  for(int i=0; i<(int)sb.num_data_blocks; i++){
    if(getBit(sb.d_bitmap_ptr, i, mem) == 0){
      return i;
    }
  }
  return -1;
}

/*
static char* getParentPath(const char *path, char *name){
  char *token, *str = strdup(path);
  char *parentPath = NULL;
  parentPath = malloc(sizeof(str));
  char tempStr[28];
  token = strtok(str, "/");
  int madeIt = 0;

  while (token != NULL) {
    strcpy(tempStr, token);
    if((token = strtok(NULL, "/")) != NULL){
      strncat(parentPath, tempStr, sizeof(str));
      madeIt = 1;
    }
    else{
      strcpy(name, tempStr);
    }
  }

  if(madeIt == 0)
    strcpy(parentPath, "/");
  return parentPath;
}
*/
/*
struct wfs_inode* update_inode_access_time(int numInode, char **nextToken, const char *delimitor) {
    //calculate the bit position and the byte in the inode bitmap
    unsigned char bitcheck = 0x80 >> (numInode % 8);
    unsigned int *valid_bit_loc = (unsigned int *)(diskImage + numInode / 8 + superBlock->i_bitmap_ptr);

    //check if the bit is set (inode is valid)
    if (!(bitcheck & *valid_bit_loc)) {
        fprintf(stderr, "Inode %d is not valid\n", numInode);
        return NULL;
    }

    //get the inode from the disk image
    struct wfs_inode *inode = (struct wfs_inode *)(diskImage + superBlock->i_blocks_ptr + numInode * sizeof(struct wfs_inode));

    //update the access time of the inode
    inode->atim = time(NULL);

    //continue tokenizing the string if nextToken and delimitor are provided
    if (nextToken && delimitor) {
        *nextToken = strtok(NULL, delimitor);
    }
    return inode;
}
*/

// Load the inode corresponding to the path for wfs_getattr
static int find_inode_ava(const char *path, struct wfs_inode **inode) {
	printf("PATH: %s", path);
    char delimitor = '/';
	int numInode = 0;
	int found = 0;
	struct wfs_dentry *dir;
	char * pathTemp = (char*)malloc((strlen(path)+1)*sizeof(char));
	strcpy(pathTemp, path);
	char *token = strtok(pathTemp, &delimitor);
    *inode = (struct wfs_inode*)(diskImage + superBlock->i_blocks_ptr);

	(*inode)->atim = time(NULL);
	
	if (token == NULL){
		free(pathTemp);
		return 0;
	}

	if (strcmp(token, "")==0 || strcmp(token, ".")==0){
		token = strtok(NULL, &delimitor);
	}

    // Start from root inode assuming root is at index 0
    // *inode = update_inode_access_time(0, &token, &delimitor);  // Update root inode access time
    // if (!*inode) {
    //     free(pathTemp);
    //     return -1; // Inode validation failed at root
    // }

	while(token != NULL){
		if ((*inode)->mode == S_IFDIR){ 
			found = 0;
			for (int i = 0; i< IND_BLOCK; i++){
				for (int j = 0; j<BLOCK_SIZE; j+= 32){
					off_t data_loc = (off_t)diskImage + superBlock->d_blocks_ptr + (* inode)->blocks[i] * BLOCK_SIZE + j;
					dir = (struct wfs_dentry*) data_loc;
					if (strcmp(dir->name, token) == 0){
						numInode = dir->num;
						found = 1;
						break;
					}
				}
				if (found == 1){
                    break;
                }
			}

			if (found == 0){
				free(pathTemp);
				printf("HERE: 2\n");
				return -1;
			}
		} 
		/*else if((*inode)->mode == 16832){
			found = 0;
			for (int i = 0; i< IND_BLOCK; i++){
				for (int j = 0; j<BLOCK_SIZE; j+= 32){
					off_t data_loc = (off_t)diskImage + superBlock->d_blocks_ptr + (* inode)->blocks[i] * BLOCK_SIZE + j;
					dir = (struct wfs_dentry*) data_loc;
					if (dir->num != 0 && strcmp(dir->name, token) == 0){
						numInode = dir->num;
						found = 1;
						break;
					}
				}
				if (found == 1){
                    break;
                }
			}

			if (found == 0){
				free(pathTemp);
				return -1;
			}
		}*/
		else {
			free(pathTemp);
			printf("HERE: 3\n");
			return -1;
		}

        //calculate the bit position and the byte in the inode bitmap
        unsigned char inodeBitMask = 0x80 >> (numInode % 8);
        unsigned int * inodeBitmapEntry = (unsigned int *)(diskImage + numInode / 8 + superBlock->i_bitmap_ptr);

        //check if the bit is set (inode is valid)
        if (!(inodeBitMask & *inodeBitmapEntry)) {
            fprintf(stderr, "Inode %d is not valid\n", numInode);
            return -1;
        }

        //get the inode from the disk image
        *inode = (struct wfs_inode *)(diskImage + superBlock->i_blocks_ptr + numInode * BLOCK_SIZE);

        //update the access time of the inode
        (*inode)->atim = time(NULL);

		token = strtok(NULL, &delimitor);

	}
	free(pathTemp);
	return 0;
}

// Implementation of getattr function to retrieve file attributes
// Fill stbuf structure with the attributes of the file/directory indicated by path

static int wfs_getattr(const char *path, struct stat *stbuf) {
	printf("HELLO 1\n");
    
    struct wfs_inode * inode = NULL;
    // char * pathTemp = (char*)malloc((strlen(path)+1)*sizeof(char));
	// strcpy(pathTemp, path);
    // char delim = '/';
	// char * pathTokenized = strtok(pathTemp, &delim);

	// (inode)->atim = time(NULL);
	
	// if (pathTokenized == NULL){
	// 	free(pathTemp);
	// 	return 0;
	// }else{//not root
    //     if (find_inode_ava(pathTemp, &inode) == -1){
	// 	    return -ENOENT;
	//     }
    // }

    if (find_inode_ava(path, &inode) == -1){
        return -ENOENT;
    }
    
    /* Time of last access */
	inode->atim = time(NULL); 
    //set statbuf
	stbuf->st_uid = inode->uid;
	stbuf->st_gid = inode->gid;
	stbuf->st_atime = inode->atim;
	stbuf->st_mtime = inode->mtim;
	stbuf->st_mode = inode->mode;
	stbuf->st_size = inode->size;
	return 0;
}


// Load the inode corresponding to the path for wfs_getattr
/*
static int find_inode(const char *path, struct wfs_inode *inode, char* mem, struct wfs_sb *sb, off_t *offset) {
    
    //calculate the address of the root inode directly in the mapped memory
    struct wfs_inode *inodes = (struct wfs_inode *)(mem + sb->i_blocks_ptr);
    
    //start at the root inode
    struct wfs_inode *current_inode = inodes;

	if(strcmp("/", path) == 0){
		if(offset != NULL)
			*offset = (off_t)(mem + sb->i_blocks_ptr);
		memcpy(inode, current_inode, sizeof(struct wfs_inode));
		return 0;    	
	}

    //split and traverse the path
    char *token, *str = strdup(path);
    token = strtok(str, "/");
    while (token != NULL) {
        bool found = false;

        //iterate over each block that may contain directory entries
        for (int blockIndex = 0; blockIndex < N_BLOCKS && !found && current_inode->blocks[blockIndex] != 0; blockIndex++) {
            struct wfs_dentry *dentries = (struct wfs_dentry *)(mem + current_inode->blocks[blockIndex] * BLOCK_SIZE);

            // Assuming a fixed number of entries per block
            int entriesPerBlock = BLOCK_SIZE / sizeof(struct wfs_dentry);
            for (int i = 0; i < entriesPerBlock && !found; i++) {
                if (strcmp(dentries[i].name, token) == 0) {
                    // Read the inode for the found directory entry
                    current_inode = &inodes[dentries[i].num - 1];
                    found = true;
                }
            }
        }

        // struct wfs_dentry *dentries = (struct wfs_dentry *)(diskmap + current_inode->blocks[0] * BLOCK_SIZE); // assuming single block directory for simplicity

        // //iterate over directory entries from just the single directory blocks[0]
        // for (int i = 0; i < current_inode->nlinks && !found; i++) {
        //     if (strcmp(dentries[i].name, token) == 0) {
        //         current_inode = &inodes[dentries[i].num - 1];
        //         found = true;
        //     }
        // }

        if (!found) {
            free(str);
            return -ENOENT;
        }

        token = strtok(NULL, "/");
    }

    memcpy(inode, current_inode, sizeof(struct wfs_inode));
    free(str);
    return 0;
}

// Implementation of getattr function to retrieve file attributes
// Fill stbuf structure with the attributes of the file/directory indicated by path

static int wfs_getattr_jaxon(const char *path, struct stat *stbuf) {
	printf("HELLO-2\n");
	int fd = open(fileName, O_RDWR | O_CREAT, S_IRUSR | S_IWUSR | S_IRGRP | S_IWGRP | S_IROTH | S_IWOTH);
	if(fd < 0){
		perror("open");
		return 1;
	}
	struct stat st;
	stat(fileName, &st);
	int tempSize = st.st_size;
	char *mem = mmap(NULL, tempSize, PROT_WRITE | PROT_READ, MAP_SHARED, fd, 0);

	if(mem == (void*) - 1){
		perror("mmap");
		return 1;
	}
	close(fd);
	struct wfs_sb *sb = (struct wfs_sb *)mem;
	
    int res = 0;
    //struct wfs_sb sb;
    struct wfs_inode inode;

    //clear the stat buffer
    memset(stbuf, 0, sizeof(struct stat));
    
    //load the inode corresponding to the path
    res = find_inode(path, &inode, mem, sb, NULL);
    if (res != 0) {
    	munmap(mem, tempSize);
        return res; //return error if the file/directory is not found
    }
    
    //fill in the stat structure with information from the inode
    //inode.num ?
    struct stat tempST;
    tempST.st_dev = 0;
    tempST.st_ino = inode.num;
    tempST.st_mode = inode.mode;
    tempST.st_uid = inode.uid;
    tempST.st_size = inode.size;
    tempST.st_nlink = inode.nlinks;
    tempST.st_atime = inode.atim;
    tempST.st_ctime = inode.ctim;
    tempST.st_blksize = BLOCK_SIZE;
    tempST.st_blocks = inode.size / BLOCK_SIZE;
    *stbuf = tempST;
    munmap(mem, tempSize);
    return 0;
}
*/

// Helper function to read a block from disk... block size is defined
/*int read_block(int block_num, char *buf, size_t size, off_t block_offset) {
    off_t offset = superblock.d_blocks_ptr + block_num * BLOCK_SIZE + block_offset;
    fseek(disk, offset, SEEK_SET);
    if (fread(buf, 1, size, disk) != size) {
        perror("Read error");
        return -EIO;
    }
    return 0;
    }*/

static int wfs_mknod(const char* path, mode_t mode, dev_t dev){
	printf("HELLO 2\n");

	char * pathTemp = malloc((strlen(path)+1)*sizeof(char));
	strcpy(pathTemp, path);

    unsigned int currBitsInode;
	unsigned int bitInode;
	int numInode = 0;
	off_t countInode = 0;
    unsigned int * inodeBitmapPtr = (unsigned int *)(diskImage + superBlock->i_bitmap_ptr);
    int isInodeAlloc = -1;
    int isDAlloc = -1;
    unsigned int currBitsD;
	unsigned int bitD;
	off_t count = 0;
    int numDBlock = 0;

    struct wfs_inode *inode = NULL;
	if (find_inode_ava(pathTemp, &inode)!=-1){
		free(pathTemp);
		return -EEXIST;
	}

    while(countInode<superBlock->num_inodes){ //runs as long as countInode, which tracks the number of checked inodes, is less than the total number of inodes (superBlock->num_inodes) in the filesystem
		//inodeBitmapPtr is a pointer to the current byte in the inode bitmap. currBitsInode
        currBitsInode = *inodeBitmapPtr;
		bitInode = 0x80; //bitInode starts as 0x80 (binary 10000000), and in each iteration of the for loop, it is right-shifted to check the next bit in currBitsInode.
		
        /*The if statement checks if the current bit in currBitsInode is 0 (using bitInode & currBitsInode). 
        If it is, the bit is set to 1 (currBitsInode | bitInode), indicating the inode is now allocated. 
        The loop then breaks as a free inode has been found and allocated. numInode and countInode are incremented
        to keep track of the overall inode count and the position within the bitmap.*/

        for (int i =0; i < 8; i++){
			if (!(bitInode & currBitsInode)){
				*inodeBitmapPtr = currBitsInode | bitInode;
				isInodeAlloc = 0;
                break;
			}
			bitInode >>= 1;
			numInode++;
			countInode++;
		}
        if(isInodeAlloc == 0){ //After processing each byte (8 bits), if an inode was allocated (isInodeAlloc == 0), the outer loop is exited.
            break;
        }
		inodeBitmapPtr++;
	}

    //no free inode was found
    if (isInodeAlloc == -1){
        free(pathTemp);
        return -ENOSPC;
    }

	// int inode_num;
    // if ((inode_num = alloc_inode()) == -1){
    //         free(path_copy);
    //         printf("ERROR: Failed to allocated inode\n");
    //         return -ENOSPC;
    // }

	inode = (struct wfs_inode*)(diskImage + superBlock->i_blocks_ptr + numInode*BLOCK_SIZE);
	inode->num = numInode;
	inode->mode = mode;
	inode->uid = getuid();
	inode->gid = getgid();
	inode->size = 0;
	inode->nlinks = 1;
	inode->atim = time(NULL);
	inode->mtim = time(NULL);
	inode->ctim = time(NULL);

    //fileName pointer to point to the last character of pathTemp before the null terminator.
	char * fileName = &pathTemp[strlen(path) - 1];

    //This loop decrements the fileName pointer until it finds the first '/' character when moving backward through the string. 
    while(*fileName != '/'){
            fileName--;
    }
    //This line replaces the '/' found by the previous loop with a null terminator ('\0').
    *fileName = '\0';
    //fileName is incremented to point to the first character of the filename or the last directory segment that follows the last '/'
    fileName++;


    struct wfs_inode *parent = NULL;
    if (find_inode_ava(pathTemp, &parent) == -1){
		free(pathTemp);
		return -ENOENT;
	}

	struct wfs_dentry *dentry;

	if (parent->size >= BLOCK_SIZE*7){
		free(pathTemp);
		return -ENOSPC;
	} else if (parent->size % BLOCK_SIZE == 0){

        //alloc d block
        unsigned int *ptr = (unsigned int*)(diskImage + superBlock->d_bitmap_ptr);
        while(count<superBlock->num_data_blocks){
            currBitsD = *ptr;
            bitD = 0x80;
            for (int i = 0; i < 8; i++){
                if (!(bitD & currBitsD)){
                    *ptr = currBitsD | bitD;
                    isDAlloc = 0;
                    break;
                }
                numDBlock++;
                bitD >>= 1;
                count++;
            }
            if(isDAlloc == 0){
                break;
            }
            ptr++;
        }

		if (isDAlloc == -1){
			free(pathTemp);
			return -ENOSPC;
		}
        //assigns the block number numDBlock to the appropriate index in the parent directory's blocks array. 
		parent->blocks[parent->size/BLOCK_SIZE] = numDBlock;
        //dentry is set to point to the location within the memory-mapped disk image where the new directory entry should be written. 
		dentry = (struct wfs_dentry*)(diskImage + superBlock->d_blocks_ptr + numDBlock*BLOCK_SIZE);
		strcpy(dentry->name, fileName);
		dentry->num = numInode;
        //each directory entry occupies 32 bytes
		parent->size += 32;
	} else {
		off_t blockOffset = parent->size % BLOCK_SIZE;
        //index of the block within the parent->blocks array where the new entry should be placed
		int blockInsert = parent->size / BLOCK_SIZE;
        //memory address of the block where the new directory entry will be inserted
		off_t blockStart = (off_t)diskImage + parent->blocks[blockInsert]*BLOCK_SIZE + superBlock->d_blocks_ptr;
        //point to the position within the block where the new directory entry will start
		dentry = (struct wfs_dentry*)(blockStart + blockOffset);
		strcpy(dentry->name, fileName);
		dentry->num = numInode;
        //each directory entry occupies 32 bytes
		parent->size += 32;
	}
	free(pathTemp);
	return 0;
}

static int wfs_unlink(const char *path) {
	printf("HELLO 6\n");
	unsigned int currBitsInode;
	unsigned int bitInode;
	int numInode = 0;
	off_t countInode = 0;
    unsigned int * inodeBitmapPtr = (unsigned int *)(diskImage + superBlock->i_bitmap_ptr);
    int isInodeAlloc = -1;
    int isDAlloc = -1;
    unsigned int currBitsD;
	unsigned int bitD;
	off_t count = 0;
    int numDBlock = 0;
	char * pathTemp = malloc((strlen(path)+1)*sizeof(char));
	strcpy(pathTemp, path);
	// Free the data blocks of the file
	struct wfs_inode *inode = NULL;
	if (find_inode_ava(pathTemp, &inode)==-1){
		free(pathTemp);
		return -EEXIST;
	}
	for(int i=0; i<IND_BLOCK; i++){
		if(inode->blocks[i] == 0)
			continue;
		off_t data_loc = superBlock->d_blocks_ptr + inode->blocks[i]*BLOCK_SIZE;
		memset(diskImage + data_loc, 0, sizeof(BLOCK_SIZE));

		// Deallocate data block
		unsigned int *ptr = (unsigned int*)(diskImage + superBlock->d_bitmap_ptr);
        while(count<superBlock->num_data_blocks){
            currBitsD = *ptr;
            bitD = 0x80;
            for (int j = 0; j < 8; j++){
                if (numDBlock == i){
                    *ptr = currBitsD & ~bitD;
                    isDAlloc = 0;
                    break;
                }
                numDBlock++;
                bitD >>= 1;
                count++;
            }
            if(isDAlloc == 0){
                break;
            }
            ptr++;
        }

		if (isDAlloc == -1){
			free(pathTemp);
			return -ENOSPC;
		}
    }
	// Free its inode
	while(countInode<superBlock->num_inodes){ //runs as long as countInode, which tracks the number of checked inodes, is less than the total number of inodes (superBlock->num_inodes) in the filesystem
		//inodeBitmapPtr is a pointer to the current byte in the inode bitmap. currBitsInode
        currBitsInode = *inodeBitmapPtr;
		bitInode = 0x80; //bitInode starts as 0x80 (binary 10000000), and in each iteration of the for loop, it is right-shifted to check the next bit in currBitsInode.
		
        /*The if statement checks if the current bit in currBitsInode is 0 (using bitInode & currBitsInode). 
        If it is, the bit is set to 1 (currBitsInode | bitInode), indicating the inode is now allocated. 
        The loop then breaks as a free inode has been found and allocated. numInode and countInode are incremented
        to keep track of the overall inode count and the position within the bitmap.*/

        for (int i =0; i < 8; i++){
			if (countInode == inode->num){
				*inodeBitmapPtr = currBitsInode & ~bitInode;
				isInodeAlloc = 0;
                break;
			}
			bitInode >>= 1;
			numInode++;
			countInode++;
		}
        if(isInodeAlloc == 0){ //After processing each byte (8 bits), if an inode was allocated (isInodeAlloc == 0), the outer loop is exited.
            break;
        }
		inodeBitmapPtr++;
	}

    //no free inode was found
    if (isInodeAlloc == -1){
        free(pathTemp);
        return -ENOSPC;
    }
	off_t tempInodeNum = inode->num;
    memset(inode, 0, sizeof(BLOCK_SIZE));

	// Remove drenty from parent file
	char * fileName = &pathTemp[strlen(path) - 1];
	
    //This loop decrements the fileName pointer until it finds the first '/' character when moving backward through the string. 
    while(*fileName != '/'){
            fileName--;
    }
    //This line replaces the '/' found by the previous loop with a null terminator ('\0').
    *fileName = '\0';
    //fileName is incremented to point to the first character of the filename or the last directory segment that follows the last '/'
    fileName++;


    struct wfs_inode *parent = NULL;
    if (find_inode_ava(pathTemp, &parent) == -1){
		free(pathTemp);
		return -ENOENT;
	}

	struct wfs_dentry *dentry;

	for(int i=0; i<IND_BLOCK; i++){
		for(int j=0; j<BLOCK_SIZE; j+=BLOCK_SIZE/16){
			dentry = (struct wfs_dentry*)(diskImage + superBlock->d_blocks_ptr + numDBlock*i+j);
			if(tempInodeNum == dentry->num){
				break;
			}
		}
	}

	memset(dentry, 0, sizeof(struct wfs_dentry));
	parent->size -= 32;
    return 0;
}

static int wfs_rmdir(const char *path){
	printf("HELLO 7\n");
	return wfs_unlink(path);
}

// Function to find and allocate a free data block
off_t allocate_data_block() {
    unsigned int *ptr = (unsigned int *)(diskImage + superBlock->d_bitmap_ptr);
    int count = 0;
    int isDAlloc = -1;  // Indicates if a block has been allocated, -1 means no
    unsigned int currBitsD;
    unsigned int bitD;
    off_t numDBlock = 0;  // Start from the first block

    while (count < superBlock->num_data_blocks) {
        currBitsD = *ptr;  // Current group of bits in the bitmap (one uint)
        bitD = 0x80;  // Start with the highest bit in the byte

        for (int i = 0; i < 8 && count < superBlock->num_data_blocks; i++) {
            if (!(bitD & currBitsD)) {
                *ptr = currBitsD | bitD;  // Set the bit to mark the block as used
                isDAlloc = 0;  // Mark as allocated
                printf("%x\n", (uint)*ptr);
                break;
            }
            bitD >>= 1;  // Move to the next bit in the byte
            numDBlock++;  // Increment the block number
            count++;  // Increment the overall count of checked blocks
        }

        if (isDAlloc == 0) {
            break;  // Break if a block has been allocated
        }
        ptr++;// Move to the next integer in the bitmap
    }

    if (isDAlloc == -1) {
        return -1;  // No free block available
    }

    // Calculate the actual address of the block in the disk image
    off_t block_address = superBlock->d_blocks_ptr + numDBlock * BLOCK_SIZE;
    memset(diskImage + block_address, 0, BLOCK_SIZE);

    return numDBlock;  // Return the block number (not the address)
}
static int wfs_write(const char *path, const char *buf, size_t size, off_t offset, struct fuse_file_info *fi){
    struct wfs_inode *inode;

    // Find the inode based on the path
    if (find_inode_ava(path, &inode) != 0) {
    	printf("THIS IS THE FIRST ONE\n");
        return -ENOENT;  // File or directory does not exist
    }

	if(offset + size > inode->size)
    	inode->size = offset + size;

    size_t total_written = 0;

    off_t block_offset = offset % BLOCK_SIZE;
    off_t indirect_index;
    int isIndirect = 0;
    off_t tempBlockOffset = 0;
    while (size > 0) {
    	
        off_t block_index = offset / BLOCK_SIZE;
        tempBlockOffset = block_index;
        

        if(isIndirect == 1)
        	block_index = indirect_index;
        //printf("")
        printf("\nBLOCK INDEX: %d %d\n", (int)block_index, (int)tempBlockOffset);
        size_t bytes_in_block = BLOCK_SIZE - block_offset;
        size_t write_amount = (size < bytes_in_block) ? size : bytes_in_block;
        if (block_index < D_BLOCK && isIndirect == 0) {
        	//printf("HELLO 1\n");
            // Writing to direct blocks
            if (inode->blocks[block_index] == 0) {
            //printf("HELLO 2\n");
                // Allocate new block if necessary
                inode->blocks[block_index] = allocate_data_block();
               // printf("HELLO 3\n");
                if (inode->blocks[block_index] == 0) {
                    return -ENOSPC;  // Failed to allocate block
                }
                //printf("HELLO 4\n");
            }
            //printf("HELLO 5\n");
            char *dest = diskImage + superBlock->d_blocks_ptr + inode->blocks[block_index] * BLOCK_SIZE + block_offset;
            //printf("HELLO 6 %d\n", (int)block_offset);
            memcpy(dest, buf, write_amount);
            //printf("HELLO 7\n");
        } else if (block_index < IND_BLOCK) {
        	printf("HELLO IN HERE %d\n", (int)block_index);
            // Writing to indirect blocks
           
            indirect_index = tempBlockOffset - D_BLOCK;
            isIndirect = 1;
            printf("\nINDIRECT INDEX: %d\n", (int)indirect_index);
            off_t *indirect_block;
            printf("HELLO 1\n");
            if (inode->blocks[IND_BLOCK] == 0) {
            	printf("HELLO 2\n");
                inode->blocks[IND_BLOCK] = allocate_data_block();
                printf("HELLO 3\n");
                if (inode->blocks[IND_BLOCK] == 0) {
                	printf("HELLO 4\n");
                    return -ENOSPC;  // Failed to allocate indirect block
                }
                printf("HELLO 5\n");
                // Clear new indirect block
                memset(diskImage + inode->blocks[IND_BLOCK] * BLOCK_SIZE, 0, BLOCK_SIZE);
                printf("HELLO 6\n");
            }
            indirect_block = (off_t *)(diskImage + inode->blocks[IND_BLOCK] * BLOCK_SIZE + superBlock->d_blocks_ptr);
            printf("HELLO 7\n");
            if (indirect_block[indirect_index] == 0) {
            printf("HELLO 8\n");
                indirect_block[indirect_index] = allocate_data_block();
                printf("HELLO 9\n");
                if (indirect_block[indirect_index] == 0) {
                printf("HELLO 10\n");
                    return -ENOSPC;  // Failed to allocate block in indirect block
                }
            }
            printf("HELLO 11\n");
            char *dest = diskImage + indirect_block[indirect_index] * BLOCK_SIZE + block_offset;
            printf("HELLO 12\n");
            memcpy(dest, buf, write_amount);
            printf("HELLO 13\n");
            
        } else {
        	printf("HELLO 14 %d\n", (int)size);
            return -ENOSPC;  // Offset is out of bounds of the indirect blocks
        }

        buf += write_amount;
        offset += write_amount;
        total_written += write_amount;
        size -= write_amount;
        
        block_offset -= (BLOCK_SIZE-block_offset);
        if(block_offset < 0)
        	block_offset = 0;
    }

    // Update the modified time of the inode
    inode->mtim = time(NULL);

    return total_written;  // Return the total number of bytes written
}

static int wfs_read(const char *path, char *buf, size_t size, off_t offset, struct fuse_file_info *fi) {
    printf("HERE: %s, %s, %x, %x\n", path, buf, (uint)size, (uint)offset);
    struct wfs_inode *inode;
    
    // Find the inode based on the given path
    if (find_inode_ava(path, &inode) != 0) {
    	printf("IN HERE\n");
        return -ENOENT;  // No such file or directory
    }

    // Check if the offset is beyond the end of the file
    if (offset >= inode->size) {
    	printf("IN HERE 1\n");
        return 0;  // Nothing to read, reached end of file
    }

    size_t total_read = 0;
    size_t bytes_to_read = size;
    
    while (bytes_to_read > 0 && offset < inode->size) {
        off_t block_index = offset / BLOCK_SIZE;
        off_t block_offset = offset % BLOCK_SIZE;
        size_t bytes_in_block = BLOCK_SIZE - block_offset;
        size_t read_amount = bytes_to_read < bytes_in_block ? bytes_to_read : bytes_in_block;
        read_amount = (offset + read_amount > inode->size) ? inode->size - offset : read_amount;
        printf("READ_AMOUNT: %x\n", (uint)read_amount);

        if (block_index < D_BLOCK) {
            // Direct block access
            char *src = diskImage + inode->blocks[block_index] * BLOCK_SIZE + block_offset;
            memcpy(buf, src, read_amount);
        } else if (block_index < N_BLOCKS) {
            // Indirect block access
            off_t indirect_index = block_index - D_BLOCK;
            off_t *indirect_block = (off_t *)(diskImage + inode->blocks[IND_BLOCK] * BLOCK_SIZE);
            off_t data_block_addr = indirect_block[indirect_index];
            char *src = diskImage + data_block_addr * BLOCK_SIZE + block_offset;
            memcpy(buf, src, read_amount);
        } else {
            // Out of bounds, should not happen if metadata is correct
            fprintf(stderr, "Read error: block index out of bounds\n");
            return -EIO;  // I/O error
        }

        buf += read_amount;
        offset += read_amount;
        total_read += read_amount;
        bytes_to_read -= read_amount;

        printf("READ: %x\n", (uint)total_read);
    }
	printf("READ: %x\n", (uint)total_read);
    return total_read;  // Return the total number of bytes read
}

static int wfs_readdir(const char* path, void* buf, fuse_fill_dir_t filler, off_t offset, struct fuse_file_info* fi){
	printf("HELLO 8\n");
	return 0;
}

static int wfs_mkdir(const char *path, mode_t mode){
printf("HELLO 4\n");
	return wfs_mknod(path, S_IFDIR, 0);
}
