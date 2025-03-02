PRG=CSMAIN.PRG
SRCS=$(wildcard *.asm)
OBJS=$(SRCS:asm=o)

all: $(OBJS) ${PRG}

run:
	x16emu -debug 080d -prg $(PRG) -run -scale 2

push-%: all
	rsync -avz -e ssh --delete --progress $(HOME)/src/6502/cx16/ciphersaber/ $(*):src/6502/cx16/ciphersaber/

${PRG}: csmain.o ciphersaber_key_zero.o ciphersaber_key_init.o ciphersaber_key_setup.o ciphersaber_key_mix.o
	cl65 -o $(@) -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

%.o: %.asm
	@ci -q -l -m- -t- $(^)
	ca65 -t cx16 -o $(@) $(^)
