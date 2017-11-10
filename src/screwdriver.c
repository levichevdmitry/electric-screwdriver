/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
© Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10.11.2017
Author  : Nikopol
Company : 
Comments: 


Chip type               : ATtiny13A
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 16
*****************************************************/

#include <tiny13a.h>

#include <delay.h>

#define ADC_VREF_TYPE 0x40

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Crystal Oscillator division factor: 1
#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
#endif

// Input/Output Ports initialization
// Port B initialization
// Func5=In Func4=Out Func3=In Func2=Out Func1=Out Func0=Out 
// State5=T State4=0 State3=T State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0x17;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7,813 kHz
// Mode: Fast PWM top=0xFF
// OC0A output: Non-Inverted PWM
// OC0B output: Non-Inverted PWM
TCCR0A=0xA3;
TCCR0B=0x05;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// External Interrupt(s) initialization
// INT0: Off
// Interrupt on any change on pins PCINT0-5: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
ACSR=0x80;
ADCSRB=0x00;
DIDR0=0x00;

// ADC initialization
// ADC Clock frequency: 1000,000 kHz
// ADC Bandgap Voltage Reference: On
// ADC Auto Trigger Source: ADC Stopped
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: Off
DIDR0&=0x03;
DIDR0|=0x08;
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x83;

while (1)
      {
      // Place your code here

      }
}
