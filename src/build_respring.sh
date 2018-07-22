#!/bin/bash

set -e
make clean
make
make test
/opt/simject/simject/bin/respring_simulator
