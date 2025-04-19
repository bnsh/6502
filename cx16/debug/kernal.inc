; https://github.com/X16Community/x16-docs/blob/master/X16%20Reference%20-%2005%20-%20KERNAL.md
; Class: CPB
    ACPTR = $FFA5
    ; Read byte from peripheral bus
    ; Inputs: 
    ; Affects: A X
    ; Origin: C64

    CIOUT = $FFA8
    ; Send byte to peripheral bus
    ; Inputs: A
    ; Affects: A X
    ; Origin: C64

    LISTEN = $FFB1
    ; Send LISTEN command
    ; Inputs: A
    ; Affects: A X
    ; Origin: C64

    MACPTR = $FF44
    ; Read multiple bytes from the peripheral bus
    ; Inputs: A X Y C
    ; Affects: A X Y P
    ; Origin: X16

    MCIOUT = $FEB1
    ; Write multiple bytes to the peripheral bus
    ; Inputs: A X Y C
    ; Affects: A X Y P
    ; Origin: X16

    SECOND = $FF93
    ; Send LISTEN secondary address
    ; Inputs: A
    ; Affects: A
    ; Origin: C64

    SETTMO = $FFA2
    ; Set timeout
    ; Inputs: 
    ; Affects: 
    ; Origin: C64

    TALK = $FFB4
    ; Send TALK command
    ; Inputs: A
    ; Affects: A
    ; Origin: C64

    TKSA = $FF96
    ; Send TALK secondary address
    ; Inputs: A
    ; Affects: A
    ; Origin: C64

    UNLSN = $FFAE
    ; Send UNLISTEN command
    ; Inputs: 
    ; Affects: A
    ; Origin: C64

    UNTLK = $FFAB
    ; Send UNTALK command
    ; Inputs: 
    ; Affects: A
    ; Origin: C64

; Class: ChIO
    BASIN = $FFCF
    ; Get character
    ; Inputs: 
    ; Affects: A X
    ; Origin: C64

    BSAVE = $FEBA
    ; Like SAVE but omits the 2-byte header
    ; Inputs: A X Y
    ; Affects: A X Y
    ; Origin: X16

    BSOUT = $FFD2
    ; Write byte in A to default output.
    ; Inputs: A
    ; Affects: P
    ; Origin: C64

    CHKIN = $FFC6
    ; Set channel for character input
    ; Inputs: X
    ; Affects: A X
    ; Origin: C64

    CHKOUT = $FFC9
    ; Set channel for character output
    ; Inputs: X
    ; Affects: A X
    ; Origin: C64

    CHRIN = $FFCF
    ; Alias for BASIN
    ; Inputs: 
    ; Affects: A X
    ; Origin: C64

    CHROUT = $FFD2
    ; Alias for BSOUT
    ; Inputs: A
    ; Affects: P
    ; Origin: C64

    CLALL = $FFE7
    ; Close all channels
    ; Inputs: 
    ; Affects: A X
    ; Origin: C64

    CLOSE = $FFC3
    ; Close a channel
    ; Inputs: A
    ; Affects: A X Y P
    ; Origin: C64

    CLOSE_ALL = $FF4A
    ; Close all files on a device
    ; Inputs: 
    ; Affects: 
    ; Origin: C128

    CLRCHN = $FFCC
    ; Restore character I/O to screen/keyboard
    ; Inputs: 
    ; Affects: A X
    ; Origin: C64

    LKUPLA = $FF59
    ; Search tables for given LA
    ; Inputs: 
    ; Affects: 
    ; Origin: C128

    LKUPSA = $FF5C
    ; Search tables for given SA
    ; Inputs: 
    ; Affects: 
    ; Origin: C128

    LOAD = $FFD5
    ; Load a file into main memory or VRAM
    ; Inputs: A X Y
    ; Affects: A X Y
    ; Origin: C64

    OPEN = $FFC0
    ; Open a channel/file.
    ; Inputs: 
    ; Affects: A X Y
    ; Origin: C64

    READST = $FFB7
    ; Return status byte
    ; Inputs: 
    ; Affects: A
    ; Origin: C64

    SAVE = $FFD8
    ; Save a file from memory
    ; Inputs: A X Y
    ; Affects: A X Y C
    ; Origin: C64

    SETLFS = $FFBA
    ; Set file parameters (LA, FA, and SA).
    ; Inputs: A X Y
    ; Affects: 
    ; Origin: C64

    SETMSG = $FF90
    ; Set verbosity
    ; Inputs: A
    ; Affects: 
    ; Origin: C64

    SETNAM = $FFBD
    ; Set file name.
    ; Inputs: A X Y
    ; Affects: 
    ; Origin: C64

