SRCS = $(wildcard *.c)
OBJS = $(patsubst %.c, $(OBJ_DIR)/%$(BUILD_SUFFIX).o, $(SRCS))

all: $(OBJS)
	# Add $(MAKE) -C <subfolder>
	# For each subfolder

$(OBJ_DIR)/%$(BUILD_SUFFIX).o: %.c
	$(CC) $(C_FLAGS) -c $^ -o $@ $(INCLUDE_DIR)
