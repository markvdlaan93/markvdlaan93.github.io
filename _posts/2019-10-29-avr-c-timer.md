---
layout: post
title: How to use AVR C timer and interrupt registers?
subtitle: C programming with AVR microcontroller
image:
tags: C programming, AVR, time register
---

## Overview

In this article, I will explain how to build C programs in which you can control the timer and interrupt registers of an AVR microcontroller. If don't know where to start with programming, I have a tutorial [here]({{ site.baseurl }}{% link _posts/2019-10-27-isp-programmer.md %}) that explains the basics of how to setup a microcontroller and blink a LED.

## Objective

In this article, I will focus on how to blink a LED by generating an interrupt every second. I have the following breadboard setup:

INSERT_IMAGE

## Setup timer and interrupt register code

```
void setupClock(){
  TCCR1B |= 1<<CS11 | 1<<CS10;
  OCR1A = 15624;
  TCCR1B |= 1<<WGM12;
  TIMSK1 |= 1<<OCIE1A;
}
```

### Abbreviations

When you first start programming in C for the AVR microcontroller, you quickly encounter many abbreviations. Therefore, I made a list of all the abbrevations used in the code above. I added a suffix `X` which indicates that there a multiple options for a certain construct. Here's the list:
* TCCR1X = Time/Counter Control Register = used to set the counting mode
* CSX = Clock Select = used to configure the prescaler
* OCRX = Ouput Control Register = maximum value to which the microcontroller should count before resetting.
* WGMX = Waveform Generation Mode = used to turn on CTC mode.
* TIMSKX = Timer Interrupt Mask Register = register where each bit is a on or off for a specific interrupt.
* OCIE1X = Timer/Counter Output Compare Match Interrupt Enable = bit of specific interrupt given as parameter in the ISR(TIMER1_COMPA_vect) function (see next section). URL with list of interrupts that are supported: http://ee-classes.usc.edu/ee459/library/documents/avr_intr_vectors/

### Function explained

Here's a function for configuring the microcontroller so that an interrupt is triggered every second. The ATMega328P has three timers. For this code, register 1 is used which has 16 bits.

Since the ATMega328P microcontroller runs at 1MHz or 1 million clock cycles per second, 16 bits is not enough (already reduced from 8MHz). Therefore, a pre-scaler is used which reduces a higher frequency signal into a lower one (options: 1, 8, 64, 256 or 1024). Check the clock frequency of your AVR microcontroller in the datasheets.

This first step is to setup the pre-scaler so that it can count to 1 million. This is done by setting the Clock Select (CS) bits. There are three Clock Select bits which are relevant to timer 1 namely CS10, CS11, CS12. See table of possible combinations [here](https://exploreembedded.com/wiki/AVR_Timer_programming).

CS10 and CS11 combined means that a prescaler of 64 is selected. Here, we select a prescaler of 64. After that, 1.000.000 / 64 = 15625 or 0 to 15624 thus 15624 is set as value for the output compare register. 

Now it is important to enable Clear Timer on Compare (CTC) mode so that the counter is resetted when the maximum value of 15624 is reached. 

The interrupt is now ready to be turned on by assigning the bit of the specific interrupt OCIE1A to the register with enabled interrupts for timer 1 (TIMSK1).

## Configure in- and ouput

```
#include <avr/io.h>

void setupIoLed(){
  /**
   * 1<<0 = move 1 zero places to the left. Often used for consistency 
   * with other bitwise operations.
   * DDRx = Data Direction Register = 8 bit register for controlling 
   * the directionality of the pin.
   * If 1 than it is an output pin, if 0 than it is an input pin.
   * DDRD = Data Direction Register of port D
   * 
   * Example: 
   * DDRD = 0010 1100
   * 1<<0 = 0000 0001
   *        --------- OR
   *        0010 1101
   * Thus first pin of port D is set as output pin (= drives the 
   * signal) regardless of bits in other pins.
   */
  DDRD |= (1<<0);

  /**
   * PORTX is used to write data to the port pins. PINX (not used here) 
   * is used for reading data from the port pins. Both are 8 bit 
   * registers.
   * 
   * PORTD = 1010 0000
   * 1<<0  = 0000 0001
   *         --------- OR
   *         1010 0001
   * Thus first pin of port D is set to high regardless of the values of 
   * other bits. This will turn on the LED on the first index of Port D
   */
  PORTD |= (1<<0);
}
```

## Main function

```
int main(void){
  // Disable global interrupts
  cli();
  setupClock();
  // Enable global interrupts
  sei();

  setupIoLed();

  // Loop forever, interrupts do the rest
  while(1) { }
}
```