PRG=MAZE.PRG
SRCS=$(wildcard *.asm)

all: ${PRG}

run:
	x16emu -prg $(PRG) -run -scale 2

runbas:
	x16emu -prg MAZE.BAS -run -scale 2

push-%: all
	rsync -avz -e ssh --delete --progress $(HOME)/src/6502/cx16/maze/ $(*):src/6502/cx16/maze/

${PRG}: $(SRCS)
	cl65 -o $(@) -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)
