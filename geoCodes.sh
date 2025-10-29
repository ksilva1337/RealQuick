#!/bin/bash

gcode=$(copyq paste)

cut -c 1-8 <<< $gcode > "inps/$1"
cut -c 20-28 <<< $gcode > "inps/$2"



