#include "msp430g2553.h"

void uartInit();
void uartPutChar(char a);
void uartPutString(char *string);
char uartGetChar();
char switchCase(char a);

int main( void )
{
    //Stop Watchdog timer
    WDTCTL = WDTPW + WDTHOLD;

    //Calibrate DCO
    BCSCTL1 = CALBC1_1MHZ;
    DCOCTL = CALDCO_1MHZ;              

    uartInit();

    //Indicator LED 
    P1DIR |= BIT6;
    for(;;)
        uartPutChar(switchCase(uartGetChar()));
    //General Interrupt Enable
    //_BIS_SR(GIE);

    return 0;
}

/****************
 *Initialize UART*
 *****************/
void uartInit()
{
    // Use P1.1 and P1.2 as USCI_A0
    P1SEL |= 0x06;                   
    // Use P1.1 and P1.2 as USCI_A0
    P1SEL2|= 0x06;                    
    // Set 1.2 as output
    P1DIR |= 0x04;                      
    // Use SMCLK / DCO 
    UCA0CTL1 |= UCSSEL_2;               
    // 1 MHz -> 9600   N=Clock/Baud
    UCA0BR0 = 104;                      
    // 1 MHz -> 9600
    UCA0BR1 = 0;                        
    // Modulation UCBRSx = 1
    UCA0MCTL = UCBRS1;                  
    // **Initialize USCI  
    UCA0CTL1 &= ~UCSWRST;                   
}

/***********
 *Send data*
 ***********/
void uartPutChar(char a)
{
    //wait to make sure its done transfering 
    while (!(IFG2 & UCA0TXIFG));
    UCA0TXBUF = a;
}

void uartPutString(char *string)
{   
    while(*string)
    {
        uartPutChar(*string);
        string++;
    }
}

/*************
 *Receive data*
 **************/
char uartGetChar()
{
    //wait for the buffer to clear
    while (!(IFG2&0x01));
    return (UCA0RXBUF);
}

/*
* Changes the case of the characer passed in if its a letter
* If the character is not a letter, it is returned unchanged
* Ex 'a' -> 'A'
* Ex 'A' -> 'a'
* Ex ';' -> ';'
*/
char switchCase(char a)
{
    return (a >= 'a' && a <= 'z') ? a - 0x20 : 
        (a >= 'A' && a <= 'Z') ? a + 0x20 : a;
}