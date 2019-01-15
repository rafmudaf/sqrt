cmake_minimum_required(VERSION 3.6)
project(sqrt VERSION 0.1 LANGUAGES Fortran)

set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Dcmake_flag")

if(${CMAKE_SYSTEM_NAME} MATCHES "Darwin")
  set(CMAKE_MACOSX_RPATH 1)
endif()

set(SOURCES ${CMAKE_CURRENT_LIST_DIR}/sqrt.F90 ${CMAKE_CURRENT_LIST_DIR}/newtonraphson.F90)

add_executable(sqrt ${SOURCES})
