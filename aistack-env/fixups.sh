#!/bin/bash
##############################
### AIStack, Final fix-ups ###
##############################
##
# (c) 2019 Emanuele Ballarin <emanuele@ballarin.cc>
# Released under the Apache License 2.0.
##
# This file is called by some other one as:
# chmod +x ./fixups.sh
# ./fixups.sh
##
source activate aistack
export CHAINER_BUILD_CHAINERX=1
export CHAINERX_BUILD_CUDA=1
export MAKEFLAGS=-j8
pip install --upgrade --no-deps --pre --force chainer
pip install --upgrade --no-deps jsonnet
source deactivate
