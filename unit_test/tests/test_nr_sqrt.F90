@test
subroutine test_nr_sqrt()
  use pFUnit_mod
  use newtonraphson
  implicit none
  @assertEqual(2.0, nr_sqrt(4.0, 10.0, 20, .FALSE.))
end subroutine test_nr_sqrt
