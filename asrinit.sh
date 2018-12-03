#!/bin/bash
##########################################
##  AIStack, v. 1.5.1-001 (03/12/2018)  ##
##########################################
#
# A hacky-but-effective environment initialization toolkit for Anaconda, aimed
# at the broadest possible Machine Learning, Artificial Intelligence, Control
# and Optimization (and the interplay between them) research audience, developed
# following the principles of fast iterations, high performance, full control,
# and minimal external (i.e. not automatically installed) dependencies.
#
# (c) 2018 Emanuele Ballarin <emanuele@ballarin.cc>
# Released under the Apache License 2.0.
##
#
# HARDWARE REQUIREMENTS:
# - Intel processor (recommended: series 6 or newer) with AVX2 support;
# - NVidia graphics card with CUDA capability >= 3.0.
#
# SOFTWARE REQUIREMENTS (mandatory, installed system-wide):
# - Relatively recent Linux operating system (with glibc >= 2.17);
# - Bash >= 4.0
# - Anaconda Python Distribution >= 5.3 (or equivalent, i.e. miniconda)
# - NVidia Graphics proprietary drivers >= 410 series
# - GNU Binutils
# - GNU Compiler Suite v.7 (C/C++/Fortran)
# - OpenMPI >= 3
# - OpenMP
# - Kitware's CMAKE >= 3.11
# - Curl >= 7 with HTTPS support.
# - WGet >= 1.19 with HTTPS support
# - Git >= 2.18
#
# SOFTWARE REQUIREMENTS (optional, installed system-wide):
# - cmdSTAN (sourced)
# - SuiteSparse >= 5.2
# - Dlib (C++ library)
# - Dlib (Python 3 bindings)
# - SWIG >= 3
# - Elemental >= 0.87.7
# - LighBGM (command line version and Python bindings)
# - MuJoCo 1.9x, (fully set-up and licensed)
# - MuJoCo 2.00, (fully set-up and licensed; if installed together with 1.9x give preference to 2.00)
# - MATLAB >= 2014a (licensed)
# - GNU Octave
# - LibRAL (shared library)
# - UDPipe
# - FLANN
# - Facebook FAIR's FastText (shared libraries)
# - Blizzard's StarCraft II Linux binaries for AI (installed in ~/)
# - Unity3D engine for Linux (through the Unity Hub)
# - CERN's ROOT >= 6 (correctly installed and sourced)
# - The ROS (Robotics Open Source) suite, 'Melodic' version
# - Optimization software, i.e.:
#                                 * COIN-OR GLPK (recommended)
#                                 * Gurobi (recommended)
#                                 * MOSEK (recommended)
#                                 * DSDP (recommended)
#                                 * OSQP (recommended)
#                                 * ECOS (recommended)
#                                 * SCS (recommended)
#                                 * IBM CPLEX
#                                 * PDOS
#                                 * Whatever compatible with PyOMO and/or MATLAB, if installed.
##

##################################################
##            # User Configuration #            ##
##  (edit according to needs and system setup)  ##
##################################################

# General configuration
export SELF_CEACT_COMMAND="activate"                        # Command used to activate conda environments (usually "activate" as in "source activate ...")
export SELF_CONDA_ENV_PATH="$HOME/anaconda3/envs/"          # Path under which given command will create Anaconda environments (must be manually specified due to possible multiple conda environment folders)
export SELF_MATLABROOT_BASEDIR="/usr/local/MATLAB/R2018b/"  # Base directory of a MATLAB installation (>= 2014a, licensed). Whatever, if unavailable.
export SELF_TCMALLOC_INJECT="1"                             # 1 -> Preload TCMalloc in order to uniform Malloc(1) calls (recommended); 0 -> Do not preload TCMalloc (more stable, but prone to invalid free() with OpenCV/MxNet)

# Configuration for CVXOPT
export CVXOPT_GSL_LIB_DIR="/usr/lib/"           # Path to the directory that contains GNU Scientific Library shared libraries
export CVXOPT_GSL_INC_DIR="/usr/include/gsl/"   # Path to the directory that contains GNU Scientific Library include files
export CVXOPT_GLPK_LIB_DIR="/usr/lib/"          # Path to the directory that contains COIN-OR's GLPK shared libraries
export CVXOPT_GLPK_INC_DIR="/usr/include/"      # Path to the directory that contains COIN-OR's GLPK include files
export CVXOPT_DSDP_LIB_DIR="/usr/lib/"          # Path to the directory that contains DSDP shared libraries
export CVXOPT_DSDP_INC_DIR="/usr/include/dsdp/" # Path to the directory that contains DSDP include files
export CVXOPT_SUITESPARSE_LIB_DIR="/usr/lib/"   # Path to the directory that contains SuiteSparse shared libraries
export CVXOPT_SUITESPARSE_INC_DIR="/usr/local/include/suitesparse/" # Path to the directory that contains SuiteSparse include files
########################################################################################################################
########################################################################################################################


