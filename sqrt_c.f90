program sqrt

use, intrinsic :: iso_c_binding
implicit none

character(len=5) :: arg
integer :: nargs

interface
    integer ( c_int ) function passarrays (in, out) bind ( c )
      use iso_c_binding
      implicit none
      real ( c_double ), intent(in) :: in(4)
      real ( c_double ), intent(out) :: out(4)
    end function
    integer ( c_int ) function initializer () bind ( c )
      use iso_c_binding
    end function
    real ( c_double ) function nr_sqrt ( input, x0, iterations, printIts ) bind ( c )
      use iso_c_binding
      real ( c_double ) :: input
      real ( c_double ) :: x0
      integer ( c_int ) :: iterations
      logical ( c_bool ) :: printIts
    end function
end interface

! arguments for the c routines
integer ( c_int ) :: errstat
real ( c_double ) :: input
real ( c_double ) :: x0 = 10
integer ( c_int ) :: iterations = 10
logical ( c_bool ) :: printIts = .FALSE.
real ( c_double ) :: result
integer ( c_int ) :: result_int
real(C_DOUBLE), dimension(0:3) :: in, out

! passing arrays to c and back
in = (/1,2,3,4/)
print *, "uninitialized out: ", out
result_int = passarrays(in, out)
print *, "after c out: ", out

! initialize the c routines
errstat = initializer()

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
