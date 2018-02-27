cmake_minimum_required(VERSION 3.9)
project(time4int)

set(CMAKE_CXX_STANDARD 11)

add_executable(time4int
        mipslab.h
        mipslabdata.c
        mipslabfunc.c
        mipslabmain.c
        mipslabwork.c
        stubs.c
        time4io.c)