# Become location-aware
SELF_INVOKE_DIR="$(pwd)"


# Prepare local build directories
mkdir -p "$SELF_INVOKE_DIR/aistack/aistack-env"
mkdir -p "$SELF_INVOKE_DIR/aistack/aistack-env/dlfiles"


# Download files needed
cd "$SELF_INVOKE_DIR/aistack/aistack-env/dlfiles"
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/environment.yml
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/dot-condarc
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/c8c78db1d051c05b5f7e6b07f06bbd292a94b68b.patch
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/5f8585f34e07e2c016fcb4b0b16c3243b41e9c3e.patch
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/ab190f5dffcfdae305a6be29145d4eec3464d956.patch
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/requirements-nodeps-pt1.txt
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/requirements-nodeps-pt2.txt
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/requirements-nodeps-pt3.txt


###################
## CONDA INSTALL ##
###################

# Remove previous Conda environments related to AIStack and backup the last one
conda env remove -y -n aistack-old
rm -R -f "$SELF_CONDA_ENV_PATH/aistack-old"
mv "$SELF_CONDA_ENV_PATH/aistack" "$SELF_CONDA_ENV_PATH/aistack-old"
conda env remove -y -n aistack
rm -R -f "$SELF_CONDA_ENV_PATH/aistack"

# Create new environment and install Conda packages
echo ' '
conda env create -f ./environment.yml


########################
## PRE-PIP PROCEDURES ##
########################

# Tweak the Conda environment to work-around some bugs or enhance features
mv "$SELF_CONDA_ENV_PATH/aistack/.condarc" "$SELF_CONDA_ENV_PATH/aistack/.condarc.old"
mv ./dot-condarc "$SELF_CONDA_ENV_PATH/aistack/.condarc"
ln -s "$SELF_CONDA_ENV_PATH/aistack/lib/libwebp.so" "$SELF_CONDA_ENV_PATH/aistack/lib/libwebp.so.6"
ln -s "$SELF_CONDA_ENV_PATH/aistack/lib/libjasper.so" "$SELF_CONDA_ENV_PATH/aistack/lib/libjasper.so.1"

# Remove faulty/buggy Conda packages and force-reinstall others, if needed
source $SELF_CEACT_COMMAND aistack
echo ' '
conda remove -y cmake curl krb5 binutils_impl_linux-64 binutils_linux-64 gcc_impl_linux-64 gcc_linux-64 gxx_impl_linux-64 gxx_linux-64 gfortran_impl_linux-64 gfortran_linux-64 libuuid libgfortran mpich mpi --force
conda install -y boost-cpp==1.67 util-linux ipywebrtc libgcc=7.2.0 urllib3 libtool --force --no-deps
source deactivate

# Fix Kerberos-related bug (MXNet)
rm -R -f "$SELF_CONDA_ENV_PATH/aistack/bin/../lib/libkrb5.so.3"
rm -R -f "$SELF_CONDA_ENV_PATH/aistack/bin/../lib/libk5crypto.so.3"
rm -R -f "$SELF_CONDA_ENV_PATH/aistack/bin/../lib/libcom_err.so.3"
ln -s "/usr/lib/libcom_err.so" "$SELF_CONDA_ENV_PATH/aistack/bin/../lib/libcom_err.so.3"

# System-to-Conda command mirroring (remove part)
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/cmake"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/ccmake"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/gcc"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/gcc-7"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-gcc"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-cc"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/g++"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/g++-7"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-g++"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-c++"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/cpp"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-cpp"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/gfortran"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-f95"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-gfortran"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-fortran"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/curl"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/krb5kdc"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/krb5-send-pr"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/krb5-config"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/as"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/ld"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/gprof"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/addr2line"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/ar"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/c++filt"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/nm"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/objcopy"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/objdump"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/ranlib"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/readelf"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/size"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/strings"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/strip"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-as"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-ld"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-gprof"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-addr2line"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-ar"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-c++filt"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-nm"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-objcopy"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-objdump"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-ranlib"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-readelf"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-size"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-strings"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-strip"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/mpic++"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/mpicc"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/mpicxx"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/mpiexec"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/mpiexec.hydra"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/mpif77"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/mpif90"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/mpifort"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/mpirun"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/mpivars"

