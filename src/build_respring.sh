#!/bin/bash

set -e
make -C src clean
make -C src
make -C src test
/opt/simject/simject/bin/respring_simulator
