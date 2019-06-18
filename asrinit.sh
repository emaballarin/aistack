#!/bin/bash
#############################################
###  AIStack, v. 3.11.6-002 (18/06/2019)  ###
#############################################
#
# A hacky-but-effective environment initialization toolkit for Anaconda, aimed
# at the broadest possible Machine Learning, Artificial Intelligence, Control
# and Optimization (and the interplay between them) research audience, developed
# following the principles of fast iterations, high performance, full control,
# and minimal(1) external (i.e. not automatically installed) dependencies.
#
# (1) What once was - indeed - minimal, then became larger and larger. Still,
# it's the `most minimal` possible for the given, very broad, requirements.
#
##
# (c) 2019 Emanuele Ballarin <emanuele@ballarin.cc>
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
# - Anaconda Python Distribution >= 4.6 (or equivalent, i.e. miniconda)
# - NVidia Graphics proprietary drivers >= 418 series
# - NVidia CUDA 10.1 (10.0/9.2 work too, but they are unsupported)
# - GNU Binutils >= 2.30 (EXCLUDED 2.31.0, but OK if >= 2.31.1)
# - GNU Compiler Suite v.7 (C/C++)
# - GNU Compiler Suite >= v.8 (C/C++/Fortran)
# - OpenMPI >= 3
# - OpenMP
# - Kitware's CMAKE >= 3.11
# - Curl >= 7 with HTTPS support.
# - WGet >= 1.19 with HTTPS support
# - Git >= 2.18
# - pkg-config
# - Google protocol buffers (protobuf/protoc) == 3.6.x
# - Google JSONnet
# - Rigetti Forest SDK (bare-bones, added to path)
# - Microsoft Q# infrastructure (and related dependencies)
#
# SOFTWARE REQUIREMENTS (optional, installed system-wide):
# - cmdSTAN (installed and sourced)
# - SuiteSparse >= 5.2
# - Dlib (C++ library)
# - Dlib (Python 3 bindings)
# - SWIG >= 3
# - Elemental >= 0.87.7
# - LighBGM (command line version)
# - MuJoCo 1.9x, (fully set-up and licensed)
# - MuJoCo 2.00, (fully set-up and licensed; if installed together with 1.9x, give preference to 2.00)
# - MATLAB >= 2014a (licensed)
# - Wolfram Mathematica >= 13
# - GNU Octave
# - LibRAL (shared library)
# - UDPipe
# - FLANN
# - Facebook FAIR's FastText (shared libraries)
# - Blizzard's StarCraft II Linux binaries for AI (installed in ~/)
# - Unity3D engine for Linux (installed through the Unity Hub)
# - CERN's ROOT >= 6 (installed and sourced)
# - Dyalog APL >= 16
# - Google OR Tools for C/C++/Java/.NET
# - A directory containing the /lib/ directory of a functioning CUDA 9.2 and 10.0 install
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
#                                 * Whatever compatible with PyOMO and/or MATLAB, if installed
# - All the necessary (or wanted, if optional) dependencies for the non-python components of FEniCS, i.e.:
#                                 * METIS & ParMETIS (recommended)
#                                 * SCOTCH & PT-SCOTCH (recommended)
#                                 * SuiteSparse >= 5.x (recommended)
#                                 * PETSc (recommended)
#                                 * SLEPc (optional)
##

##################################################
##            # User Configuration #            ##
##  (edit according to needs and system setup)  ##
##################################################

# General configuration
export SELF_CEACT_COMMAND="activate"                        # Command used to activate conda environments (usually "activate" as in "source activate ...")
export SELF_CONDA_ENV_PATH="$HOME/anaconda3/envs/"          # Path under which given command will create Anaconda environments (must be manually specified due to possible multiple conda environment folders)
export SELF_MATLABROOT_BASEDIR="/usr/local/MATLAB/R2019a/"  # Base directory of a MATLAB installation (>= 2014a, licensed). Whatever, if unavailable.
export SELF_TCMALLOC_INJECT="1"                             # 1 -> Preload TCMalloc in order to uniform Malloc(1) calls (recommended); 0 -> Do not preload TCMalloc (more stable, but prone to invalid free() with OpenCV/MxNet)
export SELF_SCHIZOCUDA_MODE="1"                             # 1 -> Enable the hybrid CUDA 10.1 / CUDA 10.0 / CUDA 9.2 / CUDA 9.0 mode (i.e. Pytorch on CUDA 10.1 and TensorFlow on CUDA 9.2)
export SELF_DO_INJECT_LIBTORCH="1"                          # 1 -> Enable forceful injection of Pytorch C/C++ libraries system-wide
export SELF_APPLY_CUDA_BANDAID="1"                          # 1 -> A dirty hack if system-CUDA is not 10.0.x (if in doubt, set to 0 BUT must have CUDA 10.0.x installed system-wide!)
export SELF_INSTALL_TF2_ENV="1"                             # 1 -> Create a new Conda environment containing a working TensorFlow 2.0 release and tooling
export SELF_PYTORCH_NIGHTLIFY="0"                           # 1 -> Use PyTorch nightly; 0 -> Use PyTorch stable (recommended!).

