#!/bin/sh

Xvfb :99 -ac -listen tcp -screen 0 1024x800x24 &
fly-wm --display :99.0 &
x11vnc -display :99.0 -forever -passwd ${X11VNC_PASSWORD:-password}
