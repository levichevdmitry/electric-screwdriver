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
AVR Core Clock frequency: 9,600000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 16
*****************************************************/
#include <tiny13a.h>
#include <stdlib.h>
#include <delay.h>


#define STATUS_LED_PIN      2
#define STATUS_LED_PORT     PORTB
#define STATUS_LED_ON       STATUS_LED_PORT |= (1<<STATUS_LED_PIN);
#define STATUS_LED_OFF      STATUS_LED_PORT &= ~(1<<STATUS_LED_PIN);
#define STATUS_LED_TOGLE    STATUS_LED_PORT ^= (1<<STATUS_LED_PIN);


#define PWR_PIN             4
#define PWR_PORT            PORTB
#define PWR_OFF             PWR_PORT |= (1<<PWR_PIN);


#define KEY_MODE_VAL        605
#define KEY_FWD_VAL         344
#define KEY_REV_VAL         186
#define KEY_DELTA_VAL       50

#define MODE_FAST           0
#define MODE_MED            1
#define MODE_SLOW           2
#define MODE_COUNT          2

#define TIME_TO_OFF         360 // sec

unsigned char mode = MODE_MED;
unsigned char btn_mode_trig = 0;
unsigned char speed[3] = {0x00, 0x3F, 0x7F};     // speed = 0xFF - need speed;
unsigned int sec, ms, tick; 

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
    tick ++;
    if (tick == 5) {
        tick = 0;
        ms ++;
        switch (mode){
            case MODE_FAST:STATUS_LED_ON; break;
            case MODE_MED: if(ms % 200 == 0) {STATUS_LED_TOGLE;} break;
            case MODE_SLOW: if(ms % 500 == 0) {STATUS_LED_TOGLE;} break;
        }
    }
    if (ms >= 1000) {
        sec ++;
        ms = 0;
    } 
    if (sec >= TIME_TO_OFF ){
        PWR_OFF;
    }
}

#define FIRST_ADC_INPUT 3
#define LAST_ADC_INPUT 3
unsigned int adc_data[LAST_ADC_INPUT-FIRST_ADC_INPUT+1];
#define ADC_VREF_TYPE 0x40

// ADC interrupt service routine
// with auto input scanning
interrupt [ADC_INT] void adc_isr(void)
{
static unsigned char input_index=0;
// Read the AD conversion result
adc_data[input_index]=ADCW;
// Select next ADC input
if (++input_index > (LAST_ADC_INPUT-FIRST_ADC_INPUT))
   input_index=0;
ADMUX=(FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff))+input_index;
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
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
// Clock value: 1200,000 kHz
// Mode: Fast PWM top=0xFF
// OC0A output: Inverted PWM
// OC0B output: Inverted PWM
TCCR0A=0xF3;
TCCR0B=0x02;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;
 
// External Interrupt(s) initialization
// INT0: Off
// Interrupt on any change on pins PCINT0-5: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer/Counter 0 Interrupt(s) initialization
TIMSK0=0x02;

// Analog Comparator initialization
// Analog Comparator: Off
ACSR=0x80;
ADCSRB=0x00;
DIDR0=0x00;

// ADC initialization
// ADC Clock frequency: 600,000 kHz
// ADC Bandgap Voltage Reference: On
// ADC Auto Trigger Source: Timer0 Overflow
// Digital input buffers on ADC0: On, ADC1: On, ADC2: On, ADC3: Off
DIDR0&=0x03;
DIDR0|=0x08;
ADMUX=FIRST_ADC_INPUT | (ADC_VREF_TYPE & 0xff);
ADCSRA=0xAC;
ADCSRB&=0xF8;
ADCSRB|=0x04;

sec = 0;
ms = 0;
tick = 0;
// Global enable interrupts
#asm("sei")

while (1)
      {
        if (abs(adc_data[0] - KEY_MODE_VAL) <=  KEY_DELTA_VAL) {
            if (!btn_mode_trig) {
                // press "mode" key detected
                mode ++;
                if (mode > MODE_COUNT) {
                    mode = 0;
                }
            }
            btn_mode_trig = 1;
        } else {
            btn_mode_trig = 0;
        }
       
        if (abs(adc_data[0] - KEY_FWD_VAL) <=  KEY_DELTA_VAL) {
            //STATUS_LED_OFF;
             OCR0A = speed[mode];
            sec = 0;     
        } else if (abs(adc_data[0] - KEY_REV_VAL) <=  KEY_DELTA_VAL) {
            //STATUS_LED_OFF;
            OCR0B = speed[mode];
            sec = 0;
        } else {
            // off all
            OCR0A=0xFF;
            OCR0B=0xFF;
            //STATUS_LED_OFF;
        }

      }
}