; Class: I2C
    I2C_BATCH_READ = $FEB4
    ; Read multiple bytes from an I2C device
    ; Inputs: X r0 r1 C
    ; Affects: A Y C
    ; Origin: X16

    I2C_BATCH_WRITE = $FEB7
    ; Write multiple bytes to an I2C device
    ; Inputs: X r0 r1 C
    ; Affects: A Y r2 C
    ; Origin: X16

    I2C_READ_BYTE = $FEC6
    ; Read a byte from an I2C device
    ; Inputs: A X Y
    ; Affects: A C
    ; Origin: X16

    I2C_WRITE_BYTE = $FEC9
    ; Write a byte to an I2C device
    ; Inputs: A X Y
    ; Affects: A C
    ; Origin: X16

; Class: Joy
    JOYSTICK_GET = $FF56
    ; Get one of the saved controller states
    ; Inputs: A
    ; Affects: A X Y P
    ; Origin: X16

    JOYSTICK_SCAN = $FF53
    ; Poll controller states and save them
    ; Inputs: none
    ; Affects: A X Y P
    ; Origin: X16

; Class: Kbd
    GETIN = $FFE4
    ; Get character from keyboard
    ; Inputs: 
    ; Affects: A X
    ; Origin: C64

    KBDBUF_GET_MODIFIERS = $FEC0
    ; Get currently pressed modifiers
    ; Inputs: A
    ; Affects: A X P
    ; Origin: X16

    KBDBUF_PEEK = $FEBD
    ; Get next char and keyboard queue length
    ; Inputs: A X
    ; Affects: A X P
    ; Origin: X16

    KBDBUF_PUT = $FEC3
    ; Append a character to the keyboard queue
    ; Inputs: A
    ; Affects: X
    ; Origin: X16

    KBD_SCAN = $FF9F
    ; Process a keystroke and place it in the buffer
    ; Inputs: none
    ; Affects: A X Y P
    ; Origin: C64

    KEYMAP = $FED2
    ; Set or get the current keyboard layout Call address
    ; Inputs: X Y C
    ; Affects: A X Y C
    ; Origin: X16

    SCNKEY = $FF9F
    ; Alias for kbd_scan
    ; Inputs: none
    ; Affects: A X Y P
    ; Origin: C64

    STOP = $FFE1
    ; Test for STOP key
    ; Inputs: 
    ; Affects: A X P
    ; Origin: C64

; Class: Mem
    FETCH = $FF74
    ; Read a byte from any RAM or ROM bank
    ; Inputs: (A) X Y
    ; Affects: A X P
    ; Origin: X16

    MEMBOT = $FF9C
    ; Get address of start of usable RAM
    ; Inputs: 
    ; Affects: 
    ; Origin: C64

    MEMORY_COPY = $FEE7
    ; Copy a memory region to a different region
    ; Inputs: r0 r1 r2
    ; Affects: r2 A X Y P
    ; Origin: X16

    MEMORY_CRC = $FEEA
    ; Calculate the CRC16 of a memory region
    ; Inputs: r0 r1
    ; Affects: r2 A X Y P
    ; Origin: X16

    MEMORY_DECOMPRESS = $FEED
    ; Decompress an LZSA2 block
    ; Inputs: r0 r1
    ; Affects: r1 A X Y P
    ; Origin: X16

    MEMORY_FILL = $FEE4
    ; Fill a memory region with a byte value
    ; Inputs: A r0 r1
    ; Affects: r1 X Y P
    ; Origin: X16

    MEMTOP = $FF99
    ; Get/set number of banks and address of the end of usable RAM
    ; Inputs: 
    ; Affects: A X Y
    ; Origin: C64

    STASH = $FF77
    ; Write a byte to any RAM bank
    ; Inputs: stavec A X Y
    ; Affects: (stavec) X P
    ; Origin: X16

