# API Documentation - URL-Based Configuration Access

This document describes how to access and use remote control configurations via URLs.

## Base URLs

### Raw GitHub Content
Direct access to configuration files:
```
https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/{path}
```

### GitHub Pages (when enabled)
Web interface access:
```
https://divyamohan1993.github.io/remote-control-setup/
```

## Endpoints

### Device Configurations

**Endpoint Pattern:**
```
https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/{device-id}.json
```

**Example:**
```bash
# Fetch a device configuration
curl https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json

# Use in a script
wget -qO- https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json | jq
```

### Templates

**Endpoint Pattern:**
```
https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/templates/{template-name}.json
```

**Available Templates:**
- `desktop-vnc-template.json` - VNC desktop configuration
- `desktop-rdp-template.json` - RDP desktop configuration
- `server-ssh-template.json` - SSH server configuration

**Example:**
```bash
# Download a template to start your own configuration
curl -o my-config.json https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/templates/desktop-vnc-template.json
```

### Profiles

**Endpoint Pattern:**
```
https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/profiles/{profile-id}.json
```

**Example:**
```bash
curl https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/profiles/example-dev-team.json
```

### Schema

**Endpoint:**
```
https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/schemas/config-schema.json
```

**Example:**
```bash
# Download the schema for validation
curl -o config-schema.json https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/schemas/config-schema.json
```

## Usage Examples

### Command Line Tools

#### cURL
```bash
# Fetch and display configuration
curl https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json

# Download configuration
curl -o config.json https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json

# Fetch and parse with jq
curl -s https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json | jq '.device.name'
```

#### wget
```bash
# Download configuration
wget https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json

# Download to specific file
wget -O my-config.json https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/templates/desktop-vnc-template.json
```

### Programming Languages

#### Python
```python
import requests
import json

# Fetch configuration
url = "https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json"
response = requests.get(url)
config = response.json()

print(f"Device Name: {config['device']['name']}")
print(f"Protocol: {config['connection']['protocol']}")
print(f"Port: {config['connection']['port']}")
```

#### JavaScript/Node.js
```javascript
const https = require('https');

const url = 'https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json';

https.get(url, (res) => {
  let data = '';
  res.on('data', (chunk) => data += chunk);
  res.on('end', () => {
    const config = JSON.parse(data);
    console.log(`Device: ${config.device.name}`);
    console.log(`Protocol: ${config.connection.protocol}`);
  });
});
```

#### Bash Script
```bash
#!/bin/bash

CONFIG_URL="https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json"

# Fetch configuration
CONFIG=$(curl -s "$CONFIG_URL")

# Extract values using jq
DEVICE_NAME=$(echo "$CONFIG" | jq -r '.device.name')
HOST=$(echo "$CONFIG" | jq -r '.connection.host')
PORT=$(echo "$CONFIG" | jq -r '.connection.port')
PROTOCOL=$(echo "$CONFIG" | jq -r '.connection.protocol')

echo "Connecting to $DEVICE_NAME"
echo "Using $PROTOCOL://$HOST:$PORT"
```

### Integration with Remote Control Software

#### Custom Client Application
```python
#!/usr/bin/env python3
import requests
import subprocess
import sys

def load_config_from_url(url):
    """Load configuration from GitHub URL"""
    response = requests.get(url)
    response.raise_for_status()
    return response.json()

def connect_vnc(config):
    """Connect using VNC client"""
    host = config['connection']['host']
    port = config['connection']['port']
    
    # Example: using vncviewer
    cmd = ['vncviewer', f'{host}:{port}']
    subprocess.run(cmd)

def connect_ssh(config):
    """Connect using SSH"""
    host = config['connection']['host']
    port = config['connection']['port']
    user = config['connection']['authentication']['username']
    
    cmd = ['ssh', f'-p{port}', f'{user}@{host}']
    subprocess.run(cmd)

def main(config_url):
    config = load_config_from_url(config_url)
    protocol = config['connection']['protocol']
    
    if protocol == 'vnc':
        connect_vnc(config)
    elif protocol == 'ssh':
        connect_ssh(config)
    else:
        print(f"Unsupported protocol: {protocol}")
        sys.exit(1)

if __name__ == '__main__':
    if len(sys.argv) < 2:
        print("Usage: connect.py <config-url>")
        sys.exit(1)
    
    main(sys.argv[1])
```

## Response Format

All configurations return JSON in the following format:

```json
{
  "version": "string (semver)",
  "device": {
    "id": "string",
    "name": "string",
    "type": "desktop|server|mobile|iot|custom",
    "description": "string (optional)",
    "tags": ["string"]
  },
  "connection": {
    "protocol": "vnc|rdp|ssh|http|https|websocket|custom",
    "host": "string",
    "port": "integer",
    "secure": "boolean",
    "authentication": {
      "method": "password|key|token|oauth|none",
      "username": "string",
      "requiresCredentials": "boolean"
    },
    "proxy": {
      "enabled": "boolean",
      "host": "string (optional)",
      "port": "integer (optional)"
    }
  },
  "settings": {
    "quality": "low|medium|high|auto",
    "colorDepth": "integer",
    "clipboard": "boolean",
    "fileTransfer": "boolean",
    "audio": "boolean",
    "customSettings": {}
  },
  "metadata": {
    "createdAt": "string (ISO 8601)",
    "updatedAt": "string (ISO 8601)",
    "owner": "string",
    "maintainers": ["string"]
  }
}
```

## Error Handling

### HTTP Status Codes

- `200 OK` - Configuration retrieved successfully
- `404 Not Found` - Configuration file doesn't exist
- `403 Forbidden` - Access denied (rare for public repos)
- `500 Internal Server Error` - GitHub service error

### Example Error Handling

```python
import requests

url = "https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/nonexistent.json"

try:
    response = requests.get(url)
    response.raise_for_status()
    config = response.json()
except requests.exceptions.HTTPError as e:
    if e.response.status_code == 404:
        print("Configuration not found")
    else:
        print(f"HTTP Error: {e}")
except requests.exceptions.RequestException as e:
    print(f"Request failed: {e}")
```

## Rate Limiting

GitHub has rate limits for API access:

- **Unauthenticated requests**: 60 requests per hour per IP
- **Authenticated requests**: 5,000 requests per hour

For raw content URLs, limits are generally more generous. For production use, consider:

1. Caching configurations locally
2. Using authenticated requests
3. Implementing retry logic with exponential backoff

## Best Practices

1. **Cache Configurations**: Don't fetch on every use
2. **Validate Responses**: Always validate the JSON structure
3. **Handle Errors**: Implement proper error handling
4. **Use HTTPS**: Always use secure connections
5. **Version Control**: Pin to specific commits for stability
6. **Monitor Usage**: Track your API usage to avoid rate limits

## Versioning

You can access specific versions by using commit SHAs or tags:

```
# Latest version (main branch)
https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json

# Specific commit
https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/{commit-sha}/configs/devices/example-dev-workstation.json

# Specific tag (if tags are used)
https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/{tag}/configs/devices/example-dev-workstation.json
```

## Support

For issues or questions about the API:
- Open an issue: https://github.com/divyamohan1993/remote-control-setup/issues
- Check documentation: https://github.com/divyamohan1993/remote-control-setup/blob/main/configs/README.md
