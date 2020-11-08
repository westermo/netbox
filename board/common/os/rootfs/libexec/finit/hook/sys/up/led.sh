#!/bin/sh

# The system is now up. Turn off any red status LEDs and turn on any
# green ones.

for led in $(find /sys/class/leds/ -name '*red:status' -o -name '*red:on'); do
    echo 0 >$led/brightness
done

for led in $(find /sys/class/leds/ -name '*green:status' -o -name '*green:on'); do
    echo 1 >$led/brightness
done
