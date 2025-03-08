PRG=HELLOWORLD.PRG
SRCS=$(wildcard *.asm)

all: ${PRG}

run:
	x16emu -prg $(PRG) -run -scale 2

push-%: all
	rsync -avz -e ssh --delete --progress $(HOME)/src/6502/cx16/hello_world/ $(*):src/6502/cx16/hello_world/

${PRG}: $(SRCS)
	cl65 -o $(@) -t cx16 -C cx16-asm.cfg $(^)
