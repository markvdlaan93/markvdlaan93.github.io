---
layout: post
title: How to get firmware on an AVR microcontroller?
subtitle: Use Arduino as In-System Programmer (ISP)
image:
---

## Overview

Okay cool, you now bought all the necessities to start programming your AVR microcontroller but how do you actually get code on the chip itself? How do you supply power to the microcontroller? In this post, I will discuss all the necessary steps. We will blink a LED to check whether the setup is working properly. 

## Prerequisites

You need to have the following supplies:
* **Breadboard**
* **Jumper cables**
* **Arduino Uno USB cable**
* **Arduino Uno:** It doesn't really matter if you get a new real one or a fake Chinese copy.
* **AVR ATMega MCU:** It doesn't matter which one you get. In this post, I will use an ATMega328P (same one that is used in the Arduino itself).
* **Led:** We need to actually do something to see whether the firmware is succesfully uploaded to the chip. Therefore, we will start with turning on a Light Emitted Diode (LED).
* **220Ω resistor:** Avoid that the LED receives too much current.

![In-System Programmer components](/img/isp_components.jpg "Components for Arduino Uno / AVR microcontroller setup"){ height=75% }

## Options

In order to get firmware on the AVR microcontroller you have several options. Each of these come with pros and cons based on costs and ease of usage. 

### Development board

This is the most expensive option that you can choose. Besides uploading the firmware to the microcontroller, you can also use techniques like On Debug Chip (ODP). Like the name suggests, it allows you to debug your firmware more effectively. There are different options for AVR microcontrollers but the most popular one seems to be the [STK500](https://www.microchip.com/DevelopmentTools/ProductDetails/PartNO/ATSTK500) and the [AVR Dragon](https://www.microchip.com/DevelopmentTools/ProductDetails/PartNO/ATAVRDRAGON) both produced by Microchip (formely Atmel). 

These development boards come for somewhere between the €50,- and €80,- depending on where you live. This are at least the prices within the Netherlands.

![AVR Dragon](/img/dragon.png "AVR Dragon") ![STK500](/img/stk500.png "STK500")

### Simple programmer

### Arduino