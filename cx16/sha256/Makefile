PRGS=SHA256TEST.PRG
MAPS=$(PRGS:PRG=MAP)

SRCS=$(wildcard *.asm)
GENERATED=\
	sha256_constants.asm \

OBJS=$(GENERATED:asm=o) $(SRCS:asm=o)
SHA256COMMON_OBJS=\
	sha256_constants.o \
	sha256_io.o \

PYTHON=$(sort $(wildcard *.py))
PYLINT3=$(addprefix .,$(PYTHON:py=pylint3))

all: pylint $(OBJS) $(PRGS) $(MAPS)

clean:
	rm -f $(GENERATED) $(OBJS) $(PRGS) $(MAPS)

run:
	x16emu -debug 080d -prg SHA256TEST.PRG -run -scale 2

push-%: all
	rsync -avz -e ssh --delete --progress $(HOME)/src/6502/cx16/sha256/ $(*):src/6502/cx16/sha256/

sha256_constants.asm: sha256_constants.py sha256_constants.asm.jinja2
	python3 ./sha256_constants.py

SHA256TEST.MAP SHA256TEST.PRG: sha256test.o $(SHA256COMMON_OBJS)
	cl65 -m SHA256.MAP -o SHA256.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

pylint: $(PYLINT3)

%.o: %.asm
	@ci -q -l -m- -t- $(^)
	ca65 -t cx16 -o $(@) $(^)

.%.pylint3: %.py
	python3 -m pylint -r n $(^)
	@>$(@)