# System-to-Conda command mirroring (link part)
ln -s "$(which gcc-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/gcc"
ln -s "$(which gcc-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/gcc-7"
ln -s "$(which gcc-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-gcc"
ln -s "$(which gcc-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-cc"
ln -s "$(which g++-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/g++"
ln -s "$(which g++-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/g++-7"
ln -s "$(which g++-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-g++"
ln -s "$(which g++-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-c++"
ln -s "$(which cpp-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/cpp"
ln -s "$(which cpp-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-cpp"
ln -s "$(which gfortran)" "$SELF_CONDA_ENV_PATH/aistack/bin/gfortran"
ln -s "$(which gfortran)" "$SELF_CONDA_ENV_PATH/aistack/bin/gfortran-7"
ln -s "$(which gfortran)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-f95"
ln -s "$(which gfortran)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-gfortran"
ln -s "$(which gfortran)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-fortran"
ln -s "$(which cmake)" "$SELF_CONDA_ENV_PATH/aistack/bin/cmake"
ln -s "$(which ccmake)" "$SELF_CONDA_ENV_PATH/aistack/bin/ccmake"
ln -s "$(which curl)" "$SELF_CONDA_ENV_PATH/aistack/bin/curl"
ln -s "$(which krb5kdc)" "$SELF_CONDA_ENV_PATH/aistack/bin/krb5kdc"
ln -s "$(which krb5-send-pr)" "$SELF_CONDA_ENV_PATH/aistack/bin/krb5-send-pr"
ln -s "$(which krb5-config)" "$SELF_CONDA_ENV_PATH/aistack/bin/krb5-config"
ln -s "$(which as)" "$SELF_CONDA_ENV_PATH/aistack/bin/as"
ln -s "$(which ld)" "$SELF_CONDA_ENV_PATH/aistack/bin/ld"
ln -s "$(which gprof)" "$SELF_CONDA_ENV_PATH/aistack/bin/gprof"
ln -s "$(which addr2line)" "$SELF_CONDA_ENV_PATH/aistack/bin/addr2line"
ln -s "$(which ar)" "$SELF_CONDA_ENV_PATH/aistack/bin/ar"
ln -s "$(which c++filt)" "$SELF_CONDA_ENV_PATH/aistack/bin/c++filt"
ln -s "$(which nm)" "$SELF_CONDA_ENV_PATH/aistack/bin/nm"
ln -s "$(which objcopy)" "$SELF_CONDA_ENV_PATH/aistack/bin/objcopy"
ln -s "$(which objdump)" "$SELF_CONDA_ENV_PATH/aistack/bin/objdump"
ln -s "$(which ranlib)" "$SELF_CONDA_ENV_PATH/aistack/bin/ranlib"
ln -s "$(which readelf)" "$SELF_CONDA_ENV_PATH/aistack/bin/readelf"
ln -s "$(which size)" "$SELF_CONDA_ENV_PATH/aistack/bin/size"
ln -s "$(which strings)" "$SELF_CONDA_ENV_PATH/aistack/bin/strings"
ln -s "$(which strip)" "$SELF_CONDA_ENV_PATH/aistack/bin/strip"
ln -s "$(which as)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-as"
ln -s "$(which ld)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-ld"
ln -s "$(which gprof)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-gprof"
ln -s "$(which addr2line)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-addr2line"
ln -s "$(which ar)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-ar"
ln -s "$(which c++filt)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-c++filt"
ln -s "$(which nm)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-nm"
ln -s "$(which objcopy)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-objcopy"
ln -s "$(which objdump)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-objdump"
ln -s "$(which ranlib)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-ranlib"
ln -s "$(which readelf)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-readelf"
ln -s "$(which size)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-size"
ln -s "$(which strings)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-strings"
ln -s "$(which strip)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-strip"
ln -s "$(which mpic++)" "$SELF_CONDA_ENV_PATH/aistack/bin/mpic++"
ln -s "$(which mpicc)" "$SELF_CONDA_ENV_PATH/aistack/bin/mpicc"
ln -s "$(which mpicxx)" "$SELF_CONDA_ENV_PATH/aistack/bin/mpicxx"
ln -s "$(which mpiexec)" "$SELF_CONDA_ENV_PATH/aistack/bin/mpiexec"
ln -s "$(which mpif77)" "$SELF_CONDA_ENV_PATH/aistack/bin/mpif77"
ln -s "$(which mpif90)" "$SELF_CONDA_ENV_PATH/aistack/bin/mpif90"
ln -s "$(which mpifort)" "$SELF_CONDA_ENV_PATH/aistack/bin/mpifort"
ln -s "$(which mpirun)" "$SELF_CONDA_ENV_PATH/aistack/bin/mpirun"