# Configuration for CVXOPT
export CVXOPT_GSL_LIB_DIR="/usr/lib/"           # Path to the directory that contains GNU Scientific Library shared libraries
export CVXOPT_GSL_INC_DIR="/usr/include/gsl/"   # Path to the directory that contains GNU Scientific Library include files
export CVXOPT_GLPK_LIB_DIR="/usr/lib/"          # Path to the directory that contains COIN-OR's GLPK shared libraries
export CVXOPT_GLPK_INC_DIR="/usr/include/"      # Path to the directory that contains COIN-OR's GLPK include files
export CVXOPT_DSDP_LIB_DIR="/usr/lib/"          # Path to the directory that contains DSDP shared libraries
export CVXOPT_DSDP_INC_DIR="/usr/include/dsdp/" # Path to the directory that contains DSDP include files
export CVXOPT_SUITESPARSE_LIB_DIR="/usr/lib/"   # Path to the directory that contains SuiteSparse shared libraries
export CVXOPT_SUITESPARSE_INC_DIR="/usr/local/include/suitesparse/" # Path to the directory that contains SuiteSparse include files

# Configuration for optional SCHIZOCUDA_MODE
export SELF_SCHIZOCUDA_MODE_CU92F="/home/emaballarin/cuda92libstrip/"   # Path to a directory containing the /lib/ directory of a functioning CUDA 10.0/9.2/9.0 install, without

# Configuration for optional PyTorch Libraries (i.e. LibTorch) injection
export SELF_LIBTORCH_ROOT_DIR="/opt/"                                   # The path inside which PyTorch libraries will be forcefully injected. Automatically deletes libtorch sub-directory beforehand.

# Configuration for CUDA Band-Aid
export SELF_CUDA_BANDAID_FAKEROOT="/opt/portablecuda/10.0.130/"         # The path to the artfully-crafted CUDA Band-Aid (CUDA+CUDNN+NCCL, relinked)
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
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/4b95ec184c55cbd9de462ea2de8b8082cd35ab5d.patch
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/ab190f5dffcfdae305a6be29145d4eec3464d956.patch
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/requirements-nodeps-pt1.txt
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/requirements-nodeps-pt1-bis.txt
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
conda remove -y cmake curl krb5 binutils_impl_linux-64 binutils_linux-64 gcc_impl_linux-64 gcc_linux-64 gxx_impl_linux-64 gxx_linux-64 gfortran_impl_linux-64 gfortran_linux-64 libuuid libgfortran mpich mpi jpeg libtiff --force
conda install -y boost-cpp==1.67 util-linux libgcc urllib3 libtool libjpeg-turbo --force --no-deps
# NOTE: PyDAAL is deprecated. Putting it here as a band-aid.
conda install -y pydaal --force --no-deps
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
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/gcc-8"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-gcc"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-cc"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/g++"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/g++-7"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/g++-8"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-g++"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-c++"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/cpp"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-cpp"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/gfortran"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/gfortran-7"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/gfortran-8"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-f95"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-gfortran"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-fortran"
rm -f "$SELF_CONDA_ENV_PATH/aistack/bin/curl"
rm -f "$SELF_CONDA_ENV_PATH/aistack/lib/libcurl.so.4.5.0"
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
rm -f "$SELF_CONDA_ENV_PATH/aistack/compiler_compat/ld"

