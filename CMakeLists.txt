cmake_minimum_required(VERSION 3.6)

project(sqrt VERSION 0.1 LANGUAGES Fortran)

if(CMAKE_SYSTEM_NAME MATCHES Darwin)
  set(CMAKE_MACOSX_RPATH 1)
endif()

if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -fprofile-arcs -ftest-coverage")
endif()

# demonstrate passing a compiler directive; used in sqrt.F90
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Dcmake_flag")

# configure the newton-raphson module library
add_library(newtonraphson ${CMAKE_CURRENT_LIST_DIR}/newtonraphson.F90)

# configure the sqrt program
set(SOURCES ${CMAKE_CURRENT_LIST_DIR}/sqrt.F90)
add_executable(sqrt ${SOURCES})
target_link_libraries(sqrt newtonraphson)






option(BUILD_TESTING "Build the testing infrastructure." OFF)
if(BUILD_TESTING)
  add_subdirectory(unit_test)
endif()