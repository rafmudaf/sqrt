cmake_minimum_required(VERSION 3.6)

project(sqrt VERSION 0.1 LANGUAGES Fortran)

if(CMAKE_SYSTEM_NAME MATCHES Darwin)
  set(CMAKE_MACOSX_RPATH 1)
endif()

if(CMAKE_Fortran_COMPILER_ID MATCHES GNU)
  set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -g -fprofile-arcs -ftest-coverage")
endif()

add_library(newtonraphson ${CMAKE_CURRENT_LIST_DIR}/newtonraphson.F90)

set(PFUNIT_DIR ${PFUNIT_INSTALL})

file(MAKE_DIRECTORY ${PROJECT_BINARY_DIR}/generated)
file(WRITE ${PROJECT_BINARY_DIR}/generated/testSuites.inc "")

include_directories(
  ${PROJECT_SOURCE_DIR}
  ${PROJECT_BINARY_DIR}/generated
  ${PFUNIT_DIR}/mod
)

set(_test_sources)
foreach(_test test_int_2x test_int_sq test_nr_sqrt)
  if(DEFINED PFUNIT_INSTALL)
    set(test_dependency ${PROJECT_SOURCE_DIR}/tests/${_test}.F90)
  else()
    set(test_dependency pfunit ${PROJECT_SOURCE_DIR}/tests/${_test}.F90)
  endif()

  add_custom_command(
    OUTPUT ${PROJECT_BINARY_DIR}/generated/${_test}.F90
    COMMAND python ${PFUNIT_DIR}/bin/pFUnitParser.py ${PROJECT_SOURCE_DIR}/tests/${_test}.F90 ${PROJECT_BINARY_DIR}/generated/${_test}.F90
    DEPENDS ${test_dependency}
  )

  set(_test_sources ${_test_sources} ${PROJECT_BINARY_DIR}/generated/${_test}.F90)
  file(APPEND ${PROJECT_BINARY_DIR}/generated/testSuites.inc "ADD_TEST_SUITE(${_test}_suite)\n")
endforeach()

set_source_files_properties(${PFUNIT_DIR}/include/driver.F90 PROPERTIES GENERATED 1)

add_executable(
  pftest_alltests
  ${PFUNIT_DIR}/include/driver.F90
  ${_test_sources}
)

target_link_libraries(
  pftest_alltests
  ${PFUNIT_DIR}/lib/libpfunit.a
  newtonraphson
)

enable_testing()
add_test(pftest_alltests ${PROJECT_BINARY_DIR}/pftest_alltests)

#set(SOURCES ${CMAKE_CURRENT_LIST_DIR}/sqrt.F90 )
#add_executable(sqrt ${SOURCES})
