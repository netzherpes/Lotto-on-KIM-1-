
;*****************************
;* Lotto                     *
;*                           *
;* Author Raimund Pourvoyeur *
;*                           *
;* Funkschau 24 1979         *
;*****************************
      
first    =       $00
scnd     =       $01
thrd     =       $02
forth    =       $03
fifth    =       $04
Turn     =       $06
switch   =       $07
RNDval   =       $08
SCANS    =       $1f1f
GETKEY   =       $1f6a

         .org    $0200
goDECimal:
         sed                ;lets start in decimal mode
         lda     #$00
         sta     Turn
         lda     #$99
         sta     RNDval
chck49:  lda     RNDval
         cmp     #$49       ;from 1-49 
         bne     add1
         lda     #$00       ;more than 49  - go to 0
add1:    clc
         adc     #$01       ;count up as long as 0 is pressed
         sta     RNDval
dblchk:  jsr     GETKEY     ;getkey
         cmp     #$00       ;0pushed?
         beq     blank
         lda     switch
         cmp     #$00
         bne     show
         lda     RNDval
         cmp     first
         beq     chck49
         cmp     scnd
         beq     chck49
         cmp     thrd
         beq     chck49
         cmp     forth
         beq     chck49
         cmp     fifth
         beq     chck49
         lda     Turn
         sta     storeRND+1 ;selfaltering code? my eyes hurt
         lda     RNDval
storeRND:
         sta     thrd       ;replace 02 with the Turn
         inc     Turn
show:    lda     #$ff       ;ff if doubles were checked... do not check again 
         sta     switch
         lda     Turn
         sta     $fa
         lda     #$00
         sta     $fb
         lda     RNDval
         sta     $f9
         jsr     SCANS
         jmp     dblchk

blank:   lda     #$00       ;set switch to not checked
         sta     switch
         sta     $fb
         sta     $fa
         sta     $f9
         jsr     SCANS      ;show blank
         lda     Turn
         cmp     #$06       ;restart on the 7th buttonpush
         bne     L0276      ;else head on
         lda     #$00
         ldx     #$06
clr:     sta     first,x    ;clear all
         dex
         bpl     clr
L0276:   jmp     chck49     ;go on with the loop as long as 0 is pushes

