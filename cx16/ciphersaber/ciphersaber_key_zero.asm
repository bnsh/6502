.exportzp cleartext_address, ciphertext_address, key_address, rounds

.SEGMENT "ZEROPAGE"
key_address:
    .addr $0000

cleartext_address:
    .addr $0000

ciphertext_address:
    .addr $0000

rounds:
    .byte $00
