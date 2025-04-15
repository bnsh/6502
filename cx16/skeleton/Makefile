NAME := skeleton
UPPER_NAME := $(shell echo $(NAME) | tr a-z A-Z)

PRGS := $(UPPER_NAME).PRG
MAPS := $(PRGS:PRG=MAP)

SRCS := $(wildcard *.asm)
OBJS := $(SRCS:asm=o)
COMMON_OBJS := \

all: $(OBJS) $(PRGS) $(MAPS)

clean:
	rm -f $(OBJS) $(PRGS) $(MAPS)

run:
	x16emu -prg $(UPPER_NAME).PRG -run -scale 2

debug:
	x16emu -debug 080d -prg $(UPPER_NAME).PRG -run -scale 2

push-%: all
	rsync -avz -e ssh --delete --progress $(HOME)/src/6502/cx16/$(NAME)/ $(*):src/6502/cx16/$(NAME)/

$(UPPER_NAME).MAP $(UPPER_NAME).PRG: $(NAME).o $(COMMON_OBJS)
	cl65 -m $(UPPER_NAME).MAP -o $(UPPER_NAME).PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

%.o: %.asm
	@ci -q -l -m- -t- $(^)
	ca65 -t cx16 -o $(@) $(^)
