.exportzp cleartext_address, ciphertext_address, key_address, iv_address, rounds

.segment "ZEROPAGE"
key_address:
    .addr $0000

iv_address:
    .addr $0000

cleartext_address:
    .addr $0000

ciphertext_address:
    .addr $0000

rounds:
    .byte $00
