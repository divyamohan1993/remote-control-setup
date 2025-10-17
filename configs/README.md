# Remote Control Configurations

This directory contains remote control software configurations that can be accessed and controlled through URLs.

## Directory Structure

- `devices/` - Device-specific configurations
- `profiles/` - User/environment profiles
- `schemas/` - JSON schemas for validation
- `templates/` - Configuration templates

## Usage

Each configuration file follows the standard schema defined in `schemas/config-schema.json`.

### URL-Based Control

Configurations can be accessed via:
- Direct file access: `https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/{device-name}.json`
- Through GitHub Pages (if enabled)
- Via API endpoints (if deployed)

## Adding New Configurations

1. Copy a template from `templates/`
2. Modify according to your device/requirements
3. Validate against the schema
4. Submit a pull request