# System-to-Conda command mirroring (link part)
ln -s "$(which gcc-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/gcc"
ln -s "$(which gcc-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/gcc-7"
ln -s "$(which gcc-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/gcc-8"
ln -s "$(which gcc-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-gcc"
ln -s "$(which gcc-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-cc"
ln -s "$(which g++-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/g++"
ln -s "$(which g++-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/g++-7"
ln -s "$(which g++-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/g++-8"
ln -s "$(which g++-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-g++"
ln -s "$(which g++-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-c++"
ln -s "$(which cpp)" "$SELF_CONDA_ENV_PATH/aistack/bin/cpp"
ln -s "$(which cpp)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-cpp"
ln -s "$(which gfortran-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/gfortran"
ln -s "$(which gfortran-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/gfortran-7"
ln -s "$(which gfortran-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/gfortran-8"
ln -s "$(which gfortran-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-f95"
ln -s "$(which gfortran-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-gfortran"
ln -s "$(which gfortran-7)" "$SELF_CONDA_ENV_PATH/aistack/bin/x86_64-conda_cos6-linux-gnu-fortran"
ln -s "$(which cmake)" "$SELF_CONDA_ENV_PATH/aistack/bin/cmake"
ln -s "$(which ccmake)" "$SELF_CONDA_ENV_PATH/aistack/bin/ccmake"
ln -s "$(which curl)" "$SELF_CONDA_ENV_PATH/aistack/bin/curl"
ln -s "/usr/lib/libcurl.so.4.5.0" "$SELF_CONDA_ENV_PATH/aistack/lib/libcurl.so.4.5.0"
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
ln -s "$(which ld)" "$SELF_CONDA_ENV_PATH/aistack/compiler_compat/ld"

###
# Hacks for Theano forward-compatibility
mkdir -p ./bandfixes
cd ./bandfixes
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/bandfixes/dnn.py
chmod +x ./dnn.py
mkdir -p "$SELF_CONDA_ENV_PATH/aistack/lib/python3.6/site-packages/theano/gpuarray"
cp -f ./dnn.py "$SELF_CONDA_ENV_PATH/aistack/lib/python3.6/site-packages/theano/gpuarray/"
cd ../
###

###
# Inject libhdfs.so (from Apache Hadoop 3.1.x)
mkdir -p ./bandfixes
cd ./bandfixes
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/bandfixes/libhdfs.so.0.0.0
mkdir -p "$SELF_CONDA_ENV_PATH/aistack/lib/"
cp -f ./libhdfs.so.0.0.0 "$SELF_CONDA_ENV_PATH/aistack/lib/"
ln -s -f "$SELF_CONDA_ENV_PATH/aistack/lib/libhdfs.so.0.0.0" "$SELF_CONDA_ENV_PATH/aistack/lib/libhdfs.so"
cd ../
###

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

# Catch Hybrid CUDA 10/9.2 mode
if [ "$SELF_SCHIZOCUDA_MODE" = "1" ]; then
  if [ "$SELF_SCHIZOCUDA_MODE_CU92F" = "UNSET" ]; then
    unset SELF_SCHIZOCUDA_MODE_CU92F
  else
    echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:$SELF_SCHIZOCUDA_MODE_CU92F\"" >> ./tweakenv-activate.sh
  fi
fi

cd "$SELF_CONDA_ENV_PATH/aistack/etc/conda/deactivate.d"
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/tweakenv-deactivate.sh
cd "$SELF_INTWDIR"


##
## Fiddle with Anaconda for the last time: remove Conda-installed Tensorflow; replace PyTorch with PyTorch Nightly
##

source $SELF_CEACT_COMMAND aistack

# Install optimized TensorFlow wheels (remove conda duplicates)
conda remove -y tensorflow tensorflow-base tensorflow-estimator tensorflow-gpu protobuf --force

# Drop-in replace Protocol Buffers
pip install --upgrade --no-deps protobuf

# Fix the ruamel.yaml problem
conda remove -y ruamel_yaml --force
pip install --upgrade --no-deps ruamel_yaml

# Remove (old) PyTorch and affected dependencies
conda remove -y pytorch _r-mutex --force

# INSTALL THE "FINAL" VERSION OF PYTORCH
echo ' '
echo "Installing PyTorch (for real, this time!)..."
if [ "$SELF_PYTORCH_NIGHTLIFY" = "1" ]; then
  conda install -y pytorch-nightly cudatoolkit=10.0.130 -c pytorch
elif [ "$SELF_PYTORCH_NIGHTLIFY" = "0" ]; then
  conda install -y pytorch=1.1 cudatoolkit=10.0.130 -c pytorch
