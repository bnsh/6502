; # New API for the Commander X16
; There are lots of new APIs. Please note that their addresses and their behavior is still preliminary and can change between revisions.
; 
; Some new APIs use the "16 bit" ABI, which uses virtual 16 bit registers r0 through r15, which are located in zero page locations $02 through $21: r0 = r0L = $02, r0H = $03, r1 = r1L = $04 etc.
; 
; The 16 bit ABI generally follows the following conventions:
; 
; arguments
; word-sized arguments: passed in r0-r5
; byte-sized arguments: if three or less, passed in .A, .X, .Y; otherwise in 16 bit registers
; boolean arguments: c, n
; return values
; basic rules as above
; function takes no arguments: r0-r5, else indirect through passed-in pointer
; arguments in r0-r5 can be "inout", i.e. they can be updated
; saved/scratch registers
; r0-r5: arguments (saved)
; r6-r10: saved
; r11-r15: scratch
; .A, .X, .Y, c, n: scratch (unless used otherwise)

; register 0 -> zero page address $02
r0 = $02
r0L = $02
r0H = $03

; register 1 -> zero page address $04
r1 = $04
r1L = $04
r1H = $05

; register 2 -> zero page address $06
r2 = $06
r2L = $06
r2H = $07

; register 3 -> zero page address $08
r3 = $08
r3L = $08
r3H = $09

; register 4 -> zero page address $0a
r4 = $0a
r4L = $0a
r4H = $0b

; register 5 -> zero page address $0c
r5 = $0c
r5L = $0c
r5H = $0d

; register 6 -> zero page address $0e
r6 = $0e
r6L = $0e
r6H = $0f

; register 7 -> zero page address $10
r7 = $10
r7L = $10
r7H = $11

; register 8 -> zero page address $12
r8 = $12
r8L = $12
r8H = $13

; register 9 -> zero page address $14
r9 = $14
r9L = $14
r9H = $15

; register 10 -> zero page address $16
r10 = $16
r10L = $16
r10H = $17

; register 11 -> zero page address $18
r11 = $18
r11L = $18
r11H = $19

; register 12 -> zero page address $1a
r12 = $1a
r12L = $1a
r12H = $1b

; register 13 -> zero page address $1c
r13 = $1c
r13L = $1c
r13H = $1d

; register 14 -> zero page address $1e
r14 = $1e
r14L = $1e
r14H = $1f

; register 15 -> zero page address $20
r15 = $20
r15L = $20
r15H = $21

