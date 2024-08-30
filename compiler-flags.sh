#!/bin/sh -e

# Increase budget for unrolling loops
# Since clang8, this budget has gotten tighter, causing performance
# regressions in selsort.
# https://github.com/llvm/llvm-project/issues/53205#issuecomment-2318697322
# CLANG_FLAGS='-O2 -funroll-loops -mllvm -scev-cheap-expansion-budget=30'
# CLANG_FLAGS='-O2 -funroll-loops'
# GCC_FLAGS='-O2 -funroll-loops'
CLANG_FLAGS='-O2'
GCC_FLAGS='-O2'
