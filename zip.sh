#!/bin/bash

rm -rf ./build/gitrelease
mkdir ./build/gitrelease

7z a -mx=9 ./build/gitrelease/colortiles-windows.zip ./build/windows/colortiles.exe

7z a -mx=9 ./build/gitrelease/colortiles-linux.zip ./build/linux/colortiles.x86_64
