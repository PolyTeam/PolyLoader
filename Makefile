# POLY BUILD SYSTEM

PWD = $(shell pwd)

PROJECT_NAME = PolyLoader

POLY_FOLDER = $(PWD)/..
PROJECT_FOLDER = $(POLY_FOLDER)/$(PROJECT_NAME)

$(PROJECT_NAME)_VERSION_MAJOR = 0
$(PROJECT_NAME)_VERSION_MINOR = 0
$(PROJECT_NAME)_VERSION_PATCH = 0

C_FLAGS_COMMON = 
C_FLAGS_DEBUG = $(C_FLAGS_COMMON) --gstabs
C_FLAGS_RELEASE = $(C_FLAGS_COMMON) -O3

LD_FLAGS = --oformat binary -Ttext 0x7c00

include utils/Makefile.utils
include utils/Makefile.custom

export


all: $(PROJECT_NAME)

#
# Preparation
#
prepare:
	$(call print_info,"Preparing folders...")
	mkdir -p $(OBJ_DIR)
	mkdir -p $(BIN_DIR)	

#
# Project targets
#
$(PROJECT_NAME): $(PROJECT_NAME)_debug

$(PROJECT_NAME)_debug: prepare
	$(call print_info,"Building $(PROJECT_NAME) Debug...")
	$(eval C_FLAGS = $(C_FLAGS_DEBUG))
	$(eval BUILD_SUFFIX = _d)
	$(MAKE) -C src
	$(LD) $(LD_FLAGS) -o $(BIN_DIR)/$(OUTPUT_NAME_DEBUG) $(OBJ_DIR)/*_d.o
		

$(PROJECT_NAME)_release: prepare
	$(call print_info,"Building $(PROJECT_NAME) Release...")
	$(eval C_FLAGS = $(C_FLAGS_RELEASE))
	$(MAKE) -C src
	$(LD) $(LD_FLAGS) -o $(BIN_DIR)/$(OUTPUT_NAME_RELEASE) $(OBJ_DIR)/*[^_d].o

test: $(PROJECT_NAME)_debug
	cat $(BIN_DIR)/$(OUTPUT_NAME_DEBUG) /dev/zero | dd of=$(BIN_DIR)/floppy_d bs=512 count=2880
	qemu-system-x86_64 -boot a -fda $(BIN_DIR)/floppy_d

#
# Tools targets
#
clean:
	$(call print_info,"Cleaning project...")
	rm -rf build/*.o
	rm -rf build/$(OUTPUT_NAME_DEBUG)
	rm -rf build/$(OUTPUT_NAME_RELEASE)

mrproper:
	$(call print_info,"Cleaning all project...")
	rm -rf build
