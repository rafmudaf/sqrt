program sqrt

use newtonraphson
use, intrinsic :: iso_c_binding
implicit none

character(len=5) :: arg
integer :: nargs

! arguments for the fortran routines
real :: input
real :: x0 = 10
integer :: iterations = 10
logical(1) :: printIts = .TRUE.
real :: result

! read the input argument and convert to real
nargs = command_argument_count()
if (nargs.ne.1) then
  print *, "Usage: sqrt N where N is a real number"
  stop 1
endif

call getarg(1, arg)
read(arg,*) input

! get the square root from newton raphson method
result = nr_sqrt(input, x0, iterations, printIts)

! display the results
print "(3A,F10.4)", "The square root of ",trim(arg)," is ",result

end program
