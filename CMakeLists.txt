cmake_minimum_required(VERSION 3.6)

project(sqrt VERSION 0.1 LANGUAGES Fortran)

if(CMAKE_SYSTEM_NAME MATCHES Darwin)
  set(CMAKE_MACOSX_RPATH 1)
endif()

if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -fprofile-arcs -ftest-coverage")
endif()

# configure the newton-raphson module compile
add_library(newtonraphson ${CMAKE_CURRENT_LIST_DIR}/newtonraphson.F90)

# confifure the sqrt program compile
set(SOURCES ${CMAKE_CURRENT_LIST_DIR}/sqrt.F90)
add_executable(sqrt ${SOURCES})
target_link_libraries(sqrt newtonraphson)

# configure the testing framework, pFUnit
include(ExternalProject)
set(ExternalProjectCMakeArgs
  -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}/pfunit
  -DROBUST=OFF
)
set(PFUNIT_INSTALL ${PROJECT_BINARY_DIR}/pfunit)
ExternalProject_Add(pfunit
  SOURCE_DIR ${PROJECT_SOURCE_DIR}/pfunit
  BINARY_DIR ${PROJECT_BINARY_DIR}/pfunit-build
  STAMP_DIR ${PROJECT_BINARY_DIR}/pfunit-stamp
  TMP_DIR ${PROJECT_BINARY_DIR}/pfunit-tmp
  INSTALL_DIR ${PFUNIT_INSTALL}
  CMAKE_ARGS ${ExternalProjectCMakeArgs}
)

set(PFUNIT_INSTALL ${PROJECT_BINARY_DIR}/pFUnit)
set(pfunit_directory ${PFUNIT_INSTALL})
set(source_testdirectory ${PROJECT_SOURCE_DIR}/tests)
set(build_testdirectory ${PROJECT_BINARY_DIR}/tests)

file(MAKE_DIRECTORY ${build_testdirectory})
file(WRITE ${build_testdirectory}/testSuites.inc "")

include_directories(
  ${PROJECT_SOURCE_DIR}
  ${build_testdirectory}
  ${pfunit_directory}/mod
)

# unit tests
set(test_sources)
foreach(test test_int_2x test_int_sq test_nr_sqrt test_isEven)
  set(test_dependency ${source_testdirectory}/${test}.F90)
  add_custom_command(
    OUTPUT ${build_testdirectory}/${test}.F90
    COMMAND python ${pfunit_directory}/bin/pFUnitParser.py ${source_testdirectory}/${test}.F90 ${build_testdirectory}/${test}.F90
    DEPENDS ${test_dependency}
  )

  set(test_sources ${test_sources} ${build_testdirectory}/${test}.F90)
  file(APPEND ${build_testdirectory}/testSuites.inc "ADD_TEST_SUITE(${test}_suite)\n")
endforeach()

set_source_files_properties(${pfunit_directory}/include/driver.F90 PROPERTIES GENERATED 1)

add_executable(
  newtonraphson_utest
  ${pfunit_directory}/include/driver.F90
  ${test_sources}
)
target_link_libraries(
  newtonraphson_utest
  ${pfunit_directory}/lib/libpfunit.a
  newtonraphson
)

enable_testing()
add_test(newtonraphson_utest ${PROJECT_BINARY_DIR}/newtonraphson_utest)
