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

# | DIR VARIABLE |========================================================|
# |=======================================================================|
DIR_INCLUDE="inc";
DIR_SOURCES="src";
DIR_BUILD="build";
# |=======================================================================|

# | COLOR VARIABLE |======================================================|
# |=======================================================================|
#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

CR_BLACK="\033[0;30m"; 
CR_RED="\033[0;31m"; 
CR_GREEN="\033[0;32m"; 
CR_ORANGE="\033[0;33m"; 
CR_BLUE="\033[0;34m"; 
CR_PURPLE="\033[0;35m"; 
CR_CYAN="\033[0;36m"; 
CR_LIGHT_GRAY="\033[0;37m";

CR_DARK_GRAY="\033[1;30m";
CR_LIGHT_RED="\033[1;31m";
CR_LIGHT_GREEN="\033[1;32m";
CR_YELLOW="\033[1;33m";
CR_LIGHT_BLUE="\033[1;34m";
CR_LIGHT_PURPLE="\033[1;35m";
CR_LIGHT_CYAN="\033[1;36m";
CR_WHITE="\033[1;37m";

CR_END="\033[0m";

# |=======================================================================|

# | Check success |=======================================================|
# |=======================================================================|
check_success() # 1 = "name part"
{
if [[ $? -eq 0 ]]
then
  printf " -- ${CR_LIGHT_PURPLE}$1${CR_END} ${CR_ORANGE}was created${CR_END} ${CR_GREEN}successfully${CR_END}!\n"
else
  printf " -- ${CR_RED}ERROR:${CR_END} ${CR_ORANGE}Script failed${CR_END}!\n" >&2
  exit 1
fi
}
# |=======================================================================|

# | Init main.c |=========================================================|
# |=======================================================================|
init_mainc() # no args
{
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

check_success "main.c";
}
# |=======================================================================|

# | Init main.cpp |=======================================================|
# |=======================================================================|
init_maincpp() # no args
{
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

check_success "main.cpp";
}
# |=======================================================================|


