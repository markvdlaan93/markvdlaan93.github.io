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

![In-System Programmer components](/img/isp_components.jpg "Components for Arduino Uno / AVR microcontroller setup"){: height=75% }

*Components that I have used for the setup*

## Options

In order to get firmware on the AVR microcontroller you have several options. Each of these come with pros and cons based on costs and ease of usage. 

### Development board

This is the most expensive option that you can choose. Besides uploading the firmware to the microcontroller, you can also use techniques like On Debug Chip (ODP). Like the name suggests, it allows you to debug your firmware more effectively. There are different options for AVR microcontrollers but the most popular one seems to be the [STK500](https://www.microchip.com/DevelopmentTools/ProductDetails/PartNO/ATSTK500) and the [AVR Dragon](https://www.microchip.com/DevelopmentTools/ProductDetails/PartNO/ATAVRDRAGON) both produced by Microchip (formely Atmel). 

These development boards cost somewhere between the €50,- and €80,- depending on where you live. These are at least the prices within the Netherlands.

![Microchip AVR Dragon](/img/dragon.png "AVR Dragon") ![Microchip STK500](/img/stk500.png "STK500")

*AVR Dragon (left) and STK500 (right)*

### Simple programmer

Another option is to use a more simple device to get firmware on the chip. A simple programmer consists of a USB socket with so-called In Circuit Serial Programming (ICSP) pins. I never tried this option myself so I'm not entirely sure how you get this option up and running.

These programmers are a lot cheaper than full development boards and are shipped in the Netherlands for as little as €5,-.

![Simple AVR programmer with In Circuit Serial Programming (ICSP) pins](/img/avr_simple_programmer.png "Simple AVR programmer In Circuit Serial Programming (ICSP) pins")

*A simple AVR programmer with ICSP pins*

### Arduino

Since the Arduino Uno internally also uses an AVR microcontroller, it can also be used to get firmware on another AVR microcontroller (in this case, the microcontroller which is going to turn on a LED).

![Arduino Uno](/img/arduino_uno.png "Arduino Uno")

*Arduino Uno*

## Uploading the bootloader

If you already have an Arduino at your disposal (like I have), it seems like a great plan to use it for uploading your firmware. More precisely, we will use the Arduino Uno to upload a bootloader. This bootloader is a small program which can place another program (the firmware to turn on the LED) at the right place in the microcontrollers' memory. 

Execute the following steps:
1. First you need to download [Arduino IDE v1.0.5](https://www.arduino.cc/en/Main/OldSoftwareReleases#1.0.x) and install it
2. Download [the boatloader](https://github.com/markvdlaan93/avr-projects/tree/master/isp_arduino_breadboard) from my project repository
3. Locate the sketchbook directory in the Arduino IDE (under `file > preferences`)
4. If it does not exist yet, create a `hardware` directory inside the sketchbook directory
5. Extract the zip from step 2 and move the `breadboard` directory to the `hardware` directory
6. Connect the Arduino Uno through USB to the computer
7. Open the Arduino IDE (for Linux make sure you run it in sudo mode)
8. In the Arduino IDE, make sure the board is selected: `tools > Board > Arduino Uno`
9. In the Arduino IDE, choose `file > examples > ArduinoISP`
10. Compile and upload the code to the Arduino Uno

## AVRDude

Now that we made the Arduino ready to burn our firmware on the chip, we need to install a tool called AVRDude:

> [AVRDUDE](https://www.nongnu.org/avrdude/) is a utility to download/upload/manipulate the ROM and EEPROM contents of AVR microcontrollers using the in-system programming technique (ISP). 

In other words, AVRDude is a command line tool that we can use to upload new firmware on the fly and with relative ease. Based on your OS, you can use *apt* (Linux Debian-based), *homebrew* (Mac OS X) or read [this guideline](http://fab.cba.mit.edu/classes/863.16/doc/projects/ftsmin/windows_avr.html) (Windows).

## Use Makefile

Because you don't want to remember the exact command everytime you want to upload a new version of your program, it is convenient to use some kind of script. Makefiles are made exactly for this purposes. I'm currently using the following Makefile:

```
# Depending on your OS, you need to edit the PORT_ID
PORT_ID=/dev/ttyACM0
MCU=atmega328p
F_CPU=1200000
CC=avr-gcc
PROGRAMMER_ID=stk500v1
OBJCOPY=avr-objcopy
CFLAGS=-std=c99 -Wall -g -Os -mmcu=${MCU} -DF_CPU=${F_CPU} -I.
TARGET=main
SRCS=main.c
BAUD_RATE=19200

all:
		${CC} ${CFLAGS} -o ${TARGET}.bin ${SRCS}
		${OBJCOPY} -j .text -j .data -O ihex ${TARGET}.bin ${TARGET}.hex

flash:
		avrdude -v -P ${PORT_ID} -b ${BAUD_RATE} -c ${PROGRAMMER_ID} -p ${MCU} -U flash:w:${TARGET}.hex

clean:
		rm -f *.bin *.hex
```