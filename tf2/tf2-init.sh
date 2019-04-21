#!/bin/bash
##############################################
### AIStack, TensorFlow 2.0 initialization ###
##############################################
##
# (c) 2019 Emanuele Ballarin <emanuele@ballarin.cc>
# Released under the Apache License 2.0.
##
# This file is called by some other one as:
# chmod +x ./tf2-init.sh
# ./tf2-init.sh
##

# General configuration (edit as needed!)
export SELFTF2_CEACT_COMMAND="activate"                 # Command used to activate conda environments (usually "activate" as in "source activate ...")
export SELFTF2_CONDA_ENV_PATH="$HOME/anaconda3/envs/"   # Path under which given command will create Anaconda environments (must be manually specified due to possible multiple conda environment folders)
export SELFTF2_APPLY_CUDA_BANDAID="1"                   # 1 -> A dirty hack if system-CUDA is not 10.0.x (if in doubt, set to 0 BUT must have CUDA 10.0.x installed system-wide!)
export SELFTF2_CUDA_BANDAID_FAKEROOT="/opt/portablecuda/10.0.130/" # The path to the artfully-crafted CUDA Band-Aid (CUDA+CUDNN+NCCL, relinked)

# Become location-aware
export SELFTF2_CALLDIR="$(pwd)"

# Create "build directory"
mkdir -p ./tf2bdir
cd ./tf2bdir
export SELFTF2_BASEDIR="$(pwd)"

# Remove previously-installed environments
conda env remove -y -n tf2-aistack-old
rm -R -f "$SELF_CONDA_ENV_PATH/tf2-aistack-old"
mv "$SELF_CONDA_ENV_PATH/tf2-aistack" "$SELF_CONDA_ENV_PATH/tf2-aistack-old"
conda env remove -y -n tf2-aistack
rm -R -f "$SELF_CONDA_ENV_PATH/tf2-aistack"
echo ' '

# Download necessary files
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/tf2/env.yml
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/tf2/dot-condarc-tf2
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/tf2/pip-deps1.txt
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/tf2/pip-deps2.txt
echo ' '

# Conda environment (creation)
conda env create -f ./env.yml
cp -f ./dot-condarc-tf2 "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/.condarc"
echo ' '

# Conda environment (band-aids and fixes)
source $SELFTF2_CEACT_COMMAND tf2-aistack
conda remove -y cmake curl krb5 tensorflow tensorflow-base tensorflow-estimator tensorflow-gpu binutils_impl_linux-64 binutils_linux-64 gcc_impl_linux-64 gcc_linux-64 gxx_impl_linux-64 gxx_linux-64 gfortran_impl_linux-64 gfortran_linux-64 libgfortran mpich mpi --force
source deactivate

####
# Fix Kerberos-related bug (MXNet)
rm -R -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/../lib/libkrb5.so.3"
rm -R -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/../lib/libk5crypto.so.3"
rm -R -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/../lib/libcom_err.so.3"
ln -s "/usr/lib/libcom_err.so" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/../lib/libcom_err.so.3"

mkdir -p "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/"

# System-to-Conda command mirroring (remove part)
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/cmake"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/ccmake"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gcc"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gcc-7"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gcc-8"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-gcc"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-cc"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/g++"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/g++-7"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/g++-8"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-g++"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-c++"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/cpp"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-cpp"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gfortran"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gfortran-7"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gfortran-8"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-f95"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-gfortran"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-fortran"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/curl"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/lib/libcurl.so.4.5.0"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/krb5kdc"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/krb5-send-pr"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/krb5-config"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/as"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/ld"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gprof"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/addr2line"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/ar"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/c++filt"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/nm"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/objcopy"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/objdump"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/ranlib"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/readelf"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/size"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/strings"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/strip"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-as"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-ld"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-gprof"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-addr2line"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-ar"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-c++filt"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-nm"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-objcopy"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-objdump"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-ranlib"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-readelf"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-size"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-strings"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-strip"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpic++"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpicc"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpicxx"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpiexec"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpiexec.hydra"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpif77"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpif90"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpifort"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpirun"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpivars"
rm -f "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/compiler_compat/ld"

