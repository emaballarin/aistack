#!/bin/bash

# Restore backed-up variables
export LD_LIBRARY_PATH="$PRE_LD_LIBRARY_PATH"
export CUDA_HOME="$PRE_CUDA_HOME"

# Unset (eventually) overridden LD_PRELOAD
unset LD_PRELOAD

# Remove now useless variables
unset PRE_LD_LIBRARY_PATH
unset PRE_CUDA_HOME
unset NPY_MKL_FORCE_INTEL