; Class: Misc
    ENTER_BASIC = $FF47
    ; Enter BASIC
    ; Inputs: C
    ; Affects: A X Y P
    ; Origin: X16

    ENTROPY_GET = $FECF
    ; get 24 random bits
    ; Inputs: none
    ; Affects: A X Y P
    ; Origin: X16

    EXTAPI = $FEAB
    ; Extended API
    ; Inputs: A X Y P
    ; Affects: A X Y P
    ; Origin: X16

    EXTAPI16 = $FEA8
    ; Extended 65C816 API
    ; Inputs: A X Y P
    ; Affects: A X Y P
    ; Origin: X16

    IOBASE = $FFF3
    ; Return start of I/O area
    ; Inputs: 
    ; Affects: X Y
    ; Origin: C64

    JSRFAR = $FF6E
    ; Execute a routine on another RAM or ROM bank
    ; Inputs: PC+3 PC+5
    ; Affects: none
    ; Origin: X16

    MONITOR = $FECC
    ; Enter machine language monitor
    ; Inputs: none
    ; Affects: A X Y P
    ; Origin: X16

    PRIMM = $FF7D
    ; Print string following the caller’s code
    ; Inputs: 
    ; Affects: 
    ; Origin: C128

; Class: Mouse
    MOUSE_CONFIG = $FF68
    ; Configure mouse pointer
    ; Inputs: A X Y
    ; Affects: A X Y P
    ; Origin: X16

    MOUSE_GET = $FF6B
    ; Get saved mouse sate
    ; Inputs: X
    ; Affects: A (X) P
    ; Origin: X16

    MOUSE_SCAN = $FF71
    ; Poll mouse state and save it
    ; Inputs: none
    ; Affects: A X Y P
    ; Origin: X16

; Class: Time
    CLOCK_GET_DATE_TIME = $FF50
    ; Get the date and time
    ; Inputs: none
    ; Affects: r0 r1 r2 r3 A X Y P
    ; Origin: X16

    CLOCK_SET_DATE_TIME = $FF4D
    ; Set the date and time
    ; Inputs: r0 r1 r2 r3
    ; Affects: A X Y P
    ; Origin: X16

    RDTIM = $FFDE
    ; Read system clock
    ; Inputs: 
    ; Affects: A X Y
    ; Origin: C64

    SETTIM = $FFDB
    ; Write system clock
    ; Inputs: A X Y
    ; Affects: A X Y
    ; Origin: C64

    UDTIM = $FFEA
    ; Increment the jiffies clock
    ; Inputs: 
    ; Affects: A X
    ; Origin: C64

