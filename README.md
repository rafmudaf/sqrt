# SQRT

A basic square root calculation program written in Fortran which provides a basis for evaluating various software infrastructure tools
and ideas.

Methods demonstrated here:

- [Compiler directives with CMake](#compiler-directives-with-cmake)
- [Unit testing with pFUnit](#unit-testing-with-pfunit)
- Debugging
- [Continuous integration with TravisCI](#continuous-integration-with-travisci)

### Compiler directives with CMake

This can be done simply with something like

```
# in CMake
set(CMAKE_Fortran_FLAGS "${CMAKE_Fortran_FLAGS} -Dcmake_flag")

# in Fortran code
#if (defined(cmake_flag))
  write(*,*) "cmake_flag", cmake_flag
#endif
```

However, it is important to ensure that the Fortran file is preprocessed. Files ending in `F90` are automatically preprocessed, but all
files can be preprocessed with the appropriate compiler flag: `-cpp` for g#.
See the [GNU preprocessor options](https://gcc.gnu.org/onlinedocs/gcc-8.2.0/gfortran/Preprocessing-Options.html#Preprocessing-Options) for more info.

### Unit testing with pFUnit

The unit testing framework I chose to evaluate and implement here is [pFUnit](https://github.com/Goddard-Fortran-Ecosystem/pFUnit)
developed at NASA Goddard. It has turned out to be nice for developing tests within a single framework. Specifically, when doing
development in Fortran it is convenient to stay in Fortran to write the unit tests.

However, I have found it to be limiting in scope and a bit of a heavy lift for the functionality that you get. A better approach
may be to use compile the Fortran project as a shared library and drive the unit tests with a Python framework.

### Continuous integration with TravisCI

[![Build Status](https://travis-ci.org/rafmudaf/sqrt.svg?branch=master)](https://travis-ci.org/rafmudaf/sqrt)

Continuous integration is configured here with [TravisCI](https://travis-ci.org/rafmudaf/sqrt). It is currently configured to run
on a macOS 10.12 (High Sierra) image with GCC version 7. The continuous integration system compiles the main program, compiles the unit
tests, and runs the unit tests.
