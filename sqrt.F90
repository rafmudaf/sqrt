program sqrt

use newtonraphson
implicit none

character(len=5) :: arg
real :: input, result

! read the input argument and convert to real
call getarg(1, arg)
read(arg,*) input

! get the square root from newton raphson method
result = nr_sqrt(input, 10.0, 20, .FALSE.)

! print results
print *, "The square root of ",input," is ", result

end program
