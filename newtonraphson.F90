module newtonraphson
implicit none

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

    if (mod(xm1,1.0) == 0) then
      nr_sqrt = xm1 - (int_sq(int(xm1))-n)/(2*xm1)
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

integer function int_sq(n)
  integer, intent(in) :: n
  int_sq = ishft(n, 1)
end function

end module
