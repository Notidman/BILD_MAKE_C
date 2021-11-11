#!/bin/bash

# |=======================================================================|
# | Create Build C (cbc)
# | Author: Notidman;
# | Description: 
# | This program is designed to create a template project with make on c18;
# |=======================================================================|

# | Init main.c |=========================================================|
# |=======================================================================|
init_mainc() # no args
{
printf " - [main.c creation]\n"

MAINC=main.c
(
cat << 'MAINTXT'
#include <stdio.h>
#include <stdlib.h>

int main(void)
{
  return EXIT_SUCCESS;
}
MAINTXT
) >$MAINC

printf " -- main.c was created successfully!\n" 
}
# |=======================================================================|

# | Init Makefile |=======================================================|
# |=======================================================================|
init_make() # no args
{
printf " - [Makefile creation]\n"
   
MAKEFILE=Makefile
(
cat << 'MAKETXT'
debug : 
	gcc -o ./bin/deb ./src/main.c -g3 -D_FORTIFY_SOURCE=2 -Werror -Wall -Wextra -Wpedantic -std=c18 -Og

release :
	gcc -o ./bin/res ./src/main.c -O2 -std=c18

dl :
	-rm -rf ./bin
MAKETXT
) >$MAKEFILE

printf " -- Makefile was created successfully!\n" 
}
# |=======================================================================|

# | Init git |============================================================|
# |=======================================================================|
init_git() # $@ args
{
if [[ $@ == *"-git"* ]]; then
  printf " - [Git creation]\n"
  git init;
fi

}
# |=======================================================================|

# | Argument handling |===================================================|
# |=======================================================================|
valid() # $@ args
{

# er(Error) = false;
er=0

# Checking whether the name is entered or not
if [[ $# -eq 0 ]]; then
    printf "ERROR: Enter the names of the projects you want to create!\n"
    er=1 # er = true
fi

## Checking for one name
#if [[ $# -gt 1 ]]; then
#    printf "ERROR: Too many arguments!"
#    er=1 # er = true
#fi

# Checking if the project exists
if [[ -e $1 ]]; then
    printf "ERROR: This build already exists!\n"
    er=1 # er = true
fi

# Сheck that all tests have passed the validation
if [[ $er -eq 1 ]]; then
   exit 1
fi
}
# |=======================================================================|


# | __MAIN__ |============================================================|
# |=======================================================================|

valid $@

printf "[[ Start building the project! ]]\n"

for name_dir in $@; do
  if [[ $name_dir == "-"* ]]; then
    continue;
  fi

  mkdir "$name_dir";
  cd $name_dir;
  init_git $@;
  mkdir bin src;
  init_make;
  cd src;
  init_mainc;
  cd ..;
  cd ..;

done

printf "[[ The project was built successfully! ]]\n"
exit 0;
# |=======================================================================|
