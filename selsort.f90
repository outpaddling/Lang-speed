!-----------------------------------------------------------------------
!   Description:
!       Usage:  sort input-file output-file
!
!       Sort a list of real numbers in input-file, placing the results
!       in output-file.  Both input and output files contain one
!       number per line.
!
!   Arguments:
!       input-file:     file to be sorted
!       output-file:    file to receive the sorted list
!
!   Modification history:
!   Date        Name        Modification
!   Apr 2010    J Bacon     Start.
!-----------------------------------------------------------------------

program selsort
    ! Import stuff from constants module
    use ISO_FORTRAN_ENV
    
    ! Disable implicit declarations (i-n rule)
    implicit none
    
    ! Local variables
    integer :: input_status, read_status, list_size
    data_t, allocatable :: list(:)

    ! Get size of list
    read (INPUT_UNIT, *, iostat=read_status) list_size
    if ( read_status /= 0 ) then
	write(ERROR_UNIT, *) 'Error reading list_size.  Error code = ', &
	    read_status
    endif
    
    ! Allocate array for list
    allocate(list(1:list_size))
    
    ! Read list
    call read_list(INPUT_UNIT, list, list_size)
    
    ! Sort list
    call sort_list(list, list_size)
    
    ! Output list
    call print_list(OUTPUT_UNIT, list, list_size)

end program


!-----------------------------------------------------------------------
!   Description:
!       Read a list of real numbers from the given unit into
!       the array list.  The input file contains one number per line.
!
!   Arguments:
!       unit:       File handle of the input file
!       list:       Array to contain the list
!       list_size:  size of the list and the array list
!
!   Modification history:
!   Date        Name        Modification
!   Apr 2010    J Bacon     Start
!-----------------------------------------------------------------------

subroutine read_list(unit, list, list_size)
    ! Disable implicit declarations (i-n rule)
    implicit none
    
    ! Dummy variables
    integer, intent(in) :: unit, list_size
    data_t, intent(out) :: list(1:list_size)

    ! Local variables
    integer :: i

    do i = 1, list_size
	read (unit, *) list(i)
    enddo
end subroutine


!-----------------------------------------------------------------------
!   Description:
!       Print the list of real numbers contained in the array list
!       to a file, one number per line.
!
!   Arguments:
!       filename:   Name of the file to store the list in
!       list:       Array containing the list
!       list_size:  Size of the list and the array
!
!   Modification history:
!   Date        Name        Modification
!   Apr 2010    J Bacon     Start.
!-----------------------------------------------------------------------

subroutine print_list(unit, list, list_size)
    ! Disable implicit declarations (i-n rule)
    implicit none
    
    ! Dummy variables
    integer, intent(in) :: unit
    integer, intent(in) :: list_size
    data_t, intent(in) :: list(1:list_size)

    ! Local variables
    integer :: i
    do i = 1, list_size
	write(unit, *) list(i)
    enddo

end subroutine


!-----------------------------------------------------------------------
!   Description:
!       Sort the list of numbers contained in the array list.
!
!   Arguments:
!       list:       Array containing the numbers
!       list_size:  Size of the list and the array
!
!   Modification history:
!   Date        Name        Modification
!   Apr 2010    J Bacon     Start.
!-----------------------------------------------------------------------

subroutine sort_list(list, list_size)
    ! Disable implicit declarations (i-n rule)
    implicit none
    
    ! Dummy variables
    integer, intent(in) :: list_size
    data_t, intent(inout) :: list(1:list_size)

    ! Local variables
    logical :: sorted
    integer :: c, low, start
    data_t :: temp

    do start = 1, list_size
	! Find low
	low = start
	do c = start+1, list_size
	    if ( list(c) < list(low) ) then
		low = c
	    endif
	enddo
	
	! Swap with first
	temp = list(low)
	list(low) = list(start)
	list(start) = temp
    enddo
end subroutine


!-----------------------------------------------------------------------
!   Description:
!       Display usage message and exit.
!
!   Arguments:
!       program_name:   Name of the program as it was invoked.
!
!   Modification history:
!   Date        Name        Modification
!   Apr 2010    J Bacon     Start.
!-----------------------------------------------------------------------

subroutine usage(program_name)
    use ISO_FORTRAN_ENV
    
    ! Disable implicit declarations (i-n rule)
    implicit none
    
    ! Dummy variables
    character(*), intent(in) :: program_name

    ! print *, len(program_name)
    
    write(ERROR_UNIT, *) "Usage: ", trim(program_name), &
	" input-file output-file"
    stop
end subroutine
