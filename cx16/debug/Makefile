PRGS=SIMPLER.PRG SIMPLE.PRG
MAPS=$(PRGS:PRG=MAP)

SRCS=$(wildcard *.asm)
OBJS=$(SRCS:asm=o)

all: $(OBJS) $(PRGS) $(MAPS)

clean:
	rm -f $(OBJS) $(PRGS) $(MAPS)

run:
	x16emu -debug 080d -prg SIMPLE.PRG -run -scale 2

push-%: all
	rsync -avz -e ssh --delete --progress $(HOME)/src/6502/cx16/debug/ $(*):src/6502/cx16/debug/

SIMPLER.MAP SIMPLER.PRG: simpler.o debug_registers.o
	cl65 -m SIMPLER.MAP -o SIMPLER.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

SIMPLE.MAP SIMPLE.PRG: simple.o debug_registers.o
	cl65 -m SIMPLE.MAP -o SIMPLE.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

%.o: %.asm
	@ci -q -l -m- -t- $(^)
	ca65 -t cx16 -o $(@) $(^)
