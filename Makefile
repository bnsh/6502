USER:=$(shell id --user --name)
UID:=$(shell id --user)
GID:=$(shell id --group)
NAME:=$(shell uname --nodename | tr 'a-z' 'A-Z')

LABEL:=$(NAME)-SD
DEVICE:=$(shell blkid -L $(LABEL) 2>/dev/null)

SRCDIR:=$(HOME)/src/6502
MOUNTDIR=/tmp/${LABEL}
DSTDIR:=$(MOUNTDIR)/6502

push: mount push-guts unmount

pull: mount pull-guts unmount

mount:
	@if [ -z "$(DEVICE)" ]; then \
		echo "Device with label $(LABEL) not found!"; \
		exit 1; \
	fi
	mkdir -p $(MOUNTDIR)
	sudo mount -o uid=$(UID),gid=$(GID) $(DEVICE) $(MOUNTDIR)

push-guts:
	rsync -av --progress --delete $(SRCDIR)/ $(DSTDIR)/

pull-guts:
	rsync -av --progress $(DSTDIR)/ $(SRCDIR)/

unmount:
	sudo umount $(MOUNTDIR)
	rm -fr $(MOUNTDIR)
