PYTHON  := $(sort $(shell find . -type f -name '*.py' -print))
PYLINT3 := $(join $(dir $(PYTHON)), $(addprefix ., $(notdir $(PYTHON:py=pylint3))))
MYPY    := $(join $(dir $(PYTHON)), $(addprefix ., $(notdir $(PYTHON:py=mypy))))
PYRIGHT := $(join $(dir $(PYTHON)), $(addprefix ., $(notdir $(PYTHON:py=pyright))))

all: pylint # mypy pyright

clean:
	rm -f $(PYLINT3) $(MYPY) $(PYRIGHT)

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
