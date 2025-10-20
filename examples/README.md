# Examples

This directory contains example scripts and code demonstrating how to use the remote control configurations.

## Available Examples

### Python Script: load_config.py

A comprehensive Python script for loading and displaying configurations.

**Installation:**
```bash
pip install requests
```

**Usage:**
```bash
# Display formatted configuration
python3 load_config.py https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json

# Output raw JSON
python3 load_config.py -j https://raw.githubusercontent.com/.../config.json

# Get connection string only
python3 load_config.py -c https://raw.githubusercontent.com/.../config.json
```

### Bash Script: load_config.sh

A Bash script that fetches configurations and optionally connects.

**Requirements:**
- curl
- jq
- Optional: vncviewer, ssh, xfreerdp (for automatic connection)

**Usage:**
```bash
chmod +x load_config.sh
./load_config.sh https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json
```

## Quick Examples

### cURL One-liner
```bash
curl -s https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json | jq .
```

### Python One-liner
```python
import requests; config = requests.get('https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json').json(); print(f"{config['connection']['protocol']}://{config['connection']['host']}:{config['connection']['port']}")
```

### Node.js Example
```javascript
const https = require('https');

const url = 'https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json';

https.get(url, (res) => {
  let data = '';
  res.on('data', (chunk) => data += chunk);
  res.on('end', () => {
    const config = JSON.parse(data);
    console.log(`${config.connection.protocol}://${config.connection.host}:${config.connection.port}`);
  });
});
```

## Integration Examples

### Ansible Playbook
```yaml
---
- name: Load remote control configuration
  hosts: localhost
  gather_facts: no
  vars:
    config_url: "https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json"
  
  tasks:
    - name: Fetch configuration
      uri:
        url: "{{ config_url }}"
        return_content: yes
      register: config_response
    
    - name: Parse configuration
      set_fact:
        remote_config: "{{ config_response.content | from_json }}"
    
    - name: Display connection info
      debug:
        msg: "Connect to {{ remote_config.device.name }} at {{ remote_config.connection.host }}:{{ remote_config.connection.port }}"
```

### Docker Compose
```yaml
version: '3.8'

services:
  remote-client:
    image: your-remote-client-image
    environment:
      - CONFIG_URL=https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json
    command: /app/connect.sh
```

## Custom Integration

You can integrate these configurations into your own applications:

1. **Fetch** the configuration from the URL
2. **Parse** the JSON response
3. **Validate** the configuration (optional)
4. **Use** the connection details in your application

See the [API Documentation](../docs/API.md) for more details.
