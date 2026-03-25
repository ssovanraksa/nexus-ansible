#!/bin/bash

set -e

echo "Stopping Nexus service..."
sudo systemctl stop nexus.service || true

echo "Disabling Nexus service..."
sudo systemctl disable nexus.service || true

echo "Removing systemd service file..."
sudo rm -f /etc/systemd/system/nexus.service

echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Removing Nexus installation directory..."
sudo rm -rf /opt/sonatype/nexus*        
sudo rm -rf /opt/sonatype/sonatype*

echo "Removing Nexus user (optional)..."
if id "nexus" &>/dev/null; then
    sudo userdel nexus || true
    sudo groupdel nexus || true
fi

echo "Cleaning up leftover PID/temp files..."
sudo rm -f /tmp/i4jdaemon_* || true

echo "Nexus Repository has been successfully uninstalled."