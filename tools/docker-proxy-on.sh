#!/usr/bin/env bash
################################################################################
#
# inist-tools / tools / docker-proxy-on.sh
# 
# Sous-routine qui positionne le proxy inist pour DOCKER
#
# /!\ S'execute en ROOT
#
# @author : INIST-CNRS/DPI
#
################################################################################

# ------------------------------------------------------------------------------
# Variables globales
# ------------------------------------------------------------------------------
DOCKER_DEFAULT_FILE="/etc/default/docker"

# PROXY
INIST_HTTP_PROXY="http://proxyout.inist.fr:8080"
INIST_HTTPS_PROXY="https://proxyout.inist.fr:8080"
INIST_FTP_PROXY="http://proxyout.inist.fr:8080"
INIST_PROXYPAC="http://proxypac.intra.inist.fr/proxy.pac"
INIST_NO_PROXY="localhost,127.0.0.0/8,*.local,172.16.0.0/16"
INIST_PROXY_ADDRESS="http://proxyout.inist.fr"
INIST_PROXY_PORT="8080"

# ------------------------------------------------------------------------------
# BACKUP !
# ------------------------------------------------------------------------------
cp "$DOCKER_DEFAULT_FILE" /etc/default/docker_inist-tools-backup

# ------------------------------------------------------------------------------
# conf docker
# ------------------------------------------------------------------------------
printf "" >> "$DOCKER_DEFAULT_FILE"

printf "# inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1

printf "DOCKER_OPTS=\"--dns 172.16.100.17 --dns 172.16.100.16\" # inist-tools" >> "$DOCKER_DEFAULT_FILE"

printf "HTTP_PROXY=\"$INIST_HTTP_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "HTTPS_PROXY=\"$INIST_HTTPS_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export HTTP_PROXY=\"$INIST_HTTP_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export HTTPS_PROXY=\"$INIST_HTTPS_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1

printf "http_proxy=\"$INIST_HTTP_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "https_proxy=\"$INIST_HTTPS_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export http_proxy=\"$INIST_HTTP_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1
printf "export https_proxy=\"$INIST_HTTPS_PROXY\" # inist-tools\n" >> "$DOCKER_DEFAULT_FILE" 2>&1


# ------------------------------------------------------------------------------
# Service
# ------------------------------------------------------------------------------
is_debian=$(cat /etc/issue | grep -i "debian")
is_ubuntu=$(cat /etc/issue | grep -i "ubuntu")
if [ ! -z "$is_debian" ]; then
  platform="debian"
elif [ ! -z "$is_ubuntu" ]; then
  platform="ubuntu"
else
  platform="unknown"
fi

echo "[docker-proxy-on] plateforme détectée : $platform"

if [ "$platform" == "debian" ]; then
  # Backup
  mkdir /etc/systemd/system/docker.service.d/
  touch /etc/systemd/system/docker.service.d/http-proxy.conf
  echo "# inist-tools" >> /etc/systemd/system/docker.service.d/http-proxy.conf
  echo "[Service] # inist-tools" >> /etc/systemd/system/docker.service.d/http-proxy.conf
  echo "EnvironmentFile=/etc/default/docker # inist-tools" >> /etc/systemd/system/docker.service.d/http-proxy.conf
  /etc/init.d/docker restart
elif [ "$platform" == "ubuntu" ]; then
  touch /lib/systemd/system/docker.service
  echo "# inist-tools" >> /lib/systemd/system/docker.service
  echo "[Service] # inist-tools" >> /lib/systemd/system/docker.service
  echo "EnvironmentFile=/etc/default/docker # inist-tools" >> /lib/systemd/system/docker.service
  echo "ExecStart=/usr/bin/docker daemon $DOCKER_OPTS -H fd:// # inist-tools" >> /lib/systemd/system/docker.service
fi

# Temporisation
sleep 3
# Redémarrage du service
service docker restart

# ------------------------------------------------------------------------------
# Sortie propre
# ------------------------------------------------------------------------------
exit 0
