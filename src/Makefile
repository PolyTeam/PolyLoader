SRCS = $(wildcard *.S)
OBJS = $(patsubst %.S, $(OBJ_DIR)/%$(BUILD_SUFFIX).o, $(SRCS))

all: $(OBJS)

$(OBJ_DIR)/%$(BUILD_SUFFIX).o: %.S
	$(AS) $(INCLUDE_DIR) -o $@ $^ 
