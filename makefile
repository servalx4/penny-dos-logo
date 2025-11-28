 n # Penny-DOS Makefile
ASM      = nasm
ASMFLAGS = -f bin
BUILD    = build

BOOT     = $(BUILD)/bootloader.bin
KERNEL   = $(BUILD)/kernel.bin

SRC_BOOT          = src/bootloader.asm
SRC_KERNEL        = src/kernel.asm
SRC_SHELL         = src/shell.asm
SRC_MULTIBOOT     = src/HEADER_FILES/multiboot_header.asm

.PHONY: all clean run

all: $(BUILD) $(BOOT) $(KERNEL)

# create build directory
$(BUILD):
	mkdir -p $(BUILD)

# assemble bootloader
$(BOOT): $(SRC_BOOT)
	$(ASM) $(ASMFLAGS) $< -o $@

# assemble kernel + shell + multiboot header
$(KERNEL): $(SRC_MULTIBOOT) $(SRC_KERNEL) $(SRC_SHELL)
	# assemble multiboot header
	$(ASM) $(ASMFLAGS) $(SRC_MULTIBOOT) -o $(BUILD)/multiboot_header.bin
	# assemble kernel
	$(ASM) $(ASMFLAGS) $(SRC_KERNEL) -o $(BUILD)/kernel.tmp.bin
	# assemble shell
	$(ASM) $(ASMFLAGS) $(SRC_SHELL) -o $(BUILD)/shell.tmp.bin
	# concatenate: multiboot_header + kernel + shell
	cat $(BUILD)/multiboot_header.bin $(BUILD)/kernel.tmp.bin $(BUILD)/shell.tmp.bin > $@
	# cleanup temporary files
	rm $(BUILD)/multiboot_header.bin $(BUILD)/kernel.tmp.bin $(BUILD)/shell.tmp.bin

# run Penny-DOS in QEMU
run: all
	qemu-system-x86_64 -drive format=raw,file=$(BOOT) -serial stdio

clean:
	rm -rf $(BUILD)
