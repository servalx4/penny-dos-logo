all: 
    nasm -f bin ./src/bootloader/boot.asm -o ./src/bin/boot.bin 

clean: 
    rm -f ./src/bin/boot.bin