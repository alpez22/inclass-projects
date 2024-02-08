#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"
int main(int argc, char *argv[]) 
{
  int fd;
  char buff[256];

  if(argc < 2){
	printf(2, "Usage: getfilename <name_of_file>\n");
    exit();
  }

  fd = open(argv[1], O_RDONLY);
  if(fd < 0){
	printf(2, "getfilename cannot open %s\n", argv[1]);
    exit();
  }  

  if(getfilename(fd, buff, sizeof(buff)) < 0){
	printf(2, "Failed to copy the name of the file associated with the file descriptor\n");
    close(fd);
	exit();
  }

  printf(1, "XV6_TEST_OUTPUT Open filename: %s\n", buff);
  exit();
}

