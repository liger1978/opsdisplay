#!/bin/bash
screen=$1
delay=$2

# Ensure silent fullscreen Opera startup
[ -d /tmp/opsdisplay/screen$screen ] || mkdir -p /tmp/opsdisplay/screen$screen
rm -rf /tmp/opsdisplay/screen$screen/*
cp /etc/opsdisplay_operaprefs.ini /tmp/opsdisplay/screen$screen/operaprefs.ini

# Start window manager in this screen
DISPLAY=:0.$screen matchbox-window-manager -use_cursor no \
                                        -use_titlebar no \
                                        -theme blondie \
                                        -use_desktop_mode plain &
sleep 2

# Start opera on this screen
DISPLAY=:0.$screen opera -fullscreen -personaldir /tmp/opsdisplay/screen$screen \
                         -windowname "$screen" http://maps.google.com &
sleep 10

# Cycle through URLs for this screen
while true; do
  for url in `cat /etc/opsdisplay.d/screen$screen | awk /^http/`; do
    DISPLAY=:0.$screen opera -remote 'openURL('$url')' -windowname "$screen" \
                             -personaldir /tmp/opsdisplay/screen$screen
    sleep $delay
  done
done
