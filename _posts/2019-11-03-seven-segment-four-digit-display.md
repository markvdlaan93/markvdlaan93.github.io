---
layout: post
title: Use 7-segment 4-digit display with 8-bit AVR microcontroller
subtitle: 
image:
tags: AVR microcontroller, ATMega, C programming, 7-segment display
---

## Overview

![Seven segment four digit breadboard setup](/img/seven_segment_four_digit/atmega328p_seven_segment_four_digit_display.GIF "Seven segment four digit breadboard setup"){:height="50%" width="50%"}

## Prerequisites

## Common anode or cathode display



## Breadboard setup

## The code

```
#include <avr/io.h>
#include <util/delay.h>

void setupIo(){
  for(int i = 0; i < 5; i++){
    DDRC |= (1<<i);
  }
  
  for(int i = 0; i < 8; i++){
    DDRD |= (1<<i);
  }
}

void resetDisplay(){
  PORTC &= 0x0;
  PORTD &= 0x0;
}

/**
 * Datasheet (very limited, could not find anything else):
 * https://www.aliexpress.com/item/32584341214.html
 */
int main(void){
  setupIo();

  while(1) {
    resetDisplay();

    PORTC |= (1<<PC0);

    PORTD |= (1<<PD1);
    PORTD |= (1<<PD2);

    _delay_ms(1000);
    resetDisplay();
    
    PORTC |= (1<<PC1);

    PORTD |= (1<<PD0);
    PORTD |= (1<<PD1);
    PORTD |= (1<<PD6);
    PORTD |= (1<<PD4);
    PORTD |= (1<<PD3);

    _delay_ms(1000);
    resetDisplay();

    PORTC |= (1<<PC2);

    PORTD |= (1<<PD0);
    PORTD |= (1<<PD1);
    PORTD |= (1<<PD6);
    PORTD |= (1<<PD2);
    PORTD |= (1<<PD3);

    _delay_ms(1000);
    resetDisplay();

    PORTC |= (1<<PC3);

    PORTD |= (1<<PD5);
    PORTD |= (1<<PD6);
    PORTD |= (1<<PD1);
    PORTD |= (1<<PD2);

    _delay_ms(1000);

  }
}
```