#!/bin/bash
#
# Example Bash script to load and use remote control configurations
#
# Usage:
#   ./load_config.sh <config-url>
#
# Example:
#   ./load_config.sh https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json

set -e

# Check if URL is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <config-url>"
    echo ""
    echo "Example:"
    echo "  $0 https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json"
    exit 1
fi

CONFIG_URL="$1"

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Error: jq is not installed. Please install it first."
    echo "  Ubuntu/Debian: sudo apt-get install jq"
    echo "  macOS: brew install jq"
    exit 1
fi

# Fetch configuration
echo "Fetching configuration from: $CONFIG_URL"
CONFIG=$(curl -s "$CONFIG_URL")

# Check if curl was successful
if [ -z "$CONFIG" ]; then
    echo "Error: Failed to fetch configuration"
    exit 1
fi

# Parse configuration
DEVICE_NAME=$(echo "$CONFIG" | jq -r '.device.name')
DEVICE_ID=$(echo "$CONFIG" | jq -r '.device.id')
DEVICE_TYPE=$(echo "$CONFIG" | jq -r '.device.type')
PROTOCOL=$(echo "$CONFIG" | jq -r '.connection.protocol')
HOST=$(echo "$CONFIG" | jq -r '.connection.host')
PORT=$(echo "$CONFIG" | jq -r '.connection.port')
USERNAME=$(echo "$CONFIG" | jq -r '.connection.authentication.username // "N/A"')

# Display configuration
echo ""
echo "============================================================"
echo "REMOTE CONTROL CONFIGURATION"
echo "============================================================"
echo ""
echo "📱 Device Information:"
echo "   Name: $DEVICE_NAME"
echo "   ID: $DEVICE_ID"
echo "   Type: $DEVICE_TYPE"
echo ""
echo "🔌 Connection Details:"
echo "   Protocol: ${PROTOCOL^^}"
echo "   Host: $HOST"
echo "   Port: $PORT"
echo "   Username: $USERNAME"
echo ""
echo "🔗 Connection String: $PROTOCOL://$HOST:$PORT"
echo ""
echo "============================================================"
echo ""

# Optional: Connect based on protocol
read -p "Do you want to connect now? (y/N) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    case "$PROTOCOL" in
        vnc)
            echo "Connecting via VNC..."
            if command -v vncviewer &> /dev/null; then
                vncviewer "$HOST:$PORT"
            else
                echo "VNC viewer not found. Please install a VNC client."
            fi
            ;;
        ssh)
            echo "Connecting via SSH..."
            if [ "$USERNAME" != "N/A" ]; then
                ssh -p "$PORT" "$USERNAME@$HOST"
            else
                ssh -p "$PORT" "$HOST"
            fi
            ;;
        rdp)
            echo "Connecting via RDP..."
            if command -v xfreerdp &> /dev/null; then
                xfreerdp /v:"$HOST:$PORT" /u:"$USERNAME"
            elif command -v rdesktop &> /dev/null; then
                rdesktop "$HOST:$PORT" -u "$USERNAME"
            else
                echo "RDP client not found. Please install xfreerdp or rdesktop."
            fi
            ;;
        *)
            echo "Automatic connection not supported for protocol: $PROTOCOL"
            echo "Please use appropriate client for $PROTOCOL://$HOST:$PORT"
            ;;
    esac
fi
