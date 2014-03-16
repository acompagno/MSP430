.include "msp430g2553.inc"

    org 0xf800
start:
    mov.w #WDTPW|WDTHOLD, &WDTCTL
    mov.w #300h , SP         ;initialize stack pointer
    mov.w #0x0041 , &P1DIR
    mov.b #0x01 , &P1OUT
    call #uartInit
    mov.b #0x61 , R4
    call #uartPutChar
endlp:
    jmp endlp

uartInit:
    push R5
    ;P1SEL |= 0x06;
    bis.b #0x06 , P1SEL
    ;P1SEL2|= 0x06;
    bis.b #0x06 , P1SEL2
    ;P1DIR |= 0x04;
    bis.b #0x04 , P1DIR
    ;UCA0CTL1 |= UCSSEL_2;
    bis.b &UCSSEL_2 , &UCA0CTL1
    ;UCA0BR0 = 104;
    mov.b #0x68 , &UCA0BR0
    ;UCA0BR1 = 0
    mov.b #0x06 , &UCA0BR1
    ;UCA0MCTL = UCBRS1;
    mov.b &UCBRS1 , UCA0MCTL
    ;UCA0CTL1 &= ~UCSWRST;
    mov.b &UCSWRST , R5
    xor.b #0xff , R5
    and.b R5 , &UCA0CTL1
    pop R5
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
    xor.b #0x41 , &P1OUT
lp2:
    mov.b &IFG2 , R5
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
