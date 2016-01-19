#!/bin/bash

# Read config file
. /etc/opsdisplay

# Start X server
X :0 &

# Start screens
screen=0
while [ $screen -lt $number_of_screens ]; do
  opsdisplay_screen $screen $rotation_delay &
  let screen=screen+1
done