; Class: Video
    CONSOLE_GET_CHAR = $FEE1
    ; Get character from console
    ; Inputs: A
    ; Affects: r0 r1 r2 r3 r4 r5 r6 r12 r13 r14 r15 A X Y P
    ; Origin: X16

    CONSOLE_INIT = $FEDB
    ; Initialize console mode
    ; Inputs: none
    ; Affects: r0 A P
    ; Origin: X16

    CONSOLE_PUT_CHAR = $FEDE
    ; Print character to console
    ; Inputs: A C
    ; Affects: r0 r1 r2 r3 r4 r5 r6 r12 r13 r14 r15 A X Y P
    ; Origin: X16

    CONSOLE_PUT_IMAGE = $FED8
    ; Draw image as if it was a character
    ; Inputs: r0 r1 r2
    ; Affects: r0 r1 r2 r3 r4 r5 r14 r15 A X Y P
    ; Origin: X16

    CONSOLE_SET_PAGING_MESSAGE = $FED5
    ; Set paging message or disable paging
    ; Inputs: r0
    ; Affects: A P
    ; Origin: X16

    FB_CURSOR_NEXT_LINE = $FF02
    ; Move direct-access cursor to next line
    ; Inputs: r0†
    ; Affects: A P
    ; Origin: X16

    FB_CURSOR_POSITION = $FEFF
    ; Position the direct-access cursor
    ; Inputs: r0 r1
    ; Affects: A P
    ; Origin: X16

    FB_FILL_PIXELS = $FF17
    ; Fill pixels with constant color, update cursor
    ; Inputs: r0 r1 A
    ; Affects: A X Y P
    ; Origin: X16

    FB_FILTER_PIXELS = $FF1A
    ; Apply transform to pixels, update cursor
    ; Inputs: r0 r1
    ; Affects: r14H r15 A X Y P
    ; Origin: X16

    FB_GET_INFO = $FEF9
    ; Get screen size and color depth
    ; Inputs: none
    ; Affects: r0 r1 A P
    ; Origin: X16

    FB_GET_PIXEL = $FF05
    ; Read one pixel, update cursor
    ; Inputs: none
    ; Affects: A
    ; Origin: X16

    FB_GET_PIXELS = $FF08
    ; Copy pixels into RAM, update cursor
    ; Inputs: r0 r1
    ; Affects: (r0) A X Y P
    ; Origin: X16

    FB_INIT = $FEF6
    ; Enable graphics mode
    ; Inputs: none
    ; Affects: A P
    ; Origin: X16

    FB_MOVE_PIXELS = $FF1D
    ; Copy horizontally consecutive pixels to a different position
    ; Inputs: r0 r1 r2 r3 r4
    ; Affects: A X Y P
    ; Origin: X16

    FB_SET_8_PIXELS = $FF11
    ; Set 8 pixels from bit mask (transparent), update cursor
    ; Inputs: A X
    ; Affects: A P
    ; Origin: X16

    FB_SET_8_PIXELS_OPAQUE = $FF14
    ; Set 8 pixels from bit mask (opaque), update cursor
    ; Inputs: r0L A X Y
    ; Affects: r0L A P
    ; Origin: X16

    FB_SET_PALETTE = $FEFC
    ; Set (parts of) the palette
    ; Inputs: A X r0
    ; Affects: A X Y P
    ; Origin: X16

    FB_SET_PIXEL = $FF0B
    ; Set one pixel, update cursor
    ; Inputs: A
    ; Affects: none
    ; Origin: X16

    FB_SET_PIXELS = $FF0E
    ; Copy pixels from RAM, update cursor
    ; Inputs: r0 r1
    ; Affects: A X P
    ; Origin: X16

    GRAPH_CLEAR = $FF23
    ; Clear screen
    ; Inputs: none
    ; Affects: r0 r1 r2 r3 A X Y P
    ; Origin: X16

    GRAPH_DRAW_IMAGE = $FF38
    ; Draw a rectangular image
    ; Inputs: r0 r1 r2 r3 r4
    ; Affects: A P
    ; Origin: X16

    GRAPH_DRAW_LINE = $FF2C
    ; Draw a line
    ; Inputs: r0 r1 r2 r3
    ; Affects: r0 r1 r2 r3 r7 r8 r9 r10 r12 r13 A X Y P
    ; Origin: X16

    GRAPH_DRAW_OVAL = $FF35
    ; Draw an oval or circle (optionally filled)
    ; Inputs: r0 r1 r2 r3 r4 C
    ; Affects: A X Y P
    ; Origin: X16

    GRAPH_DRAW_RECT = $FF2F
    ; Draw a rectangle (optionally filled)
    ; Inputs: r0 r1 r2 r3 r4 C
    ; Affects: A P
    ; Origin: X16

    GRAPH_GET_CHAR_SIZE = $FF3E
    ; Get size and baseline of a character
    ; Inputs: A X
    ; Affects: A X Y P
    ; Origin: X16

    GRAPH_INIT = $FF20
    ; Initialize graphics
    ; Inputs: r0
    ; Affects: r0 r1 r2 r3 A X Y P
    ; Origin: X16

    GRAPH_MOVE_RECT = $FF32
    ; Move pixels
    ; Inputs: r0 r1 r2 r3 r4 r5
    ; Affects: r1 r3 r5 A X Y P
    ; Origin: X16

    GRAPH_PUT_CHAR = $FF41
    ; Print a character
    ; Inputs: r0 r1 A
    ; Affects: r0 r1 A X Y P
    ; Origin: X16

    GRAPH_SET_COLORS = $FF29
    ; Set stroke, fill and background colors
    ; Inputs: A X Y
    ; Affects: none
    ; Origin: X16

    GRAPH_SET_FONT = $FF3B
    ; Set the current font
    ; Inputs: r0
    ; Affects: r0 A Y P
    ; Origin: X16

    GRAPH_SET_WINDOW = $FF26
    ; Set clipping region
    ; Inputs: r0 r1 r2 r3
    ; Affects: A P
    ; Origin: X16

    PLOT = $FFF0
    ; Read/write cursor position
    ; Inputs: A X Y
    ; Affects: A X Y
    ; Origin: C64

    SCREEN = $FFED
    ; Get the text resolution of the screen
    ; Inputs: 
    ; Affects: X Y
    ; Origin: C64

    SCREEN_MODE = $FF5F
    ; Get/set screen mode
    ; Inputs: A C
    ; Affects: A X Y P
    ; Origin: X16

    SCREEN_SET_CHARSET = $FF62
    ; Activate 8x8 text mode charset
    ; Inputs: A X Y
    ; Affects: A X Y P
    ; Origin: X16

    SPRITE_SET_IMAGE = $FEF0
    ; Set the image of a sprite
    ; Inputs: r0 r1 r2L A X Y C
    ; Affects: A P
    ; Origin: X16

    SPRITE_SET_POSITION = $FEF3
    ; Set the position of a sprite
    ; Inputs: r0 r1 A
    ; Affects: A X P
    ; Origin: X16