else
  echo "Invalid value specified for SELF_PYTORCH_NIGHTLIFY. Assuming 0 (stable version)."
  conda install -y pytorch=1.1 cudatoolkit=10.0.130 -c pytorch
fi
echo ' '

# Remove useless _r-mutex and other stuff
conda remove -y _r-mutex cudatoolkit cudnn nccl nccl2 --force

if [ "$SELF_APPLY_CUDA_BANDAID" = "1" ]; then
  if [ "$SELF_CUDA_BANDAID_FAKEROOT" != "" ]; then
    echo ' '
    export SELF_CALLDIR_CUDA_BANDAID="$(pwd)"
    echo "Appying the CUDA Band-Aid..."
    cp -R -np $SELF_CUDA_BANDAID_FAKEROOT/* "$SELF_CONDA_ENV_PATH/aistack/"
    ln -s ../../../lib64/libcudnn.so "$SELF_CONDA_ENV_PATH/aistack/x86_64-conda_cos6-linux-gnu/sysroot/lib/libcudnn.so"
    cd "$SELF_CONDA_ENV_PATH/aistack/etc/conda/activate.d"
    echo "export CUDA_HOME=\"$SELF_CONDA_ENV_PATH/aistack/\"" >> ./tweakenv-activate.sh
    cd "$SELF_CALLDIR_CUDA_BANDAID"
    echo "OK!"
    echo ' '
  fi
fi

# Re-install _r-mutex
conda install -y _r-mutex

# Install (eventually) PyTorch libraries
echo ' '
echo "Installing PyTorch libraries (if any)..."
if [ "$SELF_PYTORCH_NIGHTLIFY" = "1" ]; then
  echo "INSTALLING: YES (Nightly)."
  # Unpack and install LibTorch C++ libraries
  echo ' '
  rm -R -f ./PTLTDL
  mkdir ./PTLTDL
  cd ./PTLTDL
  wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://download.pytorch.org/libtorch/nightly/cu100/libtorch-shared-with-deps-latest.zip
  echo "Installing PyTorch libraries (Nightly)..."
  unzip ./libtorch-shared-with-deps-latest.zip
  cd ./libtorch
  cp -R -np ./* "$SELF_CONDA_ENV_PATH/aistack/"
  cd ../
  echo 'OK!'
  echo ' '

  # Optionally inject unpacked LibTorch C++ libraries (as Super User)
  if [ "$SELF_DO_INJECT_LIBTORCH" = "1" ]; then
    if [ "$SELF_LIBTORCH_ROOT_DIR" != "" ]; then
      sudo rm -R -f "$SELF_LIBTORCH_ROOT_DIR/libtorch"
      echo ' '
      echo "Injecting PyTorch libraries (Nightly)..."
      sudo cp -R -f ./libtorch "$SELF_LIBTORCH_ROOT_DIR"
      echo "OK!"
    fi
  fi
elif [ "$SELF_PYTORCH_NIGHTLIFY" = "0" ]; then
  echo "INSTALLING: YES (Stable)."
  # Unpack and install LibTorch C++ libraries
  echo ' '
  rm -R -f ./PTLTDL
  mkdir ./PTLTDL
  cd ./PTLTDL
  wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://download.pytorch.org/libtorch/cu100/libtorch-shared-with-deps-latest.zip
  echo "Installing PyTorch libraries (Stable)..."
  unzip ./libtorch-shared-with-deps-latest.zip
  cd ./libtorch
  cp -R -np ./* "$SELF_CONDA_ENV_PATH/aistack/"
  cd ../
  echo 'OK!'
  echo ' '

  # Optionally inject unpacked LibTorch C++ libraries (as Super User)
  if [ "$SELF_DO_INJECT_LIBTORCH" = "1" ]; then
    if [ "$SELF_LIBTORCH_ROOT_DIR" != "" ]; then
      sudo rm -R -f "$SELF_LIBTORCH_ROOT_DIR/libtorch"
      echo ' '
      echo "Injecting PyTorch libraries (Stable)..."
      sudo cp -R -f ./libtorch "$SELF_LIBTORCH_ROOT_DIR"
      echo "OK!"
    fi
  fi
else
  echo "Invalid value specified for SELF_PYTORCH_NIGHTLIFY. Assuming 0 (stable version)."
  echo "INSTALLING: NO."
fi

echo ' '

cd ../
source deactivate
cd "$SELF_INTWDIR"
########################################################################################################################
########################################################################################################################

# Export necessary environment variables
export MPI_C_COMPILER=mpicc
export MPI_CXX_COMPILER=mpicxx
export MPI_Fortran_COMPILER=mpifort
export MPI_FORTRAN_COMPILER=mpifort
export MPI_FC_COMPILER=mpifort
export CC=gcc
export CXX=g++
export FC=gfortran
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
CC="gcc-7 -mavx2" pip install --no-cache-dir --upgrade --no-deps --force-reinstall --no-binary :all: --compile pillow-simd
echo ' '
# Not a duplicate: it is a form of safety-net in case of (frequent) download problems
USE_OPENMP=True pip install --upgrade --no-deps git+https://github.com/slinderman/pypolyagamma.git
USE_OPENMP=True pip install --upgrade --no-deps git+https://github.com/slinderman/pypolyagamma.git

# Install TensorFlow 1.13.1 and dependencies (and reinstall Protobuf)
# Install optimized TensorFlow wheels (actually install)
pip install --upgrade --no-deps ortools
pip install --upgrade --no-deps google_pasta
pip install --upgrade --no-deps git+https://github.com/keras-team/keras-applications.git
pip install --upgrade --no-deps git+https://github.com/keras-team/keras-preprocessing.git
pip install --upgrade --no-deps tensorboard
pip install --upgrade --no-deps https://github.com/inoryy/tensorflow-optimized-wheels/releases/download/v1.13.1/tensorflow-1.13.1-cp36-cp36m-linux_x86_64.whl
pip install --upgrade --no-deps tensorflow_estimator

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

# Install PIP dependencies (in order) - 0th block
for reqline in $(cat requirements-nodeps-pt1.txt)
do
  pip install --upgrade --no-deps "$reqline"
  echo ' '
done

################################################################################
# Manually install some PIP packages that require additional flags - 0th block
export SELF_PREVIOUS_MAKEFLAGS="$MAKEFLAGS"
export CHAINER_BUILD_CHAINERX=1
export CHAINERX_BUILD_CUDA=1
export MAKEFLAGS=-j8
pip install --upgrade --no-deps --pre cupy-cuda100
echo ' '
pip install --upgrade --no-deps --pre ideep4py
echo ' '
pip install --upgrade --no-deps --pre --force chainer
echo ' '
pip install --upgrade --no-deps --pre chainercv
echo ' '
pip install --upgrade --no-deps --pre chainerrl
echo ' '
pip install --upgrade --no-deps --pre onnx-chainer
echo ' '
pip install --upgrade --no-deps --pre chainerui
echo ' '
export MAKEFLAGS="$SELF_PREVIOUS_MAKEFLAGS"
################################################################################

# Install PIP dependencies (in order) - 1st block
for reqline in $(cat requirements-nodeps-pt1-bis.txt)
do
  pip install --upgrade --no-deps "$reqline"
  echo ' '
done

################################################################################
# Manually install some PIP packages that require additional flags - 1st block
pip install --upgrade --no-deps --pre mxnet-cu100mkl
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
pip install --force --upgrade --no-deps --no-binary :all: lightgbm --install-option=--mpi --install-option=--gpu --install-option=--hdfs
echo ' '

# CudaMAT
git clone --recursive https://github.com/emaballarin/cudamat.git
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

#DWave drivers
pip install --upgrade --extra-index-url https://pypi.dwavesys.com/simple --no-deps dwave-drivers
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

# XACC
pip install --upgrade --no-deps --force-reinstall xacc
#pip install --upgrade --no-deps --force-reinstall git+https://github.com/ORNL-QCI/xacc-vqe.git

## Install PIP packages that need particular install procedures
git clone --recursive https://github.com/emaballarin/hypothesis-csv-chobeat.git
cd hypothesis-csv-chobeat
cp "$SELF_INVOKE_DIR/aistack/aistack-env/dlfiles/4b95ec184c55cbd9de462ea2de8b8082cd35ab5d.patch" ./
git apply 4b95ec184c55cbd9de462ea2de8b8082cd35ab5d.patch
pip install --upgrade --no-deps .
cd ../

echo ' '
pip install --upgrade --no-deps git+https://github.com/fbcotter/py3nvml#egg=py3nvml

echo ' '
pip install --upgrade --no-deps https://h2o-release.s3.amazonaws.com/h2o/master/4705/Python/h2o-3.25.0.4705-py2.py3-none-any.whl

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
# Boost compatibility (below)
git checkout 0c3e21f
python setup.py build_ext
python setup.py install
pip install --upgrade --no-deps .
pip install --upgrade --no-deps --force-reinstall .
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

# Dyalog APL Kernel for Jupyter (package)
echo ' '
git clone --recursive https://github.com/Dyalog/dyalog-jupyter-kernel.git
cp -R ./dyalog-jupyter-kernel/dyalog_kernel "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'Dyalog APL Jupyter Kernel package successfully installed!'

echo ' '
git clone --recursive https://github.com/nschaetti/Oger.git
cp -R ./Oger "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'Oger successfully installed!'

### NEAT STUFF (still part of experimental packages) ###

echo ' '
git clone https://github.com/nickwilliamsnewby/PyTorch-NEAT.git --recursive --branch es-hyperneat --single-branch --depth 1
cd ./PyTorch-NEAT
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/aistack-env/008d4d7a694c75a4633e27c657d3cc2aaabcae88.patch
git apply ./008d4d7a694c75a4633e27c657d3cc2aaabcae88.patch
cp -R ./pytorch_neat "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/uber_pytorch_neat"
cd ..
echo 'Uber`s PyTorch NEAT successfully installed!'

echo ' '
git clone --recursive https://github.com/crisbodnar/TensorFlow-NEAT.git
cp -R ./TensorFlow-NEAT/tf_neat "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'TensorFlow Eager NEAT successfully installed!'

echo ' '
git clone --recursive https://github.com/flxsosa/DeepHyperNEAT.git
rm -R -f ./DeepHyperNEAT/reports ./DeepHyperNEAT/.gitignore ./DeepHyperNEAT/.gitignore
cp -R ./DeepHyperNEAT "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'DeepHyperNEAT successfully installed!'

echo ' '

git clone https://github.com/nickwilliamsnewby/peas.git --recursive --branch crypto_edition --single-branch --depth 1
cd ./peas
cp -R ./peas "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
cd ..
echo 'Peas, new version, successfully installed!'

### ### ### ### ###

echo ' '
git clone --recursive https://github.com/google-research/google-research.git
cp -R ./google-research "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'Google AI Research Internal Open Codebase successfully installed! [aistack]'

echo ' '
git clone --recursive https://github.com/MatthewJA/Inverse-Reinforcement-Learning.git
mv ./Inverse-Reinforcement-Learning/irl ./Inverse-Reinforcement-Learning/matthewja-irl
cp -R ./Inverse-Reinforcement-Learning/matthewja-irl "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'Matthew Alger InverseRL Toolbox successfully installed!'

echo ' '
git clone --recursive https://github.com/VowpalWabbit/estimators.git
mv ./estimators ./vw-estimators
touch ./vw-estimators/__init__.py
echo "# Just make it importable!" >> ./vw-estimators/__init__.py
cp -R ./vw-estimators "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'Vowpal Wabbit RL estimators successfully installed!'

# Tensor2Robot (Alphabet/Google)
echo ' '
git clone --recursive https://github.com/google-research/tensor2robot.git
cp -R ./tensor2robot "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'Alphabet tensor2robot successfully installed!'

# MetaOptNet
echo ' '
git clone --recursive https://github.com/kjunelee/MetaOptNet.git
cp -R ./MetaOptNet "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'MetaOptNet successfully installed!'

# LoveLab (dimensionality)
echo ' '
git clone --recursive https://github.com/lovelabUCL/dimensionality.git
cd ./dimensionality/Python/FunctionalDimensionality
pip install --upgrade --no-deps ./
cd ..
cd ..
cd ..
echo 'LoveLab Dimensionality successfully installed!'

# Amazon Meta-Learning
echo ' '
git clone --recursive https://github.com/amzn/metalearn-leap.git
cd ./metalearn-leap/src
cd ./leap
pip install --upgrade --no-deps ./
cd ..
echo 'Amazon Leap MetaLearner successfully installed!'
echo ' '
cd ./maml
pip install --upgrade --no-deps ./
cd ..
cd ../
cd ../
echo 'Amazon MAML successfully installed!'

# Overwrite Microsoft project Malmo (gym env version)
echo ' '
git clone --recursive https://github.com/microsoft/malmo.git
cd ./malmo/MalmoEnv/
pip install --upgrade --no-deps ./
cd ..
cd ..
echo 'MalmoEnv successfully updated!'

# Lambert ELM
echo ' '
git clone --recursive https://github.com/dclambert/Python-ELM.git
touch ./Python-ELM/__init__.py
echo "# Just make it importable!" >> ./Python-ELM/__init__.py
cp -R ./Python-ELM "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/dclambert-elm"
echo 'Lambert^s ELM successfully installed!'

# pyESN
echo ' '
git clone --recursive https://github.com/cknd/pyESN.git
touch ./pyESN/__init__.py
echo "# Just make it importable!" >> ./pyESN/__init__.py
cp -R ./pyESN "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'pyESN successfully installed!'

# EasyESN - tweaked
echo ' '
git clone --recursive https://github.com/emaballarin/easyesn.git
pip install --upgrade --no-deps ./easyesn/src/easyesn/
echo 'EasyESN successfully installed!'

# Bee (LSN)
echo ' '
git clone --recursive https://github.com/ricardodeazambuja/Bee.git
pip install --upgrade --no-deps ./Bee/BEE/
echo 'Bee successfully installed!'

echo ' '
git clone --recursive https://github.com/filipradenovic/cnnimageretrieval-pytorch.git
cp -R ./cnnimageretrieval-pytorch/cirtorch "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'CIRTorch successfully installed!'

# chimera0 (manual fiddling!)
echo ' '
git clone --recursive https://github.com/chimera0/accel-brain-code.git
## pygan
echo ' '
cd ./accel-brain-code/Generative-Adversarial-Networks
pip install --upgrade --no-deps ./
cd ../..
## pyqlearning
echo ' '
cd ./accel-brain-code/Reinforcement-Learning
pip install --upgrade --no-deps ./
cd ../..
## pydbm
echo ' '
cd ./accel-brain-code/Deep-Learning-by-means-of-Design-Pattern
pip install --upgrade --no-deps ./
cd ../..

# QUPa
echo ' '
pip install --upgrade --no-deps --force https://try.quadrant.ai/hubfs/QuPA/qupa-0.1+tf16-py2.py3-none-linux_x86_64.whl

# vene SSA
echo ' '
git clone --recursive https://github.com/vene/sparse-structured-attention.git
pip install --upgrade --no-deps ./sparse-structured-attention/pytorch/
echo 'vene SSA successfully installed!'

# Angeletti - LoAd
echo ' '
git clone --recursive https://github.com/blackecho/LoAd-Network.git
cp -R ./LoAd-Network/load_network_pytorch "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo 'LoAd successfully installed!'

# Gridworld Visualizer (Chanlatte)
echo ' '
git clone --recursive https://github.com/mvcisback/gridworld-visualizer.git
pip install --upgrade --no-deps ./gridworld-visualizer/gridworld_vis/
echo 'Chanlatte^s Gridworld Visualizer successfully installed!'

# Unity ML-Agents
echo ' '
git clone https://github.com/Unity-Technologies/ml-agents.git --recursive --branch master --single-branch --depth 1
cd ./ml-agents
echo ' '
cd ./ml-agents-envs
pip install --upgrade --no-deps ./
cd ..
echo ' '
cd ./ml-agents
pip install --upgrade --no-deps ./
cd ..
echo ' '
cd ./gym-unity
pip install --upgrade --no-deps ./
cd ..
cd ..
echo 'Unity ML Agents successfully installed (3 packages)!'

# Ganguli's Complex Synapse module
echo ' '
git clone https://github.com/ganguli-lab/Complex_Synapse.git --recursive --branch master --single-branch --depth 1
cp -R ./Complex_Synapse/Code/Python/complex_synapse "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo "Ganguli's Complex Synapse successfully installed!"

# Python Tricks Repository
echo ' '
git clone https://github.com/subhylahiri/sl_py_tools.git --recursive --branch master --single-branch --depth 1
cp -R ./sl_py_tools "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo "SL PyTools successfully installed!"

# Invertible ResNet (Duvenaud)
echo ' '
git clone https://github.com/jhjacobsen/invertible-resnet.git --recursive --branch master --single-branch --depth 1
cp -R ./invertible-resnet "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo "Invertible ResNet successfully installed!"

# Raccoon (MILA)
echo ' '
git clone https://github.com/adbrebs/raccoon.git --recursive --branch master --single-branch --depth 1
cp -R ./raccoon/raccoon "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo "Raccoon successfully installed!"

# DeepMind Hanabi LE
echo ' '
git clone https://github.com/deepmind/hanabi-learning-environment.git --recursive --branch master --single-branch --depth 1
cp -R ./hanabi-learning-environment "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo "DeepMind Hanabi Learning Environment successfully installed"

echo ' '
git clone https://github.com/eth-sri/diffai.git --recursive --branch master --single-branch --depth 1
cp -R ./diffai "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo "DiffAI successfully installed"

echo ' '
git clone https://github.com/eth-sri/dp-finder.git --recursive --branch master --single-branch --depth 1
cp -R ./dp-finder/dpfinder "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/"
echo "DPFinder successfully installed"

# Final, stupid fixup
mv "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/skcuda/cublas.py" "$SELF_CONDA_ENV_PATH/aistack/lib/python$SELF_PYVRS_EXP/site-packages/skcuda/cublas.py.old"


# END BLOCK: experimental packages
echo ' '


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
jupyter nbextension install --overwrite --py nbtutor
jupyter nbextension enable --py nbtutor
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
jupyter labextension install @pyviz/jupyterlab_pyviz
# Twice, because the first time it likely fails (no rational reason why!)
jupyter labextension install nbgather
jupyter labextension install nbgather
echo "OK!"
echo ' '

# DE-activate Conda environment
source deactivate

# Tweak to make the Python-in-CondaEnv callable from outside directly
export SELF_PRECALL_PYCALLABLE="$(pwd)"
cd "$SELF_CONDA_ENV_PATH/aistack/bin"
mkdir -p ./aistack-callable
cd ./aistack-callable
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/bandfixes/python
SED_SUBF1="XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"
SED_SUBT1="$SELF_CONDA_ENV_PATH/aistack/bin/python"
sed -i "s@$SED_SUBF1@$SED_SUBT1@" ./python
chmod +x ./python
cd "$SELF_PRECALL_PYCALLABLE"


##########################
##    TENSORFLOW 2.0    ##
##########################
if [ "$SELF_INSTALL_TF2_ENV" = "1" ]; then
  echo ' '
  # Fully self-contained!
  wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/tf2/tf2-init.sh
  chmod +x ./tf2-init.sh
  ./tf2-init.sh
  echo ' '
fi

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
echo ' '
echo ' '
echo '#########################################################################'
echo ' '
echo 'You may need to reinstall Chainer, Hafnian and JSONnet.'
echo 'Just run the following code block in the terminal:'
echo ' '
echo 'source activate aistack'
echo 'export CHAINER_BUILD_CHAINERX=1'
echo 'export CHAINERX_BUILD_CUDA=1'
echo 'export MAKEFLAGS=-j8'
echo 'pip install --upgrade --no-deps --pre --force chainer'
echo 'pip install --upgrade --no-deps jsonnet'
echo 'pip install --upgrade --no-deps git+https://github.com/XanaduAI/hafnian.git'
echo 'source deactivate'
echo ' '
echo '#########################################################################'
echo ' '
echo ' '
echo '#########################################################################'
echo ' '
echo "You may also need to install manually:"
echo " - Dolfin (with Python bindings), part of the FEniCS suite;"
echo " - mshr (with Python bindings), optional, part of the FEniCS suite;"
echo "We have already cloned the necessary repositories for you! ;-)"
echo ' '
echo 'Just run the following code block in the terminal, after the cloning occurs:'
echo ' '
echo 'source activate aistack'
echo 'cd ./dolfin/python'
echo 'pip install --upgrade --no-deps ./'
echo 'cd ..'
echo 'cd ..'
echo 'cd ./mshr/python'
echo 'pip install --upgrade --no-deps ./'
echo 'source deactivate'
echo ' '
echo '#########################################################################'
echo ' '
git clone --recursive https://bitbucket.org/fenics-project/dolfin.git
cd ./dolfin
git checkout 2019.1.0.post0
cd ..
git clone --recursive https://bitbucket.org/fenics-project/mshr.git
cd ./mshr
git checkout 2019.1.0
cd ..
echo ' '
echo ' '
echo '#########################################################################'
echo ' '
echo 'Please, note that any error in the form of:'
echo ' '
echo 'ERROR: You must give at least one requirement to install (see "pip help install")'
echo 'or similar'
echo ' '
echo 'IS EXPECTED AND HAS NOT TO BE FIXED. It is just the reaction of the pip-install'
echo 'to commented package names in the package lists.'
echo ' '
echo '#########################################################################'
echo ' '
echo ' '
echo ' '
