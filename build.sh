#!/usr/bin/env bash

rm -rf obj
rm -rf bin
rm -rf build
rm -rf dist
rm -rf src/*.cxx
rm -rf hello_swig.egg-info
rm -rf swigsrc
mkdir -p swigsrc
swig -c++ -outdir swigsrc -python src/hello.i
make
python setup.py bdist_egg
cd dist
unzip hello_swig-0.0.1-py2.7-macosx-10.12-x86_64.egg
cd ..
cp swigsrc/* dist
export PYTHONPYTH=dist
python test.py
