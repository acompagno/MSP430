.include "msp430g2553.inc"

    org 0xf800
start:
    mov.w #WDTPW|WDTHOLD, &WDTCTL
    mov.w #300h , SP         ;initialize stack pointer
    mov.w #0x0041 , &P1DIR
    mov.b #0x01 , &P1OUT
    call #uartInit
loop:
    ;call #uartGetChar
    mov.b #0x41 , R4
    call #uartPutChar
    jmp delay
delay:
    dec R5
    cmp.w #0x00 , R5 
    jnz delay
    jmp loop

uartInit:
    mov.b #0x30,&P2SEL
    mov.b #0x00,&UCA0CTL0
    mov.b #0x41,&UCA0CTL1
    mov.b #0x00,&UCA0BR1
    mov.b #0x03,&UCA0BR0
    mov.b #0x06,&UCA0MCTL
    mov.b #0x00,&UCA0STAT
    mov.b #0x40,&UCA0CTL1
    mov.b #0x00,&IE2
    ret

uartPutChar:
    push R5
lp:
    mov.b &IFG2 , R5
    and.b #0x01 , R5
    cmp.b #0x00 , R5
    jnz lp
    mov.b R4 , &UCA0TXBUF
    pop R5
    ret

uartGetChar:
    push R5
lp2:
    mov.b &IFG2 , R5
    xor.b #0x41 , &P1OUT
    and.b #0x01 , R5
    cmp.b #0x00 , R5
    jz lp2
    xor.b #0x41 , &P1OUT
    mov.b &UCA0RXBUF , R4
    pop R5
    ret

end:
    org 0xfffe
    dw start
