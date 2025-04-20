; Courtesy of @MarkTheStrange
; Use as
; .basic_line_number 200, { sys, str {main} }
; .byte 0, 0

; TODO: We need a list of all the basic tokens.

basic_print = $99
basic_sys = $9e

.macro basic_line number, content
  .local next 
  .word next
  .word number
  .byte content
  .byte 0   
 next:      
.endmacro
