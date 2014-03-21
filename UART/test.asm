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
    call #initUart
main:
    mov.b #0x41 , R4
    call #uartPutChar
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

;Initilizes the uart 
initUart:
    push R5
    ;Use P1.1 and P1.2 as USCI_A0
    ;P1SEL |= 0x06; 
    bis.w #0x06 , &P1SEL
    ;Use P1.1 and P1.2 as USCI_A0
    ;P1SEL2|= 0x06;                    
    bis.b #0x06 , &P1SEL2
    ;Set 1.2 as output
    ;P1DIR |= 0x04;                      
    bis.w #0x04 , &P1DIR
    ;Use SMCLK / DCO 
    ;UCA0CTL1 |= UCSSEL_2;               
    bis.b &UCSSEL_2 , &UCA0CTL1
    ;1 MHz -> 9600   N=Clock/Baud
    ;UCA0BR0 = 104;                      
    mov.w #0x68 , &UCA0BR0
    ;1 MHz -> 9600
    ;UCA0BR1 = 0;                        
    mov.b #0x00 , &UCA0BR1
    ;Modulation UCBRSx = 1
    ;UCA0MCTL = UCBRS1
    mov.w &UCBRS1 , &UCA0MCTL  
    ;Initialize USCI  
    ;UCA0CTL1 &= ~UCSWRST
    ; mov.b &UCSWRST , R5
    ; xor.b #0xFF , R5
    ; and.b R5 , UCA0CTL1
    bic.b &UCSWRST , UCA0CTL1
    pop R5
    ret

;Displays a character on the terminal
;INPUT -> R4
uartPutChar:
    push R5
uartPutChar_loop:
    mov.b IFG2 , R5
    and.w &UCA0TXIFG , R5
    cmp.w #0x00 , R5
    jz uartPutChar_loop
    mov.b R4 , &UCA0TXBUF
    pop R5
    ret

    ;while (!(IFG2 & UCA0TXIFG));
    ;UCA0TXBUF = a;

end:
    org 0xfffe
    dw start
