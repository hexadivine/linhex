#!/bin/bash
set -e

echo "[+] Starting XRDP container..."

# Clean stale PIDs
rm -f /var/run/xrdp/xrdp.pid
rm -f /var/run/xrdp/xrdp-sesman.pid

# Start DBus (required for XFCE)
rm -rf /run/dbus /var/run/dbus
mkdir -p /run/dbus
mkdir -p /var/run/dbus
dbus-daemon --system --fork

# Ensure passwords (in case container resets)
echo "root:root" | chpasswd
echo "kali:kali" | chpasswd

# Fix XRDP session startup
cat > /etc/xrdp/startwm.sh <<'EOF'
#!/bin/bash
unset DBUS_SESSION_BUS_ADDRESS
unset XDG_RUNTIME_DIR
exec startxfce4
EOF

chmod +x /etc/xrdp/startwm.sh

# Ensure user session file
echo "startxfce4" > /home/kali/.xsession
chown kali:kali /home/kali/.xsession

# Optional: fix permissions (sometimes needed)
chown -R kali:kali /home/kali

echo "[+] Starting xrdp-sesman..."
/usr/sbin/xrdp-sesman &

sleep 2

echo "[+] Starting xrdp..."
exec /usr/sbin/xrdp --nodaemon
