# Penny-DOS Makefile
ASM      = nasm
ASMFLAGS = -f bin
BUILD    = build

BOOT     = $(BUILD)/bootloader.bin
KERNEL   = $(BUILD)/kernel.bin

SRC_BOOT   = src/bootloader.asm
SRC_KERNEL = src/kernel.asm
SRC_SHELL  = src/shell.asm

.PHONY: all clean

all: $(BUILD) $(BOOT) $(KERNEL)

# create build directory
$(BUILD):
	mkdir -p $(BUILD)

# assemble bootloader
$(BOOT): $(SRC_BOOT)
	$(ASM) $(ASMFLAGS) $< -o $@

# assemble kernel + shell
$(KERNEL): $(SRC_KERNEL) $(SRC_SHELL)
	# assemble kernel to temp
	$(ASM) $(ASMFLAGS) $(SRC_KERNEL) -o $(BUILD)/kernel.tmp.bin
	# assemble shell to temp
	$(ASM) $(ASMFLAGS) $(SRC_SHELL) -o $(BUILD)/shell.tmp.bin
	# concatenate kernel + shell into kernel.bin
	cat $(BUILD)/kernel.tmp.bin $(BUILD)/shell.tmp.bin > $@
	# cleanup temp files
	rm $(BUILD)/kernel.tmp.bin $(BUILD)/shell.tmp.bin

run: all
	qemu-system-x86_64 -hda ./build/bootloader.bin -serial stdio
	
clean:
	rm -rf $(BUILD)