# Improve the Conda environment for AIStack
mkdir -p "$SELF_CONDA_ENV_PATH/aistack/etc/conda/activate.d"
mkdir -p "$SELF_CONDA_ENV_PATH/aistack/etc/conda/deactivate.d"

export SELF_INTWDIR=$(pwd)
cd "$SELF_CONDA_ENV_PATH/aistack/etc/conda/activate.d"
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/tweakenv-activate.sh

# Catch TCMalloc injection request
if [ "$SELF_TCMALLOC_INJECT" = "1" ]; then
  echo "export LD_PRELOAD=\"$SELF_CONDA_ENV_PATH/aistack/lib/libtcmalloc_minimal.so\"" >> ./tweakenv-activate.sh
fi

cd "$SELF_CONDA_ENV_PATH/aistack/etc/conda/deactivate.d"
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/tweakenv-deactivate.sh
cd "$SELF_INTWDIR"


# Export necessary environment variables
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


######################
## PIP INSTALLATION ##
######################

# Activate Conda environment
source $SELF_CEACT_COMMAND aistack
mkdir -p "$SELF_INVOKE_DIR/aistack/aistack-env/gitpipdeps"

# Install the bindings to GSL for Cython
pip install --upgrade --no-deps git+https://github.com/twiecki/CythonGSL.git

# Install global PIP dependencies that need additional flags
echo ' '
CC="gcc-7 -mavx2" pip install --upgrade --no-deps --force-reinstall pillow-simd
echo ' '
USE_OPENMP=True pip install --upgrade --no-deps git+https://github.com/slinderman/pypolyagamma.git

# Install prerequisite libraries that need manual copy-paste
cd "$SELF_INVOKE_DIR/aistack/aistack-env/gitpipdeps"

export SELF_PYVRS="$(python -c 'import sys; print(sys.version[0])').$(python -c 'import sys; print(sys.version[2])')"

echo ' '
git clone --recursive https://github.com/kuangliu/torchcv.git
cp -R ./torchcv/torchcv "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'TorchCV successfully installed!'

echo ' '
git clone --recursive https://fleuret.org/git/agtree2dot
cp -R ./agtree2dot "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'AGTree2dot successfully installed!'

echo ' '
git clone --recursive https://github.com/openai/gradient-checkpointing.git
cp -R ./gradient-checkpointing "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'OpenAI Tensorflow Gradient Checkpointing successfully installed!'

echo ' '
git clone --recursive https://github.com/tensorflow/compression.git
cp -R ./compression/tensorflow_compression "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'Tensorflow Compression successfully installed!'

echo ' '
git clone --recursive https://github.com/akosiorek/data_tools.git
cp -R ./data_tools/data_tools "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'Kosiorek Data Tools successfully installed!'

echo ' '
git clone --recursive https://github.com/akosiorek/tf_tools.git
cp -R ./tf_tools/tf_tools "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'Kosiorek TF_Tools successfully installed!'

echo ' '
git clone --recursive https://github.com/slinderman/graphistician.git
cp -R ./graphistician/graphistician "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'Graphistician successfully installed!'

echo ' '
git clone https://github.com/mattjj/pyhsmm-subhmms.git
cp -R ./pyhsmm-subhmms "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'pyHSMM-subHSMM successfully installed!'

echo ' '
git clone --recursive https://github.com/Belval/TextRecognitionDataGenerator.git
cp -R ./TextRecognitionDataGenerator/TextRecognitionDataGenerator "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'TextRecognitionDataGenerator successfully installed!'

echo ' '
git clone --recursive https://github.com/cvxgrp/lass.git
cp -R ./lass/lass "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'LASS successfully installed!'

# Zoltán Szabó's ITE in Python - Install script (from scratch)
echo ' '
hg clone https://bitbucket.org/szzoli/ite-in-python
mv ./ite-in-python/demos ./ite-in-python/ite/demos
cp -R ./ite-in-python/ite "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'ITE in Python successfully installed!'

