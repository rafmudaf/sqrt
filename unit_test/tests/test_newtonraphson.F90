module test_newtonraphson

  use pFUnit_mod
  use newtonraphson
  use iso_c_binding

  implicit none

contains

@test
subroutine test_int_2x()
  @assertEqual(8, int_2x(4))
end subroutine test_int_2x

@test
subroutine test_int_sq()
  @assertEqual(16, int_sq(4))
end subroutine test_int_sq

@test
subroutine test_nr_sqrt()
  logical(1) :: print_iterations
  print_iterations = .FALSE.
  @assertEqual(2.0, nr_sqrt(4.0_c_double, 10.0_c_double, 20, print_iterations))
end subroutine test_nr_sqrt

@test
subroutine test_isEven()
  @assertEqual(.TRUE., isEven(2))
end subroutine test_isEven

end module
