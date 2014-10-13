#!/bin/bash

# easy compile lab09

as 9.s -o 9.o
as sub.s -o sub.o
ld 9.o sub.o -o 9

# execute binary
./9