# Theano HessianFree script
echo ' '
git clone --recursive https://github.com/boulanni/theano-hf.git
mkdir -p "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/theano-hf"
cp -R ./theano-hf/hf.py "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/theano-hf/"
echo 'Theano HessianFree script successfully installed!'

# OptLearner
echo ' '
git clone --recursive https://github.com/mwaskom/optlearner.git
cp -R ./optlearner "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'OptLearner successfully installed!'

# MatchMaker
echo ' '
git clone --recursive https://github.com/mpdavis/matchmaker.git
cp -R ./matchmaker "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'MatchMaker successfully installed!'


# DE-activate Conda environment
echo ' '
source deactivate

# RE-activate Conda environment
source $SELF_CEACT_COMMAND aistack

cd "$SELF_INVOKE_DIR/aistack/aistack-env/dlfiles"

# Install PIP dependencies (in order) - 1st block
for reqline in $(cat requirements-nodeps-pt1.txt)
do
  pip install --upgrade --no-deps "$reqline"
  echo ' '
done

################################################################################
# Manually install some PIP packages that require additional flags - 1st block
pip install --upgrade --no-deps --pre mxnet-cu92mkl
echo ' '
pip install --upgrade --no-deps --pre gluoncv
echo ' '
pip install --upgrade --no-deps --pre gluonnlp
echo ' '
USE_OPENMP=True pip install --upgrade --no-deps git+https://github.com/slinderman/ssm.git
echo ' '
USE_OPENMP=TRUE pip install --upgrade --no-deps git+https://github.com/slinderman/pyhawkes.git
echo ' '
################################################################################

# Install PIP dependencies (in order) - 2nd block
for reqline in $(cat requirements-nodeps-pt2.txt)
do
  pip install --upgrade --no-deps "$reqline"
  echo ' '
done

################################################################################
# Manually install some packages that require an unconventional setup - 2nd block
cd "$SELF_INVOKE_DIR/aistack/aistack-env/gitpipdeps"
git clone --recursive https://github.com/jaberg/skdata.git
cd ./skdata
python ./setup.py install
cd ../
echo ' '

# BoostGDB
pip install --upgrade --no-deps --no-binary :all: lightgbm --install-option=--mpi --install-option=--gpu --install-option=--hdfs
echo ' '

# CudaMAT
git clone --recursive https://github.com/cudamat/cudamat.git
cd ./cudamat
pip install --upgrade --no-deps ./
cd ../
echo ' '

git clone --recursive https://github.com/automl/HPOlib-hpconvnet.git
mv ./HPOlib-hpconvnet ./hpconvnet
cp -R ./hpconvnet "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo "HPOlib HPConvNet successfully installed!"
echo ' '

# OpenFermion-Cirq (manual install; workaround)
git clone --recursive https://github.com/quantumlib/OpenFermion-Cirq.git
cd ./OpenFermion-Cirq
cp "$SELF_INVOKE_DIR/aistack/aistack-env/dlfiles/ab190f5dffcfdae305a6be29145d4eec3464d956.patch" ./
git apply ab190f5dffcfdae305a6be29145d4eec3464d956.patch
pip install --upgrade --no-deps ./
cd ../
echo ' '

# MSCOCO Tools and COCOAPI
git clone --recursive https://github.com/cocodataset/cocoapi.git
cd ./cocoapi/PythonAPI
make install
cd ../../

# theano_toolkit
echo ' '
git clone --recursive https://github.com/shawntan/theano_toolkit.git
cp -R ./theano_toolkit "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'theano_toolkit successfully installed!'

# act-tensorflow
echo ' '
git clone --recursive https://github.com/DeNeutoy/act-tensorflow.git
mv ./act-tensorflow/src ./act-tensorflow/act-tensorflow
cp -R ./act-tensorflow/act-tensorflow "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'act-tensorflow successfully installed!'

# keras_npi
echo ' '
git clone --recursive https://github.com/mokemokechicken/keras_npi.git
mv ./keras_npi/src ./keras_npi/keras_npi
cp -R ./keras_npi/keras_npi "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'keras_npi successfully installed!'

# ai-safety-gridworlds
echo ' '
git clone --recursive https://github.com/deepmind/ai-safety-gridworlds.git
mv ./ai-safety-gridworlds/ai_safety_gridworlds ./ai-safety-gridworlds/ai-safety-gridworlds
cp -R ./ai-safety-gridworlds/ai-safety-gridworlds "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS/site-packages/"
echo 'ai-safety-gridworlds successfully installed!'

