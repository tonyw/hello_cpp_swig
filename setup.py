from distutils.core import setup, Extension

afo_module = Extension('_afo',sources=['src/hello.h','src/hello.cpp','src/hello_wrap.cxx'], extra_compile_args=['-g'], extra_link_args='_hello.so')

setup(name = "afo", version = "1.0", ext_modules = [afo_module], py_modules = ["src/afo"])