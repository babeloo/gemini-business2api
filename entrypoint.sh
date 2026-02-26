#!/bin/bash
set -e

# Start D-Bus daemon (required for Chromium)
mkdir -p /var/run/dbus
dbus-daemon --system --fork || true

# 启动 Xvfb 在后台
Xvfb :99 -screen 0 1280x800x24 -ac +extension GLX +render -noreset &
XVFB_PID=$!

# 等待 Xvfb 启动
sleep 2

# 设置 DISPLAY 环境变量
export DISPLAY=:99

# Verify Xvfb is running
if ! ps -p $XVFB_PID > /dev/null; then
    echo "ERROR: Xvfb failed to start"
    exit 1
fi

# 启动 Python 应用
exec python -u main.py
