.segment "CODE"

; https://en.wikipedia.org/wiki/SHA-2#Pseudocode
; Initialize hash values:
; (first 32 bits of the fractional parts of the square roots of the first 8 primes 2..19):
; h0 := 0x6a09e667
; h1 := 0xbb67ae85
; h2 := 0x3c6ef372
; h3 := 0xa54ff53a
; h4 := 0x510e527f
; h5 := 0x9b05688c
; h6 := 0x1f83d9ab
; h7 := 0x5be0cd19
; 
; Initialize array of round constants:
; (first 32 bits of the fractional parts of the cube roots of the first 64 primes 2..311):
; k[0..63] :=
;    0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5, 0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
;    0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3, 0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
;    0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc, 0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
;    0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7, 0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
;    0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13, 0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
;    0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3, 0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
;    0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5, 0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
;    0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208, 0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2


h:
h0:
     .byte $6a, $09, $e6, $67 ; $6a09e667
h1:
     .byte $bb, $67, $ae, $85 ; $bb67ae85
h2:
     .byte $3c, $6e, $f3, $72 ; $3c6ef372
h3:
     .byte $a5, $4f, $f5, $3a ; $a54ff53a
h4:
     .byte $51, $0e, $52, $7f ; $510e527f
h5:
     .byte $9b, $05, $68, $8c ; $9b05688c
h6:
     .byte $1f, $83, $d9, $ab ; $1f83d9ab
h7:
     .byte $5b, $e0, $cd, $19 ; $5be0cd19



k:
k00:
     .byte $42, $8a, $2f, $98 ; $428a2f98
k01:
     .byte $71, $37, $44, $91 ; $71374491
k02:
     .byte $b5, $c0, $fb, $cf ; $b5c0fbcf
k03:
     .byte $e9, $b5, $db, $a5 ; $e9b5dba5
k04:
     .byte $39, $56, $c2, $5b ; $3956c25b
k05:
     .byte $59, $f1, $11, $f1 ; $59f111f1
k06:
     .byte $92, $3f, $82, $a4 ; $923f82a4
k07:
     .byte $ab, $1c, $5e, $d5 ; $ab1c5ed5
k08:
     .byte $d8, $07, $aa, $98 ; $d807aa98
k09:
     .byte $12, $83, $5b, $01 ; $12835b01
k10:
     .byte $24, $31, $85, $be ; $243185be
k11:
     .byte $55, $0c, $7d, $c3 ; $550c7dc3
k12:
     .byte $72, $be, $5d, $74 ; $72be5d74
k13:
     .byte $80, $de, $b1, $fe ; $80deb1fe
k14:
     .byte $9b, $dc, $06, $a7 ; $9bdc06a7
k15:
     .byte $c1, $9b, $f1, $74 ; $c19bf174
k16:
     .byte $e4, $9b, $69, $c1 ; $e49b69c1
k17:
     .byte $ef, $be, $47, $86 ; $efbe4786
k18:
     .byte $0f, $c1, $9d, $c6 ; $0fc19dc6
k19:
     .byte $24, $0c, $a1, $cc ; $240ca1cc
k20:
     .byte $2d, $e9, $2c, $6f ; $2de92c6f
k21:
     .byte $4a, $74, $84, $aa ; $4a7484aa
k22:
     .byte $5c, $b0, $a9, $dc ; $5cb0a9dc
k23:
     .byte $76, $f9, $88, $da ; $76f988da
k24:
     .byte $98, $3e, $51, $52 ; $983e5152
k25:
     .byte $a8, $31, $c6, $6d ; $a831c66d
k26:
     .byte $b0, $03, $27, $c8 ; $b00327c8
k27:
     .byte $bf, $59, $7f, $c7 ; $bf597fc7
k28:
     .byte $c6, $e0, $0b, $f3 ; $c6e00bf3
k29:
     .byte $d5, $a7, $91, $47 ; $d5a79147
k30:
     .byte $06, $ca, $63, $51 ; $06ca6351
k31:
     .byte $14, $29, $29, $67 ; $14292967
k32:
     .byte $27, $b7, $0a, $85 ; $27b70a85
k33:
     .byte $2e, $1b, $21, $38 ; $2e1b2138
k34:
     .byte $4d, $2c, $6d, $fc ; $4d2c6dfc
k35:
     .byte $53, $38, $0d, $13 ; $53380d13
k36:
     .byte $65, $0a, $73, $54 ; $650a7354
k37:
     .byte $76, $6a, $0a, $bb ; $766a0abb
k38:
     .byte $81, $c2, $c9, $2e ; $81c2c92e
k39:
     .byte $92, $72, $2c, $85 ; $92722c85
k40:
     .byte $a2, $bf, $e8, $a1 ; $a2bfe8a1
k41:
     .byte $a8, $1a, $66, $4b ; $a81a664b
k42:
     .byte $c2, $4b, $8b, $70 ; $c24b8b70
k43:
     .byte $c7, $6c, $51, $a3 ; $c76c51a3
k44:
     .byte $d1, $92, $e8, $19 ; $d192e819
k45:
     .byte $d6, $99, $06, $24 ; $d6990624
k46:
     .byte $f4, $0e, $35, $85 ; $f40e3585
k47:
     .byte $10, $6a, $a0, $70 ; $106aa070
k48:
     .byte $19, $a4, $c1, $16 ; $19a4c116
k49:
     .byte $1e, $37, $6c, $08 ; $1e376c08
k50:
     .byte $27, $48, $77, $4c ; $2748774c
k51:
     .byte $34, $b0, $bc, $b5 ; $34b0bcb5
k52:
     .byte $39, $1c, $0c, $b3 ; $391c0cb3
k53:
     .byte $4e, $d8, $aa, $4a ; $4ed8aa4a
k54:
     .byte $5b, $9c, $ca, $4f ; $5b9cca4f
k55:
     .byte $68, $2e, $6f, $f3 ; $682e6ff3
k56:
     .byte $74, $8f, $82, $ee ; $748f82ee
k57:
     .byte $78, $a5, $63, $6f ; $78a5636f
k58:
     .byte $84, $c8, $78, $14 ; $84c87814
k59:
     .byte $8c, $c7, $02, $08 ; $8cc70208
k60:
     .byte $90, $be, $ff, $fa ; $90befffa
k61:
     .byte $a4, $50, $6c, $eb ; $a4506ceb
k62:
     .byte $be, $f9, $a3, $f7 ; $bef9a3f7
k63:
     .byte $c6, $71, $78, $f2 ; $c67178f2

