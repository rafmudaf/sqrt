@test
subroutine test_nr_sqrt()
  use pFUnit_mod
  use newtonraphson
  implicit none
  logical(1) :: print_iterations
  print_iterations = .FALSE.
  @assertEqual(2.0, nr_sqrt(4.0, 10.0, 20, print_iterations))
end subroutine test_nr_sqrt
