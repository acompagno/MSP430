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
    call #uartGetChar
    call #switchCase
    call #uartPutChar
    xor.b #0x41 ,  &P1OUT
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

;Subprocess that initilizes the uart 
initUart:
    push R5
    ;Use P1.1 and P1.2 as USCI_A0
    ;P1SEL |= 0x06; 
    bis.b #0x06 , &P1SEL
    ;Use P1.1 and P1.2 as USCI_A0
    ;P1SEL2|= 0x06;                    
    bis.b #0x06 , &P1SEL2
    ;Set 1.2 as output
    ;P1DIR |= 0x04;                      
    bis.w #0x04 , &P1DIR
    ;Use SMCLK / DCO 
    ;UCA0CTL1 = UCSSEL_2;               
    mov.b &UCSSEL_2 , &UCA0CTL1
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
    bic.b &UCSWRST , UCA0CTL1
    pop R5
    ret

;Displays a character on the terminal
;R4 -> UART
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

;Gets a character entered on the terminal
;UART -> R4
uartGetChar:
    push R5
uartGetChar_loop:  
    mov.b IFG2 , R5
    and.b #0x01 , R5
    cmp.w #0x00 , R5
    jz uartGetChar_loop
    mov.b &UCA0RXBUF , R4
    pop R5
    ret

;Switch case
;Params -> R4(character that gets switched)
;R4->R4 
switchCase:
    ;R4 < 'A'
    cmp.b #0x41 , R4
    jnc switchCase_return
    ;R4 < ('Z' + 1)
    cmp.b #0x5B , R4
    jnc switchCase_isUpper
    ;R4 >= ('z' + 1)
    cmp.b #0x7B , R4
    jc switchCase_return
    ;R4 >= 'a'
    cmp.b #0x61 , R4
    jc switchCase_isLower
    jmp switchCase_return
switchCase_isUpper:
    add.b #0x20 , R4
    jmp switchCase_return
switchCase_isLower:
    sub.b #0x20 , R4
switchCase_return:
    ret

end:
    org 0xfffe
    dw start