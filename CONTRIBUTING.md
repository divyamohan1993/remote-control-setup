# Contributing to Remote Control Setup

Thank you for your interest in contributing to the Remote Control Setup repository! This document provides guidelines for contributing.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [How to Contribute](#how-to-contribute)
- [Configuration Guidelines](#configuration-guidelines)
- [Submitting Changes](#submitting-changes)
- [Reporting Issues](#reporting-issues)

## Code of Conduct

- Be respectful and inclusive
- Focus on constructive feedback
- Help others in the community
- Keep security in mind - never commit credentials

## How to Contribute

### Adding New Configurations

1. **Fork the repository** and create a new branch
2. **Choose the right template** from `configs/templates/`
3. **Create your configuration file** in the appropriate directory:
   - Device configs go in `configs/devices/`
   - Profile configs go in `configs/profiles/`
4. **Validate your configuration** against the schema
5. **Test your configuration** (if possible)
6. **Submit a pull request**

### Modifying Existing Configurations

1. Fork and create a branch
2. Make your changes
3. Ensure the configuration still validates
4. Submit a PR with a clear description of changes

## Configuration Guidelines

### Naming Conventions

- Use lowercase with hyphens for file names: `my-device-name.json`
- Be descriptive but concise
- Include device type in the name when helpful

### Configuration Structure

All configurations must follow the schema defined in `configs/schemas/config-schema.json`.

Required fields:
- `version` - Semantic version (e.g., "1.0.0")
- `device.id` - Unique identifier
- `device.name` - Human-readable name
- `device.type` - One of: desktop, server, mobile, iot, custom
- `connection.protocol` - Connection protocol
- `connection.port` - Port number

### Security Best Practices

⚠️ **IMPORTANT**: Never commit sensitive information!

- **DO NOT** include passwords, API keys, or tokens
- **DO NOT** include private IP addresses if not necessary
- **DO** use placeholders like "your-password-here"
- **DO** use environment-specific examples
- **DO** document what credentials are needed

### Validation

Before submitting, validate your configuration:

```bash
# Install AJV CLI
npm install -g ajv-cli

# Validate your configuration
ajv validate -s configs/schemas/config-schema.json -d configs/devices/your-config.json
```

Or use Python:

```bash
python3 -m json.tool configs/devices/your-config.json
```

## Submitting Changes

### Pull Request Process

1. **Update documentation** if you're adding new features
2. **Follow the PR template** when creating your pull request
3. **Link related issues** using keywords like "Fixes #123"
4. **Wait for review** - maintainers will review your PR
5. **Address feedback** if any changes are requested

### Commit Messages

Write clear, concise commit messages:

- Use present tense: "Add configuration" not "Added configuration"
- Be descriptive: "Add VNC configuration for dev server" not "Update file"
- Reference issues when applicable: "Fix #123: Update SSH template"

### Branch Naming

Use descriptive branch names:

- `feature/device-name` for new configurations
- `fix/issue-description` for bug fixes
- `docs/update-readme` for documentation updates

## Reporting Issues

### Bug Reports

Use the bug report template and include:

- Configuration file affected
- Expected vs actual behavior
- Steps to reproduce
- Any error messages

### Feature Requests

Use the configuration request template and include:

- Type of configuration needed
- Device/protocol details
- Use case description

## Development Setup

### Prerequisites

- Git
- Node.js (for validation)
- Text editor with JSON support

### Local Setup

```bash
# Clone your fork
git clone https://github.com/YOUR-USERNAME/remote-control-setup.git
cd remote-control-setup

# Create a branch
git checkout -b feature/my-new-config

# Make changes
# ... edit files ...

# Validate
npm install -g ajv-cli
ajv validate -s configs/schemas/config-schema.json -d configs/devices/my-config.json

# Commit and push
git add .
git commit -m "Add new configuration for XYZ"
git push origin feature/my-new-config
```

## Questions?

If you have questions:

1. Check existing issues and discussions
2. Review the documentation in `configs/README.md`
3. Open a new issue with the question label

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! 🎉
