#!/bin/bash

# |=======================================================================|
# | Create Build C (cbc)
# | Author: Notidman;
# | Description: 
# | This program is designed to create a template project with make on c18;
# |=======================================================================|

# | Init main.c |=========================================================|
# |=======================================================================|
init_mainc()
{
echo " - [main.c creation]"

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

echo " -- main.c was created successfully!" 
}
# |=======================================================================|

# | Init Makefile |=======================================================|
# |=======================================================================|
init_make() 
{
echo " - [Makefile creation]"
   
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

echo " -- Makefile was created successfully!" 
}
# |=======================================================================|


# | Argument handling |===================================================|
# |=======================================================================|
if [[ $# -eq 0 ]]; then
    echo "ERROR: Enter the names of the projects you want to create!"
    exit 1;
elif [[ $# -gt 1 ]]; then
    echo "ERROR: Too many arguments!"
    exit 1;
elif [[ -e $1 ]]; then
    echo "ERROR: This build already exists!"
    exit 1;
fi
# |=======================================================================|


# | __MAIN__ |============================================================|
# |=======================================================================|
echo "[[ Start building the project! ]]"

name_dir=$1;

mkdir "$name_dir";
cd $name_dir;
mkdir bin src
init_make
cd src
init_mainc
cd ..

echo "[[ The project was built successfully! ]]"
exit 0;
# |=======================================================================|
