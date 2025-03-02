PRG=CSMAIN.PRG
SRCS=$(wildcard *.asm)
OBJS=$(SRCS:asm=o)

all: $(OBJS) ${PRG}

run:
	x16emu -debug -prg $(PRG) -run -scale 2

push-%: all
	rsync -avz -e ssh --delete --progress $(HOME)/src/6502/cx16/ciphersaber/ $(*):src/6502/cx16/ciphersaber/

${PRG}: csmain.o ciphersaber_common.o
	cl65 -o $(@) -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

%.o: %.asm
	ca65 -o $(@) $(^)
