#
# --------------------------------------
#     Title: C-projects
# Copyright: Copyright 2018 by Shawn H Corey. Some rights reserved.
#   Licence: GPLv3, see https://www.gnu.org/licenses/gpl-3.0.html
#   Purpose: Used to GNU make to build a C/C++ project.
#

# --------------------------------------
# configuration

.SUFFIXES: .o .mk .cpp .cxx .c .hpp .hxx .h .t
.PHONY: all test install uninstall clean info
.DEFAULT_GOAL := all

# --------------------------------------
# compile commands
CC  := gcc
CXX := g++
LD  := g++

# --------------------------------------
# compile flags
CFLAGS   := -Wall -fPIC
CXXFLAGS := -Wall -fPIC
LDLIBS   := -lstdc++ -lm -lc
MFLAGS   := -MM -MT

# --------------------------------------
# file manipulation commands
AR_CMD := ar crs
CP_CMD := cp -f
LN_CMD := ln -sf
MD_CMD := mkdir -p
RM_CMD := rm -fv

# --------------------------------------
# directories
BUILD_DIR   := ./build
TEST_DIR    := ./test
INSTALL_DIR := ~/bin

# --------------------------------------
# c-projects files
PROJECT_DIR  := $(abspath .)
PROJECT_NAME := $(notdir $(PROJECT_DIR))
PROJECT      := $(BUILD_DIR)/$(PROJECT_NAME)
PROJECT_SO   := $(PROJECT).so

# source files
INCLUDES := $(wildcard *.hpp) $(wildcard *.hxx) $(wildcard *.h)
SOURCES  := $(wildcard *.cpp) $(wildcard *.cxx) $(wildcard *.c)

# intermediate targets
DEPENDS := $(addprefix $(BUILD_DIR)/, $(addsuffix .mk, $(basename $(notdir $(SOURCES)))))
OBJECTS := $(addprefix $(BUILD_DIR)/, $(addsuffix .o,  $(basename $(notdir $(SOURCES)))))

# --------------------------------------
# test
TEST_INCLUDES := $(wildcard $(TEST_DIR)/*.hpp) $(wildcard $(TEST_DIR)/*.hxx) $(wildcard $(TEST_DIR)/*.h)
TEST_SOURCES  := $(wildcard $(TEST_DIR)/*.cpp) $(wildcard $(TEST_DIR)/*.cxx) $(wildcard $(TEST_DIR)/*.c)

TEST_DEPENDS  := $(addprefix $(BUILD_DIR)/, $(addsuffix .mk, $(basename $(notdir $(TEST_SOURCES)))))
TEST_TARGETS  := $(addprefix $(BUILD_DIR)/, $(addsuffix .t,  $(basename $(notdir $(TEST_SOURCES)))))

# --------------------------------------
# includes
ifneq ($(MAKECMDGOALS),clean)
ifneq ($(MAKECMDGOALS),info)
ifeq  ($(MAKECMDGOALS),test)
DEPENDS := $(DEPENDS) $(TEST_DEPENDS)
endif
-include extra.mk $(DEPENDS)
endif
endif

# --------------------------------------
# c-projects rules

# implicit rules for C++
$(BUILD_DIR)/%.mk : %.cpp
	$(CXX) $(CXXFLAGS) $(MFLAGS) '$(patsubst %.mk,%.o,$@) $@' -MF $@ $<

$(BUILD_DIR)/%.o : %.cpp
	$(CXX) $(CXXFLAGS) -o $@ -c $<

# implicit rules for C++
$(BUILD_DIR)/%.mk : %.cxx
	$(CXX) $(CXXFLAGS) $(MFLAGS) '$(patsubst %.mk,%.o,$@) $@' -MF $@ $<

$(BUILD_DIR)/%.o : %.cxx
	$(CXX) $(CXXFLAGS) -o $@ -c $<

# implicit rules for C
$(BUILD_DIR)/%.mk : %.c
	$(CC) $(CFLAGS) $(MFLAGS) '$(patsubst %.mk,%.o,$@) $@' -MF $@ $<

$(BUILD_DIR)/%.o : %.c
	$(CC) $(CFLAGS) -o $@ -c $<

# --------------------------------------
# test rules

# implicit rules for test C++
$(BUILD_DIR)/%.mk : $(TEST_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) $(MFLAGS) '$(patsubst %.mk,%.o,$@) $@' -MF $@ $<

$(BUILD_DIR)/%.t : $(TEST_DIR)/%.cpp
	$(CXX) $(CXXFLAGS) -I$(BUILD_DIR) -L$(BUILD_DIR) -l$(PROJECT_NAME) -o $@ $<

# implicit rules for test C++
$(BUILD_DIR)/%.mk : $(TEST_DIR)/%.cxx
	$(CXX) $(CXXFLAGS) $(MFLAGS) '$(patsubst %.mk,%.o,$@) $@' -MF $@ $<

$(BUILD_DIR)/%.t : $(TEST_DIR)/%.cxx
	$(CXX) $(CXXFLAGS) -I$(BUILD_DIR) -L$(BUILD_DIR) -l$(PROJECT_NAME) -o $@ $<

# implicit rules for test C
$(BUILD_DIR)/%.mk : $(TEST_DIR)/%.c
	$(CC) $(CFLAGS) $(MFLAGS) '$(patsubst %.mk,%.o,$@) $@' -MF $@ $<

$(BUILD_DIR)/%.t : $(TEST_DIR)/%.c
	$(CC) $(CFLAGS) -I$(BUILD_DIR) -L$(BUILD_DIR) -l$(PROJECT_NAME) -o $@ $<

# --------------------------------------
# .PHONY targets

all: $(PROJECT)

test: $(PROJECT) $(TEST_TARGETS)
	@echo TODO run tests

install: $(PROJECT)
	$(MD_CMD) $(INSTALL_DIR)
	$(CP_CMD) $(PROJECT_NAME) $(INSTALL_DIR)

uninstall:
	$(RM_CMD) $(INSTALL_DIR)/$(PROJECT_NAME)

clean:
	find $(BUILD_DIR) ! -path $(BUILD_DIR) -print -delete

info:
	$(info BUILD_DIR=$(BUILD_DIR))
	$(info TEST_DIR=$(TEST_DIR))
	$(info INSTALL_DIR=$(INSTALL_DIR))
	$(info )
	$(info PROJECT_DIR=$(PROJECT_DIR))
	$(info PROJECT_NAME=$(PROJECT_NAME))
	$(info PROJECT=$(PROJECT))
	$(info PROJECT_SO=$(PROJECT_SO))
	$(info )
	$(info INCLUDES=$(INCLUDES))
	$(info SOURCES=$(SOURCES))
	$(info DEPENDS=$(DEPENDS))
	$(info OBJECTS=$(OBJECTS))
	$(info )
	$(info TEST_INCLUDES=$(TEST_INCLUDES))
	$(info TEST_SOURCES=$(TEST_SOURCES))
	$(info TEST_DEPENDS=$(TEST_DEPENDS))
	$(info TEST_TARGETS=$(TEST_TARGETS))
	$(info )

# --------------------------------------
# real target
$(PROJECT): $(OBJECTS) $(DEPENDS)
	$(LD) $(LDFLAGS) -o $@ $(OBJECTS) $(LDLIBS)
	$(LN_CMD) $(PROJECT) $(PROJECT_DIR)
	$(CC) -shared $(OBJECTS) -o $(PROJECT_SO)

