;; bcc is acc < compare
;; bcs is acc >= compare
.macro blt arg
    bcc arg
.endmacro

.macro ble arg
    bcc arg ; _strictly_ less than. 
    beq arg ; or _equal_
.endmacro

.macro bge arg
    bcs arg
.endmacro

.macro bgt arg
.scope
    beq skip  ; if not equal and
    bcs arg   ; (>=)
skip:
.endscope
.endmacro

.macro bzc arg
; branch on zero clear
    bne arg
.endmacro

.macro bzs arg
; branch on zero set
    beq arg
.endmacro

.macro bnc arg
; branch on negative clear
    bpl arg
.endmacro

.macro bns arg
; branch on negative set
    bmi arg
.endmacro
