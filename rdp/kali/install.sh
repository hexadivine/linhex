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
