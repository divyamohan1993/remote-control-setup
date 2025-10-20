#!/usr/bin/env bash

# Usage: curl -fsSL "https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/refs/heads/main/autoconfig.sh"   | sudo DOMAIN=remote.dmj.one ADMIN_USER=admin ADMIN_PASS='admin123!' bash
# sudo bash -lc 'curl -fsSL https://raw.githubusercontent.com/divyamohan1993/remote-control-setup/refs/heads/main/autoconfig.sh?nocache=$(date +%s) | sudo DOMAIN=remote.dmj.one ADMIN_USER=admin ADMIN_PASS=admin123 bash'
set -euo pipefail

# --------------------------
# Config (overridable via env)
# --------------------------
DOMAIN="${DOMAIN:-remote.dmj.one}"
ADMIN_USER="${ADMIN_USER:-admin}"
ADMIN_PASS="${ADMIN_PASS:-admin123!}"

# --------------------------
# Pre-flight
# --------------------------
if [[ $EUID -ne 0 ]]; then
  echo "Please run as root (use sudo)."
  exit 1
fi

if ! command -v apt-get >/dev/null 2>&1; then
  echo "This script targets Debian/Ubuntu (apt-based). Exiting."
  exit 1
fi

export DEBIAN_FRONTEND=noninteractive

echo "[1/8] Installing base packages..."
apt-get update -y
apt-get install -y curl gnupg ca-certificates nginx openssl

# --------------------------
# Node.js (>=16 required). Install Node 20 via NodeSource if needed.
# --------------------------
need_node=1
if command -v node >/dev/null 2>&1; then
  NODE_MAJOR="$(node -v | sed -E 's/^v([0-9]+).*/\1/')"
  if [[ "${NODE_MAJOR}" -ge 16 ]]; then need_node=0; fi
fi

if [[ "${need_node}" -eq 1 ]]; then
  echo "[2/8] Installing Node.js 20.x from NodeSource..."
  curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
  apt-get install -y nodejs
fi

# --------------------------
# MeshCentral install
# --------------------------
echo "[3/8] Installing MeshCentral under /opt/meshcentral..."
id -u meshcentral >/dev/null 2>&1 || useradd -r -m -d /opt/meshcentral -s /usr/sbin/nologin meshcentral
install -d -o meshcentral -g meshcentral /opt/meshcentral
cd /opt/meshcentral

if [[ ! -d /opt/meshcentral/node_modules/meshcentral ]]; then
  # Minimal package scaffolding for local npm install
  su -s /bin/bash -c 'cd /opt/meshcentral && { [ -f package.json ] || echo "{\"name\":\"mesh-wrapper\",\"version\":\"1.0.0\"}" > package.json; } && npm install meshcentral --omit=dev --no-audit --no-fund' meshcentral
fi

# --------------------------
# MeshCentral config
# --------------------------
echo "[4/8] Writing MeshCentral config.json..."
install -d -o meshcentral -g meshcentral /opt/meshcentral/meshcentral-data

cat >/opt/meshcentral/meshcentral-data/config.json <<EOF
{
  "settings": {
    "Cert": "${DOMAIN}",
    "Port": 4430,
    "AliasPort": 443,
    "RedirPort": 800,
    "AgentPong": 300,
    "TlsOffload": "127.0.0.1",
    "ExactPorts": true,
    "Minify": 1,
    "WANonly": true,
    "ignoreAgentHashCheck": true
  },
  "domains": {
    "": {
      "title": "Remote (TEST)",
      "newAccounts": true,
      "certUrl": "https://127.0.0.1:443/"
    }
  }
}
EOF
chown -R meshcentral:meshcentral /opt/meshcentral/meshcentral-data

# --------------------------
# systemd unit
# --------------------------
echo "[5/8] Creating systemd service..."
cat >/etc/systemd/system/meshcentral.service <<'EOF'
[Unit]
Description=MeshCentral Server
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=meshcentral
WorkingDirectory=/opt/meshcentral
Environment=NODE_ENV=production
ExecStart=/usr/bin/node /opt/meshcentral/node_modules/meshcentral
Restart=always
RestartSec=3
LimitNOFILE=262144

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable --now meshcentral

# Generate a self-signed TLS cert for NGINX (TLS offload)
echo "[6/8] Generating self-signed TLS cert for NGINX (TLS offload)..."
mkdir -p /etc/nginx/ssl
if [ ! -f "/etc/nginx/ssl/${DOMAIN}.crt" ]; then
  openssl req -x509 -nodes -newkey rsa:2048 -days 365 \
    -subj "/CN=${DOMAIN}" \
    -keyout /etc/nginx/ssl/${DOMAIN}.key \
    -out /etc/nginx/ssl/${DOMAIN}.crt
