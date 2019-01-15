@test
subroutine test_isEven()
  use pFUnit_mod
  use newtonraphson
  implicit none
  @assertEqual(.TRUE., isEven(2))
end subroutine test_isEven