## Manually install CVXOPT, CVXPY and related (must stay here and be 'manual') ##

# CVXOPT - Python module (custom install)
export CVXOPT_BUILD_GSL=1
export CVXOPT_BUILD_FFTW=1
export CVXOPT_BUILD_GLPK=1
export CVXOPT_BUILD_DSDP=1
export CVXOPT_MSVC=0
export CVXOPT_FFTW_LIB_DIR="$SELF_CONDA_ENV_PATH/aistack/lib/"
export CVXOPT_FFTW_INC_DIR="$SELF_CONDA_ENV_PATH/aistack/include/"
export CVXOPT_MKLLIB=mkl_rt
export CVXOPT_PREFIX_LIB="$SELF_CONDA_ENV_PATH/aistack/lib"
export CVXOPT_LAPACK_LIB="$CVXOPT_MKLLIB"
export CVXOPT_BLAS_LIB="$CVXOPT_MKLLIB"
export CVXOPT_BLAS_LIB_DIR="$PREFIX_LIB"
export CVXOPT_BLAS_EXTRA_LINK_ARGS="-L$PREFIX_LIB;-Wl,-rpath,$PREFIX_LIB;-l$CVXOPT_MKLLIB"

echo ' '
pip install --upgrade --no-deps git+https://github.com/cvxopt/cvxopt
echo ' '

# CHOMPACK - Extension to CVXOPT
pip install --upgrade --no-deps chompack
echo ' '

# SMCP - Extension to CVXOPT
pip install --upgrade --no-deps smcp
echo ' '

# ECOS - Python interface
pip install --upgrade --no-deps ecos
echo ' '

# SCS - Python interface for Python
pip install --upgrade --no-deps scs --no-binary :all:
echo ' '

# SCSprox - SCS Extension
pip install --upgrade --no-deps git+https://github.com/ajfriend/scsprox.git
echo ' '

# CVXportfolio - CVXPY Extension
pip install --upgrade --no-deps git+https://github.com/cvxgrp/cvxportfolio.git
echo ' '

# CVXPY - Full Python package
pip install --upgrade --no-deps git+https://github.com/cvxgrp/cvxpy.git
echo ' '

# CVXanon - CVXPY Extension
pip install --upgrade --no-deps git+https://github.com/cvxgrp/CVXcanon.git
echo ' '

# CVXflow - CVXPY Extension
pip install --upgrade --no-deps git+https://github.com/cvxgrp/cvxflow.git
echo ' '

# DCCP - CVXPY Extension
pip install --upgrade --no-deps git+https://github.com/cvxgrp/dccp.git
echo ' '

# CVXpower - CVXPY Extension
pip install --upgrade --no-deps git+https://github.com/cvxgrp/cvxpower.git
echo ' '

# Cone ProgRefine - CVXPY Extension
pip install --upgrade --no-deps git+https://github.com/cvxgrp/cone_prog_refine.git
echo ' '

# SigOPT - CVXPY Extension
pip install --upgrade --no-deps git+https://github.com/cvxgrp/sigopt.git
echo ' '

# PDOS - CVXPY Extension
git clone --recursive https://github.com/cvxgrp/pdos.git
cd ./pdos/python
python setup.py install
cd ../../
echo ' '

# MIOSQP
pip install --upgrade --no-deps git+https://github.com/oxfordcontrol/miosqp.git
echo ' '

# DYNET
pip install --upgrade --no-deps git+https://github.com/clab/dynet#egg=dynet
################################################################################

cd "$SELF_INVOKE_DIR/aistack/aistack-env/dlfiles"

# Install PIP dependencies (in order) - 3rd block
for reqline in $(cat requirements-nodeps-pt3.txt)
do
  pip install --upgrade --no-deps "$reqline"
  echo ' '
done

# DE-activate Conda environment
source deactivate


#########################
## POST-PIP PROCEDURES ##
#########################

# Activate Conda environment
source $SELF_CEACT_COMMAND aistack

cd "$SELF_INVOKE_DIR/aistack/aistack-env/gitpipdeps"

# Install PIP packages that need particular install procedures
git clone --recursive https://github.com/chobeat/hypothesis-csv.git
cd hypothesis-csv
cp "$SELF_INVOKE_DIR/aistack/aistack-env/dlfiles/5f8585f34e07e2c016fcb4b0b16c3243b41e9c3e.patch" ./
git apply 5f8585f34e07e2c016fcb4b0b16c3243b41e9c3e.patch
pip install --upgrade --no-deps .
cd ../

