#!/bin/bash

# |=======================================================================|
# | Create Build C (cbc);
# | Author: Notidman;
# | Description:
# | [[
# |   This program is designed to create a template project
# |   with cmake on c/cpp
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

int 
main(void)
{
  return EXIT_SUCCESS;
}
MAINTXT
) >$MAINC

printf " -- main.c was created successfully!\n"
}
# |=======================================================================|

# | Init main.cpp |=========================================================|
# |=======================================================================|
init_maincpp() # no args
{
printf " - [main.cpp creation]\n"

MAINCPP=main.cpp
(
cat << 'MAINTXT'
#include <iostream>

int 
main()
{
  return EXIT_SUCCESS;
}
MAINTXT
) >$MAINCPP

printf " -- main.cpp was created successfully!\n"
}
# |=======================================================================|


# | Init CMakeLists.txt C++ |=============================================|
# |=======================================================================|
init_cmake_cpp() # $1 - name programm
{
printf " - [CMakeLists.txt creation]\n"

CMAKELISTSTXT=CMakeLists.txt
(
cat << CMAKETXT
cmake_minimum_required(VERSION 3.2)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
project($1 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 20) 

set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -std=c++20 -Werror -Wall -Wextra -Wpedantic -fPIC -march=native -pthread -g")
set(CMAKE_CXX_FLAGS_RELEASE "-std=c++20 -O2 -fPIC -march=native -pthread")

include_directories(lib)
set(PROJECT_SOURCES_DIR src)
file(GLOB_RECURSE SOURCES \${PROJECT_SOURCES_DIR}/*.cpp)

add_executable(\${PROJECT_NAME} \${SOURCES})

CMAKETXT
) >$CMAKELISTSTXT

printf " -- CMakeLists.txt was created successfully!\n"
}
# |=======================================================================|

# | Init CMakeLists.txt C |===============================================|
# |=======================================================================|
init_cmake_c() # $1 - name programm
{
printf " - [CMakeLists.txt creation]\n"

CMAKELISTSTXT=CMakeLists.txt
(
cat << CMAKETXT
cmake_minimum_required(VERSION 3.2)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
project($1 LANGUAGES C)
set(CMAKE_CXX_STANDARD 18) 

set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -std=c18 -Werror -Wall -Wextra -Wpedantic -fPIC -march=native -pthread -g")
set(CMAKE_CXX_FLAGS_RELEASE "-std=c18 -O2 -fPIC -march=native -pthread")

include_directories(lib)
set(PROJECT_SOURCES_DIR src)
file(GLOB_RECURSE SOURCES \${PROJECT_SOURCES_DIR}/*.c)

add_executable(\${PROJECT_NAME} \${SOURCES})

CMAKETXT
) >$CMAKELISTSTXT

printf " -- CMakeLists.txt was created successfully!\n"
}
# |=======================================================================|

# | Init run.sh |=========================================================|
# |=======================================================================|
init_runsh() # $1 - name programm
{
printf " - [run.sh creation]\n"

RUNSH=run.sh
(
cat << RUNTXT
#!/bin/bash
cmake .. && make && ./$1
RUNTXT
) >$RUNSH

printf " -- run.sh was created successfully!\n"
}
# |=======================================================================|

# | Init C/CPP files |====================================================|
# |=======================================================================|
check_ctype() # $@ args
{

if [[ $@ == *"-c" ]]; then
  printf " - [C project creation]\n"
  init_cmake_c $name_dir;
  cd src;
  init_mainc;
  cd ..;
elif [[ $@ == *"-cpp" ]]; then
  printf " - [Cpp project creation]\n"
  init_cmake_cpp $name_dir;
  cd src;
  init_maincpp;
  cd ..;
else
  printf " - [C project creation]\n"
  init_cmake_c $name_dir;
  cd src;
  init_mainc;
  cd ..;
fi
}
# |=======================================================================|

# | Init git |============================================================|
# |=======================================================================|
init_git() # $@ args
{
if [[ $@ == *"-git" ]]; then
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
  check_ctype $@
  cd build;
  init_runsh $name_dir;
  chmod +x *;
  cd ../..;

done

printf "[[ The project was built successfully! ]]\n"
exit 0;
# |=======================================================================|