# | Init CMakeLists.txt C++ |=============================================|
# |=======================================================================|
init_cmake_cpp() # $1 - name programm
{
CMAKELISTSTXT=CMakeLists.txt
(
cat << CMAKETXT
cmake_minimum_required(VERSION 3.2)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
project($1 LANGUAGES CXX)
set(CMAKE_CXX_STANDARD 20) 

set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -std=c++20 -Werror -Wall -Wextra -Wpedantic -fPIC -march=native -pthread -g")
set(CMAKE_CXX_FLAGS_RELEASE "-std=c++20 -O2 -fPIC -march=native -pthread")

include_directories(${DIR_INCLUDE})
set(PROJECT_SOURCES_DIR ${DIR_SOURCES})
file(GLOB_RECURSE SOURCES \${PROJECT_SOURCES_DIR}/*.cpp)

add_executable(\${PROJECT_NAME} \${SOURCES})

CMAKETXT
) >$CMAKELISTSTXT

check_success "CMakeLists.txt";
}
# |=======================================================================|

# | Init CMakeLists.txt C |===============================================|
# |=======================================================================|
init_cmake_c() # $1 - name programm
{
CMAKELISTSTXT=CMakeLists.txt
(
cat << CMAKETXT
cmake_minimum_required(VERSION 3.2)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)
project($1 LANGUAGES C)
set(CMAKE_CXX_STANDARD 18) 

set(CMAKE_CXX_FLAGS "\${CMAKE_CXX_FLAGS} -std=c18 -Werror -Wall -Wextra -Wpedantic -fPIC -march=native -pthread -g")
set(CMAKE_CXX_FLAGS_RELEASE "-std=c18 -O2 -fPIC -march=native -pthread")

include_directories(${DIR_INCLUDE})
set(PROJECT_SOURCES_DIR ${DIR_SOURCES})
file(GLOB_RECURSE SOURCES \${PROJECT_SOURCES_DIR}/*.c)

add_executable(\${PROJECT_NAME} \${SOURCES})

CMAKETXT
) >$CMAKELISTSTXT

check_success "CMakeLists.txt";
}
# |=======================================================================|

# | Init run.sh |=========================================================|
# |=======================================================================|
init_runsh() # $1 - name programm
{
RUNSH=run.sh
(
cat << RUNTXT
#!/bin/bash

# | COLOR VARIABLE |======================================================|
# |=======================================================================|
#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35
#Cyan         0;36     Light Cyan    1;36
#Light Gray   0;37     White         1;37

CR_BLACK="\033[0;30m"; 
CR_RED="\033[0;31m"; 
CR_GREEN="\033[0;32m"; 
CR_ORANGE="\033[0;33m"; 
CR_BLUE="\033[0;34m"; 
CR_PURPLE="\033[0;35m"; 
CR_CYAN="\033[0;36m"; 
CR_LIGHT_GRAY="\033[0;37m";

CR_DARK_GRAY="\033[1;30m";
CR_LIGHT_RED="\033[1;31m";
CR_LIGHT_GREEN="\033[1;32m";
CR_YELLOW="\033[1;33m";
CR_LIGHT_BLUE="\033[1;34m";
CR_LIGHT_PURPLE="\033[1;35m";
CR_LIGHT_CYAN="\033[1;36m";
CR_WHITE="\033[1;37m";

CR_END="\033[0m";

# |=======================================================================|

# | Check success |=======================================================|
# |=======================================================================|
check_success() # 1 = "name part"
{
if [[ \$? -eq 0 ]]
then
  printf " -- \${CR_LIGHT_PURPLE}\$1\${CR_END} \${CR_ORANGE}was created\${CR_END} \${CR_GREEN}successfully\${CR_END}!\n"
else
  printf " -- \${CR_RED}ERROR:\${CR_END} \${CR_ORANGE}Script failed\${CR_END}!\n" >&2
  exit 1
fi
}
# |=======================================================================|

# | __MAIN__ |============================================================|
# |=======================================================================|
printf " --- [[ \${CR_ORANGE}Start run.sh\${CR_END}! ]] ---\n\n"
cmake ..;
check_success "CMake";

while true; do

  printf " -- \${CR_ORANGE}Do you want continue?\${CR_END} (\${CR_GREEN}y\${CR_END},\${CR_RED}N\${CR_END})\n";
  read answer;

  if [[ \$answer == "y"* ]]; then
    make;
    check_success "Make";
    break;
  elif [[ \$answer == "N"* ]]; then
    exit 0;
  else
    printf " --- [\${CR_RED}Incomprehensible characters\${CR_END}] '\${CR_ORANGE}\$answer\${CR_END}' ";
  fi
done

while true; do

  printf " -- \${CR_ORANGE}Do you want continue?\${CR_END} (\${CR_GREEN}y\${CR_END},\${CR_RED}N\${CR_END})\n";
  read answer;

  if [[ \$answer == "y"* ]]; then
    ./$1;
    check_success "$1"
    break;
  elif [[ \$answer == "N"* ]]; then
    exit 0;
  else
    printf " --- [\${CR_RED}Incomprehensible characters\${CR_END}] '\${CR_ORANGE}\$answer\${CR_END}' ";
  fi
done

printf "\n --- [[ \${CR_ORANGE}run.sh completed\${CR_END} \${CR_LIGHT_GREEN}successfully\${CR_END}! ]] ---\n"
exit 0;
# |=======================================================================|
RUNTXT
) >$RUNSH

check_success "run.sh";
}
# |=======================================================================|

# | Init C/CPP files |====================================================|
# |=======================================================================|
check_ctype() # $@ args
{

if [[ $@ == *"--c" ]]; then
  printf " -- [[[  ${CR_LIGHT_CYAN}C${CR_END} ${CR_ORANGE}project creation${CR_END}!  ]]] --\n"
  init_cmake_c $name_dir;
  cd ${DIR_SOURCES};
  init_mainc;
  cd ..;
elif [[ $@ == *"--cpp" ]]; then
  printf " -- [[[  ${CR_LIGHT_CYAN}CPP${CR_END} ${CR_ORANGE}project creation${CR_END}!  ]]] --\n"
  init_cmake_cpp $name_dir;
  cd ${DIR_SOURCES};
  init_maincpp;
  cd ..;
else
  printf " -- [[[  ${CR_LIGHT_CYAN}C${CR_END} ${CR_ORANGE}project creation${CR_END}!  ]]] --\n"
  init_cmake_c $name_dir;
  cd ${DIR_SOURCES};
  init_mainc;
  cd ..;
fi
}
# |=======================================================================|

# | Init git |============================================================|
# |=======================================================================|
init_git() # $@ args
{
if [[ $@ == *"--git"* ]]; then
  git init &> .git_log.txt;
  check_success "git";
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
    printf "[[ ${CR_RED}ERROR:${CR_END} ${CR_ORANGE}Enter the names of the projects you want to create${CR_END}! ]]\n" >&2
    er=1 # er = true
fi

## Checking for one name
#if [[ $# -gt 1 ]]; then
#    printf "ERROR: Too many arguments!"
#    er=1 # er = true
#fi

# Checking if the project exists
if [[ -e $1 ]]; then
    printf "[[ ${CR_RED}ERROR:${CR_END} ${CR_ORANGE}This build already exists${CR_END}! ]]\n" >&2
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

printf " --- [[ ${CR_ORANGE}Start building the project${CR_END}! ]] ---\n\n"

for name_dir in $@; do
  if [[ $name_dir == "-"* ]]; then
    continue;
  fi

  mkdir "$name_dir";
  cd $name_dir;
  mkdir ${DIR_BUILD} ${DIR_SOURCES} ${DIR_INCLUDE};
  check_ctype $@
  init_git $@;
  cd build;
  init_runsh $name_dir;
  chmod +x *;
  cd ../..;

done

printf "\n --- [[ ${CR_ORANGE}The project was built${CR_END} ${CR_LIGHT_GREEN}successfully${CR_END}! ]] ---\n"
exit 0;
# |=======================================================================|
