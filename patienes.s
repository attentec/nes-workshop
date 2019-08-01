.INCLUDE "modules/nk_joypad.s"
.INCLUDE "nk.s"

.SEGMENT    "ZEROPAGE"

COUNTER:
    .RES 1

.SEGMENT    "CODE"

RESET:
    NK_CTRL_CONFIG  NK_CTRL_NMI
    NK_MASK_CONFIG  NK_MASK_BG_SHOW|NK_MASK_SPR_SHOW|NK_MASK_BG_NOCLIP

    LDX #%00000100
    STX $4015
    LDX #%10000001
    STX $4008
    STX $400B
    LDX #$FF
    STX COUNTER
    STX $400A

; Reset palette
    LDA     #$06
    STA     v_nk_pal_zero
    LDA     #$0F
    LDX     #3*4-1
@reset_pal_loop:
    STA     v_nk_pal_bg, X
    STA     v_nk_pal_spr, X
    DEX
    BPL     @reset_pal_loop

; Reset tiles
    NK_PPU_ORG $0000
    LDX     #$00
    LDY     #16
@reset_tiles_loop:
    STX     $2007
    DEY
    BNE     @reset_tiles_loop

    RTS

UPDATE:
    NK_JOYPAD_READ 0
    LDA v_nk_joypad_pressed
    BEQ @exit
    LDX #$FF
    STX COUNTER
    LDX #$2A
    STX v_nk_pal_zero
@exit:
    RTS

VBLANK:
    LDX COUNTER
    BEQ @exit
    DEX
    STX COUNTER
    STX $400A
@exit:
    RTS
