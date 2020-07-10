cmake_minimum_required(VERSION 3.6)
project(sqrt VERSION 0.2 LANGUAGES Fortran CXX)

if(CMAKE_SYSTEM_NAME MATCHES Darwin)
  set(CMAKE_MACOSX_RPATH 1)
endif()

if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g")
  # set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -fprofile-arcs -ftest-coverage")
endif()

# demonstrate passing a compiler directive; used in sqrt.f90
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Dcmake_flag")

# configure the newton-raphson module libraries
add_library(newtonraphson_fortran SHARED ${CMAKE_CURRENT_LIST_DIR}/newtonraphson.f90 ${CMAKE_CURRENT_LIST_DIR}/sqrt_types.f90)
add_library(newtonraphson_c SHARED ${CMAKE_CURRENT_LIST_DIR}/newtonraphson.cpp)

# configure the sqrt programs
add_executable(sqrt_fortran ${CMAKE_CURRENT_LIST_DIR}/sqrt.f90)
target_link_libraries(sqrt_fortran newtonraphson_fortran)

add_executable(sqrt_c ${CMAKE_CURRENT_LIST_DIR}/sqrt.cpp)
target_link_libraries(sqrt_c newtonraphson_c)

add_executable(sqrt_c_fortran ${CMAKE_CURRENT_LIST_DIR}/sqrt_f90.cpp)
target_link_libraries(sqrt_c_fortran newtonraphson_fortran)

add_executable(sqrt_fortran_c ${CMAKE_CURRENT_LIST_DIR}/sqrt_c.f90)
target_link_libraries(sqrt_fortran_c newtonraphson_c)

option(BUILD_TESTING "Build the testing infrastructure." OFF)
if(BUILD_TESTING)
  add_subdirectory(unit_test)
endif()