# System-to-Conda command mirroring (link part)
ln -s "$(which gcc-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gcc"
ln -s "$(which gcc-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gcc-7"
ln -s "$(which gcc-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gcc-8"
ln -s "$(which gcc-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-gcc"
ln -s "$(which gcc-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-cc"
ln -s "$(which g++-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/g++"
ln -s "$(which g++-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/g++-7"
ln -s "$(which g++-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/g++-8"
ln -s "$(which g++-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-g++"
ln -s "$(which g++-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-c++"
ln -s "$(which cpp)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/cpp"
ln -s "$(which cpp)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-cpp"
ln -s "$(which gfortran-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gfortran"
ln -s "$(which gfortran-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gfortran-7"
ln -s "$(which gfortran-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gfortran-8"
ln -s "$(which gfortran-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-f95"
ln -s "$(which gfortran-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-gfortran"
ln -s "$(which gfortran-7)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-fortran"
ln -s "$(which cmake)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/cmake"
ln -s "$(which ccmake)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/ccmake"
ln -s "$(which curl)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/curl"
ln -s "/usr/lib/libcurl.so.4.5.0" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/lib/libcurl.so.4.5.0"
ln -s "$(which krb5kdc)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/krb5kdc"
ln -s "$(which krb5-send-pr)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/krb5-send-pr"
ln -s "$(which krb5-config)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/krb5-config"
ln -s "$(which as)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/as"
ln -s "$(which ld)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/ld"
ln -s "$(which gprof)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/gprof"
ln -s "$(which addr2line)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/addr2line"
ln -s "$(which ar)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/ar"
ln -s "$(which c++filt)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/c++filt"
ln -s "$(which nm)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/nm"
ln -s "$(which objcopy)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/objcopy"
ln -s "$(which objdump)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/objdump"
ln -s "$(which ranlib)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/ranlib"
ln -s "$(which readelf)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/readelf"
ln -s "$(which size)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/size"
ln -s "$(which strings)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/strings"
ln -s "$(which strip)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/strip"
ln -s "$(which as)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-as"
ln -s "$(which ld)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-ld"
ln -s "$(which gprof)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-gprof"
ln -s "$(which addr2line)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-addr2line"
ln -s "$(which ar)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-ar"
ln -s "$(which c++filt)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-c++filt"
ln -s "$(which nm)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-nm"
ln -s "$(which objcopy)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-objcopy"
ln -s "$(which objdump)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-objdump"
ln -s "$(which ranlib)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-ranlib"
ln -s "$(which readelf)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-readelf"
ln -s "$(which size)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-size"
ln -s "$(which strings)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-strings"
ln -s "$(which strip)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/x86_64-conda_cos6-linux-gnu-strip"
ln -s "$(which mpic++)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpic++"
ln -s "$(which mpicc)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpicc"
ln -s "$(which mpicxx)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpicxx"
ln -s "$(which mpiexec)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpiexec"
ln -s "$(which mpif77)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpif77"
ln -s "$(which mpif90)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpif90"
ln -s "$(which mpifort)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpifort"
ln -s "$(which mpirun)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/bin/mpirun"
ln -s "$(which ld)" "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/compiler_compat/ld"
####

mkdir -p "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/etc/conda/activate.d"
mkdir -p "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/etc/conda/deactivate.d"

cd "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/etc/conda/activate.d"
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/tf2/tf2-tweakenv-activate.sh

cd "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/etc/conda/deactivate.d"
wget --tries=0 --retry-connrefused --continue --progress=bar --show-progress --timeout=30 --dns-timeout=30 --random-wait https://ballarin.cc/aistack/tf2/tf2-tweakenv-deactivate.sh

cd "$SELFTF2_BASEDIR"
echo ' '

if [ "$SELFTF2_APPLY_CUDA_BANDAID" = "1" ]; then
    if [ "$SELFTF2_CUDA_BANDAID_FAKEROOT" != "" ]; then
        echo ' '
        export SELFTF2_CALLDIR_CUDA_BANDAID="$(pwd)"
        echo "Appying the CUDA Band-Aid..."
        cp -R -np $SELFTF2_CUDA_BANDAID_FAKEROOT/* "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/"
        mkdir -p "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/x86_64-conda_cos6-linux-gnu/sysroot/lib/"
        ln -s ../../../lib64/libcudnn.so "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/x86_64-conda_cos6-linux-gnu/sysroot/lib/libcudnn.so"
        cd "$SELFTF2_CONDA_ENV_PATH/tf2-aistack/etc/conda/activate.d"
        echo "export CUDA_HOME=\"$SELFTF2_CONDA_ENV_PATH/tf2-aistack/\"" >> ./tf2-tweakenv-activate.sh
        cd "$SELFTF2_CALLDIR_CUDA_BANDAID"
        echo "OK!"
        echo ' '
    fi
fi

# PIP Install (pre-TF2)
cd "$SELFTF2_BASEDIR"
echo ' '
source $SELFTF2_CEACT_COMMAND tf2-aistack
for reqline in $(cat pip-deps1.txt)
do
    pip install --upgrade --no-deps "$reqline"
    echo ' '
done
source deactivate

# Install TF2
cd "$SELFTF2_BASEDIR"
echo ' '
source $SELFTF2_CEACT_COMMAND tf2-aistack
#pip install --upgrade --no-deps https://github.com/inoryy/tensorflow-optimized-wheels/releases/download/v2.0.0a0/tensorflow-2.0.0a0-cp37-cp37m-linux_x86_64.whl
pip install --upgrade --no-deps tf-nightly-gpu-2.0-preview
pip install --upgrade --no-deps tensorflow-estimator-2.0-preview
pip install --upgrade --no-deps git+https://github.com/keras-team/keras-applications.git
pip install --upgrade --no-deps git+https://github.com/keras-team/keras-preprocessing.git
pip install --upgrade --no-deps tb-nightly
echo ' '
source deactivate

# PIP Install (post-TF2)
source $SELFTF2_CEACT_COMMAND tf2-aistack
for reqline in $(cat pip-deps2.txt)
do
    pip install --upgrade --no-deps "$reqline"
    echo ' '
done
source deactivate

# Jupyter(lab) extensions
source $SELFTF2_CEACT_COMMAND tf2-aistack
sudo ipcluster nbextension enable
jupyter nbextension install --py ipyparallel
jupyter nbextension enable --py ipyparallel
jupyter nbextension install hinterland
jupyter nbextension enable hinterland/hinterland
jupyter nbextension install --overwrite --py nbtutor
jupyter nbextension enable --py nbtutor
jupyter nbextension enable --py qgrid
jupyter serverextension enable --py ipyparallel
jupyter serverextension enable --py jupyterlab
jupyter serverextension enable nteract_on_jupyter
jupyter serverextension enable --py nteract_on_jupyter
jupyter labextension install qgrid
jupyter labextension install @jupyter-widgets/jupyterlab-manager
jupyter labextension install jupyterlab_bokeh
jupyter labextension install @pyviz/jupyterlab_pyviz
source deactivate

# Final band-aids and fixes
# Nothing

# Reset to original call-state
cd "$SELFTF2_CALLDIR"
