module newtonraphson

use iso_c_binding
use sqrt_types

implicit none

private :: isInteger
public :: nr_sqrt, int_2x, int_sq, isEven

contains

real(c_double) function randn()
  integer :: n
  integer, allocatable :: seed(:)
  real(c_double) :: r
  
  ! call random_seed(size = seedsize)
  call random_seed(size = n)
  write (*,*) n
  allocate(seed(n))
  call random_seed(get=seed)
  write (*, *) seed

  call random_number(r)
  write (*,*) r
  randn = r
end function

real(c_double) function nr_sqrt(n, x0, iterations, printIts) bind(c, name='nr_sqrt')
  real(c_double), intent(in) :: n, x0
  integer(c_int), intent(in) :: iterations
  logical(c_bool), intent(in) :: printIts
  integer :: i
  real(c_double) :: xm1

  do i = 1, iterations
    if (i == 1) then
      xm1 = x0
    endif

    ! if integer, use integer algorithm
    if (isInteger(xm1)) then
      nr_sqrt = xm1 - (int_sq(int(xm1))-n)/(int_2x(int(xm1)))
    else
      nr_sqrt = xm1 - (xm1**2-n)/(2*xm1)
    end if

    if (printIts) then
      print *, xm1
    end if

    xm1 = nr_sqrt
  end do

  return
end function

integer(c_int) function int_2x(n) bind(c, name='int_2x')
  integer(c_int), value, intent(in) :: n
  int_2x = ishft(n, 1)
end function

recursive integer(c_int) function int_sq(n) bind(c, name='int_sq') result(sq)
  integer(c_int), value, intent(in) :: n
  integer :: x

  if (n.eq.0) then
    sq = 0
  else
    x = ishft(n, -1)
    if (isEven(n)) then
      sq = ishft(int_sq(x),2)
    else
      sq = ishft(int_sq(x),2) + ishft(x,2) + 1
    end if
  end if
end function

logical function isEven(n)
  integer, intent(in) :: n
  isEven = mod(n,2) == 0
end function

logical function isInteger(n)
  real(c_double), intent(in) :: n
  isInteger = mod(n,1.0) == 0
end function

subroutine array_passing(input_data, output_data) bind(c, name="array_passing")

  type(array_container_c), intent(in) :: input_data
  type(array_container_c), intent(out) :: output_data
  type(array_container) :: fortran_internal_data

  ! Check that all required values are present in input
  ! TODO

  ! Convert the data from C to Fortran
  call c2f(input_data, fortran_internal_data)

  ! Do some math
  fortran_internal_data%array = fortran_internal_data%array * 10.0

  ! Convert the data back to C
  call f2c(fortran_internal_data, output_data)

end subroutine

subroutine array_passing2d(input_data, output_data) bind(c, name="array_passing2d")

  type(array2d_container_c), intent(in) :: input_data
  type(array2d_container_c), intent(out) :: output_data
  type(array2d_container) :: fortran_internal_data

  ! Check that all required values are present in input
  ! TODO

  ! Convert the data from C to Fortran
  call c2f(input_data, fortran_internal_data)

  ! ! Do some math
  fortran_internal_data%array(1)%array = fortran_internal_data%array(1)%array * 10.0
  fortran_internal_data%array(2)%array = fortran_internal_data%array(2)%array * 100.0

  ! ! Convert the data back to C
  call f2c(fortran_internal_data, output_data)

end subroutine

end module
