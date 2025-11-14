# Penny-DOS Installation.

*last updated on 11/14/2025 @ 12:45p (EST)*

## Installation Requirements.

To install Penny-DOS you will need the following...

- A VM
- An official Penny-DOS image (can be grabbed from [GitHub](https://github.com/penne-not-pasta/penny-dos/releases))

    - Go to the releases tab > Latest Release > click the release title > click to download the `.iso` or `.bin` file!


## Actual Installation.

Note: This has only been tested on debian 13, so commands are for Debian 13 Trixie!

1. Open the terminal on your desired machine.
2. if you havent already install QEMU by entering the following command. `apt-get install qemu-system` if that doesnt work try running w/ `sudo` or `su` then follow the instructions.
3. once QEMU is installed *restart* your machine to ensure the install is complete.
4. after restart, open the terminal again.
5. Download the latest release from [Here](https://github.com/penne-not-pasta/penny-dos/releases) and add to desired foler, in this example i will use the `Documents` folder.
6. going back to the terminal, enter the following commands.

    - `cd Documents`
    - `qemu-system-x86_64 clementine-v001-alpha.bin` and follow the install instructions in the VM.