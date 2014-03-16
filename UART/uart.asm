    .include "msp430g2553.inc"
    org 0xf800
start:
    mov.w #WDTPW|WDTHOLD, &WDTCTL
    mov.w #300h,SP         ;initialize stack pointer
    mov.b #0x41, &P1DIR
uart:
    ;call #uartInit
    mov.b #0x041 , &UCA0TXBUF
    org 0xfffe
    dw start             ; set reset vector to 'init' labl
uartInit:
    mov.b #0x06 , &P1SEL
    mov.b #0x06 , &P1SEL2
    mov.b #0x04 , &P1DIR
    mov.b &UCSSEL_2 , &UCA0CTL1
    mov.b #0x68 , UCA0BR0
    mov.b #0x00 , UCA0BR1
    mov.b &UCBRS1 , &UCA0MCTL
    mov.b &UCSWRST , R8
    xor.b #0xff , R8
    and.b R8 , UCA0CTL1
    ret
