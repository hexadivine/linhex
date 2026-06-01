#!/bin/bash
echo "Removing old container if any..."
sudo docker stop remote_kali_by_hexadivine 2>/dev/null || true
sudo docker rm remote_kali_by_hexadivine 2>/dev/null || true
sudo docker rmi remote_kali_by_hexadivine 2>/dev/null || true

sudo docker build . -t remote_kali_by_hexadivine

sudo docker run -d --name remote_kali_by_hexadivine \
  --restart unless-stopped \
  --network guac_guacnet \
  --cap-add NET_ADMIN \
  --device /dev/net/tun \
  -p 3389:3389 \
  -v ~/.kali-rdp:/home/kali \
  remote_kali_by_hexadivine

IP=$(ip -4 route get 1.1.1.1 | awk '{print $7; exit}')

cat <<EOF > kali.desktop

[Desktop Entry]
Name=Kali
Comment=Run commands on Kali via SSH
Exec=sshpasswd -p kali ssh -p 22001 -Y -C -c chacha20-poly1305@openssh.com kali@$IP rofi
Icon=distributor-logo-kali
Terminal=false
Type=Application
Categories=Utility;

EOF
