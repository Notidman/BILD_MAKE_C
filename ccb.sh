#!/bin/bash

#Init main.c
init_mainc()
{
echo " - [Creation of main.c]"

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

echo " -- main.c creation successfully!" 
}

#Init Makefile
init_make() 
{
echo " - [Creation of Makefile]"
   
MAKEFILE=Makefile
(
cat << 'MAKETXT'
debug : 
	gcc -o ./bin/deb ./src/main.c -Wall -Wextra -Wpedantic -std=c18

release :
	gcc -o ./bin/res ./src/main.c -O3 -std=c18

dl :
	-rm -rf ./bin
MAKETXT
) >$MAKEFILE

echo " -- Makefile creation successfully!" 
}

#Argument handling 
if [[ $# -eq 0 ]]; then
    echo "Enter the names of the projects you want to create!"
    exit 1;
elif [[ $# -gt 1 ]]; then
    echo "Too many arguments!"
    exit 1;
elif [[ -e $1 ]]; then
    echo "This build already exists!"
    exit 1;
fi

#MAIN
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
