#!/bin/bash
set -e

# Start D-Bus daemon (required for Chromium)
mkdir -p /var/run/dbus
dbus-daemon --system --fork || true

# Start Xvfb for headless Chromium
Xvfb :99 -screen 0 1280x800x24 -ac +extension GLX +render -noreset &
XVFB_PID=$!
sleep 2
export DISPLAY=:99

# Verify Xvfb is running
if ! ps -p $XVFB_PID > /dev/null; then
    echo "ERROR: Xvfb failed to start"
    exit 1
fi

# Run the worker
exec python -u -m worker.main
