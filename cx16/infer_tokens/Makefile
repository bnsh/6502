PYTHON := $(sort $(shell find . -type f -name '*.py' -print))
PYLINT3 := $(join $(dir $(PYTHON)), $(addprefix ., $(notdir $(PYTHON:py=pylint3))))
MYPY    := $(join $(dir $(PYTHON)), $(addprefix ., $(notdir $(PYTHON:py=mypy))))

all: pylint # mypy

clean:
	rm -f $(PYLINT3) $(MYPY)

pylint: $(PYLINT3)
mypy: $(MYPY)

.%.pylint3: %.py
	python3 -m pylint -r n $(^)
	@>$(@)

.%.mypy: %.py
	python3 -m mypy --disallow-untyped-defs --ignore-missing-imports --cache-dir=${HOME}/.mypy-cache $(^)
	@>$(@)
