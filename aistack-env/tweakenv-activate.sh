#!/bin/bash

# Backup already set variables
export PRE_MPI_C_COMPILER="$MPI_C_COMPILER"
export PRE_MPI_CXX_COMPILER="$MPI_CXX_COMPILER"
export PRE_MPI_Fortran_COMPILER="$MPI_Fortran_COMPILER"
export PRE_MPI_FORTRAN_COMPILER="$MPI_FORTRAN_COMPILER"
export PRE_MPI_FC_COMPILER="$MPI_FC_COMPILER"
export PRE_CC="$CC"
export PRE_CXX="$CXX"
export PRE_FC="$FC"
export PRE_CMAKE_C_COMPILER="$CMAKE_C_COMPILER"
export PRE_CMAKE_CXX_COMPILER="$CMAKE_CXX_COMPILER"
export PRE_CMAKE_Fortran_COMPILER="$CMAKE_Fortran_COMPILER"
export PRE_CMAKE_FORTRAN_COMPILER="$CMAKE_FORTRAN_COMPILER"
export PRE_CMAKE_FC_COMPILER="$CMAKE_FC_COMPILER"
export PRE_cc="$cc"
export PRE_cxx="$cxx"
export PRE_fc="$fc"
export PRE_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
export PRE_CUDA_HOME="$CUDA_HOME"

# Set new necessary variables
export MPI_C_COMPILER=mpicc
export MPI_CXX_COMPILER=mpicxx
export MPI_Fortran_COMPILER=mpifort
export MPI_FORTRAN_COMPILER=mpifort
export MPI_FC_COMPILER=mpifort
export CC=gcc-7
export CXX=g++-7
export FC=gfortran-7
export CMAKE_C_COMPILER="$CC"
export CMAKE_CXX_COMPILER="$CXX"
export CMAKE_Fortran_COMPILER="$FC"
export CMAKE_FORTRAN_COMPILER="$FC"
export CMAKE_FC_COMPILER="$FC"
export cc="$CC"
export cxx="$CXX"
export fc="$FC"

# Numpy + MKL fix (e.g. for Dolfin)
export NPY_MKL_FORCE_INTEL=1

# Additional LD_PRELOAD or LD_LIBRARY_PATH or CUDA_HOME flags will be eventually added after this line
