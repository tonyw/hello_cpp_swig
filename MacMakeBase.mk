# Default target
all:

# Standard phony targets and dependencies for all projects
.PHONY: all
# build_test and test targets do not have all dependency
.PHONY: build_test test
test: build_test
.PHONY: clean distclean
distclean: clean
.PHONY: TAGS tags cscope gtags
.PHONY: pre-build post-build

# Directory settings
PAI_HOME := $(PAI_HOME)
WORKSPACE := $(realpath $(dir $(realpath $(dir $(lastword $(MAKEFILE_LIST))))))
BIN_DIR = bin
DATA_DIR = data
DOC_DIR = doc
CONF_DIR = conf
INC_DIR = include
OBJ_DIR = obj
SRC_DIR = src
TEST_DIR = test
PROJECT_NAME = $(shell basename $(shell pwd))

# Temporary variables for transition period
#FIXME: Need to use OBJ_DIR variable in projects Makefiles and not
#FIXME: SRC_OBJ_PATH variable. After the transition is done, the line
#FIXME: below can be deleted.
SRC_OBJ_PATH = $(OBJ_DIR)

# Support for subdirectories
subdirs = $(foreach dir,$(SRC_CODE_SUBDIRS), $(SRC_DIR)/$(dir))
SRC_PATH = $(SRC_DIR)
SRC_PATH += $(subdirs)
SRC_PATH += $(TEST_DIR)
INC_PATH = $(INC_DIR)
INC_PATH += $(SRC_PATH)
vpath %.cpp $(SRC_PATH)
vpath %.c $(SRC_PATH)
vpath %.cu $(SRC_PATH)
vpath %.f $(SRC_PATH)
vpath %.f90 $(SRC_PATH)
vpath %.h $(INC_PATH)
vpath %.o $(OBJ_DIR)

INCPATH += -I$(INC_DIR)

CXXFLAGS = -g -Wall -Wextra -pthread

ifeq ($(TYPE), lib)
TARGETD ?= $(TARGET)
TARGET0 ?= $(shell echo $(TARGET) | sed 's/\(.*\.so\).*/\1/')
TARGET1 ?= $(shell echo $(TARGET) | sed 's/\(.*\.so\.[0-9]\).*/\1/')
TARGET2 ?= $(shell echo $(TARGET) | sed 's/\(.*\.so\.[0-9]\.[0-9]\).*/\1/')
endif
ifeq ($(TYPE), module)
TARGETD ?= $(TARGET)
TARGET0 ?= $(shell echo $(TARGET) | sed 's/\(.*\.so\).*/\1/')
TARGET1 ?= $(shell echo $(TARGET) | sed 's/\(.*\.so\.[0-9]\).*/\1/')
TARGET2 ?= $(shell echo $(TARGET) | sed 's/\(.*\.so\.[0-9]\.[0-9]\).*/\1/')
endif




# Google Testing Framework
TEST ?= 0
ifeq ($(TEST), 1)
	GTEST_INC_PATH = /Users/wangxin/Documents/gtest-1.7.0/include
	GTEST_LIB_PATH = /Users/wangxin/Documents/gtest-1.7.0/lib
	INCPATH += -I$(GTEST_INC_PATH) 
	LFLAGS += -L$(GTEST_LIB_PATH) -lgtest
	CXXFLAGS += -DUNIT_TEST
endif

LFLAGS +=-undefined suppress -flat_namespace

SHARED ?= 0
ifeq ($(SHARED), 1)
	LFLAGS += -dynamiclib 
endif



all: post-build

pre-build:

post-build: $(TARGET)

$(CXX_OBJS) : | pre-build

####### Compiler, tools and options
########C/C++
CC            = gcc
CXX           = g++
LINK          = g++
LIBS          =
AR            = ar cqs
RANLIB        =
TAR           = tar -cf
SED           = sed
STRIP         = strip
INSTALL_FILE  = install -m 644 -p
INSTALL_PROGRAM = install -m 755 -p
DEL_FILE      = rm -rf
SYMLINK       = ln -f -s
DEL_DIR       = rmdir
MOVE          = mv -f
CHK_DIR_EXISTS= test -d
MKDIR         = mkdir -p


# Pattern rules

$(OBJ_DIR)/%.o: %.cpp
	@$(CHK_DIR_EXISTS) $(dir $@) || $(MKDIR) $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCPATH) -o $@ -c $<


# TARGET
$(TARGET):  $(CXX_OBJS)
	@$(CHK_DIR_EXISTS) $(BIN_DIR) || $(MKDIR) $(BIN_DIR)
	-$(DEL_FILE) $(BIN_DIR)/$(TARGET)
	$(LINK) $(LFLAGS) -o $(BIN_DIR)/$(TARGET) $(C_OBJS) $(CXX_OBJS) $(F_OBJS) $(CUDA_OBJS) $(LIBS)



staticlib: $(TARGETA)

$(TARGETA):  $(OBJECTS) $(OBJCOMP)
	-$(DEL_FILE) $(TARGETA)
	$(AR) $(TARGETA) $(OBJECTS)

clean:
	$(DEL_FILE) $(OBJ_DIR)/* $(BIN_DIR)/* *~ core *.core core.* $(ADDITIONAL_CLEAN) $(CLEAN_FILES)

distclean: clean

TAGS tags:
	ctags -f $@ -R --sort=yes --excmd=p --c++-kinds=+pl --fields=+iaS --extra=+q .

cscope:
	cscope -Rb

gtags:
	gtags

cppcheck:
