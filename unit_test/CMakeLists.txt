# cmake_minimum_required(VERSION 3.6)
# project(sqrt_utest LANGUAGES Fortran)

find_package(PFUNIT REQUIRED)
enable_testing()

# message("${CMAKE_CURRENT_LIST_DIR}/tests/test_newtonraphson.F90")
add_pfunit_ctest(
  newtonraphson_utest
  TEST_SOURCES test_newtonraphson.pf
  LINK_LIBRARIES newtonraphson_fortran
)
