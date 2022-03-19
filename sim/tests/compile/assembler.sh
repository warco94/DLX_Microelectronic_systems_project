#!/bin/bash

./dlxasm.pl test.asm
./conv2memory test.asm.exe > test.asm.mem
sed -i '/^$/d' test.asm.mem