fi

# Stop service to perform "server recovery" commands
systemctl stop meshcentral || true

# Create admin user offline if needed, set password, promote to site admin
echo "[7/8] Ensuring admin user exists..."
if ! /usr/bin/node /opt/meshcentral/node_modules/meshcentral/meshcentral.js --listuserids 2>/dev/null | grep -q "^user//${ADMIN_USER}$"; then
  /usr/bin/node /opt/meshcentral/node_modules/meshcentral/meshcentral.js --createaccount "${ADMIN_USER}" || true
fi
/usr/bin/node /opt/meshcentral/node_modules/meshcentral/meshcentral.js --resetaccount "${ADMIN_USER}" --pass "${ADMIN_PASS}" || true
/usr/bin/node /opt/meshcentral/node_modules/meshcentral/meshcentral.js --adminaccount "${ADMIN_USER}" || true

systemctl start meshcentral

# --------------------------
# NGINX reverse proxy (TLS offload)
# --------------------------
echo "[8/8] Configuring NGINX reverse proxy for ${DOMAIN}..."
cat >/etc/nginx/sites-available/meshcentral.conf <<NGINX
# Preserve visitor scheme from Cloudflare when available.
# For direct (non-CF) requests, fall back to \$scheme.
map \$http_x_forwarded_proto \$proxy_xfp {
  default \$http_x_forwarded_proto;
  ""      \$scheme;
}
server {
  listen 80;
  server_name ${DOMAIN};

  # If Cloudflare says the visitor used HTTPS at the edge,
  # DO NOT redirect to HTTPS here (avoids Flexible SSL loops).
  set \$redirect_to_https 1;
  if (\$http_x_forwarded_proto = "https") { set \$redirect_to_https 0; }
  if (\$redirect_to_https = 1) {
    return 301 https://\$host\$request_uri;
  }

  # When behind Cloudflare Flexible, CF -> origin is HTTP.
  # Proxy straight to MeshCentral without redirecting.
  proxy_send_timeout 330s;
  proxy_read_timeout 330s;
  location / {
    proxy_pass http://127.0.0.1:4430/;
    proxy_http_version 1.1;

    # WebSocket upgrade
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_set_header Host \$host;
    proxy_set_header X-Forwarded-Host \$host:\$server_port;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto \$proxy_xfp;

    proxy_buffering off;
  }
}

server {
  listen 443 ssl;
  http2 on;
  server_name ${DOMAIN};

  # Use locally generated self-signed cert/key (TLS offload)
  ssl_certificate     /etc/nginx/ssl/${DOMAIN}.crt;
  ssl_certificate_key /etc/nginx/ssl/${DOMAIN}.key;

  # Long timeouts for web sockets (agents and browser viewers)
  proxy_send_timeout 330s;
  proxy_read_timeout 330s;

  location / {
    proxy_pass http://127.0.0.1:4430/;
    proxy_http_version 1.1;

    # WebSocket upgrade
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_set_header Host \$host;
    proxy_set_header X-Forwarded-Host \$host:\$server_port;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;    
    proxy_set_header X-Forwarded-Proto \$proxy_xfp;

    proxy_buffering off;
  }
}
NGINX

ln -sf /etc/nginx/sites-available/meshcentral.conf /etc/nginx/sites-enabled/meshcentral.conf
[ -e /etc/nginx/sites-enabled/default ] && rm -f /etc/nginx/sites-enabled/default

# # Allow NGINX to read the private key (testing-only perms)
# chgrp www-data /opt/meshcentral/meshcentral-data/webserver-cert-private.key || true
# chmod 640 /opt/meshcentral/meshcentral-data/webserver-cert-private.key || true
# chmod 644 /opt/meshcentral/meshcentral-data/webserver-cert-public.crt || true

systemctl restart nginx
systemctl restart meshcentral

# Create a default device group so "Add device" is immediately visible
/usr/bin/node /opt/meshcentral/node_modules/meshcentral/meshctrl \
  adddevicegroup \
  --loginuser "${ADMIN_USER}" \
  --loginpass "${ADMIN_PASS}" \
  --url "ws://127.0.0.1:4430" \
  --name "Test Group" \
  --desc "Autocreated group for MVP" || true

echo
echo "=============================================="
echo "MeshCentral is ready at: https://${DOMAIN}"
echo "Auto-login user: ${ADMIN_USER}"
echo "Admin password:  ${ADMIN_PASS}"
echo
echo "Open 'Test Group' → 'Add device' to download the Windows agent."
echo "=============================================="
