program sqrt

use newtonraphson
implicit none

character(len=5) :: arg
integer :: nargs
real :: input, result, randomn

! read the input argument and convert to real
nargs = command_argument_count()
if (nargs.ne.1) then
  print *, "Usage: sqrt N where N is a real number"
  stop 1
endif

call getarg(1, arg)
read(arg,*) input

! get the square root from newton raphson method
result = nr_sqrt(input, 10.0, 20, .FALSE.)

! print results
print "(3A,F10.4)", "The square root of ",trim(arg)," is ",result

randomn = randn()

end program
