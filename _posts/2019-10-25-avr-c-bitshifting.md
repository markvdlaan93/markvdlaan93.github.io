---
layout: post
title: Bit shifting in C programming for AVR
subtitle: C programming with AVR microcontroller
image:
tags: C programming, AVR, bit shifting, bitwise operations
---

## Overview

In this article, I give a short overview of bit shifting operations (or bitwise operations) in the C programming language. For programming AVR microcontrollers, bitwise operations are great to alter individual bits inside a register. 

## Manipulating registers without bitwise operations

A naive approach for manipulating registers is to set the entire byte in a single operation:
```
void setupIoPins(){
    // DDRD = Data Direction Register D = configure the eight pins of Port D. 
    // 0 = input pin; 1 = output pin
    // In this case, we want to set the first, second, third and fourth pin as output pin.
    DDRD = 0b00001111;
}

void main(){
    setupIoPins();
}
```

The problem of this approach is that it is difficult to target a single bit inside the register because you need to know what the state of the other bits is. 

## Use bitwise operations

With bit shifting, we can avoid this by targetting indivual bits:
```
void setupIoPins(){
    // DDRD = Data Direction Register D = configure the eight pins of Port D. 
    // 0 = input pin; 1 = output pin
    // In this case, we want to set the first, second, third and fourth pin as output pin.
    DDRD = DDRD | (1<<0); // same as DDRD |= (1<<0);
    DDRD = DDRD | (1<<1);
    DDRD = DDRD | (1<<2);
    DDRD = DDRD | (1<<3);
}

void main(){
    setupIoPins();
}
```

### Set individual bit high, regardless of value (OR)

The example above works because `(1<<0)` translates to one, zero places to the left or `0000 0001`. The DDRD register can be any value. Lets take `0110 0000` as example. The single pipe symbol (`|`) stands for a logical OR:
> 0000 0001&nbsp;
> 0110 0000&nbsp;
> --------- OR&nbsp;
> 0110 0001

### Set individual bit low, regardless of value (AND/NOT)

In order to make sure that an individual bit will be set to zero regardless of the value, you need to use a combination of the logical AND (`&`) operator and the logical NOT or Tilde (`~`). This operation is necessary when you want to configure an IO pin as an input pin:
```
void setupIoPins(){
    DDRD &= ~(1 << 0);
}
```

This code makes sure that the first pin of port D is zero which means that it is an input pin. This works as follows (initial value of DDRD doesn't matter):
> ~(0000 0001) = 1111 1110&nbsp;
> DDRD         = 0110 0111&nbsp;
>               ---------- AND&nbsp;
>                0110 0110

### Flip individual bits in register (XOR)

Sometimes, for example when you want to blink a LED, you want to flip bits inside the register. You can do this by XOR-ing:

```
ISR(TIMER1_COMPA_vect)
{
  PORTD ^= (1<<0);		
}
```

This function describes an interrupt which is generated based on the settings in the timing register. For AVR timers and interrupts, I have an article [here]({{ site.baseurl }}{% link _posts/2019-10-29-avr-c-timer.md %}). 

The goal of this function is to flip the first bit in the register, everytime the interrupt is triggered:
> 0000 0001&nbsp;
> 0110 0001&nbsp;
> --------- XOR&nbsp;
> 0110 0000