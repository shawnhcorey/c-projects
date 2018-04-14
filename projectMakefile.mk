# --------------------------------------
#     Title: Master Makefile
# Copyright: Copyright 2015 by Shawn H Corey.  All rights reserved.
#   Licence: GPLv3, see https://www.gnu.org/licenses/gpl-3.0.html
#   Purpose: Controls which subdirectorys are made.
# --------------------------------------

# configuration

.PHONY: all clean install uninstall info

.DEFAULT_GOAL := all

BUILD_DIR := './build'

BUILD_MAKEFILE := build.mk

# .PHONY targets

all clean install uninstall info:
	$(MAKE) --directory=$(BUILD_DIR) --makefile=$(BUILD_MAKEFILE) $@

