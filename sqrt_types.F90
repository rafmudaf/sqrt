module sqrt_types
  implicit none

    type, public :: ControlData
      integer :: array_size
      integer :: max_iterations
    end type ControlData

contains
  subroutine InitValues(control_data)
    type(ControlData), intent(inout) :: control_data

    control_data%array_size = 4096
    control_data%max_iterations = 1000000
      
  end subroutine

end module sqrt_types
