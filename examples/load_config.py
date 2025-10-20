#!/usr/bin/env python3
"""
Example script demonstrating how to use remote control configurations from URLs.

This script shows how to:
1. Load configurations from GitHub URLs
2. Parse configuration data
3. Display connection information
4. Validate configurations

Usage:
    python3 examples/load_config.py https://raw.githubusercontent.com/.../config.json
"""

import sys
import json
import argparse
from typing import Dict, Any

try:
    import requests
except ImportError:
    print("Error: requests library not found. Install with: pip install requests")
    sys.exit(1)


def load_config_from_url(url: str) -> Dict[str, Any]:
    """
    Load a configuration from a GitHub URL.
    
    Args:
        url: The URL to the configuration JSON file
        
    Returns:
        Dictionary containing the configuration
        
    Raises:
        requests.exceptions.RequestException: If the request fails
        json.JSONDecodeError: If the response is not valid JSON
    """
    try:
        response = requests.get(url, timeout=10)
        response.raise_for_status()
        return response.json()
    except requests.exceptions.HTTPError as e:
        if e.response.status_code == 404:
            print(f"Error: Configuration not found at {url}")
        else:
            print(f"HTTP Error: {e}")
        sys.exit(1)
    except requests.exceptions.RequestException as e:
        print(f"Error loading configuration: {e}")
        sys.exit(1)
    except json.JSONDecodeError as e:
        print(f"Error parsing JSON: {e}")
        sys.exit(1)


def display_config_info(config: Dict[str, Any]) -> None:
    """
    Display formatted configuration information.
    
    Args:
        config: Configuration dictionary
    """
    print("\n" + "="*60)
    print("REMOTE CONTROL CONFIGURATION")
    print("="*60)
    
    # Device information
    device = config.get('device', {})
    print(f"\n📱 Device Information:")
    print(f"   Name: {device.get('name', 'N/A')}")
    print(f"   ID: {device.get('id', 'N/A')}")
    print(f"   Type: {device.get('type', 'N/A')}")
    if device.get('description'):
        print(f"   Description: {device.get('description')}")
    if device.get('tags'):
        print(f"   Tags: {', '.join(device.get('tags', []))}")
    
    # Connection information
    connection = config.get('connection', {})
    print(f"\n🔌 Connection Details:")
    print(f"   Protocol: {connection.get('protocol', 'N/A').upper()}")
    print(f"   Host: {connection.get('host', 'N/A')}")
    print(f"   Port: {connection.get('port', 'N/A')}")
    print(f"   Secure: {'Yes' if connection.get('secure') else 'No'}")
    
    # Authentication
    auth = connection.get('authentication', {})
    if auth:
        print(f"\n🔐 Authentication:")
        print(f"   Method: {auth.get('method', 'N/A')}")
        if auth.get('username'):
            print(f"   Username: {auth.get('username')}")
        print(f"   Requires Credentials: {'Yes' if auth.get('requiresCredentials') else 'No'}")
    
    # Settings
    settings = config.get('settings', {})
    if settings:
        print(f"\n⚙️  Settings:")
        if settings.get('quality'):
            print(f"   Quality: {settings.get('quality')}")
        if settings.get('colorDepth'):
            print(f"   Color Depth: {settings.get('colorDepth')}-bit")
        if 'clipboard' in settings:
            print(f"   Clipboard: {'Enabled' if settings.get('clipboard') else 'Disabled'}")
        if 'fileTransfer' in settings:
            print(f"   File Transfer: {'Enabled' if settings.get('fileTransfer') else 'Disabled'}")
        if 'audio' in settings:
            print(f"   Audio: {'Enabled' if settings.get('audio') else 'Disabled'}")
    
    # Metadata
    metadata = config.get('metadata', {})
    if metadata:
        print(f"\n📋 Metadata:")
        if metadata.get('owner'):
            print(f"   Owner: {metadata.get('owner')}")
        if metadata.get('createdAt'):
            print(f"   Created: {metadata.get('createdAt')}")
        if metadata.get('updatedAt'):
            print(f"   Updated: {metadata.get('updatedAt')}")
    
    print("\n" + "="*60)


def generate_connection_string(config: Dict[str, Any]) -> str:
    """
    Generate a connection string from the configuration.
    
    Args:
        config: Configuration dictionary
        
    Returns:
        Connection string
    """
    connection = config.get('connection', {})
    protocol = connection.get('protocol', 'unknown')
    host = connection.get('host', 'unknown')
    port = connection.get('port', 0)
    
    return f"{protocol}://{host}:{port}"


def main():
    """Main entry point for the script."""
    parser = argparse.ArgumentParser(
        description='Load and display remote control configuration from URL',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog='''
Examples:
  # Load a device configuration
  python3 load_config.py https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/devices/example-dev-workstation.json
  
  # Load a template
  python3 load_config.py https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/main/configs/templates/desktop-vnc-template.json
        '''
    )
    
    parser.add_argument(
        'url',
        help='URL to the configuration JSON file'
    )
    
    parser.add_argument(
        '-j', '--json',
        action='store_true',
        help='Output raw JSON instead of formatted display'
    )
    
    parser.add_argument(
        '-c', '--connection-string',
        action='store_true',
        help='Only output the connection string'
    )
    
    args = parser.parse_args()
    
    # Load configuration
    config = load_config_from_url(args.url)
    
    # Output based on flags
    if args.json:
        print(json.dumps(config, indent=2))
    elif args.connection_string:
        print(generate_connection_string(config))
    else:
        display_config_info(config)
        print(f"\n🔗 Connection String: {generate_connection_string(config)}\n")


if __name__ == '__main__':
    main()
