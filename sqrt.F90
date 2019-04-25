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
integer :: i, j
real :: t1, t2
integer, parameter :: n = 4096
real(8), dimension(n, n) :: m1, m2, result

do i=1,n
  do j=1,n
    m1(i, j) = i
    m2(i, j) = 0.1 * i
  end do
end do

call cpu_time ( t1 )
do i=1,100000
  call matrixmultiply_vectorized(n, m1, m2, result)
end do
call cpu_time ( t2 )
write ( *, * ) 'matrixmultiple CPU time = ', t2 - t1

! do i=1,n
!   do j=1,n
!     ! "(A,I5,A,F10.4)"
!     print "(F12.4)", result(i, j)
!   end do
! end do

call getarg(1, arg)
read(arg,*) input

! get the square root from newton raphson method
result = nr_sqrt(input, x0, iterations, printIts)

! display the results
print "(3A,F10.4)", "The square root of ",trim(arg)," is ",result

end program
