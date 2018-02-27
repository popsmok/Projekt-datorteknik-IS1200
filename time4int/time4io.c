#include <stdint.h>
#include <pic32mx.h>
#include "mipslab.h" 

int getsw (void)
{
	return ((PORTD & 0x0f00) >> 8);	// Bitvis AND för att sen flytta 8 steg höger.
}

int getbtns (void)
{
	return ((PORTD & 0x0e0) >> 5);	// bitvis AND för att sen flytta 5 steg höger.
	//return ((PORTD & 0x0f0) >> 4);
}