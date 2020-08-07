module sqrt_types

use iso_c_binding

! The objective is to allocate an array in Python, pass it to Fortran
! to be populated, and return it to Python.
! We cannot use allocatable arrays in the iso_c_binding interface,
! so instead we'll pass a pointer to an array along with the length of it.
! Fortran routines will allocate the Fortran-specific data values accordingly.
! When the Fortran-specific values are ready to be returned to Python,
! the pointer will be populated.

type, bind(c) :: array_container_c
    type(c_ptr) :: array
    integer(c_int) :: array_len
end type

type array_container
    real, dimension(:), allocatable :: array
end type

type, bind(c) :: array2d_container_c
    type(c_ptr) :: array
    integer(c_int) :: array_len
end type

type array2d_container
    type(array_container), dimension(:), allocatable :: array
end type

contains

subroutine c2f_1d(c_data, f_data)
    ! This assumes the f_data arrays are not allocated

    type(array_container_c), intent(in) :: c_data
    type(array_container), intent(out) :: f_data
    real, dimension(:), pointer :: temporary_pointer

    ! Allocate the Fortran arrays
    allocate(f_data%array(c_data%array_len))

    ! Assign a Fortran pointer to the incoming C pointer
    call c_f_pointer(       &
        c_data%array,       &
        temporary_pointer,  &
        [c_data%array_len]  &
    )
    ! We could alternatively change the Fortran types array to
    ! Fortran pointers and use them the same, but this may break
    ! some of the existing API

    ! Assign the Fortran array to the pointer values
    f_data%array = temporary_pointer

end subroutine

subroutine c2f_2d(c_data, f_data)
    type(array2d_container_c), intent(in) :: c_data
    type(array2d_container), intent(out) :: f_data
    type(array_container_c), dimension(:), pointer :: temporary_pointer
    real, dimension(:), pointer :: temporary_pointer2
    integer :: i

    ! Outer C-pointer to F-pointer
    allocate(f_data%array(c_data%array_len))

    call c_f_pointer(       &
        c_data%array,       &
        temporary_pointer,  &
        [c_data%array_len]  &
    )

    ! Inner C-pointer to F-pointer
    allocate(f_data%array(1)%array( temporary_pointer(1)%array_len ) )
    call c_f_pointer(                     &
        temporary_pointer(1)%array,       &
        temporary_pointer2,               &
        [temporary_pointer(1)%array_len]  &
    )
    f_data%array(1)%array = temporary_pointer2

    allocate(f_data%array(2)%array( temporary_pointer(2)%array_len ) )
    call c_f_pointer(                     &
        temporary_pointer(2)%array,       &
        temporary_pointer2,               &
        [temporary_pointer(2)%array_len]  &
    )
    f_data%array(2)%array = temporary_pointer2

end subroutine

subroutine f2c_1d(f_data, c_data)

    type(array_container), intent(in) :: f_data
    type(array_container_c), intent(out) :: c_data
    real, dimension(:), pointer :: array_pointer

    allocate( array_pointer( size(f_data%array) ) )
    array_pointer = f_data%array

    c_data%array = c_loc(array_pointer)
    c_data%array_len = size(f_data%array)

end subroutine

subroutine f2c_2d(f_data, c_data)

    type(array2d_container), intent(in) :: f_data
    type(array2d_container_c), intent(out) :: c_data
    type(array_container_c), dimension(:), pointer :: temporary_pointer
    real, dimension(:), pointer :: temporary_pointer2

    integer :: i

    allocate( temporary_pointer(2) )
    do i = 1,2

        allocate( temporary_pointer2( size(f_data%array(i)%array) ) )
        temporary_pointer2 = f_data%array(i)%array
    
        temporary_pointer(i)%array = c_loc(temporary_pointer2)
        temporary_pointer(i)%array_len = size(f_data%array(i)%array)
    end do

    c_data%array = c_loc(temporary_pointer)
    c_data%array_len = 2

end subroutine

end module
