PRGS=SIMPLER.PRG SIMPLE.PRG BRANCH_TESTS.PRG
MAPS=$(PRGS:PRG=MAP)
SRCS=$(wildcard *.asm)
OBJS=$(SRCS:asm=o)

GENERATED=\
    branch_tests.asm \
    kernal.inc \

PYTHON=$(sort $(wildcard *.py))
PYLINT3=$(addprefix .,$(PYTHON:py=pylint3))

all: pylint3 $(GENERATED) $(OBJS) $(PRGS) $(MAPS)

clean:
	rm -f $(OBJS) $(PRGS) $(MAPS)

run:
	x16emu -debug 080d -prg BRANCH_TESTS.PRG -run -scale 2

push-%: all
	rsync -avz -e ssh --delete --progress $(HOME)/src/6502/cx16/debug/ $(*):src/6502/cx16/debug/

branch_tests.asm: branch_tests.py
	python3 $(^) --output $(@)

kernal.inc: kernal.py kernal.csv
	python3 kernal.py --output $(@)

BRANCH_TESTS.MAP BRANCH_TESTS.PRG: branch_tests.o debug_registers.o writeutils.o
	cl65 -m BRANCH_TESTS.MAP -o BRANCH_TESTS.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

SIMPLER.MAP SIMPLER.PRG: simpler.o debug_registers.o writeutils.o
	cl65 -m SIMPLER.MAP -o SIMPLER.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

SIMPLE.MAP SIMPLE.PRG: simple.o debug_registers.o writeutils.o
	cl65 -m SIMPLE.MAP -o SIMPLE.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

pylint3: $(PYLINT3)

%.o: %.asm
	@ci -q -l -m- -t- $(^)
	ca65 -t cx16 -o $(@) $(^)

.%.pylint3: %.py
	python3 -m pylint -r n $(^)
	@>$(@)
