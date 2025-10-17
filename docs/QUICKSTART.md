# Quick Reference Guide

## Quick Links

- **Repository**: https://github.com/divyamohan1993/remote-control-setup
- **Configurations**: [configs/](../configs/)
- **Templates**: [configs/templates/](../configs/templates/)
- **API Docs**: [docs/API.md](API.md)
- **Contributing**: [CONTRIBUTING.md](../CONTRIBUTING.md)

## Common Tasks

### 1. Access a Configuration via URL

```bash
# Device configuration
curl https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json

# Template
curl https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/templates/desktop-vnc-template.json
```

### 2. Create a New Configuration

```bash
# 1. Download a template
curl -o my-config.json https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/templates/desktop-vnc-template.json

# 2. Edit the file
nano my-config.json

# 3. Validate it
ajv validate -s configs/schemas/config-schema.json -d my-config.json

# 4. Submit a PR with your new configuration
```

### 3. Validate a Configuration

```bash
# Install AJV CLI
npm install -g ajv-cli

# Validate
ajv validate -s configs/schemas/config-schema.json -d your-config.json --strict=false
```

### 4. Use Configuration in Code

#### Python
```python
import requests
config = requests.get('https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json').json()
print(f"Connect to: {config['connection']['host']}:{config['connection']['port']}")
```

#### Bash
```bash
CONFIG_URL="https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json"
curl -s $CONFIG_URL | jq -r '.connection | "\(.protocol)://\(.host):\(.port)"'
```

## Configuration Types

| Type | Directory | Purpose |
|------|-----------|---------|
| Devices | `configs/devices/` | Specific device configurations |
| Profiles | `configs/profiles/` | User/team/environment profiles |
| Templates | `configs/templates/` | Starting point for new configs |
| Schema | `configs/schemas/` | Validation schema |

## Supported Protocols

- **VNC** - Virtual Network Computing (Port 5900)
- **RDP** - Remote Desktop Protocol (Port 3389)
- **SSH** - Secure Shell (Port 22)
- **HTTP/HTTPS** - Web-based remote control
- **WebSocket** - Real-time connections
- **Custom** - User-defined protocols

## File Structure

```json
{
  "version": "1.0.0",           // Required: Semantic version
  "device": {                   // Required: Device information
    "id": "string",             // Required: Unique ID
    "name": "string",           // Required: Display name
    "type": "desktop",          // Required: desktop|server|mobile|iot|custom
    "tags": []                  // Optional: Tags for categorization
  },
  "connection": {               // Required: Connection details
    "protocol": "vnc",          // Required: Connection protocol
    "host": "hostname",         // Optional: Host address
    "port": 5900,              // Required: Port number
    "secure": true             // Optional: Use encryption
  },
  "settings": {},              // Optional: Additional settings
  "metadata": {}               // Optional: Metadata
}
```

## Validation Workflow

When you submit a PR:
1. GitHub Actions runs automatically
2. All JSON files are validated against the schema
3. JSON syntax is checked
4. Results appear in the PR

## Security Checklist

- [ ] No passwords or secrets
- [ ] No private keys
- [ ] No sensitive IP addresses
- [ ] Use placeholders for credentials
- [ ] Review before committing

## Common Errors

### Invalid JSON
```bash
Error: Unexpected token } in JSON
```
**Solution**: Use `python3 -m json.tool file.json` to check syntax

### Schema Validation Failed
```bash
Error: data must have required property 'version'
```
**Solution**: Ensure all required fields are present

### File Not Found (404)
```bash
Error: 404 Not Found
```
**Solution**: Check the file path and branch name in URL

## Getting Help

1. Check [API Documentation](API.md)
2. Review [Contributing Guide](../CONTRIBUTING.md)
3. Search [existing issues](https://github.com/divyamohan1993/remote-control-setup/issues)
4. Ask in [Discussions](https://github.com/divyamohan1993/remote-control-setup/discussions)
5. Create a [new issue](https://github.com/divyamohan1993/remote-control-setup/issues/new/choose)
