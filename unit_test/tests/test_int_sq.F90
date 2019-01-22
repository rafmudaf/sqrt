@test
subroutine test_int_sq()
  use pFUnit_mod
  use newtonraphson
  implicit none
  @assertEqual(16, int_sq(4))
end subroutine test_int_sq
