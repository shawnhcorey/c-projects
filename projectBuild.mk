# --------------------------------------
#     Title: Build Makefile
# Copyright: Copyright 2015 by Shawn H Corey.  All rights reserved.
#   Licence: GPLv3, see https://www.gnu.org/licenses/gpl-3.0.html
#   Purpose: Used to GNU make to build a C/C++ project.
# --------------------------------------

# configuration

.SUFFIXES: .o .cpp .c .h .mk

.PHONY: all clean install uninstall info

.DEFAULT_GOAL := all

# --------------------------------------
# compiling commands
CC  := gcc
CXX := gcc
LD  := gcc

# standard compile flags
CFLAGS   := -Wall
CXXFLAGS := -Wall
LDLIBS   := -lstdc++ -lm -lc
MFLAGS   := -MM -MT

# file manipulation commands
RM_CMD := rm -f
CP_CMD := cp -f
LN_CMD := ln -sf

# --------------------------------------
#  build
BUILD          := $(notdir $(abspath .))
BUILD_MAKEFILE := $(BUILD).mk

# --------------------------------------
# project has same name as parent directory
PROJECT_DIR := $(abspath ..)
PROJECT     := $(notdir $(PROJECT_DIR))

# build is a sub-directory of where the source files are
VPATH       := ../src
SOURCE_DIRS := $(subst :, ,$(VPATH))
INCLUDES    := $(foreach srcdir,$(SOURCE_DIRS),$(wildcard $(srcdir)/*.h))
SOURCES     := $(foreach srcdir,$(SOURCE_DIRS),$(wildcard $(srcdir)/*.cpp) $(wildcard $(srcdir)/*.c))

# intermediate targets
DEPENDS := $(addsuffix .mk, $(basename $(notdir $(SOURCES))))
OBJECTS := $(addsuffix .o,  $(basename $(notdir $(SOURCES))))

# installation directory
INSTALL_DIR := $(wildcard ~/bin)

# --------------------------------------
# implicit rules for C++
%.mk : %.cpp
	$(CXX) $(CPPFLAGS) $(MFLAGS) '$(patsubst %.mk,%.o,$@) $@' -MF $@ $<

%.o : %.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -o $@ -c $<

# implicit rules for C
%.mk : %.c
	$(CC) $(CPPFLAGS) $(MFLAGS) '$(patsubst %.mk,%.o,$@) $@' -MF $@ $<

%.o : %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -o $@ -c $<

# --------------------------------------
# .PHONY targets

all: $(PROJECT)

clean:
	find ! -name $(BUILD_MAKEFILE) ! -name . -print -delete
	find .. -ilname $(BUILD)/\* -print -delete

install: $(PROJECT)
	$(CP_CMD) $(PROJECT) $(INSTALL_DIR)

uninstall:
	$(RM_CMD) $(INSTALL_DIR)/$(PROJECT)

info:
	$(info BUILD=$(BUILD))
	$(info PROJECT=$(PROJECT))
	$(info SOURCE_DIRS=$(SOURCE_DIRS))
	$(info INCLUDES=$(INCLUDES))
	$(info SOURCES=$(SOURCES))
	$(info DEPENDS=$(DEPENDS))
	$(info OBJECTS=$(OBJECTS))
	$(info INSTALL_DIR=$(INSTALL_DIR))

# --------------------------------------
# real targets

$(PROJECT): $(DEPENDS) $(OBJECTS)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS) $(LDLIBS)
	$(LN_CMD) $(BUILD)/$(PROJECT) $(PROJECT_DIR)

-include $(DEPENDS)
