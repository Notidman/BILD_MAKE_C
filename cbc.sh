#!/bin/bash

# |=======================================================================|
# | Create Build C (cbc)
# | Author: Notidman;
# | Description:
# | [[
# |   This program is designed to create a template project
# |   with cmake on c18
# | ]]
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

# | Init CMakeLists.txt |=================================================|
# |=======================================================================|
init_cmake() # $1 - name programm
{
printf " - [CMakeLists.txt creation]\n"

CMAKELISTSTXT=CMakeLists.txt
(
cat << CMAKETXT
cmake_minimum_required(VERSION 3.2)

include_directories(lib)
project($1)

set( SRC
     src/main.c
   )

add_executable(\${PROJECT_NAME} \${SRC})
CMAKETXT
) >$CMAKELISTSTXT

printf " -- CMakeLists.txt was created successfully!\n"
}
# |=======================================================================|

# | Init run.sh |=========================================================|
# |=======================================================================|
init_runsh()  # no args
{
printf " - [run.sh creation]\n"

RUNSH=run.sh
(
cat << RUNTXT
#!/bin/bash
cmake .. && make
RUNTXT
) >$RUNSH

printf " -- run.sh was created successfully!\n"
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
  mkdir build src lib;
  init_cmake $name_dir;
  cd src;
  init_mainc;
  cd ..;
  cd build;
  init_runsh;
  chmod +x *;
  cd ../..;

done

printf "[[ The project was built successfully! ]]\n"
exit 0;
# |=======================================================================|
