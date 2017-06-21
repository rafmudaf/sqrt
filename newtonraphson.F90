module newtonraphson
implicit none

private :: isEven, isInteger
public :: nr_sqrt, int_2x, int_sq

contains

real function nr_sqrt(n, x0, iterations, printIts)
  real, intent(in) :: n, x0
  integer, intent(in) :: iterations
  logical, intent(in) :: printIts
  integer :: i
  real :: xm1

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

integer function int_2x(n)
  integer, intent(in) :: n
  int_2x = ishft(n, 1)
end function

recursive integer function int_sq(n) result(sq)
  integer, intent(in) :: n
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
  real, intent(in) :: n
  isInteger = mod(n,1.0) == 0
end function

end module
