program sqrt

use newtonraphson
use, intrinsic :: iso_c_binding
implicit none

character(len=5) :: arg
integer :: nargs

! arguments for the fortran routines
real(8) :: input
real(8) :: x0 = 10
integer :: iterations = 10
logical(1) :: printIts = .TRUE.
integer :: i
integer, parameter :: n = 1024
real(8), dimension(n) :: m1, m2, result

do i=1,n
  m1(i) = i
  m2(i) = 0.1 * i
end do

call matrixmultiply_vectorized(n, m1, m2, result)

do i=1, n
  ! "(A,I5,A,F10.4)"
  print "(F12.4)", result(i)
end do

call getarg(1, arg)
read(arg,*) input

! get the square root from newton raphson method
result = nr_sqrt(input, x0, iterations, printIts)

! display the results
print "(3A,F10.4)", "The square root of ",trim(arg)," is ",result

end program
