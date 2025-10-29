#!/bin/bash

echo -e $(grep ^"$(cat snips/$1 | awk -F '~' '{print $1}' | rofi -dmenu -i)"~ snips/$1 | awk -F '~' '{print $2}'| sed 's/\^/\\n/g') > "inps/$2"