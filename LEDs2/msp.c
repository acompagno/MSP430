#include <msp430g2231.h>

int main()
{
  // stop he watchdog timer
  WDTCTL = WDTPW + WDTHOLD;

  // set the output direction
  P1DIR |= (BIT0 + BIT6);

  // make sure the LEDS are off
  P1OUT &= ~(BIT0 + BIT6);               
  
  for (;;) 
  {
    for (i = 0; i < 2000; i++)
    {
      P1OUT ^= BIT0;
      P1OUT ^= BIT6;
    }

    for (i = 0; i < 20000; i++)
    {
      P1OUT &= ~(BIT0 + BIT6);
    }
  }
}