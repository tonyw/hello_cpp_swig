SHARED  = 1

TARGET  = libhello.so

first: all

CXX_OBJS=   $(SRC_OBJ_PATH)/hello.o

####### Build rules
include Makefile.setup