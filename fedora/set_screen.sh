#!/bin/sh

DATE=$(date '+%Y-%m-%d %H:%M:%S')
echo "Set Screen resolution script executed at ${DATE}" | systemd-cat -p info

edid_decoded=$(edid-decode < /sys/class/drm/card0-HDMI-A-1/edid)
LG_id='LG ULTRAWIDE'

if grep -q "$LG_id" <<< "$edid_decoded"; then
	echo "LG ULTRAWIDE detected"
	# Switch LG ultrawide to native resolution
	xrandr --newmode "2560x1080_60.00_1"  230.00  2560 2720 2992 3424  1080 1083 1093 1120 -hsync +vsync
	xrandr --addmode HDMI-1-1 "2560x1080_60.00_1"                                                       
	xrandr --output HDMI-1-1 --mode "2560x1080_60.00_1"
else
  	echo "No requested monitor(s) found, nothing to do here."
fi
