PRGS=SHA256TEST.PRG
MAPS=$(PRGS:PRG=MAP)

SRCS=$(wildcard *.asm)
GENERATED=\
	sha256_constants.asm \

OBJS=$(GENERATED:asm=o) $(SRCS:asm=o)
SHA256COMMON_OBJS=\
	sha256_constants.o \
	sha256_io.o \

PYTHON  := $(sort $(shell find . -type f -name '*.py' -print))
PYLINT3 := $(join $(dir $(PYTHON)), $(addprefix ., $(notdir $(PYTHON:py=pylint3))))
MYPY    := $(join $(dir $(PYTHON)), $(addprefix ., $(notdir $(PYTHON:py=mypy))))
PYRIGHT := $(join $(dir $(PYTHON)), $(addprefix ., $(notdir $(PYTHON:py=pyright))))

all: pylint $(OBJS) $(PRGS) $(MAPS) # mypy pyright

clean:
	rm -f $(GENERATED) $(OBJS) $(PRGS) $(MAPS) $(PYLINT3) $(MYPY) $(PYRIGHT)

run:
	x16emu -debug 080d -prg SHA256TEST.PRG -run -scale 2

push-%: all
	rsync -avz -e ssh --delete --progress $(HOME)/src/6502/cx16/sha256/ $(*):src/6502/cx16/sha256/

sha256_constants.asm: sha256_constants.py sha256_constants.asm.jinja2
	python3 ./sha256_constants.py

SHA256TEST.MAP SHA256TEST.PRG: sha256test.o $(SHA256COMMON_OBJS)
	cl65 -m SHA256.MAP -o SHA256.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

%.o: %.asm
	@ci -q -l -m- -t- $(^)
	ca65 -t cx16 -o $(@) $(^)

pylint: $(PYLINT3)
mypy: $(MYPY)
pyright: $(PYRIGHT)

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
