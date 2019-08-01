.INCLUDE "modules/nk_joypad.s"
.INCLUDE "nk.s"

.SEGMENT    "ZEROPAGE"

COUNTER:
    .RES 1

.SEGMENT    "CODE"

RESET:
    NK_CTRL_CONFIG  NK_CTRL_NMI
    NK_MASK_CONFIG  NK_MASK_TINT_BLUE
    LDX #%00000100
    STX $4015
    LDX #%10000001
    STX $4008
    STX $400B
    LDX #$FF
    STX COUNTER
    STX $400A
    RTS

UPDATE:
    NK_JOYPAD_READ 0
    LDA v_nk_joypad_pressed
    BEQ @exit
    LDX #$FF
    STX COUNTER
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
