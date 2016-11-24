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

AS_FLAGS = --32 -gstabs -ggdb

LD_FLAGS = -m elf_i386 -Ttext 0 --oformat binary

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
		

$(PROJECT_NAME)_release: prepare
	$(call print_info,"Building $(PROJECT_NAME) Release...")
	$(eval C_FLAGS = $(C_FLAGS_RELEASE))
	$(MAKE) -C src

prepare_test: $(PROJECT_NAME)_debug
	$(call print_success,"Creating the bootable floppy...")
	cat $(BIN_DIR)/loader$(BUILD_SUFFIX).bin $(BIN_DIR)/loader2$(BUILD_SUFFIX).bin /dev/zero | dd of=$(BIN_DIR)/floppy_d bs=512 count=2880

test: test_qemu

test_bochs: prepare_test
	$(BOCHS) -f utils/bochsrc.txt -q

test_qemu: prepare_test
	qemu-system-i386 -boot a -fda $(BIN_DIR)/floppy_d -m 4G -monitor stdio

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
