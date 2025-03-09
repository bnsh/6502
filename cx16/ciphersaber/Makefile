PRGS=CSENCRYPT.PRG CSDECRYPT.PRG CSTEST.PRG
MAPS=$(PRGS:PRG=MAP)

SRCS=$(wildcard *.asm)
OBJS=$(SRCS:asm=o)
CSCOMMON_OBJS=\
    randomstream.o \
    ciphersaber_cipher.o \
    ciphersaber_io.o \
    ciphersaber_key_zero.o \
    ciphersaber_key_initialization_vector.o \
    ciphersaber_key_initialize_state_array.o \
    ciphersaber_key_setup.o \
    ciphersaber_key_mix.o \

all: $(OBJS) $(PRGS) $(MAPS)

clean:
	rm -f $(OBJS) $(PRGS) $(MAPS)

run:
	x16emu -debug 080d -prg CSDECRYPT.PRG -run -scale 2

push-%: all
	rsync -avz -e ssh --delete --progress $(HOME)/src/6502/cx16/ciphersaber/ $(*):src/6502/cx16/ciphersaber/

CSENCRYPT.MAP CSENCRYPT.PRG: csencrypt.o $(CSCOMMON_OBJS) randomstream.o
	cl65 -m CSENCRYPT.MAP -o CSENCRYPT.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

CSDECRYPT.MAP CSDECRYPT.PRG: csdecrypt.o $(CSCOMMON_OBJS)
	cl65 -m CSDECRYPT.MAP -o CSDECRYPT.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

CSTEST.MAP CSTEST.PRG: cstest.o ciphersaber_io.o
	cl65 -m CSTEST.MAP -o CSTEST.PRG -Wl -S,2049 -t cx16 -C cx16-asm.cfg $(^)

%.o: %.asm
	@ci -q -l -m- -t- $(^)
	ca65 -t cx16 -o $(@) $(^)
