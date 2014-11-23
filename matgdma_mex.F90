#include "fintrf.h"


subroutine mexFunction(nlhs, plhs, nrhs, prhs)

use gdma_driver
implicit none

interface
    
    function InputVector(structPtr, fieldName, refM)
        real*8, allocatable :: InputVector(:)
        mwPointer, intent(in) :: structPtr
        character*(*), intent(in) :: fieldName
        logical checkDim
        integer refM
    end function InputVector
    
    function InputMatrix(structPtr, fieldName, refM, refN)
        real*8, allocatable :: InputMatrix(:, :)
        mwPointer, intent(in) :: structPtr
        character*(*), intent(in) :: fieldName
        logical checkDim
        integer refM, refN
    end function InputMatrix
    
end interface

mwPointer plhs(*), prhs(*)
integer nlhs, nrhs

mwPointer mxGetPr
integer*4 mxIsStruct

mwPointer size_m, size_n

mwPointer mxCreateDoubleMatrix

type(gdma_input) input_args
integer, parameter :: dp = kind(1d0)
real(dp), dimension(:,:), allocatable :: q_out

real*8 InputScalar

integer numSites, numShells, numBasisFunc, numPrims

if(nrhs .ne. 1 .or. mxIsStruct(prhs(1)) .eq. 0 ) & 
    call mexErrMsgIdAndTxt("mexFunction:nrhs", "Expect a struct as input.")

! sites info
input_args%limit = InputVector(prhs(1), 'limit', -2)
numSites = size(input_args%limit)
input_args%nucleiCharges = InputVector(prhs(1), 'nucleiCharges', numSites)
input_args%xyzSites = InputMatrix(prhs(1), 'xyzSites', 3, numSites)

! shells info
input_args%shellNfuncs = InputVector(prhs(1), 'shellNfuncs', -2)
numShells = size(input_args%shellNfuncs)
input_args%shellNprims = InputVector(prhs(1), 'shellNprims', numShells)
input_args%shell2atom = InputVector(prhs(1), 'shell2atom', numShells)

! primitives info
numPrims = sum(input_args%shellNprims)
input_args%primExps = InputVector(prhs(1), 'primExps', numPrims)
input_args%primCoefs = InputVector(prhs(1), 'primCoefs', numPrims)

numBasisFunc = sum(input_args%shellNfuncs)
input_args%density = InputMatrix(prhs(1), 'density', numBasisFunc, numBasisFunc)

input_args%bigexp = InputScalar(prhs(1), 'bigexp')

call gdma_driver_routine(q_out, input_args)

size_m = size(q_out,1)
size_n = size(q_out,2)
plhs(1) = mxCreateDoubleMatrix(size_m, size_n, 0)
call mxCopyReal8ToPtr(q_out, mxGetPr(plhs(1)), size_m*size_n)

return
end


function InputScalar(structPtr, fieldName)

    mwPointer structPtr
    character*(*) fieldname
    real*8 InputScalar
    
    mwPointer mxGetPr
    mwPointer mxGetField
    
    call mxCopyPtrToReal8(mxGetPr(mxGetField(structPtr, 1, fieldName)), InputScalar, 1)

end function InputScalar


function InputVector(structPtr, fieldName, refM)
    
    interface
        
        function ReadField(structPtr, fieldName)
            real*8, allocatable :: ReadField(:, :)
            mwPointer, intent(in) :: structPtr
            character*(*), intent(in) :: fieldName
        end function ReadField
        
    end interface
    
    mwPointer structPtr
    character*(*) fieldname
    logical checkDim
    integer refM
    real*8, allocatable :: InputVector(:)
    real*8, allocatable :: tempMatrix(:, :)
    
    tempMatrix = ReadField(structPtr, fieldName)
    if(size(tempMatrix, 1) < size(tempMatrix, 2)) then
        tempMatrix = transpose(tempMatrix)
    end if
    
    if(refM .ne. -2) then ! if -2, do not check dimension
        call DimensionCheck(fieldName, size(tempMatrix, 1), refM)
        call DimensionCheck(fieldName, size(tempMatrix, 2), 1)
    end if
    
    InputVector = tempMatrix(:, 1)

end function InputVector


function InputMatrix(structPtr, fieldName, refM, refN)

    interface
        
        function ReadField(structPtr, fieldName)
            real*8, allocatable :: ReadField(:, :)
            mwPointer, intent(in) :: structPtr
            character*(*), intent(in) :: fieldName
        end function ReadField
        
    end interface

    mwPointer :: structPtr
    character*(*) :: fieldName
    integer refM, refN
    real*8, allocatable :: InputMatrix(:, :)
    
    InputMatrix = ReadField(structPtr, fieldName)
    
    call DimensionCheck(fieldName, size(InputMatrix, 1), refM)
    call DimensionCheck(fieldName, size(InputMatrix, 2), refN)

end function InputMatrix


function ReadField(structPtr, fieldName)

    mwPointer :: structPtr
    character*(*) :: fieldName
    logical checkDim
    integer refM, refN
    real*8, allocatable :: ReadField(:, :)
    
    integer*4 mxGetFieldNumber
    mwPointer mxGetPr
    mwPointer mxGetField
    mwPointer mxGetM
    mwPointer mxGetN
    mwPointer size_m, size_n
    mwPointer tempMwPointer
    
    ! field existence check
    if(mxGetFieldNumber(structPtr, fieldName) .eq. 0) then
        call mexErrMsgIdAndTxt("ReadField:structPtr", "Field "//fieldName//" does not exist.")
    end if
    
    tempMwPointer = mxGetField(structPtr, 1, fieldName)
    size_m = mxGetM(tempMwPointer)
    size_n = mxGetN(tempMwPointer)
    
    allocate(ReadField(size_m, size_n))
    call mxCopyPtrToReal8(mxGetPr(tempMwPointer), ReadField, size_m * size_n)

end function ReadField


subroutine DimensionCheck(fieldName, dim_, dim_ref)
    character*(*) :: fieldName
    integer dim_, dim_ref
    if(dim_ .ne. dim_ref) then
        call mexErrMsgIdAndTxt("DimensionCheck:check_dim", "Field "//fieldName//" has wrong dimension.")
    end if
    return
end subroutine DimensionCheck

