;*****************************
;* Lotto                     *
;*                           *
;* Author Raimund Pourvoyeur *
;*                           *
;* Funkschau 24 1979         *
;*****************************
 
Turn     =       $06
RNDval   =       $08

         .org    $0200
goDECimal:
         sed
         lda     #$00
         sta     Turn
         lda     #$99
         sta     RNDval
chck49:  lda     RNDval
         cmp     #$49
         bne     add1
         lda     #$00
add1:    clc
         adc     #$01
         sta     RNDval
dblchk:  jsr     $1f6a      ;getkey
         cmp     #$00       ;0pushed?
         beq     blank
         lda     $07
         cmp     #$00
         bne     show
         lda     RNDval
         cmp     $00
         beq     chck49
         cmp     $01
         beq     chck49
         cmp     $02
         beq     chck49
         cmp     $03
         beq     chck49
         cmp     $04
         beq     chck49
         lda     Turn
         sta     @L0240+1   ;selfaltering code?
         lda     RNDval
@L0240:  sta     $02
         inc     Turn
show:    lda     #$ff
         sta     $07
         lda     Turn
         sta     $fa
         lda     #$00
         sta     $fb
         lda     RNDval
         sta     $f9
         jsr     $1f1f
         jmp     dblchk

blank:   lda     #$00
         sta     $07
         sta     $fb
         sta     $fa
         sta     $f9
         jsr     $1f1f
         lda     Turn
         cmp     #$06       ;last turn?
         bne     L0276      ;then head on
         lda     #$00
         ldx     #$06
clr:     sta     $00,x      ;clear all
         dex
         bpl     clr
L0276:   jmp     chck49

