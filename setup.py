from setuptools import setup, Extension, find_packages

afo_module = Extension('_hello_swig',
                       sources=['src/hello_wrap.cxx'],
                       extra_compile_args=['-g'],
                       include_dirs=['cppsrc'],
                       library_dirs=["bin"],
                       libraries=["hello"])

setup(name="hello_swig",
      version="0.0.1",
      description='hello_swig',
      author='python newer',
      author_email='dont_thank_to_me@meituan.com',
      keywords='hello,swig',
      ext_modules=[afo_module],
      platforms=['any'],
      packages=find_packages(where='swigsrc',include=['hello_swig']))
