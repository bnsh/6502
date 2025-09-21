PYTHON  := $(sort $(shell find . -type f -name '*.py' -print))
PYLINT3 := $(join $(dir $(PYTHON)), $(addprefix ., $(notdir $(PYTHON:py=pylint3))))
MYPY    := $(join $(dir $(PYTHON)), $(addprefix ., $(notdir $(PYTHON:py=mypy))))
PYRIGHT := $(join $(dir $(PYTHON)), $(addprefix ., $(notdir $(PYTHON:py=pyright))))

PRGS=SIMPLER.PRG SIMPLE.PRG BRANCH_TESTS.PRG
MAPS=$(PRGS:PRG=MAP)
SRCS=$(wildcard *.asm)
OBJS=$(SRCS:asm=o)

GENERATED=\
    branch_tests.asm \
    kernal.inc \
    cx16_registers.inc \

all: pylint3 mypy pyright $(GENERATED) $(OBJS) $(PRGS) $(MAPS)

clean:
	rm -f $(PYLINT3) $(MYPY) $(PYRIGHT) $(GENERATED) $(OBJS) $(PRGS) $(MAPS)

run:
	x16emu -debug 080d -prg BRANCH_TESTS.PRG -run -scale 2

push-%: all
	rsync -avz -e ssh --delete --progress $(HOME)/src/6502/cx16/debug/ $(*):src/6502/cx16/debug/

branch_tests.asm: branch_tests.py
	python3 $(^) --output $(@)

kernal.inc: kernal.py kernal.csv
	python3 kernal.py --output $(@)

cx16_registers.inc: cx16_registers.py
	python3 cx16_registers.py --output $(@)

BRANCH_TESTS.MAP BRANCH_TESTS.PRG: branch_tests.o debug_registers.o writeutils.o
	cl65 -m BRANCH_TESTS.MAP -o BRANCH_TESTS.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

SIMPLER.MAP SIMPLER.PRG: simpler.o debug_registers.o writeutils.o
	cl65 -m SIMPLER.MAP -o SIMPLER.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

SIMPLE.MAP SIMPLE.PRG: simple.o debug_registers.o writeutils.o
	cl65 -m SIMPLE.MAP -o SIMPLE.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

pylint: $(PYLINT3)
mypy: $(MYPY)
pyright: $(PYRIGHT)

%.o: %.asm
	@ci -q -l -m- -t- $(^)
	ca65 -t cx16 -o $(@) $(^)

.%.pylint3: %.py
	python3 -m pylint --rcfile $(HOME)/.pylintrc -r n $(^)
	@>$(@)

MYPY_PROJECT_ROOT := $(abspath $(CURDIR))
MYPY_PROJECT_NAME := $(notdir $(MYPY_PROJECT_ROOT))
MYPY_PROJECT_HASH := $(shell printf %s '$(MYPY_PROJECT_ROOT)' | sha256sum | cut -c1-8)
MYPY_CACHE   := $(HOME)/.mypy-cache/$(MYPY_PROJECT_NAME)-$(MYPY_PROJECT_HASH)
.%.mypy: %.py
	@mkdir -p '$(MYPY_CACHE)'
	python3 -m mypy --disallow-untyped-defs --ignore-missing-imports --cache-dir='$(MYPY_CACHE)' $(^)
	@>$@

.%.pyright: %.py
	pyright $(^)
	@>$(@)
