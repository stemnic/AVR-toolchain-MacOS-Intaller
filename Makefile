#	This is a Makefile for AVR KURS,
#	attempting to provide support for compiling and flashing AtMega4809 Curiosity from MacOS (2019-03-01)
#	Author: ole.sivert@aarhaug.com
#	Special thanks: magne.hov@gmail.com and richard.bman@gmail.com
#	
#	Guide for programming AVR AtMega4809 in MacOS  
#		To compile for AVR AtMega4809 we need some utilities for AVR, install these:
#		The ones in your repos may or may not be up to date, let's save ourselves
#		the trouble and go straight to the source. 
#		1) Run 'make install', which will execute install_toolchain.sh. It is always wise to 
#		   read the contents of scripts before running them. 
#		2) The chip acts as a USB storage device! It should automount the path given below
#		3) Done! You can now cp the Makefile to wherever the main.c file you're working on is,
#		   and run 'make'. Note that uploading to the chip requires sudo priviledges, so you
#		   you will be asked for your password when uploading


# ###
# Dependency directories and binaries
CHIP_DIR = /Volumes/CURIOSITY/

TOOL_CHAIN_URL = "https://omegav.no/files/avrkurs/MacOS/install_toolchain.sh"

DFP_DIR = $(HOME)/Library/avr-atpack/
AVR-GCC = avr-gcc
AVR-OBJCOPY = avr-objcopy

# ####
# Project files and flags

#Source files, add more files to SRC if needed: main.c uart.c ...
SRC = main.c
OBJ = $(SRC:.c=.o)

#Target name
TARGET = out

#Compiler and Linker flags
MCU = atmega4809
CFLAGS = -B $(DFP_DIR)gcc/dev/atmega4809 -I $(DFP_DIR)include -mmcu=$(MCU) -Os 
LDFLAGS = -B $(DFP_DIR)gcc/dev/atmega4809 -I $(DFP_DIR)include -mmcu=$(MCU) #-Wl,-Map=$(TARGET).map

# ####
# Make rules
all: build flash clean

build: $(TARGET).hex

flash:
	cp $(TARGET).hex $(CHIP_DIR) && sync $(CHIP_DIR)$(TARGET).hex 

clean:
	rm -f $(OBJ) $(TARGET).{elf,hex}

install:
	curl $(TOOL_CHAIN_URL) > install_toolchain.sh
	chmod +x install_toolchain.sh
	./install_toolchain.sh
	rm install_toolchain.sh

# ####
# Compiler rules
%.hex: %.elf
	$(AVR-OBJCOPY) -O ihex -R .eeprom -R .fuse -R .lock -R .signature $< $@

%.elf: $(OBJ)
	$(AVR-GCC) $^ $(LDFLAGS) -o $@

%.o : %.c
	$(AVR-GCC) $(CFLAGS) -o $@ -c $<
