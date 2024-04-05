#include "types.h"
#include "stat.h"
#include "user.h"
#define O_RDONLY  0x000

int main(int argc, char*argv[]){
  int successful = wmap(0x70000000, 8192, MAP_FIXED | MAP_SHARED | MAP_ANONYMOUS, -1);
  if(successful == 0){
    printf(1, "XV6_TEST_OUTPUT Open filename: %s\n", successful);
  }
  else{
    printf(1, "XV6_TEST_OUTPUT Open filename: %d\n", successful);
  }
  exit();
}
