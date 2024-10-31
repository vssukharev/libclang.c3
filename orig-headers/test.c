
#include "clang-c/Index.h"
#include <stdio.h>

typedef void* NeHueta;

int main() {
  NeHueta var;
  printf("Size: %lu\n", sizeof(*var));
}

