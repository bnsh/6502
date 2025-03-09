# Ciphersaber for the Commander x16.

[Ciphersaber](https://cablemodem.hex21.com/ciphersaber/) is an encryption algorithm based on [RC4](https://en.wikipedia.org/wiki/RC4).. There's a whole advocacy about cryptography in there, which I somewhat agree with, but really this is just my way of leveling up my chops with the [Commander X16](https://www.commanderx16.com/)/[65C02](https://en.wikipedia.org/wiki/WDC_65C02)..

The "main" programs are:
1. `csdecrypt.asm` -> `CSDECRYPT.PRG`
2. `csencrypt.asm` -> `CSENCRYPT.PRG` and
3. `cstest.asm` -> `CSTEST.PRG`

`CSTEST.PRG` just copies `cknightcx16.cs256` to `cknightcx16.cpy` is all.. The other two do what their names imply.

# Roadmap

- [csencrypt.asm](csencrypt.asm): _Encryption program_
- [csdecrypt.asm](csdecrypt.asm): _Decryption program_
- [cstest.asm](cstest.asm): _File I/O test program_
- [ciphersaber_cipher.asm](ciphersaber_cipher.asm): _Core cipher logic_
- [ciphersaber_key_initialization_vector.asm](ciphersaber_key_initialization_vector.asm): _Copies the key address, iv etc, into place._
- [ciphersaber_key_initialize_state_array.asm](ciphersaber_key_initialize_state_array.asm): _Initializes the RC4 state array_
- [ciphersaber_key_mix.asm](ciphersaber_key_mix.asm): _Key Mixing routine._
- [ciphersaber_io.asm](ciphersaber_io.asm): _File reading & writing_
- [ciphersaber_key_setup.asm](ciphersaber_key_setup.asm): _Calls key setup functions_
- [randomstream.asm](randomstream.asm): _Random number generator_
- [debug_ciphersaber.asm](debug_ciphersaber.asm): _Debugging specific to ciphersaber_
- [debug_registers.asm](../debug/debug_registers.asm): _Register debugger (I don't think I actually use either of these anymore, but it _was_ handy while I was writing this.)_
- [writeutils.inc](../debug/writeutils.inc): _These are utilities to write to the console. I think they're really only used by the debuggers._
- [writeutils.asm](../debug/writeutils.asm)
- [sensible_unsigned_compares.inc](../debug/sensible_unsigned_compares.inc): _Friendlier (to me, anyway) comparison *pseudo* op-codes, like `blt`, `ble`, `bgt` and `bge` as opposed to `bcs` and `bcc`_
- [ciphersaber_key_zero.asm](ciphersaber_key_zero.asm): _Zero page locations. (Tho, there are other zero page addresses in use, so this is somewhat misleading, unfortunately.)_
- [cknightcx16.gif](cknightcx16.gif): _My signed Ciphersaber certificate! Go get your own! See [cknight.cs1](https://cablemodem.hex21.com/ciphersaber/#testfiles)_
- [cknightcx16.cs256](cknightcx16.cs256): _The above Ciphersaber certificate encrypted with "CommanderX16!" and rounds=256_
- [kernal.inc](../debug/kernal.inc) _These are just all the kernal routines from [KERNAL.md](https://github.com/X16Community/x16-docs/blob/master/X16%20Reference%20-%2005%20-%20KERNAL.md)_
- [Makefile](Makefile): _Build automation_
- [README.md](README.md): _This file._

# TODO
- I'd _love_ to be able to just write a
   ```basic
   pw$ = "CommanderX16!"
   plaintext_fn$ = "cknightcx16.gif"
   ciphertext_fn$ = "cknightcx16.cs256"
   rounds = 256
  ```
  And _somehow_ call it with these arguments.. I just don't know how to pass arguments that way to machine language short of awful `POKE`ing. Which I guess I was fine with back in the day, but now seems.. *crude*.

  Although... I saw in the [C64 Programmers Reference Guide](https://archive.org/details/c64-programmer-ref/page/n329/mode/2up) a reference to a `CHRGET` routine, which says:

  > 5. The **CHRGET** routine is used by BASIC to get each character/token. This makes it simple to add new BASIC commands. Naturally, each new command must be executed by a user written machine language subroutine. A common way to use this method is to specify a character (@ for example) which will occur before any of the new commands. The new CHRGET routine will search for the special character. If none is present, control is passed to the normal BASIC CHRGET routine. If the special character is present, the new command is interpreted and executed by your machine language program. This minimizes the extra execution time added by the need to search for additional commands. This technique is often called a wedge.

  But then, I don't see any further reference to `CHRGET`... Hm. Well, I'm not programming on the C64.. I wonder if I _could_ in _practice_ _make_ a new commander X16 basic command... Hmmm.. Maybe
  ```basic
  ciphersaber_encrypt(256, "CommanderX16!", "ciphertext.cs1", "plaintext.txt") REM to encrypt and
  ciphersaber_decrypt(256, "CommanderX16!", "plaintext.txt", "ciphertext.cs1") REM to decrypt
  ```
  Hmm..