echo ' '
git clone --recursive https://github.com/Microsoft/TextWorld.git
cd TextWorld
cp "$SELF_INVOKE_DIR/aistack/aistack-env/dlfiles/c8c78db1d051c05b5f7e6b07f06bbd292a94b68b.patch" ./
git apply ./c8c78db1d051c05b5f7e6b07f06bbd292a94b68b.patch
pip install --upgrade --no-deps .
cd ../

echo ' '
export SELF_PREV_MNBUILD="$MN_BUILD"
export MN_BUILD=boost
git clone --recursive https://github.com/peter-ch/MultiNEAT.git
cd MultiNEAT
python setup.py build_ext
pip install --upgrade --no-deps .
export MN_BUILD="$SELF_PREV_MNBUILD"
cd ../
echo ' '

echo ' '
echo 'Installing Python-to-MATLAB interface...'
mkdir -p "$SELF_INVOKE_DIR/aistack/aistack-env/gitpipdeps/MATLAB-BUILDBASE"
cd "$SELF_MATLABROOT_BASEDIR/extern/engines/python"
python setup.py build --build-base="$SELF_INVOKE_DIR/aistack/aistack-env/gitpipdeps/MATLAB-BUILDBASE" install
cd "$SELF_INVOKE_DIR/aistack/aistack-env/gitpipdeps"
echo 'Python-to-MATLAB interface successfully installed!'

# Zalando Dilated RNN
echo ' '
export SELF_PYVRS_NEW="$(python -c 'import sys; print(sys.version[0])').$(python -c 'import sys; print(sys.version[2])')"
git clone --recursive https://github.com/zalandoresearch/pytorch-dilated-rnn.git
mv ./pytorch-dilated-rnn ./pytorch-drnn
cp -R ./pytorch-drnn "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_NEW/site-packages/"
echo 'Zalando Dilated RNN successfully installed!'

# PConv-Keras
echo ' '
git clone --recursive https://github.com/MathiasGruber/PConv-Keras.git
mv ./PConv-Keras/libs ./PConv-Keras/pconv-keras
cp -R ./PConv-Keras/pconv-keras "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_NEW/site-packages/"
echo 'PConv-Keras successfully installed!'

# SRGAN-Keras
echo ' '
git clone --recursive https://github.com/MathiasGruber/SRGAN-Keras.git
mv ./SRGAN-Keras/libs ./SRGAN-Keras/srgan-keras
cp -R ./SRGAN-Keras/srgan-keras "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_NEW/site-packages/"
echo 'SRGAN-Keras successfully installed!'


## Install PIP packages that are HEAVILY EXPERIMENTAL! [comment this block if you don't like surprises] ##
# START BLOCK: experimental packages

cd "$SELF_INVOKE_DIR/aistack/aistack-env"
mkdir ./experimental
cd ./experimental

export SELF_PYVRS_EXP="$(python -c 'import sys; print(sys.version[0])').$(python -c 'import sys; print(sys.version[2])')"

# Mirror (F. Zuppichini)
echo ' '
git clone --recursive https://github.com/FrancescoSaverioZuppichini/mirror.git
cp -R ./mirror/mirror "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'Mirror successfully installed!'

# tfLego (F. Zuppichini)
echo ' '
git clone --recursive https://github.com/FrancescoSaverioZuppichini/tfLego.git
mv ./tfLego/test ./tfLego/tfLego/
cp -R ./tfLego/tfLego/ "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'tfLego successfully installed!'

# pix2pix (A. Bessi)
echo ' '
git clone --recursive https://github.com/alessandrobessi/pix2pix.git
mv ./pix2pix/main.py ./pix2pix/pix2pix/
cp -R ./pix2pix/pix2pix "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'PyTorch pix2pix successfully installed!'

# FasterAI (J. Antic - ported version)
echo ' '
git clone --recursive https://github.com/jantic/Deep-Learning-Projects.git
touch ./Deep-Learning-Projects/fasterai/__init__.py
echo "# Just make it importable!" >> ./Deep-Learning-Projects/fasterai/__init__.py
cp -R ./Deep-Learning-Projects/fasterai "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'FasterAI successfully installed!'

# NVIDIA DALI
echo ' '
pip install --upgrade --no-deps --extra-index-url https://developer.download.nvidia.com/compute/redist nvidia-dali
echo 'NVIDIA DALI successfully installed!'

# marathon-envs (download)
echo ' '
git clone --recursive https://github.com/Unity-Technologies/marathon-envs.git

