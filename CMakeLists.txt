cmake_minimum_required(VERSION 3.10)
project(tutorial VERSION 1.0)
set(CMAKE_CXX_STANDARD 17)

add_library(ssb-generate
        SqlGenerator.cpp SqlGenerator.h)

add_executable(SQLgenerator
        GenerateSqlFile.cpp)

find_package(FMT REQUIRED) 
target_link_libraries(ssb-generate PUBLIC fmt::fmt)
target_link_libraries(SQLgenerator PRIVATE ssb-generate)
