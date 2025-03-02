.export key_setup
.import key_initialize, key_mix

.SEGMENT "CODE"

key_setup:
    jsr key_initialize
    jsr key_mix
    rts
