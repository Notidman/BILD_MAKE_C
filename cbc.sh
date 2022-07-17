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
DIR_SRC="src";
DIR_OBJ="obj";
# |=======================================================================|

# | COLOR VARIABLE |======================================================|
# |=======================================================================|
#Black        0;30     Dark Gray     1;30
#Red          0;31     Light Red     1;31
#Green        0;32     Light Green   1;32
#Brown/Orange 0;33     Yellow        1;33
#Blue         0;34     Light Blue    1;34
#Purple       0;35     Light Purple  1;35

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
init_make_cpp() # $1 - name programm
{
MAKELISTSTXT=Makefile
(
cat << MAKETXT
# project name
TARGET=$1

# user way install
PRF_USERWAY=/usr/local/bin

# project compiler
CC=clang++

# cpp standart version
DEFINES=-std=c++20

# project flags release
CXXRFLAGS= \$(DEFINES) -O2 -fPIC -march=native

# project flags debug
CXXFLAGS= \$(DEFINES) -Wall -Werror -Wextra -Wpedantic -fPIC -march=native -g

# directory with source code
PRF_SRC=./${DIR_SRC}/

# directory with object files
PRF_OBJ=./${DIR_OBJ}/

# libs
LDLIBS=
LIBINCLUDE=

# list source files
SRC=\$(wildcard \$(PRF_SRC)*.cpp)
OBJ=\$(patsubst \$(PRF_SRC)%.cpp, \$(PRF_OBJ)%.o, \$(SRC))

# all targets
.PHONY : all release debug clear install uninstall docs

# default make
all : debug

# target program debug
debug : \$(OBJ)
	\$(CC) \$(CXXFLAGS) \$(OBJ) \$(LIBINCLUDE) \$(LDLIBS) -o \$(TARGET)

# target program release
release : \$(OBJ)
	\$(CC) \$(CXXRFLAGS) \$(OBJ) \$(LIBINCLUDE) \$(LDLIBS) -o \$(TARGET)

# generate doc
docs :
	doxygen Doxyfile

# generate .o files
\$(PRF_OBJ)%.o : \$(PRF_SRC)%.cpp
	\$(CC) -c \$(CXXFLAGS) $< -o \$@

# clean object and binary files
clean :
	rm -rf \$(PRF_OBJ)*.o \$(TARGET) doc/*

# install on system unix
install :
	install \$(TARGET) \$(PREFIX)

# uninstall on system unix
uninstall :
	rm -rf \$(PREFIX)/\$(TARGET)
MAKETXT
) >$MAKELISTSTXT

check_success "Makefile";
}
# |=======================================================================|

# | Init CMakeLists.txt C |===============================================|
# |=======================================================================|
init_make_c() # $1 - name programm
{
MAKELISTSTXT=Makefile
(
cat << MAKETXT
# project name
TARGET=$1

# user way install
PRF_USERWAY=/usr/local/bin

# project compiler
CC=clang

# cpp standart version
DEFINES=-std=c18

# project flags release
CRFLAGS= \$(DEFINES) -O2 -fPIC -march=native

# project flags debug
CFLAGS= \$(DEFINES) -Wall -Werror -Wextra -Wpedantic -fPIC -march=native -g

# directory with source code
PRF_SRC=./${DIR_SRC}/

# directory with object files
PRF_OBJ=./${DIR_OBJ}/

# libs
LDLIBS=
LIBINCLUDE=

# list source files
SRC=\$(wildcard \$(PRF_SRC)*.c)
OBJ=\$(patsubst \$(PRF_SRC)%.c, \$(PRF_OBJ)%.o, \$(SRC))

# all targets
.PHONY : all release debug clear install uninstall docs

# default make
all : debug

# target program debug
debug : \$(OBJ)
	\$(CC) \$(CFLAGS) \$(OBJ) \$(LIBINCLUDE) \$(LDLIBS) -o \$(TARGET)

# target program release
release : \$(OBJ)
	\$(CC) \$(CRFLAGS) \$(OBJ) \$(LIBINCLUDE) \$(LDLIBS) -o \$(TARGET)

# generate doc
docs :
	doxygen Doxyfile

# generate .o files
\$(PRF_OBJ)%.o : \$(PRF_SRC)%.c
	\$(CC) -c \$(CFLAGS) $< -o \$@

# clean object and binary files
clean :
	rm -rf \$(PRF_OBJ)*.o \$(TARGET) doc/*

# install on system unix
install :
	install \$(TARGET) \$(PREFIX)

# uninstall on system unix
uninstall :
	rm -rf \$(PREFIX)/\$(TARGET)
MAKETXT
) >$MAKELISTSTXT

check_success "Makefile";
}
# |=======================================================================|

# | Init C/CPP files |====================================================|
# |=======================================================================|
check_ctype() # $@ args
{

if [[ $@ == *"-c"* ]]; then
  printf " -- [[[  ${CR_LIGHT_CYAN}C${CR_END} ${CR_ORANGE}project creation${CR_END}!  ]]] --\n"
  init_make_c $name_dir;
  cd ${DIR_SRC};
  init_mainc;
  cd ..;
elif [[ $@ == *"-C"* ]]; then
  printf " -- [[[  ${CR_LIGHT_CYAN}CPP${CR_END} ${CR_ORANGE}project creation${CR_END}!  ]]] --\n"
  init_make_cpp $name_dir;
  cd ${DIR_SRC};
  init_maincpp;
  cd ..;
else
  printf " -- [[[  ${CR_LIGHT_CYAN}[DEFAULT] C${CR_END} ${CR_ORANGE}project creation${CR_END}!  ]]] --\n"
  init_make_c $name_dir;
  cd ${DIR_SRC};
  init_mainc;
  cd ..;
fi
}
# |=======================================================================|

# | Init git |============================================================|
# |=======================================================================|
init_git() # $@ args
{
if [[ $@ == *"-g"* ]]; then
  git init &> .git_log.txt;
  check_success "git";
fi

}
# |=======================================================================|

# | Init .clangd |========================================================|
# |=======================================================================|
gen_clangd() # $@ args
{
if [[ $@ == *"-v"* && $@ == *"-C"* ]]; then
CLANGD=.clangd
(
cat << CLANGDTXT
CompileFlags:
	Add: [-Wall, -Werror, -Wextra, -Wpedantic, -fPIC, -march=native, -g, -std=c++20]
	Compiler: clang++
CLANGDTXT
) >$CLANGD
elif [[ $@ == *"-v"* && $@ == *"-c"* ]]; then
CLANGD=.clangd
(
cat << CLANGDTXT
CompileFlags:
	Add: [-Wall, -Werror, -Wextra, -Wpedantic, -fPIC, -march=native, -g, -std=c18]
	Compiler: clang
CLANGDTXT
) >$CLANGD
fi

check_success ".clangd";
}
# |=======================================================================|

# | Init .gitignore |=====================================================|
# |=======================================================================|
init_gitignore() # $@ args
{
if [[ $@ == *"-C"* ]]; then
CPPIGNORE=.gitignore  
(
cat << IGNORETXT
# Prerequisites
*.d

# Compiled Object files
*.slo
*.lo
*.o
*.obj

# Precompiled Headers
*.gch
*.pch

# Compiled Dynamic libraries
*.so
*.dylib
*.dll

# Fortran module files
*.mod
*.smod

# Compiled Static libraries
*.lai
*.la
*.a
*.lib

# Executables
*.exe
*.out
*.app
IGNORETXT
) >$CPPIGNORE
elif [[ $@ == *"-c"* ]]; then
CIGNORE=.gitignore  
(
cat << IGNORETXT
# Prerequisites
*.d

# Object files
*.o
*.ko
*.obj
*.elf

# Linker output
*.ilk
*.map
*.exp

# Precompiled Headers
*.gch
*.pch

# Libraries
*.lib
*.a
*.la
*.lo

# Shared objects (inc. Windows DLLs)
*.dll
*.so
*.so.*
*.dylib

# Executables
*.exe
*.out
*.app
*.i*86
*.x86_64
*.hex

# Debug files
*.dSYM/
*.su
*.idb
*.pdb

# Kernel Module Compile Results
*.mod*
*.cmd
.tmp_versions/
modules.order
Module.symvers
Mkfile.old
dkms.conf
IGNORETXT
) >$CIGNORE
else
CIGNORE=.gitignore  
(
cat << IGNORETXT
# Prerequisites
*.d

# Object files
*.o
*.ko
*.obj
*.elf

# Linker output
*.ilk
*.map
*.exp

# Precompiled Headers
*.gch
*.pch

# Libraries
*.lib
*.a
*.la
*.lo

# Shared objects (inc. Windows DLLs)
*.dll
*.so
*.so.*
*.dylib

# Executables
*.exe
*.out
*.app
*.i*86
*.x86_64
*.hex

# Debug files
*.dSYM/
*.su
*.idb
*.pdb

# Kernel Module Compile Results
*.mod*
*.cmd
.tmp_versions/
modules.order
Module.symvers
Mkfile.old
dkms.conf
IGNORETXT
) >$CIGNORE
fi

check_success ".gitignore";
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

  # Make project dir
  mkdir "$name_dir";
  cd $name_dir;
  # Make src and obj dirs
  mkdir ${DIR_SRC} ${DIR_OBJ};
  # Generate C or Cpp files
  check_ctype $@;
  # Init git
  init_git $@;
  # Make .gitignore
  init_gitignore $@;
  # Make .clangd for vim
  gen_clangd $@;
  cd ..;

done

printf "\n --- [[ ${CR_ORANGE}The project was built${CR_END} ${CR_LIGHT_GREEN}successfully${CR_END}! ]] ---\n"
exit 0;
# |=======================================================================|
