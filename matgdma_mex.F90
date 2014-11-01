#include "fintrf.h"

subroutine mexFunction(nlhs, plhs, nrhs, prhs)

use gdma_driver
implicit none

interface

    function InputVector(structPtr, fieldName)
        real*8, allocatable :: InputVector(:)
        mwPointer, intent(in) :: structPtr
        character*(*), intent(in) :: fieldName
    end function InputVector
    
    function InputMatrix(structPtr, fieldName)
        real*8, allocatable :: InputMatrix(:, :)
        mwPointer, intent(in) :: structPtr
        character*(*), intent(in) :: fieldName
    end function InputMatrix
    
end interface

mwPointer plhs(*), prhs(*)
integer nlhs, nrhs

mwPointer mxGetPr
mwPointer mxGetField
integer*4 mxIsStruct

mwPointer mxGetM
mwPointer mxGetN
mwPointer size_m, size_n

mwPointer mxCreateDoubleMatrix

type(gdma_input) input_args
integer, parameter :: dp = kind(1d0)
real(dp), dimension(:,:), allocatable :: q_out

real*8 InputScalar

input_args%numSites = InputScalar(prhs(1), 'numSites')
input_args%numShells = InputScalar(prhs(1), 'numShells')
input_args%numPrims = InputScalar(prhs(1), 'numPrims')
input_args%limit = InputVector(prhs(1), 'limit')
input_args%shellNprims = InputVector(prhs(1), 'shellNprims')
input_args%shell2atom = InputVector(prhs(1), 'shell2atom')
input_args%shellType = InputVector(prhs(1), 'shellType')
input_args%shellNfuncs = InputVector(prhs(1), 'shellNfuncs')
input_args%nucleiCharges = InputVector(prhs(1), 'nucleiCharges')
input_args%xyzSites = InputMatrix(prhs(1), 'xyzSites')
input_args%primExps = InputVector(prhs(1), 'primExps')
input_args%primCoefs = InputVector(prhs(1), 'primCoefs')
input_args%density = InputMatrix(prhs(1), 'density')
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


function InputVector(structPtr, fieldName)

    mwPointer :: structPtr
    character*(*) :: fieldName
    real*8, allocatable :: InputVector(:)
    
    mwPointer mxGetPr
    mwPointer mxGetField
    mwPointer mxGetM
    mwPointer mxGetN
    mwPointer size_m, size_n
    
    mwPointer tempMwPointer
    
    tempMwPointer = mxGetField(structPtr, 1, fieldName)
    size_m = mxGetM(tempMwPointer)
    size_n = mxGetN(tempMwPointer)
    allocate(InputVector(size_m * size_n))
    call mxCopyPtrToReal8(mxGetPr(tempMwPointer), InputVector, size_m * size_n)

end function InputVector


function InputMatrix(structPtr, fieldName)

    mwPointer :: structPtr
    character*(*) :: fieldName
    real*8, allocatable :: InputMatrix(:, :)
    
    mwPointer mxGetPr
    mwPointer mxGetField
    mwPointer mxGetM
    mwPointer mxGetN
    mwPointer size_m, size_n
    
    mwPointer tempMwPointer
    
    tempMwPointer = mxGetField(structPtr, 1, fieldName)
    size_m = mxGetM(tempMwPointer)
    size_n = mxGetN(tempMwPointer)
    allocate(InputMatrix(size_m, size_n))
    call mxCopyPtrToReal8(mxGetPr(tempMwPointer), InputMatrix, size_m * size_n)

end function InputMatrix


