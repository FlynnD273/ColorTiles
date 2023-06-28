#!/bin/bash

cd build/windows
7z a -mx=9 colortiles-windows.zip colortiles.exe

cd ../linux
7z a -mx=9 colortiles-linux.zip colortiles.x86_64
