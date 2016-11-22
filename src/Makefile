SRCS = $(wildcard *.S)
OBJS = $(patsubst %.S, $(OBJ_DIR)/%$(BUILD_SUFFIX).o, $(SRCS))
BINS = $(patsubst %.S, $(BIN_DIR)/%$(BUILD_SUFFIX).bin, $(SRCS))

.PRECIOUS: $(OBJ_DIR)/%$(BUILD_SUFFIX).o

all: $(BINS)

$(BIN_DIR)/%$(BUILD_SUFFIX).bin: $(OBJ_DIR)/%$(BUILD_SUFFIX).o
	$(LD) $(LD_FLAGS) -o $@ $^

$(OBJ_DIR)/%$(BUILD_SUFFIX).o: %.S
	$(AS) $(AS_FLAGS) $(INCLUDE_DIR) -o $@ $^
	
