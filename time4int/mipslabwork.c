/* mipslabwork.c

   This file written 2015 by F Lundevall

   This file should be changed by YOU! So add something here:

   This file modified 2015-12-24 by Ture Teknolog 

   Latest update 2015-08-28 by F Lundevall

   Chanced by Adam Rosell & Robin Björk 2016-03-9

   For copyright and licensing, see file COPYING */

#include <stdint.h>   /* Declarations of uint_32 and the like */
#include <pic32mx.h>  /* Declarations of system-specific addresses etc */
#include "mipslab.h"  /* Declatations for these labs */

int mytime = 0x5957;

char textstring[] = "text, more text, and even more text!";

int prime = 1234567; 
int timeoutcount = 0; 
volatile int* porte = (volatile int*) 0xbf886110;
int count = 0;


/* Interrupt Service Routine */
void user_isr( void ){  

  if ((IFS(0) & 0x80) == 0x80)         // bit 7 för INT1, 0x80
    {
      count++;
      *porte = count;                   // output (LEDS) ökar med 1.
      IFSCLR(0) = 128;               // Clears interrupt flag INT1.
    }
  //static int count = 0;
    // init port e

  if((IFS(0) & 0x100) == 0x100)       // bit 8 för timer 2.
    {
      IFSCLR(0) = 0x100;               // återställer bit 8 i IFS.
      timeoutcount ++; 
                // Clears interrupt flag INT1.   
                  // global count++
      if (timeoutcount == 10){
          timeoutcount = 0;
          time2string (textstring, mytime);
          display_string (3, textstring);
          display_update ();
          tick (&mytime);
        } 
    }
    

  

}

/* Lab-specific initialization goes here */
void labinit( void )
{
  //volatile int* trise = (volatile int*) 0xbf886100;
  //*trise &= ~0xff;                // bitvis AND med ~0xff. 0 - 7 blir output

  TRISD |= 0xfe0;                 //bitvis OR. sätter bit 11 - 8 ill input

  T2CON = 0x070 ;                 // bestämmer vilka funtioner som ska användas av T2
                                  // 1:256 prescaling.
  TMR2 = 0x0;                     // sätter timer till 0. Startvalue.

  PR2 = 31250;                     // 80milj / 256 / 100 = 3125.
                                  // load the period register. 

        IPC(1) = 0x3000000;           // set subpriority INT1 till 3
        IPC(1) = 0x18000000;           // Set priority INT1 till 6.
        IFSCLR(0) = 0x80;               // Clears interrupt flag INT1.

  IPCSET(2) = 0x0000001C;   // Set priority level 
  IPCSET(2) = 0x00000003;   // Set subpriority level

  IFSCLR(0) = 0x00000100;   // Clear the timer interrupt status flag
  IECSET(0) = 0x00000180;
  //IECSET(0) = 0x00040000;// Enable timer interrupts och INT1
  //IEC(0) = 0xC0;
  T2CONSET = 0x8000;        // Start the timer  

  enable_interrupt ();
 // T2IF bit 8 IFS0, T2IE bit 8 IEC0,
  return;
}

/* This function is called rpeetitively from the main program */
void labwork( void )
{
   prime = nextprime( prime );
   display_string (0, itoaconv( prime) );
   display_update ();
/*
  volatile int* porte = (volatile int*) 0xbf886110;
  static int count = 0;

if(IFS(0))
{
  IFS(0) = 0;         // Räknar timeouts.
  timeoutcount ++;
}

if(timeoutcount == 100)
  { 
    timeoutcount = 0;
    time2string( textstring, mytime );
    display_string( 3, textstring );
    display_update();
    tick( &mytime );
    *porte = count;
    count++;
    display_image(96, icon);

   if(getbtns())
    {
      if((getbtns() & 0x04) == 4)
        {
         mytime = (mytime & 0x0fff) | (getsw() << 12);
       }
     if((getbtns() & 0x02) == 2)
       {
         mytime = (mytime & 0xf0ff) | (getsw() << 8);
       }
    if((getbtns() & 0x01) == 1)
       {
          mytime = (mytime & 0xff0f) | (getsw() << 4);
      }
   }
  }
  */
}