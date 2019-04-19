#!/bin/bash

# Backup already set variables
export PRE_LD_LIBRARY_PATH="$LD_LIBRARY_PATH"
export PRE_CUDA_HOME="$CUDA_HOME"

# Additional LD_PRELOAD or LD_LIBRARY_PATH or CUDA_HOME flags will be eventually added after this line
