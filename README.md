# Remote Control Setup 🖥️

A centralized repository for storing and managing remote control software configurations that can be accessed and controlled through URLs.

[![Validate Configurations](https://github.com/divyamohan1993/remote-control-setup/actions/workflows/validate-configs.yml/badge.svg)](https://github.com/divyamohan1993/remote-control-setup/actions/workflows/validate-configs.yml)
[![Deploy to Pages](https://github.com/divyamohan1993/remote-control-setup/actions/workflows/deploy-pages.yml/badge.svg)](https://github.com/divyamohan1993/remote-control-setup/actions/workflows/deploy-pages.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## 📋 Overview

This repository provides a structured framework for managing remote control configurations that can be accessed via URLs. It supports various remote access protocols including VNC, RDP, SSH, and more.

## ✨ Features

- **📦 Standardized Configuration Schema** - JSON schema validation for all configurations
- **🔗 URL-Based Access** - Configurations accessible via GitHub raw URLs or GitHub Pages
- **🤖 Automated Validation** - GitHub Actions workflow to validate all configurations
- **📚 Multiple Templates** - Pre-built templates for common use cases
- **🔒 Security First** - Guidelines to prevent committing sensitive data
- **📖 Comprehensive Documentation** - Detailed guides for contributors

## 🚀 Quick Start

### Accessing Configurations

Configurations can be accessed via direct URLs:

```
https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/{config-name}.json
```

Or through GitHub Pages (once enabled):

```
https://divyamohan1993.github.io/remote-control-setup/
```

### Using a Configuration

1. **Choose a configuration** from the `configs/devices/` directory
2. **Copy the URL** to the configuration file
3. **Use in your remote control client** that supports URL-based configuration

Example:
```bash
# Download a configuration
curl https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json

# Or use it directly in compatible software
your-remote-client --config-url https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json
```

## 📁 Repository Structure

```
remote-control-setup/
├── configs/
│   ├── devices/          # Device-specific configurations
│   ├── profiles/         # User/environment profiles
│   ├── schemas/          # JSON schemas for validation
│   │   └── config-schema.json
│   ├── templates/        # Configuration templates
│   │   ├── desktop-vnc-template.json
│   │   ├── desktop-rdp-template.json
│   │   └── server-ssh-template.json
│   └── README.md
├── .github/
│   ├── workflows/        # GitHub Actions workflows
│   │   ├── validate-configs.yml
│   │   └── deploy-pages.yml
│   ├── ISSUE_TEMPLATE/   # Issue templates
│   │   ├── bug_report.yml
│   │   └── config_request.yml
│   └── PULL_REQUEST_TEMPLATE.md
├── CONTRIBUTING.md       # Contribution guidelines
├── LICENSE              # MIT License
└── README.md           # This file
```

## 🔧 Configuration Schema

All configurations follow a standardized JSON schema with the following structure:

```json
{
  "version": "1.0.0",
  "device": {
    "id": "unique-device-id",
    "name": "Human Readable Name",
    "type": "desktop|server|mobile|iot|custom",
    "description": "Optional description",
    "tags": ["tag1", "tag2"]
  },
  "connection": {
    "protocol": "vnc|rdp|ssh|http|https|websocket|custom",
    "host": "hostname.example.com",
    "port": 5900,
    "secure": true,
    "authentication": {
      "method": "password|key|token|oauth|none",
      "username": "user",
      "requiresCredentials": true
    }
  },
  "settings": {
    "quality": "low|medium|high|auto",
    "colorDepth": 24,
    "clipboard": true,
    "fileTransfer": false,
    "audio": false
  },
  "metadata": {
    "createdAt": "2025-10-17T08:00:00Z",
    "updatedAt": "2025-10-17T08:00:00Z",
    "owner": "username",
    "maintainers": ["user1", "user2"]
  }
}
```

See [configs/schemas/config-schema.json](configs/schemas/config-schema.json) for the complete schema.

## 📝 Available Templates

### Desktop VNC
For VNC connections to desktop computers
- Template: [desktop-vnc-template.json](configs/templates/desktop-vnc-template.json)
- Protocol: VNC
- Default Port: 5900

### Desktop RDP
For RDP connections to Windows desktops
- Template: [desktop-rdp-template.json](configs/templates/desktop-rdp-template.json)
- Protocol: RDP
- Default Port: 3389

### Server SSH
For SSH connections to servers
- Template: [server-ssh-template.json](configs/templates/server-ssh-template.json)
- Protocol: SSH
- Default Port: 22

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

### Quick Contribution Steps

1. Fork the repository
2. Create a branch (`git checkout -b feature/my-config`)
3. Copy a template from `configs/templates/`
4. Modify for your use case
5. Validate your configuration
6. Commit your changes
7. Push and create a Pull Request

### Validation

Validate your configuration before submitting:

```bash
# Install validator
npm install -g ajv-cli

# Validate
ajv validate -s configs/schemas/config-schema.json -d configs/devices/your-config.json
```

## 🔒 Security

**⚠️ IMPORTANT**: Never commit sensitive information!

- ❌ No passwords or API keys
- ❌ No private keys or tokens
- ❌ No sensitive IP addresses
- ✅ Use placeholders for credentials
- ✅ Document what credentials are needed
- ✅ Review configurations before committing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed security guidelines.

## 🔄 GitHub Actions

This repository includes automated workflows:

### Configuration Validation
- **Workflow**: [validate-configs.yml](.github/workflows/validate-configs.yml)
- **Triggers**: Push/PR to main/develop branches
- **Actions**: Validates all JSON configurations against the schema

### GitHub Pages Deployment
- **Workflow**: [deploy-pages.yml](.github/workflows/deploy-pages.yml)
- **Triggers**: Push to main branch
- **Actions**: Deploys a web interface to access configurations

## 📊 Use Cases

### 1. IT Administration
Centralize remote access configurations for your IT infrastructure

### 2. Development Teams
Share development environment access configurations

### 3. DevOps
Manage server access configurations for deployment and monitoring

### 4. Remote Support
Maintain configurations for customer support sessions

### 5. Personal Use
Keep track of your personal remote access setups

## 🛠️ Tools and Integration

This repository can be integrated with:

- **VNC Clients**: TigerVNC, RealVNC, TightVNC
- **RDP Clients**: Microsoft Remote Desktop, Remmina
- **SSH Clients**: OpenSSH, PuTTY, Terminal
- **Multi-Protocol Clients**: Remote Desktop Manager, mRemoteNG
- **Custom Applications**: Any tool that supports URL-based configuration

## 📖 Documentation

- [Main README](README.md) - This file
- [Configs Documentation](configs/README.md) - Details about the configs directory
- [Contributing Guide](CONTRIBUTING.md) - How to contribute
- [Schema Documentation](configs/schemas/config-schema.json) - Configuration schema

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙋 Support

- 🐛 [Report a Bug](../../issues/new?template=bug_report.yml)
- 💡 [Request a Configuration](../../issues/new?template=config_request.yml)
- 📚 [View Documentation](configs/README.md)
- 💬 [Discussions](../../discussions)

## 🌟 Acknowledgments

- Built with ❤️ for the remote work community
- Inspired by the need for centralized configuration management
- Powered by GitHub Actions and GitHub Pages

---

**Made with ❤️ by [Divya Mohan](https://github.com/divyamohan1993)**