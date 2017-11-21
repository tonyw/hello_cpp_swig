####### Compiler, tools and options
########C/C++
CC            = gcc
CXX           = g++
LINK          = g++
CFLAGS        += -fPIC -pthread -lrt
CXXFLAGS      += -fPIC -pthread -lrt 
CXXFLAGS 	  += -Wshadow -Wall
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


# Directory settings
BIN_DIR = bin
INC_DIR = cppsrc
OBJ_DIR = obj
SRC_DIR = cppsrc
TEST_DIR = test

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

# Google Testing Framework
TEST ?= 0
ifeq ($(TEST), 1)
	GTEST_INC_PATH = /vagrant/googletest-read-only/include
	GTEST_LIB_PATH = /vagrant/googletest-read-only/build
	INCPATH += -I$(GTEST_INC_PATH) 
	LFLAGS += -L$(GTEST_LIB_PATH) -lgtest -lgtest_main
	CXXFLAGS += -DUNIT_TEST
endif

SHARED ?= 0
ifeq ($(SHARED), 1)
        LFLAGS += -shared -fPIC
endif

LFLAGS += -Lbin -rdynamic

all: $(TARGET)

$(OBJ_DIR)/%.o: %.cpp
	@$(CHK_DIR_EXISTS) $(dir $@) || $(MKDIR) $(dir $@)
	$(CXX) $(CXXFLAGS) $(INCPATH) -o $@ -c $<


# TARGET
$(TARGET):  $(CXX_OBJS)
	@$(CHK_DIR_EXISTS) $(BIN_DIR) || $(MKDIR) $(BIN_DIR)
	-$(DEL_FILE) $(BIN_DIR)/$(TARGET)
	$(LINK) -o $(BIN_DIR)/$(TARGET) $(CXX_OBJS) $(LFLAGS)


clean:
	$(DEL_FILE) $(OBJ_DIR)/* $(BIN_DIR)/* *~ core *.core core.* $(ADDITIONAL_CLEAN) $(CLEAN_FILES)

distclean: clean