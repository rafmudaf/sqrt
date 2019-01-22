@test
subroutine test_int_2x()
  use pFUnit_mod
  use newtonraphson
  implicit none
  @assertEqual(8, int_2x(4))
end subroutine test_int_2x
