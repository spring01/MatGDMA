MEX    := /home/haichen/program/bin/MATLAB/R2013a/bin/mex

FFLAGS := -O2 -fpic
FC     := gfortran

build: gdma_driver.o dma.o atom_grids.o input.o timing.o
	${MEX} matgdma_mex.F90 $^

%.o: %.f90
	${FC} ${FFLAGS} -c $<

%.o: %.F90
	${FC} ${FFLAGS} -c $<

gdma_driver.o: dma.o atom_grids.o input.o timing.o
dma.o: atom_grids.o input.o

clean: 
	rm *.o *.mod matgdma_mex.mex*

