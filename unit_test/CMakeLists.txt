cmake_minimum_required(VERSION 3.6)
project(sqrt_utest LANGUAGES Fortran)

if(NOT EXISTS ${PYTHON_EXECUTABLE})
  find_program(PYTHON_EXECUTABLE NAMES python3 python py)
  if(NOT EXISTS ${PYTHON_EXECUTABLE})
    message(FATAL_ERROR "CMake cannot find a Python interpreter in your path. Python is required to run OpenFAST tests." )
  endif()
endif()

# configure the testing framework, pFUnit
include(ExternalProject)
set(ExternalProjectCMakeArgs
  -DCMAKE_INSTALL_PREFIX=${PROJECT_BINARY_DIR}/pfunit
  -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_COMPILER}
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

set(pfunit_directory ${PROJECT_BINARY_DIR}/pfunit)
set(source_testdirectory ${PROJECT_SOURCE_DIR}/tests)
set(build_testdirectory ${PROJECT_BINARY_DIR}/tests)

file(MAKE_DIRECTORY ${build_testdirectory})
file(WRITE ${build_testdirectory}/testSuites.inc "")

include_directories(
  ${PROJECT_BINARY_DIR}/..
  ${PROJECT_SOURCE_DIR}
  ${build_testdirectory}
  ${pfunit_directory}/mod
)

# unit tests
set(test_sources)
foreach(test test_newtonraphson)
  set(test_dependency pfunit ${source_testdirectory}/${test}.F90)
  add_custom_command(
    OUTPUT ${build_testdirectory}/${test}.F90
    COMMAND python ${PROJECT_SOURCE_DIR}/pfunit/bin/pFUnitParser.py ${source_testdirectory}/${test}.F90 ${build_testdirectory}/${test}.F90
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
  newtonraphson_fortran
)

enable_testing()
add_test(newtonraphson_utest ${PROJECT_BINARY_DIR}/newtonraphson_utest)
