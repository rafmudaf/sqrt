@test
subroutine test_nr_sqrt()
  use pFUnit_mod
  use newtonraphson
  use iso_c_binding

  implicit none
  logical(1) :: print_iterations
  print_iterations = .FALSE.
  @assertEqual(2.0, nr_sqrt(real(4.0, c_double), real(10.0, c_double), 20, print_iterations))
end subroutine test_nr_sqrt
