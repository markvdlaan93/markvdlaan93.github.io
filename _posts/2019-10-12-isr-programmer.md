---
layout: post
title: How to get firmware on an AVR microcontroller?
subtitle: Use Arduino as In-System Programmer (ISP)
image: /img/powersymbol.png
---

## Overview

Okay cool, you now bought all the necessities to start programming your AVR microcontroller but how do you actually get code on the chip itself? How do you supply power to the microcontroller? In this post, I will discuss all the necessary steps. We will blink a LED to check whether the setup is working properly. 

## Prerequisites
* **Breadboard**
* **Jumper cables**
* **Arduino Uno:** It doesn't really matter if you get a new real one or a fake Chinese copy.
* **AVR ATMega MCU:** It doesn't matter which one you get. In this post, I will use an ATMega328P (same one that is used in the Arduino itself).
* **Led:** We need to actually do something to see whether the firmware is succesfully uploaded to the chip. Therefore, we will start with turning on a Light Emitted Diode (LED).
* **220Ω resistor:** Avoid that the LED receives too much current.

## Options
