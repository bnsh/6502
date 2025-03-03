.export key_setup
.import key_initialize_state_array, key_initialization_vector, key_mix

.segment "CODE"

key_setup:
    jsr key_initialize_state_array
    jsr key_initialization_vector
    jsr key_mix
    rts
