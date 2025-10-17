# Profiles

Profiles are environment or user-specific configuration sets that can include multiple device configurations and preferences.

## Structure

Profiles extend the base configuration schema with additional fields for managing multiple devices and user preferences.

## Example Profile

```json
{
  "version": "1.0.0",
  "profile": {
    "id": "dev-team-profile",
    "name": "Development Team Profile",
    "description": "Shared profile for development team members",
    "environment": "development"
  },
  "devices": [
    "example-dev-workstation",
    "dev-server-01",
    "test-environment-01"
  ],
  "preferences": {
    "defaultQuality": "high",
    "autoConnect": false,
    "saveCredentials": false
  },
  "metadata": {
    "createdAt": "2025-10-17T08:00:00Z",
    "owner": "devteam",
    "maintainers": ["devteam-lead", "sysadmin"]
  }
}
```

## Use Cases

- Team-based access configurations
- Environment-specific settings (dev, staging, production)
- Role-based access profiles
- Project-specific configurations
