FROM kalilinux/kali-rolling

ENV DEBIAN_FRONTEND=noninteractive

# Base install
RUN apt update && \
    apt install -y \
        kali-desktop-xfce \
        xrdp \
        xorgxrdp \
        dbus-x11 \
        openssh-server \
        sudo \
        rofi \
        terminator \
    && apt clean && rm -rf /var/lib/apt/lists/*

# Create users
RUN echo "root:root" | chpasswd && \
    useradd -ms /bin/bash kali && \
    echo "kali:kali" | chpasswd && \
    adduser kali sudo

# Fix XRDP TLS (no snakeoil issues)
RUN rm -f /etc/xrdp/key.pem /etc/xrdp/cert.pem && \
    openssl req -x509 -newkey rsa:2048 \
        -keyout /etc/xrdp/key.pem \
        -out /etc/xrdp/cert.pem \
        -days 3650 -nodes \
        -subj "/CN=xrdp" && \
    chown root:xrdp /etc/xrdp/key.pem && \
    chmod 640 /etc/xrdp/key.pem && \
    chmod 644 /etc/xrdp/cert.pem

# XRDP runtime dir
RUN mkdir -p /var/run/xrdp

# Copy entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3389
EXPOSE 22001

ENTRYPOINT ["/entrypoint.sh"]
