.include "msp430g2553.inc"

    org 0xf800
start:
    mov.w #WDTPW|WDTHOLD, &WDTCTL
    ;Initialize stack pointer
    mov.w #300h , SP 
    ;Calibrate DCO
    mov.b &CALBC1_1MHZ , &BCSCTL1
    mov.b &CALDCO_1MHZ , &DCOCTL          
    ;Initialize LED's    
    mov.w #0x0041 , &P1DIR
    mov.b #0x01 , &P1OUT
main:
    xor.b #0x41 ,  &P1OUT
    call #delay
    jmp main


;Subprocess that creates a delay
delay:
    push R5
    mov.w #0xFFFF , R5
delay_loop:
    dec R5
    jn delay_loop
delay_done:
    pop R5
    ret

end:
    org 0xfffe
    dw start