# Unity 3D agents for ML (download)
echo ' '
git clone --recursive https://github.com/Unity-Technologies/ml-agents.git

# marathon-envs (install)
cp -R ./marathon-envs/MarathonEnvs ./ml-agents/UnitySDK/Assets/
cp ./marathon-envs/config/marathon_envs_config.yaml ./ml-agents/UnitySDK/Assets/config/

# Unity 3D agents for ML (install)
echo ' '
cd ./ml-agents
# Not a duplicate!
cd ./ml-agents
pip install --upgrade --no-deps ./
cd ..
echo ' '
cd ./gym-unity
pip install --upgrade --no-deps ./
cd ..
# Not a duplicate!
cd ..
echo 'Unity 3D Agents for ML & Marathon Agents successfully installed!'

# # OpenAI Roboschool
# echo ' '
# git clone --recursive https://github.com/openai/roboschool.git
# cd roboschool
# git checkout newer_bullet_lib
# cd ../
# export ROBOSCHOOL_PATH="$(pwd)/roboschool"
# git clone --recursive https://github.com/bulletphysics/bullet3
# mkdir bullet3/build
# cd bullet3/build
# cmake -DBUILD_SHARED_LIBS=ON -DUSE_DOUBLE_PRECISION=1 -DCMAKE_INSTALL_PREFIX:PATH=$ROBOSCHOOL_PATH/roboschool/cpp-household/bullet_local_install -DBUILD_CPU_DEMOS=OFF -DBUILD_BULLET2_DEMOS=OFF -DBUILD_EXTRAS=ON -DBUILD_UNIT_TESTS=OFF -DBUILD_CLSOCKET=OFF -DBUILD_ENET=OFF -DBUILD_OPENGL3_DEMOS=OFF ../
# make -j8
# make install
# cd ../..
# pip install --upgrade --no-deps "$ROBOSCHOOL_PATH"

# PyTorch LibTorch for C++
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://download.pytorch.org/libtorch/nightly/cu92/libtorch-shared-with-deps-latest.zip
unzip ./libtorch-shared-with-deps-latest.zip
cd ./libtorch
cp -R -np ./* "$SELF_CONDA_ENV_PATH/aistack/"
cd ../

# END BLOCK: experimental packages


cd "$SELF_INVOKE_DIR/aistack/aistack-env"
echo ' '

# Download SpaCy data
python -m spacy download en
echo ' '
python -m spacy download fr
echo ' '
python -m spacy download it
echo ' '
python -m spacy download xx
echo ' '
pip install --no-deps https://github.com/huggingface/neuralcoref-models/releases/download/en_coref_md-3.0.0/en_coref_md-3.0.0.tar.gz
echo ' '

# Activate Jupyter Notebook and Lab extensions
echo ' '
echo "Installing and enabling additional Jupyter Notebook/Lab extensions..."
echo ' '
echo "You can safely ignore the following lines if they contain errors. They are expected."
echo ' '
sudo ipcluster nbextension enable
jupyter nbextension install --py ipyparallel
jupyter nbextension enable --py ipyparallel
jupyter nbextension install hinterland
jupyter nbextension enable hinterland/hinterland
jupyter nbextension enable --py qgrid
jupyter serverextension enable --py ipyparallel
jupyter serverextension enable --py jupyterlab
jupyter serverextension enable nteract_on_jupyter
jupyter serverextension enable --py nteract_on_jupyter
echo ' '
pip install --upgrade --no-deps jupyterlab-git
echo ' '
jupyter serverextension enable --py jupyterlab_git
jupyter labextension install @jupyter-widgets/jupyterlab-manager
jupyter labextension install dask-labextension
jupyter labextension install @jupyterlab/git
jupyter labextension install jupyterlab_bokeh
jupyter labextension install qgrid
echo "OK!"
echo ' '

# DE-activate Conda environment
source deactivate
########################################################################################################################
########################################################################################################################

#########################
## CONCLUSIVE MESSAGES ##
#########################

# Get current time for profiling purposes
cd "$SELF_INVOKE_DIR/aistack/aistack-env/dlfiles"
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/thankyou.txt

cd "$SELF_INVOKE_DIR"
echo ' '
echo ' '
echo "SUCCESS!"
echo ' '
echo ' '
echo "Temporary, local files will now be removed..."
rm -R -f "$SELF_INVOKE_DIR/aistack"
rm -f "$SELF_INVOKE_DIR/asrinit.sh"
echo "Done."
echo ' '
