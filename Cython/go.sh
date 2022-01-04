#!/bin/sh -e

python3.8 setup.py build_ext --inplace
time python3.8 run.py ../40000nums > sorted-list.txt
